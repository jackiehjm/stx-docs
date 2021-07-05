
.. _aio_duplex_install_kubernetes_r5:

================================================
Install Kubernetes Platform on All-in-one Duplex
================================================

.. only:: partner

   .. include:: /_includes/install-kubernetes-null-labels.rest

.. only:: starlingx

   This section describes the steps to install the StarlingX Kubernetes
   platform on a **StarlingX R5.0 All-in-one Duplex** deployment
   configuration.

   .. contents::
      :local:
      :depth: 1

   ---------------------
   Create a bootable USB
   ---------------------

   Refer to :ref:`Bootable USB <bootable_usb>` for instructions on how
   to create a bootable USB with the StarlingX ISO on your system.

   --------------------------------
   Install software on controller-0
   --------------------------------

   .. include:: inc-install-software-on-controller.rest
      :start-after: incl-install-software-controller-0-aio-start
      :end-before: incl-install-software-controller-0-aio-end

--------------------------------
Bootstrap system on controller-0
--------------------------------

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

      .. code-block::

         # Add these lines to configure Docker to use a proxy server
         docker_http_proxy: http://my.proxy.com:1080
         docker_https_proxy: https://my.proxy.com:1443
         docker_no_proxy:
            - 1.2.3.4


      Refer to :ref:`Ansible Bootstrap Configurations <ansible_bootstrap_configs_r5>`
      for information on additional Ansible bootstrap configurations for advanced
      Ansible bootstrap scenarios.

#. Run the Ansible bootstrap playbook:

   ::

      ansible-playbook /usr/share/ansible/stx-ansible/playbooks/bootstrap.yml

   Wait for Ansible bootstrap playbook to complete. This can take 5-10 minutes,
   depending on the performance of the host machine.

----------------------
Configure controller-0
----------------------

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

   .. code-block:: none

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

#. Configure |NTP| servers for network time synchronization:

   ::

     system ntp-modify ntpservers=0.pool.ntp.org,1.pool.ntp.org

.. only:: openstack

   *************************************
   OpenStack-specific host configuration
   *************************************

   .. important::

      **These steps are required only if the StarlingX OpenStack application
      (stx-openstack) will be installed.**

   #. **For OpenStack only:** Assign OpenStack host labels to controller-0 in
      support of installing the stx-openstack manifest and helm-charts later.

      ::

        system host-label-assign controller-0 openstack-control-plane=enabled
        system host-label-assign controller-0 openstack-compute-node=enabled
        system host-label-assign controller-0 openvswitch=enabled
        system host-label-assign controller-0 sriov=enabled

   #. **For OpenStack only:** Configure the system setting for the vSwitch.

      StarlingX has |OVS| (kernel-based) vSwitch configured as default:

      * Runs in a container; defined within the helm charts of stx-openstack
        manifest.
      * Shares the core(s) assigned to the platform.

      If you require better performance, |OVS|-|DPDK| (|OVS| with the Data
      Plane Development Kit, which is supported only on bare metal hardware)
      should be used:

      * Runs directly on the host (it is not containerized).
      * Requires that at least 1 core be assigned/dedicated to the vSwitch function.

      **To deploy the default containerized OVS:**

      ::

           system modify --vswitch_type none

      This does not run any vSwitch directly on the host, instead, it uses the
      containerized |OVS| defined in the helm charts of stx-openstack
      manifest.

      **To deploy OVS-DPDK, run the following command:**

      ::

        system modify --vswitch_type ovs-dpdk

      Default recommendation for an |AIO|-controller is to use a single core
      for |OVS|-|DPDK| vswitch.

      ::


        # assign 1 core on processor/numa-node 0 on controller-0 to vswitch
        system host-cpu-modify -f vswitch -p0 1 controller-0

      Once vswitch_type is set to |OVS|-|DPDK|, any subsequent nodes created
      will default to automatically assigning 1 vSwitch core for |AIO|
      controllers and 2 vSwitch cores for compute-labeled worker nodes.


      When using |OVS|-|DPDK|, configure 1x 1G huge page for vSwitch memory on
      each |NUMA| node where vswitch is running on this host, with the
      following command:

      ::

         # assign 1x 1G huge page on processor/numa-node 0 on controller-0 to vswitch
         system host-memory-modify -f vswitch -1G 1 controller-0 0


      .. important::

         |VMs| created in an |OVS|-|DPDK| environment must be configured to use
         huge pages to enable networking and must use a flavor with property:
         hw:mem_page_size=large

         Configure the huge pages for |VMs| in an |OVS|-|DPDK| environment on this host with
         the commands:

         ::


            # assign 10x 1G huge page on processor/numa-node 0 on controller-0 to applications
            system host-memory-modify -f application -1G 10 controller-0 0

            # assign 10x 1G huge page on processor/numa-node 1 on controller-0 to applications
            system host-memory-modify -f application -1G 10 controller-0 1

      .. note::

         After controller-0 is unlocked, changing vswitch_type requires
         locking and unlocking controller-0 to apply the change.

   #. **For OpenStack only:** Set up disk partition for nova-local volume
      group, which is needed for stx-openstack nova ephemeral disks.

      ::

        export NODE=controller-0

        echo ">>> Getting root disk info"
        ROOT_DISK=$(system host-show ${NODE} | grep rootfs | awk '{print $4}')
        ROOT_DISK_UUID=$(system host-disk-list ${NODE} --nowrap | grep ${ROOT_DISK} | awk '{print $2}')
        echo "Root disk: $ROOT_DISK, UUID: $ROOT_DISK_UUID"

        echo ">>>> Configuring nova-local"
        NOVA_SIZE=34
        NOVA_PARTITION=$(system host-disk-partition-add -t lvm_phys_vol ${NODE} ${ROOT_DISK_UUID} ${NOVA_SIZE})
        NOVA_PARTITION_UUID=$(echo ${NOVA_PARTITION} | grep -ow "| uuid | [a-z0-9\-]* |" | awk '{print $4}')
        system host-lvg-add ${NODE} nova-local
        system host-pv-add ${NODE} nova-local ${NOVA_PARTITION_UUID}
        sleep 2

   #. **For OpenStack only:** Configure data interfaces for controller-0.
      Data class interfaces are vswitch interfaces used by vswitch to provide
      VM virtio vNIC connectivity to OpenStack Neutron Tenant Networks on the
      underlying assigned Data Network.

      .. important::

         A compute-labeled All-in-one controller host **MUST** have at least one Data class interface.

      * Configure the data interfaces for controller-0.

        ::

           export NODE=controller-0

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

#. **Optionally**, configure pci-sriov interfaces for controller-0.

   This step is **optional** for Kubernetes. Do this step if using |SRIOV|
   network attachments in hosted application containers.

   .. only:: openstack

      This step is **optional** for OpenStack.  Do this step if using |SRIOV|
      vNICs in hosted application VMs.  Note that pci-sriov interfaces can
      have the same Data Networks assigned to them as vswitch data interfaces.


   * Configure the pci-sriov interfaces for controller-0.

     ::

        export NODE=controller-0

        # List inventoried host’s ports and identify ports to be used as ‘pci-sriov’ interfaces,
        # based on displayed linux port name, pci address and device type.
        system host-port-list ${NODE}

        # List host’s auto-configured ‘ethernet’ interfaces,
        # find the interfaces corresponding to the ports identified in previous step, and
        # take note of their UUID
        system host-if-list -a ${NODE}

        # Modify configuration for these interfaces
        # Configuring them as ‘pci-sriov’ class interfaces, MTU of 1500 and named sriov#
        system host-if-modify -m 1500 -n sriov0 -c pci-sriov ${NODE} <sriov0-if-uuid>
        system host-if-modify -m 1500 -n sriov1 -c pci-sriov ${NODE} <sriov1-if-uuid>

        # Create Data Networks that the 'pci-sriov' interfaces will be connected to
        DATANET0='datanet0'
        DATANET1='datanet1'
        system datanetwork-add ${DATANET0} vlan
        system datanetwork-add ${DATANET1} vlan

        # Assign Data Networks to PCI-SRIOV Interfaces
        system interface-datanetwork-assign ${NODE} <sriov0-if-uuid> ${DATANET0}
        system interface-datanetwork-assign ${NODE} <sriov1-if-uuid> ${DATANET1}


   * To enable using |SRIOV| network attachments for the above interfaces in
     Kubernetes hosted application containers:

     * Configure the Kubernetes |SRIOV| device plugin.

       ::

          system host-label-assign controller-0 sriovdp=enabled

     * If planning on running |DPDK| in Kubernetes hosted application
       containers on this host, configure the number of 1G Huge pages required
       on both |NUMA| nodes.

       ::

          # assign 10x 1G huge page on processor/numa-node 0 on controller-0 to applications
          system host-memory-modify -f application controller-0 0 -1G 10

          # assign 10x 1G huge page on processor/numa-node 1 on controller-0 to applications
          system host-memory-modify -f application controller-0 1 -1G 10

***************************************************************
If required, initialize a Ceph-based Persistent Storage Backend
***************************************************************

A persistent storage backend is required if your application requires |PVCs|.

.. only:: openstack

    .. important::

       The StarlingX OpenStack application **requires** |PVCs|.

.. only:: starlingx

    There are two options for persistent storage backend: the host-based Ceph
    solution and the Rook container-based Ceph solution.

For host-based Ceph:

#. Initialize with add ceph backend:

   ::

      system storage-backend-add ceph --confirmed

#. Add an |OSD| on controller-0 for host-based Ceph:

   .. code-block:: bash

      # List host’s disks and identify disks you want to use for CEPH OSDs, taking note of their UUID
      # By default, /dev/sda is being used as system disk and can not be used for OSD.
      system host-disk-list controller-0

      # Add disk as an OSD storage
      system host-stor-add controller-0 osd <disk-uuid>

      # List OSD storage devices
      system host-stor-list controller-0


   # Add disk as an OSD storage
   system host-stor-add controller-0 osd <disk-uuid>

.. only:: starlingx

   For Rook container-based Ceph:

   #. Initialize with add ceph-rook backend:

      ::

         system storage-backend-add ceph-rook --confirmed

   #. Assign Rook host labels to controller-0 in support of installing the
      rook-ceph-apps manifest/helm-charts later:

      ::

         system host-label-assign controller-0 ceph-mon-placement=enabled
         system host-label-assign controller-0 ceph-mgr-placement=enabled


-------------------
Unlock controller-0
-------------------

.. include:: aio_simplex_install_kubernetes.rst
   :start-after: incl-unlock-controller-0-aio-simplex-start:
   :end-before: incl-unlock-controller-0-aio-simplex-end:

-------------------------------------
Install software on controller-1 node
-------------------------------------

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

#. Wait for the software installation on controller-1 to complete, for
   controller-1 to reboot, and for controller-1 to show as
   locked/disabled/online in 'system host-list'.

   This can take 5-10 minutes, depending on the performance of the host machine.

   ::

      system host-list
      +----+--------------+-------------+----------------+-------------+--------------+
      | id | hostname     | personality | administrative | operational | availability |
      +----+--------------+-------------+----------------+-------------+--------------+
      | 1  | controller-0 | controller  | unlocked       | enabled     | available    |
      | 2  | controller-1 | controller  | locked         | disabled    | online       |
      +----+--------------+-------------+----------------+-------------+--------------+

----------------------
Configure controller-1
----------------------

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

      **These steps are required only if the StarlingX OpenStack application
      (stx-openstack) will be installed.**

   #. **For OpenStack only:** Assign OpenStack host labels to controller-1 in
      support of installing the stx-openstack manifest and helm-charts later.

      ::

         system host-label-assign controller-1 openstack-control-plane=enabled
         system host-label-assign controller-1 openstack-compute-node=enabled
         system host-label-assign controller-1 openvswitch=enabled
         system host-label-assign controller-1 sriov=enabled

   #. **For OpenStack only:** Configure the host settings for the vSwitch.

      **If using OVS-DPDK vswitch, run the following commands:**

      Default recommendation for an AIO-controller is to use a single core
      for |OVS|-|DPDK| vswitch.  This should have been automatically configured,
      if not run the following command.

      ::

        # assign 1 core on processor/numa-node 0 on controller-1 to vswitch
        system host-cpu-modify -f vswitch -p0 1 controller-1


      When using |OVS|-|DPDK|, configure 1x 1G huge page for vSwitch memory on
      each |NUMA| node where vswitch is running on this host, with the
      following command:

      ::

         # assign 1x 1G huge page on processor/numa-node 0 on controller-1 to vswitch
         system host-memory-modify -f vswitch -1G 1 controller-1 0


      .. important::

         |VMs| created in an |OVS|-|DPDK| environment must be configured to use
         huge pages to enable networking and must use a flavor with property:
         hw:mem_page_size=large

         Configure the huge pages for |VMs| in an |OVS|-|DPDK| environment for
         this host with the command:

         ::

            # assign 10x 1G huge page on processor/numa-node 0 on controller-1 to applications
            system host-memory-modify -f application -1G 10 controller-1 0

            # assign 10x 1G huge page on processor/numa-node 1 on controller-1 to applications
            system host-memory-modify -f application -1G 10 controller-1 1


   #. **For OpenStack only:** Set up disk partition for nova-local volume group,
      which is needed for stx-openstack nova ephemeral disks.

      ::

         export NODE=controller-1

         echo ">>> Getting root disk info"
         ROOT_DISK=$(system host-show ${NODE} | grep rootfs | awk '{print $4}')
         ROOT_DISK_UUID=$(system host-disk-list ${NODE} --nowrap | grep ${ROOT_DISK} | awk '{print $2}')
         echo "Root disk: $ROOT_DISK, UUID: $ROOT_DISK_UUID"

         echo ">>>> Configuring nova-local"
         NOVA_SIZE=34
         NOVA_PARTITION=$(system host-disk-partition-add -t lvm_phys_vol ${NODE} ${ROOT_DISK_UUID} ${NOVA_SIZE})
         NOVA_PARTITION_UUID=$(echo ${NOVA_PARTITION} | grep -ow "| uuid | [a-z0-9\-]* |" | awk '{print $4}')
         system host-lvg-add ${NODE} nova-local
         system host-pv-add ${NODE} nova-local ${NOVA_PARTITION_UUID}
         sleep 2

   #. **For OpenStack only:** Configure data interfaces for controller-1.
      Data class interfaces are vswitch interfaces used by vswitch to provide
      VM virtio vNIC connectivity to OpenStack Neutron Tenant Networks on the
      underlying assigned Data Network.

      .. important::

         A compute-labeled All-in-one controller host **MUST** have at least one Data class interface.

      * Configure the data interfaces for controller-1.

        ::

           export NODE=controller-1

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

#. **Optionally**, configure pci-sriov interfaces for controller-1.

   This step is **optional** for Kubernetes. Do this step if using |SRIOV|
   network attachments in hosted application containers.

   .. only:: openstack

      This step is **optional** for OpenStack.  Do this step if using |SRIOV|
      vNICs in hosted application VMs.  Note that pci-sriov interfaces can
      have the same Data Networks assigned to them as vswitch data interfaces.


   * Configure the pci-sriov interfaces for controller-1.

     ::

        export NODE=controller-1

        # List inventoried host’s ports and identify ports to be used as ‘pci-sriov’ interfaces,
        # based on displayed linux port name, pci address and device type.
        system host-port-list ${NODE}

        # List host’s auto-configured ‘ethernet’ interfaces,
        # find the interfaces corresponding to the ports identified in previous step, and
        # take note of their UUID
        system host-if-list -a ${NODE}

        # Modify configuration for these interfaces
        # Configuring them as ‘pci-sriov’ class interfaces, MTU of 1500 and named sriov#
        system host-if-modify -m 1500 -n sriov0 -c pci-sriov ${NODE} <sriov0-if-uuid>
        system host-if-modify -m 1500 -n sriov1 -c pci-sriov ${NODE} <sriov1-if-uuid>

        # Create Data Networks that the 'pci-sriov' interfaces will be connected to
        DATANET0='datanet0'
        DATANET1='datanet1'
        system datanetwork-add ${DATANET0} vlan
        system datanetwork-add ${DATANET1} vlan

        # Assign Data Networks to PCI-SRIOV Interfaces
        system interface-datanetwork-assign ${NODE} <sriov0-if-uuid> ${DATANET0}
        system interface-datanetwork-assign ${NODE} <sriov1-if-uuid> ${DATANET1}


   * To enable using |SRIOV| network attachments for the above interfaces in
     Kubernetes hosted application containers:

     * Configure the Kubernetes |SRIOV| device plugin.

       ::

          system host-label-assign controller-1 sriovdp=enabled

     * If planning on running |DPDK| in Kubernetes hosted application
       containers on this host, configure the number of 1G Huge pages required
       on both |NUMA| nodes.

       ::

          # assign 10x 1G huge page on processor/numa-node 0 on controller-1 to applications
          system host-memory-modify -f application controller-1 0 -1G 10

          # assign 10x 1G huge page on processor/numa-node 1 on controller-1 to applications
          system host-memory-modify -f application controller-1 1 -1G 10


***************************************************************************************
If configuring a Ceph-based Persistent Storage Backend, configure host-specific details
***************************************************************************************

For host-based Ceph:

#. Add an |OSD| on controller-1 for host-based Ceph:

   ::

      # List host’s disks and identify disks you want to use for CEPH OSDs, taking note of their UUID
      # By default, /dev/sda is being used as system disk and can not be used for OSD.
      system host-disk-list controller-1

      # Add disk as an OSD storage
      system host-stor-add controller-1 osd <disk-uuid>

      # List OSD storage devices
      system host-stor-list controller-1

      # Add disk as an OSD storage
      system host-stor-add controller-1 osd <disk-uuid>


.. only:: starlingx

   For Rook container-based Ceph:

   #. Assign Rook host labels to controller-1 in support of installing the
      rook-ceph-apps manifest/helm-charts later:

      ::

         system host-label-assign controller-1 ceph-mon-placement=enabled
         system host-label-assign controller-1 ceph-mgr-placement=enabled


-------------------
Unlock controller-1
-------------------

Unlock controller-1 in order to bring it into service:

::

  system host-unlock controller-1

Controller-1 will reboot in order to apply configuration changes and come into
service. This can take 5-10 minutes, depending on the performance of the host
machine.

.. only:: starlingx

   -----------------------------------------------------------------------------------------------
   If using Rook container-based Ceph, finish configuring the ceph-rook Persistent Storage Backend
   -----------------------------------------------------------------------------------------------

   For Rook container-based Ceph:

   On active controller:

   #. Wait for the ``rook-ceph-apps`` application to be uploaded

      ::

        $ source /etc/platform/openrc
        $ system application-list
        +---------------------+---------+-------------------------------+---------------+----------+-----------+
        | application         | version | manifest name                 | manifest file | status   | progress  |
        +---------------------+---------+-------------------------------+---------------+----------+-----------+
        | oidc-auth-apps      | 1.0-0   | oidc-auth-manifest            | manifest.yaml | uploaded | completed |
        | platform-integ-apps | 1.0-8   | platform-integration-manifest | manifest.yaml | uploaded | completed |
        | rook-ceph-apps      | 1.0-1   | rook-ceph-manifest            | manifest.yaml | uploaded | completed |
        +---------------------+---------+-------------------------------+---------------+----------+-----------+

   #. Configure Rook to use /dev/sdb on controller-0 and controller-1 as a ceph
      |OSD|.

      ::

       $ system host-disk-wipe -s --confirm controller-0 /dev/sdb
       $ system host-disk-wipe -s --confirm controller-1 /dev/sdb

      values.yaml for rook-ceph-apps.
      ::

       cluster:
         storage:
           nodes:
           - name: controller-0
             devices:
             - name: /dev/disk/by-path/pci-0000:00:03.0-ata-2.0
           - name: controller-1
             devices:
             - name: /dev/disk/by-path/pci-0000:00:03.0-ata-2.0

      ::

       system helm-override-update rook-ceph-apps rook-ceph kube-system --values values.yaml

   #. Apply the rook-ceph-apps application.

      ::

       system application-apply rook-ceph-apps

   #. Wait for |OSDs| pod to be ready.

      ::

        kubectl get pods -n kube-system
        rook-ceph-crashcollector-controller-0-f984688ff-jsr8t    1/1     Running     0          4m9s
        rook-ceph-crashcollector-controller-1-7f9b6f55b6-699bb   1/1     Running     0          2m5s
        rook-ceph-mgr-a-7f9d588c5b-49cbg                         1/1     Running     0          3m5s
        rook-ceph-mon-a-75bcbd8664-pvq99                         1/1     Running     0          4m27s
        rook-ceph-mon-b-86c67658b4-f4snf                         1/1     Running     0          4m10s
        rook-ceph-mon-c-7f48b58dfb-4nx2n                         1/1     Running     0          3m30s
        rook-ceph-operator-77b64588c5-bhfg7                      1/1     Running     0          7m6s
        rook-ceph-osd-0-6949657cf7-dkfp2                         1/1     Running     0          2m6s
        rook-ceph-osd-1-5d4b58cf69-kdg82                         1/1     Running     0          2m4s
        rook-ceph-osd-prepare-controller-0-wcvsn                 0/1     Completed   0          2m27s
        rook-ceph-osd-prepare-controller-1-98h76                 0/1     Completed   0          2m26s
        rook-ceph-tools-5778d7f6c-2h8s8                          1/1     Running     0          5m55s
        rook-discover-xc22t                                      1/1     Running     0          6m2s
        rook-discover-xndld                                      1/1     Running     0          6m2s
        storage-init-rook-ceph-provisioner-t868q                 0/1     Completed   0          108s


.. include:: /_includes/bootstrapping-and-deploying-starlingx.rest

.. only:: starlingx

   ----------
   Next steps
   ----------

   .. include:: ../kubernetes_install_next.txt


.. only:: partner

   .. include:: /_includes/72hr-to-license.rest
