========================================================================
Install StarlingX Kubernetes on Virtual Standard with Controller Storage
========================================================================

This section describes the steps to install the StarlingX Kubernetes platform
on a **StarlingX R4.0 virtual Standard with Controller Storage** deployment
configuration.

.. contents::
   :local:
   :depth: 1

--------------------------------
Install software on controller-0
--------------------------------

In the last step of :doc:`controller_storage_environ`, the controller-0 virtual
server 'controllerstorage-controller-0' was started by the
:command:`setup_configuration.sh` command.

On the host, attach to the console of virtual controller-0 and select the appropriate
installer menu options to start the non-interactive install of
StarlingX software on controller-0.

.. note::

   When entering the console, it is very easy to miss the first installer menu
   selection. Use ESC to navigate to previous menus, to ensure you are at the
   first installer menu.

::

  virsh console controllerstorage-controller-0

Make the following menu selections in the installer:

#. First menu: Select 'Standard Controller Configuration'
#. Second menu: Select 'Serial Console'

Wait for the non-interactive install of software to complete and for the server
to reboot. This can take 5-10 minutes depending on the performance of the host
machine.

--------------------------------
Bootstrap system on controller-0
--------------------------------

.. incl-bootstrap-controller-0-virt-controller-storage-start:

On virtual controller-0:

#. Log in using the username / password of "sysadmin" / "sysadmin".
   When logging in for the first time, you will be forced to change the password.

   ::

      Login: sysadmin
      Password:
      Changing password for sysadmin.
      (current) UNIX Password: sysadmin
      New Password:
      (repeat) New Password:

#. External connectivity is required to run the Ansible bootstrap playbook:

   ::

      export CONTROLLER0_OAM_CIDR=10.10.10.3/24
      export DEFAULT_OAM_GATEWAY=10.10.10.1
      sudo ip address add $CONTROLLER0_OAM_CIDR dev enp7s1
      sudo ip link set up dev enp7s1
      sudo ip route add default via $DEFAULT_OAM_GATEWAY dev enp7s1

#. Specify user configuration overrides for the Ansible bootstrap playbook.

   Ansible is used to bootstrap StarlingX on controller-0. Key files for Ansible
   configuration are:

   ``/etc/ansible/hosts``
      The default Ansible inventory file. Contains a single host: localhost.

   ``/usr/share/ansible/stx-ansible/playbooks/bootstrap.yml``
      The Ansible bootstrap playbook.

   ``/usr/share/ansible/stx-ansible/playbooks/host_vars/bootstrap/default.yml``
      The default configuration values for the bootstrap playbook.

   ``sysadmin home directory ($HOME)``
      The default location where Ansible looks for and imports user
      configuration override files for hosts. For example: ``$HOME/<hostname>.yml``.

   .. include:: ../ansible_install_time_only.txt

   Specify the user configuration override file for the Ansible bootstrap
   playbook using one of the following methods:

   * Copy the default.yml file listed above to ``$HOME/localhost.yml`` and edit
     the configurable values as desired (use the commented instructions in
     the file).

   or

   * Create the minimal user configuration override file as shown in the example
     below:

     ::

        cd ~
        cat <<EOF > localhost.yml
        system_mode: duplex

        dns_servers:
          - 8.8.8.8
          - 8.8.4.4

        external_oam_subnet: 10.10.10.0/24
        external_oam_gateway_address: 10.10.10.1
        external_oam_floating_address: 10.10.10.2
        external_oam_node_0_address: 10.10.10.3
        external_oam_node_1_address: 10.10.10.4

        admin_username: admin
        admin_password: <sysadmin-password>
        ansible_become_pass: <sysadmin-password>
        EOF

   Refer to :doc:`/deploy_install_guides/r4_release/ansible_bootstrap_configs`
   for information on additional Ansible bootstrap configurations for advanced
   Ansible bootstrap scenarios.

#. Run the Ansible bootstrap playbook:

   ::

      ansible-playbook /usr/share/ansible/stx-ansible/playbooks/bootstrap.yml

   Wait for Ansible bootstrap playbook to complete.
   This can take 5-10 minutes, depending on the performance of the host machine.

.. incl-bootstrap-controller-0-virt-controller-storage-end:

----------------------
Configure controller-0
----------------------

.. incl-config-controller-0-virt-controller-storage-start:

On virtual controller-0:

#. Acquire admin credentials:

   ::

      source /etc/platform/openrc

#. Configure the OAM and MGMT interfaces of controller-0 and specify the
   attached networks:

   ::

      OAM_IF=enp7s1
      MGMT_IF=enp7s2
      system host-if-modify controller-0 lo -c none
      IFNET_UUIDS=$(system interface-network-list controller-0 | awk '{if ($6=="lo") print $4;}')
      for UUID in $IFNET_UUIDS; do
          system interface-network-remove ${UUID}
      done
      system host-if-modify controller-0 $OAM_IF -c platform
      system interface-network-assign controller-0 $OAM_IF oam
      system host-if-modify controller-0 $MGMT_IF -c platform
      system interface-network-assign controller-0 $MGMT_IF mgmt
      system interface-network-assign controller-0 $MGMT_IF cluster-host

#. Configure NTP servers for network time synchronization:

   .. note::

      In a virtual environment, this can sometimes cause Ceph clock skew alarms.
      Also, the virtual instance clock is synchronized with the host clock,
      so it is not absolutely required to configure NTP here.

   ::

      system ntp-modify ntpservers=0.pool.ntp.org,1.pool.ntp.org

#. Configure Ceph storage backend

   .. important::

      This step required only if your application requires
      persistent storage.

      **If you want to install the StarlingX Openstack application
      (stx-openstack) this step is mandatory.**

   ::

    system storage-backend-add ceph --confirmed

*************************************
OpenStack-specific host configuration
*************************************

.. important::

   **This step is required only if the StarlingX OpenStack application
   (stx-openstack) will be installed.**

#. **For OpenStack only:** Assign OpenStack host labels to controller-0 in
   support of installing the stx-openstack manifest/helm-charts later:

   ::

    system host-label-assign controller-0 openstack-control-plane=enabled

#. **For OpenStack only:** A vSwitch is required.

   The default vSwitch is containerized OVS that is packaged with the
   stx-openstack manifest/helm-charts. StarlingX provides the option to use
   OVS-DPDK on the host, however, in the virtual environment OVS-DPDK is NOT
   supported, only OVS is supported. Therefore, simply use the default OVS
   vSwitch here.

.. incl-config-controller-0-virt-controller-storage-end:

-------------------
Unlock controller-0
-------------------

Unlock virtual controller-0 in order to bring it into service:

::

    system host-unlock controller-0

Controller-0 will reboot in order to apply configuration changes and come into
service. This can take 5-10 minutes, depending on the performance of the host machine.

-------------------------------------------------
Install software on controller-1 and worker nodes
-------------------------------------------------

#. On the host, power on the controller-1 virtual server,
   'controllerstorage-controller-1'. It will automatically attempt to network
   boot over the management network:

   ::

      virsh start controllerstorage-controller-1

#. Attach to the console of virtual controller-1:

   ::

      virsh console controllerstorage-controller-1

   As controller-1 VM boots, a message appears on its console instructing you to
   configure the personality of the node.

#. On console of virtual controller-0, list hosts to see the newly discovered
   controller-1 host (hostname=None):

   ::

      system host-list
      +----+--------------+-------------+----------------+-------------+--------------+
      | id | hostname     | personality | administrative | operational | availability |
      +----+--------------+-------------+----------------+-------------+--------------+
      | 1  | controller-0 | controller  | unlocked       | enabled     | available    |
      | 2  | None         | None        | locked         | disabled    | offline      |
      +----+--------------+-------------+----------------+-------------+--------------+

#. On virtual controller-0, using the host id, set the personality of this host
   to 'controller':

   ::

      system host-update 2 personality=controller

   This initiates the install of software on controller-1.
   This can take 5-10 minutes, depending on the performance of the host machine.

#. While waiting on the previous step to complete, start up and set the personality
   for 'controllerstorage-worker-0' and 'controllerstorage-worker-1'. Set the
   personality to 'worker' and assign a unique hostname for each.

   For example, start 'controllerstorage-worker-0' from the host:

   ::

      virsh start controllerstorage-worker-0

   Wait for new host (hostname=None) to be discovered by checking
   ‘system host-list’ on virtual controller-0:

   ::

      system host-update 3 personality=worker hostname=worker-0

   Repeat for 'controllerstorage-worker-1'. On the host:

   ::

      virsh start controllerstorage-worker-1

   And wait for new host (hostname=None) to be discovered by checking
   ‘system host-list’ on virtual controller-0:

   ::

      system host-update 4 personality=worker hostname=worker-1

#. Wait for the software installation on controller-1, worker-0, and worker-1 to
   complete, for all virtual servers to reboot, and for all to show as
   locked/disabled/online in 'system host-list'.

   ::

      system host-list
      +----+--------------+-------------+----------------+-------------+--------------+
      | id | hostname     | personality | administrative | operational | availability |
      +----+--------------+-------------+----------------+-------------+--------------+
      | 1  | controller-0 | controller  | unlocked       | enabled     | available    |
      | 2  | controller-1 | controller  | locked         | disabled    | online       |
      | 3  | worker-0     | worker      | locked         | disabled    | online       |
      | 4  | worker-1     | worker      | locked         | disabled    | online       |
      +----+--------------+-------------+----------------+-------------+--------------+

----------------------
Configure controller-1
----------------------

.. incl-config-controller-1-virt-controller-storage-start:

Configure the OAM and MGMT interfaces of virtual controller-0 and specify the
attached networks. Note that the MGMT interface is partially set up by the
network install procedure.

::

  OAM_IF=enp7s1
  system host-if-modify controller-1 $OAM_IF -c platform
  system interface-network-assign controller-1 $OAM_IF oam
  system interface-network-assign controller-1 mgmt0 cluster-host

*************************************
OpenStack-specific host configuration
*************************************

.. important::

   **This step is required only if the StarlingX OpenStack application
   (stx-openstack) will be installed.**

**For OpenStack only:** Assign OpenStack host labels to controller-1 in support
of installing the stx-openstack manifest/helm-charts later:

::

  system host-label-assign controller-1 openstack-control-plane=enabled

.. incl-config-controller-1-virt-controller-storage-end:

-------------------
Unlock controller-1
-------------------

.. incl-unlock-controller-1-virt-controller-storage-start:

Unlock virtual controller-1 in order to bring it into service:

::

  system host-unlock controller-1

Controller-1 will reboot in order to apply configuration changes and come into
service. This can take 5-10 minutes, depending on the performance of the host machine.

.. incl-unlock-controller-1-virt-controller-storage-end:

----------------------
Configure worker nodes
----------------------

On virtual controller-0:

#. Add the third Ceph monitor to a worker node:

   (The first two Ceph monitors are automatically assigned to controller-0 and
   controller-1.)

   ::

      system ceph-mon-add worker-0

#. Wait for the worker node monitor to complete configuration:

   ::

      system ceph-mon-list
      +--------------------------------------+-------+--------------+------------+------+
      | uuid                                 | ceph_ | hostname     | state      | task |
      |                                      | mon_g |              |            |      |
      |                                      | ib    |              |            |      |
      +--------------------------------------+-------+--------------+------------+------+
      | 64176b6c-e284-4485-bb2a-115dee215279 | 20    | controller-1 | configured | None |
      | a9ca151b-7f2c-4551-8167-035d49e2df8c | 20    | controller-0 | configured | None |
      | f76bc385-190c-4d9a-aa0f-107346a9907b | 20    | worker-0     | configured | None |
      +--------------------------------------+-------+--------------+------------+------+

#. Assign the cluster-host network to the MGMT interface for the worker nodes.

   Note that the MGMT interfaces are partially set up automatically by the
   network install procedure.

   ::

      for NODE in worker-0 worker-1; do
         system interface-network-assign $NODE mgmt0 cluster-host
      done

#. Configure data interfaces for worker nodes.

   .. important::

      **This step is required only if the StarlingX OpenStack application
      (stx-openstack) will be installed.**

      1G Huge Pages are not supported in the virtual environment and there is no
      virtual NIC supporting SRIOV. For that reason, data interfaces are not
      applicable in the virtual environment for the Kubernetes-only scenario.

   For OpenStack only:

   ::

      DATA0IF=eth1000
      DATA1IF=eth1001
      PHYSNET0='physnet0'
      PHYSNET1='physnet1'
      SPL=/tmp/tmp-system-port-list
      SPIL=/tmp/tmp-system-host-if-list

      # configure the datanetworks in sysinv, prior to referencing it
      # in the ``system host-if-modify`` command'.
      system datanetwork-add ${PHYSNET0} vlan
      system datanetwork-add ${PHYSNET1} vlan

      for NODE in worker-0 worker-1; do
        echo "Configuring interface for: $NODE"
        set -ex
        system host-port-list ${NODE} --nowrap > ${SPL}
        system host-if-list -a ${NODE} --nowrap > ${SPIL}
        DATA0PCIADDR=$(cat $SPL | grep $DATA0IF |awk '{print $8}')
        DATA1PCIADDR=$(cat $SPL | grep $DATA1IF |awk '{print $8}')
        DATA0PORTUUID=$(cat $SPL | grep ${DATA0PCIADDR} | awk '{print $2}')
        DATA1PORTUUID=$(cat $SPL | grep ${DATA1PCIADDR} | awk '{print $2}')
        DATA0PORTNAME=$(cat $SPL | grep ${DATA0PCIADDR} | awk '{print $4}')
        DATA1PORTNAME=$(cat $SPL | grep ${DATA1PCIADDR} | awk '{print $4}')
        DATA0IFUUID=$(cat $SPIL | awk -v DATA0PORTNAME=$DATA0PORTNAME '($12 ~ DATA0PORTNAME) {print $2}')
        DATA1IFUUID=$(cat $SPIL | awk -v DATA1PORTNAME=$DATA1PORTNAME '($12 ~ DATA1PORTNAME) {print $2}')
        system host-if-modify -m 1500 -n data0 -c data ${NODE} ${DATA0IFUUID}
        system host-if-modify -m 1500 -n data1 -c data ${NODE} ${DATA1IFUUID}
        system interface-datanetwork-assign ${NODE} ${DATA0IFUUID} ${PHYSNET0}
        system interface-datanetwork-assign ${NODE} ${DATA1IFUUID} ${PHYSNET1}
        set +ex
      done

*************************************
OpenStack-specific host configuration
*************************************

.. important::

   **This step is required only if the StarlingX OpenStack application
   (stx-openstack) will be installed.**

#. **For OpenStack only:** Assign OpenStack host labels to the worker nodes in
   support of installing the stx-openstack manifest/helm-charts later:

   ::

      for NODE in worker-0 worker-1; do
        system host-label-assign $NODE  openstack-compute-node=enabled
        system host-label-assign $NODE  openvswitch=enabled
        system host-label-assign $NODE  sriov=enabled
      done

#. **For OpenStack only:** Set up disk partition for nova-local volume group,
   which is needed for stx-openstack nova ephemeral disks:

   ::

      for NODE in worker-0 worker-1; do
        echo "Configuring Nova local for: $NODE"
        ROOT_DISK=$(system host-show ${NODE} | grep rootfs | awk '{print $4}')
        ROOT_DISK_UUID=$(system host-disk-list ${NODE} --nowrap | grep ${ROOT_DISK} | awk '{print $2}')
        PARTITION_SIZE=10
        NOVA_PARTITION=$(system host-disk-partition-add -t lvm_phys_vol ${NODE} ${ROOT_DISK_UUID} ${PARTITION_SIZE})
        NOVA_PARTITION_UUID=$(echo ${NOVA_PARTITION} | grep -ow "| uuid | [a-z0-9\-]* |" | awk '{print $4}')
        system host-lvg-add ${NODE} nova-local
        system host-pv-add ${NODE} nova-local ${NOVA_PARTITION_UUID}
      done

-------------------
Unlock worker nodes
-------------------

.. incl-unlock-compute-nodes-virt-controller-storage-start:

Unlock virtual worker nodes to bring them into service:

::

  for NODE in worker-0 worker-1; do
     system host-unlock $NODE
  done

The worker nodes will reboot in order to apply configuration changes and come into
service. This can take 5-10 minutes, depending on the performance of the host machine.

.. incl-unlock-compute-nodes-virt-controller-storage-end:

----------------------------
Add Ceph OSDs to controllers
----------------------------

On virtual controller-0:

#. Add OSDs to controller-0:

   .. important::

      This step requires a configured Ceph storage backend

   ::

      HOST=controller-0
      DISKS=$(system host-disk-list ${HOST})
      TIERS=$(system storage-tier-list ceph_cluster)
      OSDs="/dev/sdb"
      for OSD in $OSDs; do
         system host-stor-add ${HOST} $(echo "$DISKS" | grep "$OSD" | awk '{print $2}') --tier-uuid $(echo "$TIERS" | grep storage | awk '{print $2}')
         while true; do system host-stor-list ${HOST} | grep ${OSD} | grep configuring; if [ $? -ne 0 ]; then break; fi; sleep 1; done
      done

      system host-stor-list $HOST

#. Add OSDs to controller-1:

   .. important::

      This step requires a configured Ceph storage backend

   ::

      HOST=controller-1
      DISKS=$(system host-disk-list ${HOST})
      TIERS=$(system storage-tier-list ceph_cluster)
      OSDs="/dev/sdb"
      for OSD in $OSDs; do
          system host-stor-add ${HOST} $(echo "$DISKS" | grep "$OSD" | awk '{print $2}') --tier-uuid $(echo "$TIERS" | grep storage | awk '{print $2}')
          while true; do system host-stor-list ${HOST} | grep ${OSD} | grep configuring; if [ $? -ne 0 ]; then break; fi; sleep 1; done
      done

      system host-stor-list $HOST

----------
Next steps
----------

.. include:: ../kubernetes_install_next.txt
