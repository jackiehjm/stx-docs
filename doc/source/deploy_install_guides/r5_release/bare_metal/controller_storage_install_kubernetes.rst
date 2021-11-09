
.. _controller_storage_install_kubernetes_r5:

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

   .. include:: /shared/_includes/r5_inc-install-software-on-controller.rest
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

   .. code-block:: bash

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

      .. include:: /shared/_includes/r5_ansible_install_time_only.txt

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

      .. include:: /_includes/min-bootstrap-overrides-non-simplex.rest

      .. only:: starlingx

         In either of the above options, the bootstrap playbook’s default
         values will pull all container images required for the |prod-p| from
         Docker hub.

         If you have setup a private Docker registry to use for bootstrapping
         then you will need to add the following lines in $HOME/localhost.yml:

      .. only:: partner

         .. include:: /_includes/install-kubernetes-bootstrap-playbook.rest
            :start-after: docker-reg-begin
            :end-before: docker-reg-end

      .. code-block:: yaml

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

      See :ref:`Use a Private Docker Registry <use-private-docker-registry-r5>`
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

      .. code-block:: bash

         # Add these lines to configure Docker to use a proxy server
         docker_http_proxy: http://my.proxy.com:1080
         docker_https_proxy: https://my.proxy.com:1443
         docker_no_proxy:
            - 1.2.3.4

      Refer to :ref:`Ansible Bootstrap Configurations
      <ansible_bootstrap_configs_r5>` for information on additional Ansible
      bootstrap configurations for advanced Ansible bootstrap scenarios.

#. Run the Ansible bootstrap playbook:

   .. include:: /shared/_includes/ntp-update-note.rest

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

   The following example configures the |OAM| interface on a physical untagged
   ethernet port, use the |OAM| port name that is applicable to your deployment
   environment, for example eth0:

   .. code-block:: bash

     OAM_IF=<OAM-PORT>
     system host-if-modify controller-0 $OAM_IF -c platform
     system interface-network-assign controller-0 $OAM_IF oam

   To configure a vlan or aggregated ethernet interface, see :ref:`Node
   Interfaces <node-interfaces-index>`.

#. Configure the MGMT interface of controller-0 and specify the attached
   networks of both "mgmt" and "cluster-host".

   The following example configures the MGMT interface on a physical untagged
   ethernet port, use the MGMT port name that is applicable to your deployment
   environment, for example eth1:

   .. code-block:: bash

      MGMT_IF=<MGMT-PORT>

      # De-provision loopback interface and
      # remove mgmt and cluster-host networks from loopback interface
      system host-if-modify controller-0 lo -c none
      IFNET_UUIDS=$(system interface-network-list controller-0 | awk '{if ($6=="lo") print $4;}')
      for UUID in $IFNET_UUIDS; do
          system interface-network-remove ${UUID}
      done

      # Configure management interface and assign mgmt and cluster-host networks to it
      system host-if-modify controller-0 $MGMT_IF -c platform
      system interface-network-assign controller-0 $MGMT_IF mgmt
      system interface-network-assign controller-0 $MGMT_IF cluster-host

   To configure a vlan or aggregated ethernet interface, see :ref:`Node
   Interfaces <node-interfaces-index>`.

#. Configure |NTP| servers for network time synchronization:

   ::

     system ntp-modify ntpservers=0.pool.ntp.org,1.pool.ntp.org

   To configure |PTP| instead of |NTP|, see :ref:`PTP Server Configuration
   <ptp-server-config-index>`.

#. If required, configure Ceph storage backend:

   A persistent storage backend is required if your application requires |PVCs|.

   .. only:: openstack

      .. important::

         The StarlingX OpenStack application **requires** |PVCs|.

   ::

     system storage-backend-add ceph --confirmed

.. only:: openstack

   *************************************
   OpenStack-specific host configuration
   *************************************

   .. important::

      These steps are required only if the |prod-os| application
      (|prefix|-openstack) will be installed.

   #. **For OpenStack only:** Assign OpenStack host labels to controller-0 in
      support of installing the |prefix|-openstack manifest and helm-charts later.

      ::

        system host-label-assign controller-0 openstack-control-plane=enabled

   #. **For OpenStack only:** Configure the system setting for the vSwitch.

      .. only:: starlingx

         StarlingX has |OVS| (kernel-based) vSwitch configured as default:

         * Runs in a container; defined within the helm charts of |prefix|-openstack
           manifest.
         * Shares the core(s) assigned to the platform.

         If you require better performance, |OVS-DPDK| (|OVS| with the Data
         Plane Development Kit, which is supported only on bare metal hardware)
         should be used:

         * Runs directly on the host (it is not containerized).
           Requires that at least 1 core be assigned/dedicated to the vSwitch
           function.

         To deploy the default containerized |OVS|:

         ::

              system modify --vswitch_type none

         This does not run any vSwitch directly on the host, instead, it uses
         the containerized |OVS| defined in the helm charts of |prefix|-openstack
         manifest.

      To deploy |OVS-DPDK|, run the following command:

      .. parsed-literal::

         system modify --vswitch_type |ovs-dpdk|

      Once vswitch_type is set to |OVS-DPDK|, any subsequent |AIO|-controller
      or worker nodes created will default to automatically assigning 1 vSwitch
      core for |AIO| controllers and 2 vSwitch cores (both on numa-node 0;
      physical |NICs| are typically on first numa-node) for compute-labeled
      worker nodes.

      .. note::
         After controller-0 is unlocked, changing vswitch_type requires
         locking and unlocking controller-0 to apply the change.


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

.. only:: openstack

   * **For OpenStack only:** Due to the additional openstack services’
     containers running on the controller host, the size of the docker
     filesystem needs to be increased from the default size of 30G to 60G.

     .. code-block:: bash

        # check existing size of docker fs
        system host-fs-list controller-0

        # check available space (Avail Size (GiB)) in cgts-vg LVG where docker fs is located
        system host-lvg-list controller-0

        # if existing docker fs size + cgts-vg available space is less than
        # 60G, you will need to add a new disk partition to cgts-vg.

                # Assuming you have unused space on ROOT DISK, add partition to ROOT DISK.
                # ( if not use another unused disk )

                # Get device path of ROOT DISK
                system host-show controller-0 --nowrap | fgrep rootfs

                # Get UUID of ROOT DISK by listing disks
                system host-disk-list controller-0

                # Create new PARTITION on ROOT DISK, and take note of new partition’s ‘uuid’ in response
                # Use a partition size such that you’ll be able to increase docker fs size from 30G to 60G
                PARTITION_SIZE=30
                system system host-disk-partition-add -t lvm_phys_vol controller-0 <root-disk-uuid> ${PARTITION_SIZE}

                # Add new partition to ‘cgts-vg’ local volume group
                system host-pv-add controller-0 cgts-vg <NEW_PARTITION_UUID>
                sleep 2    # wait for partition to be added

        # Increase docker filesystem to 60G
        system host-fs-modify controller-0 docker=60

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

   .. only:: starlingx

     .. Note::

        A node with Edgeworker personality is also available. See
        :ref:`deploy-edgeworker-nodes` for details.

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

   The following example configures the |OAM| interface on a physical untagged
   ethernet port, use the |OAM| port name that is applicable to your deployment
   environment, for example eth0:

   .. code-block:: bash

      OAM_IF=<OAM-PORT>
      system host-if-modify controller-1 $OAM_IF -c platform
      system interface-network-assign controller-1 $OAM_IF oam

   To configure a vlan or aggregated ethernet interface, see :ref:`Node
   Interfaces <node-interfaces-index>`.

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

      This step is required only if the |prod-os| application
      (|prefix|-openstack) will be installed.

   **For OpenStack only:** Assign OpenStack host labels to controller-1 in
   support of installing the |prefix|-openstack manifest and helm-charts later.

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

.. only:: openstack

   #. **For OpenStack only:** Due to the additional openstack services’
      containers running on the controller host, the size of the docker
      filesystem needs to be increased from the default size of 30G to 60G.

      .. code-block:: bash

         # check existing size of docker fs
         system host-fs-list controller-1

         # check available space (Avail Size (GiB)) in cgts-vg LVG where docker fs is located
         system host-lvg-list controller-1

         # if existing docker fs size + cgts-vg available space is less than
         # 60G, you will need to add a new disk partition to cgts-vg.

                  # Assuming you have unused space on ROOT DISK, add partition to ROOT DISK.
                  # ( if not use another unused disk )

                  # Get device path of ROOT DISK
                  system host-show controller-1 --nowrap | fgrep rootfs

                  # Get UUID of ROOT DISK by listing disks
                  system host-disk-list controller-1

                  # Create new PARTITION on ROOT DISK, and take note of new partition’s ‘uuid’ in response
                  # Use a partition size such that you’ll be able to increase docker fs size from 30G to 60G
                  PARTITION_SIZE=30
                  system hostdisk-partition-add -t lvm_phys_vol controller-1 <root-disk-uuid> ${PARTITION_SIZE}

                  # Add new partition to ‘cgts-vg’ local volume group
                  system host-pv-add controller-1 cgts-vg <NEW_PARTITION_UUID>
                  sleep 2    # wait for partition to be added

         # Increase docker filesystem to 60G
         system host-fs-modify controller-1 docker=60

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

   .. code-block:: bash

     for NODE in worker-0 worker-1; do
        system interface-network-assign $NODE mgmt0 cluster-host
     done

.. only:: openstack

   *************************************
   OpenStack-specific host configuration
   *************************************

   .. important::

      These steps are required only if the |prod-os| application
      (|prefix|-openstack) will be installed.

   #. **For OpenStack only:** Assign OpenStack host labels to the worker nodes in
      support of installing the |prefix|-openstack manifest and helm-charts later.

      .. parsed-literal::

         for NODE in worker-0 worker-1; do
           system host-label-assign $NODE  openstack-compute-node=enabled
           system host-label-assign $NODE  |vswitch-label|
           system host-label-assign $NODE  sriov=enabled
         done

   #. **For OpenStack only:** Configure the host settings for the vSwitch.

      If using |OVS-DPDK| vswitch, run the following commands:

      Default recommendation for worker node is to use two cores on numa-node 0
      for |OVS-DPDK| vSwitch; physical NICs are typically on first numa-node.
      This should have been automatically configured, if not run the following
      command.

      .. code-block:: bash

          for NODE in worker-0 worker-1; do

              # assign 2 cores on processor/numa-node 0 on worker-node to vswitch
              system host-cpu-modify -f vswitch -p0 2 $NODE

          done


      When using |OVS-DPDK|, configure 1G of huge pages for vSwitch memory on
      each |NUMA| node on the host. It is recommended to configure 1x 1G huge
      page (-1G 1) for vSwitch memory on each |NUMA| node on the host.

      However, due to a limitation with Kubernetes, only a single huge page
      size is supported on any one host. If your application |VMs| require 2M
      huge pages, then configure 500x 2M huge pages (-2M 500) for vSwitch
      memory on each |NUMA| node on the host.

      .. code-block:: bash

         for NODE in worker-0 worker-1; do

           # assign 1x 1G huge page on processor/numa-node 0 on worker-node to vswitch
           system host-memory-modify -f vswitch -1G 1 $NODE 0

           # assign 1x 1G huge page on processor/numa-node 0 on worker-node to vswitch
           system host-memory-modify -f vswitch -1G 1 $NODE 1

         done


      .. important::

         |VMs| created in an |OVS-DPDK| environment must be configured to use
         huge pages to enable networking and must use a flavor with the
         property ``hw:mem_page_size=large``

         Configure the huge pages for |VMs| in an |OVS-DPDK| environment on
         this host, the following commands are an example that assumes that 1G
         huge page size is being used on this host:

         .. code-block:: bash

            for NODE in worker-0 worker-1; do

              # assign 10x 1G huge page on processor/numa-node 0 on worker-node to applications
              system host-memory-modify -f application -1G 10 $NODE 0

              # assign 10x 1G huge page on processor/numa-node 1 on worker-node to applications
              system host-memory-modify -f application -1G 10 $NODE 1

            done

   #. **For OpenStack only:** Setup disk partition for nova-local volume group,
      needed for |prefix|-openstack nova ephemeral disks.

      .. code-block:: bash

         for NODE in worker-0 worker-1; do
            system host-lvg-add ${NODE} nova-local

            # Get UUID of DISK to create PARTITION to be added to ‘nova-local’ local volume group
            # CEPH OSD Disks can NOT be used
            # For best performance, do NOT use system/root disk, use a separate physical disk.

            # List host’s disks and take note of UUID of disk to be used
            system host-disk-list ${NODE}
            # ( if using ROOT DISK, select disk with device_path of
            #   ‘system host-show ${NODE} | fgrep rootfs’   )

            # Create new PARTITION on selected disk, and take note of new partition’s ‘uuid’ in response
            # The size of the PARTITION needs to be large enough to hold the aggregate size of
            # all nova ephemeral disks of all VMs that you want to be able to host on this host,
            # but is limited by the size and space available on the physical disk you chose above.
            # The following example uses a small PARTITION size such that you can fit it on the
            # root disk, if that is what you chose above.
            # Additional PARTITION(s) from additional disks can be added later if required.
            PARTITION_SIZE=30

            system hostdisk-partition-add -t lvm_phys_vol ${NODE} <disk-uuid> ${PARTITION_SIZE}

            # Add new partition to ‘nova-local’ local volume group
            system host-pv-add ${NODE} nova-local <NEW_PARTITION_UUID>
            sleep 2
         done

   #. **For OpenStack only:** Configure data interfaces for worker nodes.
      Data class interfaces are vswitch interfaces used by vswitch to provide
      |VM| virtio vNIC connectivity to OpenStack Neutron Tenant Networks on the
      underlying assigned Data Network.

      .. important::

         A compute-labeled worker host **MUST** have at least one Data class
         interface.

      * Configure the data interfaces for worker nodes.

        .. code-block:: bash

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

              # Create Data Networks that vswitch 'data' interfaces will be connected to
              DATANET0='datanet0'
              DATANET1='datanet1'
              system datanetwork-add ${DATANET0} vlan
              system datanetwork-add ${DATANET1} vlan

              # Assign Data Networks to Data Interfaces
              system interface-datanetwork-assign ${NODE} <data0-if-uuid> ${DATANET0}
              system interface-datanetwork-assign ${NODE} <data1-if-uuid> ${DATANET1}

*****************************************
Optionally Configure PCI-SRIOV Interfaces
*****************************************

#. **Optionally**, configure pci-sriov interfaces for worker nodes.

   This step is **optional** for Kubernetes. Do this step if using |SRIOV|
   network attachments in hosted application containers.

   .. only:: openstack

      This step is **optional** for OpenStack.  Do this step if using |SRIOV|
      vNICs in hosted application |VMs|.  Note that pci-sriov interfaces can
      have the same Data Networks assigned to them as vswitch data interfaces.


   * Configure the pci-sriov interfaces for worker nodes.

     .. code-block:: bash

        # Execute the following lines with
        export NODE=worker-0
        # and then repeat with
        export NODE=worker-1

           # List inventoried host’s ports and identify ports to be used as ‘pci-sriov’ interfaces,
           # based on displayed linux port name, pci address and device type.
           system host-port-list ${NODE}

           # List host’s auto-configured ‘ethernet’ interfaces,
           # find the interfaces corresponding to the ports identified in previous step, and
           # take note of their UUID
           system host-if-list -a ${NODE}

           # Modify configuration for these interfaces
           # Configuring them as ‘pci-sriov’ class interfaces, MTU of 1500 and named sriov#
           system host-if-modify -m 1500 -n sriov0 -c pci-sriov ${NODE} <sriov0-if-uuid> -N <num_vfs>
           system host-if-modify -m 1500 -n sriov1 -c pci-sriov ${NODE} <sriov1-if-uuid> -N <num_vfs>

           # If not already created, create Data Networks that the 'pci-sriov'
           # interfaces will be connected to
           DATANET0='datanet0'
           DATANET1='datanet1'
           system datanetwork-add ${DATANET0} vlan
           system datanetwork-add ${DATANET1} vlan

           # Assign Data Networks to PCI-SRIOV Interfaces
           system interface-datanetwork-assign ${NODE} <sriov0-if-uuid> ${DATANET0}
           system interface-datanetwork-assign ${NODE} <sriov1-if-uuid> ${DATANET1}


   * **For Kubernetes only:** To enable using |SRIOV| network attachments for
     the above interfaces in Kubernetes hosted application containers:

     * Configure the Kubernetes |SRIOV| device plugin.

       .. code-block:: bash

          for NODE in worker-0 worker-1; do
             system host-label-assign $NODE sriovdp=enabled
          done

     * If planning on running |DPDK| in Kubernetes hosted application
       containers on this host, configure the number of 1G Huge pages required
       on both |NUMA| nodes.

       .. code-block:: bash

          for NODE in worker-0 worker-1; do

             # assign 10x 1G huge page on processor/numa-node 0 on worker-node to applications
             system host-memory-modify -f application $NODE 0 -1G 10

             # assign 10x 1G huge page on processor/numa-node 1 on worker-node to applications
             system host-memory-modify -f application $NODE 1 -1G 10

          done


--------------------
Unlock worker nodes
--------------------

Unlock worker nodes in order to bring them into service:

.. code-block:: bash

  for NODE in worker-0 worker-1; do
     system host-unlock $NODE
  done

The worker nodes will reboot in order to apply configuration changes and come into
service. This can take 5-10 minutes, depending on the performance of the host machine.

-----------------------------------------------------------------
If configuring Ceph Storage Backend, Add Ceph OSDs to controllers
-----------------------------------------------------------------

#. Add |OSDs| to controller-0. The following example adds |OSDs| to the `sdb` disk:

   .. code-block:: bash

     HOST=controller-0

     # List host's disks and identify disks you want to use for CEPH OSDs, taking note of their UUID
     # By default, /dev/sda is being used as system disk and can not be used for OSD.
     system host-disk-list ${HOST}

     # Add disk as an OSD storage
     system host-stor-add ${HOST} osd <disk-uuid>

     # List OSD storage devices and wait for configuration of newly added OSD to complete.
     system host-stor-list ${HOST}

#. Add |OSDs| to controller-1. The following example adds |OSDs| to the `sdb` disk:

   .. code-block:: bash

     HOST=controller-1

     # List host's disks and identify disks you want to use for CEPH OSDs, taking note of their UUID
     # By default, /dev/sda is being used as system disk and can not be used for OSD.
     system host-disk-list ${HOST}

     # Add disk as an OSD storage
     system host-stor-add ${HOST} osd <disk-uuid>

     # List OSD storage devices and wait for configuration of newly added OSD to complete.
     system host-stor-list ${HOST}

.. only:: starlingx

   ----------
   Next steps
   ----------

   .. include:: /_includes/r5_kubernetes_install_next.txt


.. only:: partner

   .. include:: /_includes/72hr-to-license.rest
