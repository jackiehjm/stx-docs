===========================================================================
Install StarlingX Kubernetes on Bare Metal Standard with Controller Storage
===========================================================================

This section describes the steps to install the StarlingX Kubernetes platform
on a **StarlingX R4.0 bare metal Standard with Controller Storage** deployment
configuration.

.. contents::
   :local:
   :depth: 1

-------------------
Create bootable USB
-------------------

Refer to :doc:`/deploy_install_guides/bootable_usb` for instructions on how to
create a bootable USB with the StarlingX ISO on your system.

--------------------------------
Install software on controller-0
--------------------------------

.. incl-install-software-controller-0-standard-start:

#. Insert the bootable USB into a bootable USB port on the host you are
   configuring as controller-0.

#. Power on the host.

#. Attach to a console, ensure the host boots from the USB, and wait for the
   StarlingX Installer Menus.

#. Make the following menu selections in the installer:

   #. First menu: Select 'Standard Controller Configuration'
   #. Second menu: Select 'Graphical Console' or 'Textual Console' depending on
      your terminal access to the console port

#. Wait for non-interactive install of software to complete and server to reboot.
   This can take 5-10 minutes, depending on the performance of the server.

.. incl-install-software-controller-0-standard-end:

--------------------------------
Bootstrap system on controller-0
--------------------------------

.. incl-bootstrap-sys-controller-0-standard-start:

#. Login using the username / password of "sysadmin" / "sysadmin".

   When logging in for the first time, you will be forced to change the password.

   ::

      Login: sysadmin
      Password:
      Changing password for sysadmin.
      (current) UNIX Password: sysadmin
      New Password:
      (repeat) New Password:

#. Verify and/or configure IP connectivity.

   External connectivity is required to run the Ansible bootstrap playbook. The
   StarlingX boot image will DHCP out all interfaces so the server may have
   obtained an IP address and have external IP connectivity if a DHCP server is
   present in your environment. Verify this using the :command:`ip addr` and
   :command:`ping 8.8.8.8` commands.

   Otherwise, manually configure an IP address and default IP route. Use the
   PORT, IP-ADDRESS/SUBNET-LENGTH and GATEWAY-IP-ADDRESS applicable to your
   deployment environment.

   ::

      sudo ip address add <IP-ADDRESS>/<SUBNET-LENGTH> dev <PORT>
      sudo ip link set up dev <PORT>
      sudo ip route add default via <GATEWAY-IP-ADDRESS> dev <PORT>
      ping 8.8.8.8

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

   #. Use a copy of the default.yml file listed above to provide your overrides.

      The default.yml file lists all available parameters for bootstrap
      configuration with a brief description for each parameter in the file comments.

      To use this method, copy the default.yml file listed above to
      ``$HOME/localhost.yml`` and edit the configurable values as desired.

   #. Create a minimal user configuration override file.

      To use this method, create your override file at ``$HOME/localhost.yml``
      and provide the minimum required parameters for the deployment configuration
      as shown in the example below. Use the OAM IP SUBNET and IP ADDRESSing
      applicable to your deployment environment.

      ::

        cd ~
        cat <<EOF > localhost.yml
        system_mode: duplex

        dns_servers:
          - 8.8.8.8
          - 8.8.4.4

        external_oam_subnet: <OAM-IP-SUBNET>/<OAM-IP-SUBNET-LENGTH>
        external_oam_gateway_address: <OAM-GATEWAY-IP-ADDRESS>
        external_oam_floating_address: <OAM-FLOATING-IP-ADDRESS>
        external_oam_node_0_address: <OAM-CONTROLLER-0-IP-ADDRESS>
        external_oam_node_1_address: <OAM-CONTROLLER-1-IP-ADDRESS>

        admin_username: admin
        admin_password: <admin-password>
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

.. incl-bootstrap-sys-controller-0-standard-end:


----------------------
Configure controller-0
----------------------

.. incl-config-controller-0-storage-start:

#. Acquire admin credentials:

   ::

	   source /etc/platform/openrc

#. Configure the OAM and MGMT interfaces of controller-0 and specify the
   attached networks. Use the OAM and MGMT port names, for example eth0, that are
   applicable to your deployment environment.

   ::

  	 OAM_IF=<OAM-PORT>
  	 MGMT_IF=<MGMT-PORT>
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
   support of installing the stx-openstack manifest and helm-charts later.

   ::

     system host-label-assign controller-0 openstack-control-plane=enabled

#. **For OpenStack only:** Configure the system setting for the vSwitch.

   StarlingX has OVS (kernel-based) vSwitch configured as default:

   * Runs in a container; defined within the helm charts of stx-openstack
     manifest.
   * Shares the core(s) assigned to the platform.

   If you require better performance, OVS-DPDK (OVS with the Data Plane
   Development Kit, which is supported only on bare metal hardware) should be
   used:

   * Runs directly on the host (it is not containerized).
   * Requires that at least 1 core be assigned/dedicated to the vSwitch function.

   To deploy the default containerized OVS:

   ::

     system modify --vswitch_type none

   Do not run any vSwitch directly on the host, instead, use the containerized
   OVS defined in the helm charts of stx-openstack manifest.

   To deploy OVS-DPDK, run the following command:

   ::

     system modify --vswitch_type ovs-dpdk
     system host-cpu-modify -f vswitch -p0 1 controller-0

   Once vswitch_type is set to OVS-DPDK, any subsequent nodes created will
   default to automatically assigning 1 vSwitch core for AIO controllers and 2
   vSwitch cores for compute-labeled worker nodes.

   When using OVS-DPDK, configure vSwitch memory per NUMA node with the following
   command:

   ::

      system host-memory-modify -f <function> -1G <1G hugepages number> <hostname or id> <processor>

   For example:

   ::

      system host-memory-modify -f vswitch -1G 1 worker-0 0

   VMs created in an OVS-DPDK environment must be configured to use huge pages
   to enable networking and must use a flavor with property: hw:mem_page_size=large

   Configure the huge pages for VMs in an OVS-DPDK environment with the command:

   ::

      system host-memory-modify -1G <1G hugepages number> <hostname or id> <processor>

   For example:

   ::

      system host-memory-modify worker-0 0 -1G 10

   .. note::

      After controller-0 is unlocked, changing vswitch_type requires
      locking and unlocking all compute-labeled worker nodes (and/or AIO
      controllers) to apply the change.

.. incl-config-controller-0-storage-end:

-------------------
Unlock controller-0
-------------------

Unlock controller-0 in order to bring it into service:

::

  system host-unlock controller-0

Controller-0 will reboot in order to apply configuration changes and come into
service. This can take 5-10 minutes, depending on the performance of the host machine.

-------------------------------------------------
Install software on controller-1 and worker nodes
-------------------------------------------------

#. Power on the controller-1 server and force it to network boot with the
   appropriate BIOS boot options for your particular server.

#. As controller-1 boots, a message appears on its console instructing you to
   configure the personality of the node.

#. On the console of controller-0, list hosts to see newly discovered controller-1
   host (hostname=None):

   ::

     system host-list
	 +----+--------------+-------------+----------------+-------------+--------------+
	 | id | hostname     | personality | administrative | operational | availability |
	 +----+--------------+-------------+----------------+-------------+--------------+
	 | 1  | controller-0 | controller  | unlocked       | enabled     | available    |
	 | 2  | None         | None        | locked         | disabled    | offline      |
	 +----+--------------+-------------+----------------+-------------+--------------+

#. Using the host id, set the personality of this host to 'controller':

   ::

     system host-update 2 personality=controller

   This initiates the install of software on controller-1.
   This can take 5-10 minutes, depending on the performance of the host machine.

#. While waiting for the previous step to complete, power on the worker nodes.
   Set the personality to 'worker' and assign a unique hostname for each.

   For example, power on worker-0 and wait for the new host (hostname=None) to
   be discovered by checking 'system host-list':

   ::

     system host-update 3 personality=worker hostname=worker-0

   Repeat for worker-1. Power on worker-1 and wait for the new host (hostname=None) to
   be discovered by checking 'system host-list':

   ::

     system host-update 4 personality=worker hostname=worker-1-1

#. Wait for the software installation on controller-1, worker-0, and worker-1 to
   complete, for all servers to reboot, and for all to show as locked/disabled/online in
   'system host-list'.

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

.. incl-config-controller-1-start:

Configure the OAM and MGMT interfaces of controller-0 and specify the attached
networks. Use the OAM and MGMT port names, for example eth0, that are applicable
to your deployment environment.

(Note that the MGMT interface is partially set up automatically by the network
install procedure.)

::

	OAM_IF=<OAM-PORT>
	MGMT_IF=<MGMT-PORT>
	system host-if-modify controller-1 $OAM_IF -c platform
	system interface-network-assign controller-1 $OAM_IF oam
	system interface-network-assign controller-1 $MGMT_IF cluster-host

*************************************
OpenStack-specific host configuration
*************************************

.. important::

   **This step is required only if the StarlingX OpenStack application
   (stx-openstack) will be installed.**

**For OpenStack only:** Assign OpenStack host labels to controller-1 in support
of installing the stx-openstack manifest and helm-charts later.

::

	system host-label-assign controller-1 openstack-control-plane=enabled

.. incl-config-controller-1-end:

-------------------
Unlock controller-1
-------------------

.. incl-unlock-controller-1-start:

Unlock controller-1 in order to bring it into service:

::

	system host-unlock controller-1

Controller-1 will reboot in order to apply configuration changes and come into
service. This can take 5-10 minutes, depending on the performance of the host
machine.

.. incl-unlock-controller-1-end:

----------------------
Configure worker nodes
----------------------

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

#. Assign the cluster-host network to the MGMT interface for the worker nodes:

   (Note that the MGMT interfaces are partially set up automatically by the
   network install procedure.)

   ::

  	 for NODE in worker-0 worker-1; do
  	    system interface-network-assign $NODE mgmt0 cluster-host
  	 done

#. Configure data interfaces for worker nodes. Use the DATA port names, for
   example eth0, that are applicable to your deployment environment.

   .. important::

      This step is **required** for OpenStack.

      This step is optional for Kubernetes: Do this step if using SRIOV network
      attachments in hosted application containers.

   For Kubernetes SRIOV network attachments:

   * Configure SRIOV device plug in:

     ::

  		for NODE in worker-0 worker-1; do
  		   system host-label-assign ${NODE} sriovdp=enabled
  		done

   * If planning on running DPDK in containers on this host, configure the number
     of 1G Huge pages required on both NUMA nodes:

     ::

    		for NODE in worker-0 worker-1; do
    		   system host-memory-modify ${NODE} 0 -1G 100
    		   system host-memory-modify ${NODE} 1 -1G 100
    		done

   For both Kubernetes and OpenStack:

   ::

	    DATA0IF=<DATA-0-PORT>
  		DATA1IF=<DATA-1-PORT>
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
   support of installing the stx-openstack manifest and helm-charts later.

   ::

 	 for NODE in worker-0 worker-1; do
	   system host-label-assign $NODE  openstack-compute-node=enabled
	   system host-label-assign $NODE  openvswitch=enabled
	   system host-label-assign $NODE  sriov=enabled
	 done

#. **For OpenStack only:** Set up disk partition for nova-local volume group,
   which is needed for stx-openstack nova ephemeral disks.

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

--------------------
Unlock worker nodes
--------------------

Unlock worker nodes in order to bring them into service:

::

	for NODE in worker-0 worker-1; do
	   system host-unlock $NODE
	done

The worker nodes will reboot in order to apply configuration changes and come into
service. This can take 5-10 minutes, depending on the performance of the host machine.

----------------------------
Add Ceph OSDs to controllers
----------------------------

#. Add OSDs to controller-0. The following example adds OSDs to the `sdb` disk:

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

#. Add OSDs to controller-1. The following example adds OSDs to the `sdb` disk:

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
