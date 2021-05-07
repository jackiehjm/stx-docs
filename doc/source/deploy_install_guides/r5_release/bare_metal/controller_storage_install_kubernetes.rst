
.. _controller_storage_install_kubernetes:

===============================================================
Install Kubernetes Platform on Standard with Controller Storage
===============================================================

.. contents::
   :local:
   :depth: 1

.. only:: starlingx

   This section describes the steps to install the StarlingX Kubernetes
   platform on a **StarlingX R5.0 Standard with Controller Storage**
   deployment configuration.

   -------------------
   Create bootable USB
   -------------------

   Refer to :ref:`Bootable USB <bootable_usb>` for instructions on how to
   create a bootable USB with the StarlingX ISO on your system.

   --------------------------------
   Install software on controller-0
   --------------------------------

   .. include:: inc-install-software-on-controller.rest
      :start-after: incl-install-software-controller-0-standard-start
      :end-before: incl-install-software-controller-0-standard-end

--------------------------------
Bootstrap system on controller-0
--------------------------------

.. incl-bootstrap-sys-controller-0-standard-start:

#. Login using the username / password of "sysadmin" / "sysadmin".

   When logging in for the first time, you will be forced to change the
   password.

   ::

      Login: sysadmin
      Password:
      Changing password for sysadmin.
      (current) UNIX Password: sysadmin
      New Password:
      (repeat) New Password:

#. Verify and/or configure IP connectivity.

   External connectivity is required to run the Ansible bootstrap playbook. The
   StarlingX boot image will |DHCP| out all interfaces so the server may have
   obtained an IP address and have external IP connectivity if a |DHCP| server
   is present in your environment. Verify this using the :command:`ip addr` and
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

   Ansible is used to bootstrap StarlingX on controller-0. Key files for
   Ansible configuration are:

   ``/etc/ansible/hosts``
      The default Ansible inventory file. Contains a single host: localhost.

   ``/usr/share/ansible/stx-ansible/playbooks/bootstrap.yml``
         The Ansible bootstrap playbook.

   ``/usr/share/ansible/stx-ansible/playbooks/host_vars/bootstrap/default.yml``
      The default configuration values for the bootstrap playbook.

   ``sysadmin home directory ($HOME)``
      The default location where Ansible looks for and imports user
      configuration override files for hosts. For example:
      ``$HOME/<hostname>.yml``.

   .. only:: starlingx

      .. include:: ../ansible_install_time_only.txt

   Specify the user configuration override file for the Ansible bootstrap
   playbook using one of the following methods:

   #. Use a copy of the default.yml file listed above to provide your overrides.

      The default.yml file lists all available parameters for bootstrap
      configuration with a brief description for each parameter in the file
      comments.

      To use this method, copy the default.yml file listed above to
      ``$HOME/localhost.yml`` and edit the configurable values as desired.

   #. Create a minimal user configuration override file.

      To use this method, create your override file at ``$HOME/localhost.yml``
      and provide the minimum required parameters for the deployment
      configuration as shown in the example below. Use the OAM IP SUBNET and IP
      ADDRESSing applicable to your deployment environment.

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

      .. only:: starlingx

         In either of the above options, the bootstrap playbook’s default values
         will pull all container images required for the |prod-p| from Docker hub.

         If you have setup a private Docker registry to use for bootstrapping
         then you will need to add the following lines in $HOME/localhost.yml:

      .. only:: partner

         .. include:: /_includes/install-kubernetes-bootstrap-playbook.rest
            :start-after: docker-reg-begin
            :end-before: docker-reg-end

      .. code-block::

         docker_registries:
         quay.io:
            url: myprivateregistry.abc.com:9001/quay.io
         docker.elastic.co:
            url: myprivateregistry.abc.com:9001/docker.elastic.co
         gcr.io:
            url: myprivateregistry.abc.com:9001/gcr.io
         k8s.gcr.io:
            url: myprivateregistry.abc.com:9001/k8s.gcr.io
         docker.io:
            url: myprivateregistry.abc.com:9001/docker.io
         defaults:
            type: docker
            username: <your_myprivateregistry.abc.com_username>
            password: <your_myprivateregistry.abc.com_password>

         # Add the CA Certificate that signed myprivateregistry.abc.com’s
         # certificate as a Trusted CA
         ssl_ca_cert: /home/sysadmin/myprivateregistry.abc.com-ca-cert.pem

      See :ref:`Use a Private Docker Registry <use-private-docker-registry>`
      for more information.

      .. only:: starlingx

         If a firewall is blocking access to Docker hub or your private
         registry from your StarlingX deployment, you will need to add the
         following lines in $HOME/localhost.yml  (see :ref:`Docker Proxy
         Configuration <docker_proxy_config>` for more details about Docker
         proxy settings):

      .. only:: partner

         .. include:: /_includes/install-kubernetes-bootstrap-playbook.rest
            :start-after: firewall-begin
            :end-before: firewall-end

      .. code-block::

         # Add these lines to configure Docker to use a proxy server
         docker_http_proxy: http://my.proxy.com:1080
         docker_https_proxy: https://my.proxy.com:1443
         docker_no_proxy:
            - 1.2.3.4

      Refer to :ref:`Ansible Bootstrap Configurations <ansible_bootstrap_configs>`
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

#. Configure the |OAM| interface of controller-0 and specify the
   attached network as "oam".

   Use the |OAM| port name that is applicable to your deployment environment,
   for example eth0:

   ::

     OAM_IF=<OAM-PORT>
     system host-if-modify controller-0 $OAM_IF -c platform
     system interface-network-assign controller-0 $OAM_IF oam

#. Configure the MGMT interface of controller-0 and specify the attached
   networks of both "mgmt" and "cluster-host".

   Use the MGMT port name that is applicable to your deployment environment,
   for example eth1:

   ::

     MGMT_IF=<MGMT-PORT>
     system host-if-modify controller-0 lo -c none
     IFNET_UUIDS=$(system interface-network-list controller-0 | awk '{if ($6=="lo") print $4;}')
     for UUID in $IFNET_UUIDS; do
         system interface-network-remove ${UUID}
     done
     system host-if-modify controller-0 $MGMT_IF -c platform
     system interface-network-assign controller-0 $MGMT_IF mgmt
     system interface-network-assign controller-0 $MGMT_IF cluster-host

#. Configure |NTP| servers for network time synchronization:

   ::

     system ntp-modify ntpservers=0.pool.ntp.org,1.pool.ntp.org

#. Configure Ceph storage backend:

   This step is required only if your application requires persistent storage.

   .. only:: starlingx

      .. important::

         **If you want to install the StarlingX Openstack application
         (stx-openstack), this step is mandatory.**

   ::

     system storage-backend-add ceph --confirmed

.. only:: openstack

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

      StarlingX has |OVS| (kernel-based) vSwitch configured as default:

      * Runs in a container; defined within the helm charts of stx-openstack
        manifest.
      * Shares the core(s) assigned to the platform.

      If you require better performance, |OVS|-|DPDK| (OVS with the Data Plane
      Development Kit, which is supported only on bare metal hardware) should
      be used:

      * Runs directly on the host (it is not containerized).
      * Requires that at least 1 core be assigned/dedicated to the vSwitch function.

      **To deploy the default containerized OVS:**

      ::

        system modify --vswitch_type none

      This does not run any vSwitch directly on the host, instead, it uses the
      containerized |OVS| defined in the helm charts of stx-openstack manifest.

      **To deploy OVS-DPDK, run the following command:**

      ::

        system modify --vswitch_type ovs-dpdk

      Once vswitch_type is set to OVS-|DPDK|, any subsequent AIO-controller or
      worker nodes created will default to automatically assigning 1 vSwitch
      core for |AIO| controllers and 2 vSwitch cores for compute-labeled worker
      nodes.

      .. note::

         After controller-0 is unlocked, changing vswitch_type requires
         locking and unlocking all compute-labeled worker nodes (and/or |AIO|
         controllers) to apply the change.

      .. incl-config-controller-0-storage-end:

-------------------
Unlock controller-0
-------------------

Unlock controller-0 in order to bring it into service:

::

  system host-unlock controller-0

Controller-0 will reboot in order to apply configuration changes and come into
service. This can take 5-10 minutes, depending on the performance of the host
machine.

-------------------------------------------------
Install software on controller-1 and worker nodes
-------------------------------------------------

#. Power on the controller-1 server and force it to network boot with the
   appropriate BIOS boot options for your particular server.

#. As controller-1 boots, a message appears on its console instructing you to
   configure the personality of the node.

#. On the console of controller-0, list hosts to see newly discovered
   controller-1 host (hostname=None):

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

   Repeat for worker-1. Power on worker-1 and wait for the new host
   (hostname=None) to be discovered by checking 'system host-list':

   ::

     system host-update 4 personality=worker hostname=worker-1

#. Wait for the software installation on controller-1, worker-0, and worker-1
   to complete, for all servers to reboot, and for all to show as
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

.. incl-config-controller-1-start:

#. Configure the |OAM| interface of controller-1 and specify the
   attached network of "oam".

   Use the |OAM| port name that is applicable to your deployment environment,
   for example eth0:

   ::

      OAM_IF=<OAM-PORT>
      system host-if-modify controller-1 $OAM_IF -c platform
      system interface-network-assign controller-1 $OAM_IF oam

#. The MGMT interface is partially set up by the network install procedure;
   configuring the port used for network install as the MGMT port and
   specifying the attached network of "mgmt".

   Complete the MGMT interface configuration of controller-1 by specifying the
   attached network of "cluster-host".

   ::

      system interface-network-assign controller-1 mgmt0 cluster-host


.. only:: openstack

   *************************************
   OpenStack-specific host configuration
   *************************************

   .. important::

      **This step is required only if the StarlingX OpenStack application
      (stx-openstack) will be installed.**

   **For OpenStack only:** Assign OpenStack host labels to controller-1 in
   support of installing the stx-openstack manifest and helm-charts later.

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

.. include:: /_includes/bootstrapping-and-deploying-starlingx.rest

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

   This step is optional for Kubernetes: Do this step if using |SRIOV| network
   attachments in hosted application containers.

   .. only:: starlingx

      .. important::

           This step is **required** for OpenStack.

   * Configure the data interfaces

     ::

       # Execute the following lines with
       export NODE=worker-0
       # and then repeat with
       export NODE=worker-1

       # List inventoried host’s ports and identify ports to be used as ‘data’ interfaces,
       # based on displayed linux port name, pci address and device type.
       system host-port-list ${NODE}

       # List host’s auto-configured ‘ethernet’ interfaces,
       # find the interfaces corresponding to the ports identified in previous step, and
       # take note of their UUID
       system host-if-list -a ${NODE}

       # Modify configuration for these interfaces
       # Configuring them as ‘data’ class interfaces, MTU of 1500 and named data#
       system host-if-modify -m 1500 -n data0 -c data ${NODE} <data0-if-uuid>
       system host-if-modify -m 1500 -n data1 -c data ${NODE} <data1-if-uuid>

       # Create Data Networks
       PHYSNET0='physnet0'
       PHYSNET1='physnet1'
       system datanetwork-add ${PHYSNET0} vlan
       system datanetwork-add ${PHYSNET1} vlan

       # Assign Data Networks to Data Interfaces
       system interface-datanetwork-assign ${NODE} <data0-if-uuid> ${PHYSNET0}
       system interface-datanetwork-assign ${NODE} <data1-if-uuid> ${PHYSNET1}

   * To enable using |SRIOV| network attachments for the above interfaces in
     Kubernetes hosted application containers:

     * Configure |SRIOV| device plug in:

       ::

        for NODE in worker-0 worker-1; do
           system host-label-assign ${NODE} sriovdp=enabled
        done

     * If planning on running DPDK in containers on this host, configure the number
       of 1G Huge pages required on both |NUMA| nodes:

       ::

          for NODE in worker-0 worker-1; do

            # assign 10x 1G huge page on processor/numa-node 0 on worker-node to applications
            system host-memory-modify -f application $NODE 0 -1G 10

            # assign 10x 1G huge page on processor/numa-node 1 on worker-node to applications
            system host-memory-modify -f application $NODE 1 -1G 10

          done


.. only:: openstack

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

   #. **For OpenStack only:** Configure the host settings for the vSwitch.

      **If using OVS-DPDK vswitch, run the following commands:**

      Default recommendation for worker node is to use a single core on each numa-node
      for |OVS|-|DPDK| vswitch.  This should have been automatically configured,
      if not run the following command.

      ::

        for NODE in worker-0 worker-1; do

           # assign 1 core on processor/numa-node 0 on worker-node to vswitch
           system host-cpu-modify -f vswitch -p0 1 $NODE

           # assign 1 core on processor/numa-node 1 on worker-node to vswitch
           system host-cpu-modify -f vswitch -p1 1 $NODE

        done


      When using |OVS|-|DPDK|, configure 1x 1G huge page for vSwitch memory on each |NUMA| node
      where vswitch is running on this host, with the following command:

      ::

         for NODE in worker-0 worker-1; do

           # assign 1x 1G huge page on processor/numa-node 0 on worker-node to vswitch
           system host-memory-modify -f vswitch -1G 1 $NODE 0

           # assign 1x 1G huge page on processor/numa-node 0 on worker-node to vswitch
           system host-memory-modify -f vswitch -1G 1 $NODE 1

         done


      .. important::

         |VMs| created in an |OVS|-|DPDK| environment must be configured to use
         huge pages to enable networking and must use a flavor with property:
         hw:mem_page_size=large

         Configure the huge pages for |VMs| in an |OVS|-|DPDK| environment for this host with
         the command:

         ::

            for NODE in worker-0 worker-1; do

              # assign 10x 1G huge page on processor/numa-node 0 on worker-node to applications
              system host-memory-modify -f application -1G 10 $NODE 0

              # assign 10x 1G huge page on processor/numa-node 1 on worker-node to applications
              system host-memory-modify -f application -1G 10 $NODE 1

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

#. Add |OSDs| to controller-0. The following example adds |OSDs| to the `sdb` disk:

   .. important::

      This step requires a configured Ceph storage backend.

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

#. Add |OSDs| to controller-1. The following example adds |OSDs| to the `sdb` disk:

   .. important::

      This step requires a configured Ceph storage backend.

   ::

     HOST=controller-1
     DISKS=$(system host-disk-list ${HOST})
     TIERS=$(system storage-tier-list ceph_cluster)
     OSDs="/dev/sdb"
     for OSD in $OSDs; do
         system host-stor-add ${HOST} $(echo "$DISKS" | grep "$OSD" | awk '{print $2}') --tier-uuid $(echo "$TIERS" | grep storage | awk '{print $2}')
         while true; do system host-stor-list ${HOST} | grep ${OSD} | grep configuring; if [ $? -ne 0 ]; then break; fi; sleep 1; done
     done

   ::

     system host-stor-list $HOST

.. only:: starlingx

   ----------
   Next steps
   ----------

   .. include:: ../kubernetes_install_next.txt
