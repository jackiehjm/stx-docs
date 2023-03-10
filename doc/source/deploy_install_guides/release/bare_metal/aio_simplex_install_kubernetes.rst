
.. Greg updates required for -High Security Vulnerability Document Updates

.. _aio_simplex_install_kubernetes_r7:

=================================================
Install Kubernetes Platform on All-in-one Simplex
=================================================


.. only:: partner

   .. include:: /_includes/install-kubernetes-null-labels.rest

.. contents:: |minitoc|
   :local:
   :depth: 1

--------
Overview
--------

.. _aiosx-installation-prereqs:

.. include:: /shared/_includes/desc_aio_simplex.txt

.. _installation-prereqs:

.. _aio_simplex_hardware_r7:

-----------------------------
Minimum hardware requirements
-----------------------------

.. include:: /shared/_includes/prepare-servers-for-installation-91baad307173.rest
   :start-after: begin-min-hw-reqs-sx
   :end-before: end-min-hw-reqs-sx

--------------------------
Installation Prerequisites
--------------------------

.. include:: /shared/_includes/installation-prereqs.rest
   :start-after: begin-install-prereqs
   :end-before: end-install-prereqs

--------------------------------
Prepare Servers for Installation
--------------------------------

.. include:: /shared/_includes/prepare-servers-for-installation-91baad307173.rest
   :start-after: start-prepare-servers-common
   :end-before: end-prepare-servers-common

--------------------------------
Install Software on Controller-0
--------------------------------

.. include:: /shared/_includes/inc-install-software-on-controller.rest
   :start-after: incl-install-software-controller-0-aio-start
   :end-before: incl-install-software-controller-0-aio-end

--------------------------------
Bootstrap system on controller-0
--------------------------------

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


   .. include:: /shared/_includes/ansible_install_time_only.txt

   Specify the user configuration override file for the Ansible bootstrap
   playbook using one of the following methods:

   .. note::

      This Ansible Overrides file for the Bootstrap Playbook ($HOME/localhost.yml)
      contains security sensitive information, use the
      :command:`ansible-vault create $HOME/localhost.yml` command to create it.
      You will be prompted for a password to protect/encrypt the file.
      Use the :command:`ansible-vault edit $HOME/localhost.yml` command if the
      file needs to be edited after it is created.

   #. Use a copy of the default.yml file listed above to provide your overrides.

      The default.yml file lists all available parameters for bootstrap
      configuration with a brief description for each parameter in the file
      comments.

      To use this method, run the :command:`ansible-vault create $HOME/localhost.yml`
      command and copy the contents of the ``default.yml`` file into the
      ansible-vault editor, and edit the configurable values as required.

   #. Create a minimal user configuration override file.

      To use this method, create your override file with
      the :command:`ansible-vault create $HOME/localhost.yml`
      command and provide the minimum required parameters for the deployment
      configuration as shown in the example below. Use the OAM IP SUBNET and IP
      ADDRESSing applicable to your deployment environment.

      .. include:: /_includes/min-bootstrap-overrides-simplex.rest

      .. only:: starlingx

         In either of the above options, the bootstrap playbook’s default
         values will pull all container images required for the |prod-p| from
         Docker hub

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
           ghcr.io:
              url: myprivateregistry.abc.com:9001/ghcr.io
           k8s.gcr.io:
              url: myprivateregistry.abc.com:9001/k8s.gcr.io
           docker.io:
              url: myprivateregistry.abc.com:9001/docker.io
           registry.k8s.io
              url: myprivateregistry.abc.com:9001/registry.k8s.io
           defaults:
              type: docker
              username: <your_myprivateregistry.abc.com_username>
              password: <your_myprivateregistry.abc.com_password>

         # Add the CA Certificate that signed myprivateregistry.abc.com’s
         # certificate as a Trusted CA
         ssl_ca_cert: /home/sysadmin/myprivateregistry.abc.com-ca-cert.pem

      See :ref:`Use a Private Docker Registry <use-private-docker-registry-r7>`
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


      Refer to :ref:`Ansible Bootstrap Configurations <ansible_bootstrap_configs_r7>`
      for information on additional Ansible bootstrap configurations for advanced
      Ansible bootstrap scenarios.

#. Run the Ansible bootstrap playbook:

   .. include:: /shared/_includes/ntp-update-note.rest

   ::

      ansible-playbook --ask-vault-pass /usr/share/ansible/stx-ansible/playbooks/bootstrap.yml

   Wait for Ansible bootstrap playbook to complete. This can take 5-10 minutes,
   depending on the performance of the host machine.

----------------------
Configure controller-0
----------------------

The newly installed controller needs to be configured.

#. Acquire admin credentials:

   ::

     source /etc/platform/openrc

#. Configure the |OAM| interface of controller-0 and specify the attached
   network as "oam". The following example configures the OAM interface on a
   physical untagged ethernet port, use |OAM| port name that is applicable to
   your deployment environment, for example eth0:

   ::

     ~(keystone_admin)$ OAM_IF=<OAM-PORT>
     ~(keystone_admin)$ system host-if-modify controller-0 $OAM_IF -c platform
     ~(keystone_admin)$ system interface-network-assign controller-0 $OAM_IF oam

   To configure a vlan or aggregated ethernet interface, see :ref:`Node
   Interfaces <node-interfaces-index>`.

#. Configure |NTP| servers for network time synchronization:

   ::

      ~(keystone_admin)$ system ntp-modify ntpservers=0.pool.ntp.org,1.pool.ntp.org

   To configure |PTP| instead of |NTP|, see :ref:`PTP Server Configuration
   <ptp-server-config-index>`.

.. only:: openstack

   *************************************
   OpenStack-specific host configuration
   *************************************

   .. incl-config-controller-0-openstack-specific-aio-simplex-start:

   .. important::

      These steps are required only if the StarlingX OpenStack application
      (|prefix|-openstack) will be installed.

   #. **For OpenStack only:** Assign OpenStack host labels to controller-0 in
      support of installing the |prefix|-openstack manifest and helm-charts later.

      .. only:: starlingx

         .. parsed-literal::

            ~(keystone_admin)$ system host-label-assign controller-0 openstack-control-plane=enabled
            ~(keystone_admin)$ system host-label-assign controller-0 openstack-compute-node=enabled
            ~(keystone_admin)$ system host-label-assign controller-0 |vswitch-label|

         .. note::

            If you have a |NIC| that supports |SRIOV|, then you can enable it by
            using the following:

            .. code-block:: none

               ~(keystone_admin)$ system host-label-assign controller-0 sriov=enabled

      .. only:: partner

         .. include:: /_includes/aio_simplex_install_kubernetes.rest
            :start-after: ref1-begin
            :end-before: ref1-end

   #. **For OpenStack only:** Due to the additional OpenStack services running
      on the |AIO| controller platform cores, a minimum of 4 platform cores are
      required, 6 platform cores are recommended.

      Increase the number of platform cores with the following commands:

      .. code-block:: bash

         # Assign 6 cores on processor/numa-node 0 on controller-0 to platform
         ~(keystone_admin)$ system host-cpu-modify -f platform -p0 6 controller-0

   #. Due to the additional OpenStack services' containers running on the
      controller host, the size of the Docker filesystem needs to be
      increased from the default size of 30G to 60G.

      .. code-block:: bash

          # check existing size of docker fs
          system host-fs-list controller-0
          # check available space (Avail Size (GiB)) in cgts-vg LVG where docker fs is located
          system host-lvg-list controller-0
          # if existing docker fs size + cgts-vg available space is less than
          # 60G, you will need to add a new disk to cgts-vg.

             # Get device path of BOOT DISK
             system host-show controller-0 | fgrep rootfs

             # Get UUID of ROOT DISK by listing disks
             system host-disk-list controller-0

             # Add new disk to 'cgts-vg' local volume group
             system host-pv-add controller-0 cgts-vg <DISK_UUID>
             sleep 10    # wait for disk to be added

             # Confirm the available space and increased number of physical
             # volumes added to the cgts-vg colume group
             system host-lvg-list controller-0

          # Increase docker filesystem to 60G
          system host-fs-modify controller-0 docker=60

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

              ~(keystone_admin)$ system modify --vswitch_type none

         This does not run any vSwitch directly on the host, instead, it uses
         the containerized |OVS| defined in the helm charts of
         |prefix|-openstack manifest.

      To deploy |OVS-DPDK|, run the following command:

      .. parsed-literal::

         ~(keystone_admin)$ system modify --vswitch_type |ovs-dpdk|

      Default recommendation for an |AIO|-controller is to use a single core
      for |OVS-DPDK| vSwitch.

      .. code-block:: bash

         # assign 1 core on processor/numa-node 0 on controller-0 to vswitch
         ~(keystone_admin)$ system host-cpu-modify -f vswitch -p0 1 controller-0

      When using |OVS-DPDK|, configure 1G of huge pages for vSwitch memory on
      each |NUMA| node on the host. It is recommended
      to configure 1x 1G huge page (-1G 1) for vSwitch memory on each |NUMA|
      node on the host.

      However, due to a limitation with Kubernetes, only a single huge page
      size is supported on any one host. If your application |VMs| require 2M
      huge pages, then configure 500x 2M huge pages (-2M 500) for vSwitch
      memory on each |NUMA| node on the host.


      .. code-block::

         # Assign 1x 1G huge page on processor/numa-node 0 on controller-0 to vswitch
         ~(keystone_admin)$ system host-memory-modify -f vswitch -1G 1 controller-0 0

         # Assign 1x 1G huge page on processor/numa-node 1 on controller-0 to vswitch
         ~(keystone_admin)$ system host-memory-modify -f vswitch -1G 1 controller-0 1

      .. important::

         |VMs| created in an |OVS-DPDK| environment must be configured to use
         huge pages to enable networking and must use a flavor with property:
         hw:mem_page_size=large

         Configure the huge pages for |VMs| in an |OVS-DPDK| environment on
         this host, the following commands are an example that assumes that 1G
         huge page size is being used on this host:

         .. code-block:: bash

            # assign 1x 1G huge page on processor/numa-node 0 on controller-0 to applications
            ~(keystone_admin)$ system host-memory-modify -f application -1G 10 controller-0 0

            # assign 1x 1G huge page on processor/numa-node 1 on controller-0 to applications
            ~(keystone_admin)$ system host-memory-modify -f application -1G 10 controller-0 1

      .. note::

         After controller-0 is unlocked, changing vswitch_type requires
         locking and unlocking controller-0 to apply the change.

   #. **For OpenStack only:** Add an instances filesystem OR Set up a disk
      based nova-local volume group, which is needed for |prefix|-openstack
      nova ephemeral disks.

      .. note::

         Both cannot exist at the same time.

      Add an 'instances' filesystem

      .. code-block:: bash

        export NODE=controller-0

         # Create ‘instances’ filesystem
         system host-fs-add ${NODE} instances=<size>

         OR add a 'nova-local' volume group

      .. code-block:: bash

         export NODE=controller-0

         # Create ‘nova-local’ local volume group
         system host-lvg-add ${NODE} nova-local

         # Get UUID of an unused DISK to to be added to the ‘nova-local’ volume
         # group. CEPH OSD Disks can NOT be used

         # List host’s disks and take note of UUID of disk to be used
         system host-disk-list ${NODE}

         # Add the unused disk to the ‘nova-local’ volume group
         system host-pv-add ${NODE} nova-local <DISK_UUID>

   #. **For OpenStack only:** Configure data interfaces for controller-0.
      Data class interfaces are vSwitch interfaces used by vSwitch to provide
      VM virtio vNIC connectivity to OpenStack Neutron Tenant Networks on the
      underlying assigned Data Network.

      .. important::

         A compute-labeled |AIO|-controller host **MUST** have at least one
         Data class interface.

      * Configure the data interfaces for controller-0.

        .. code-block:: bash

           ~(keystone_admin)$  NODE=controller-0

           # List inventoried host’s ports and identify ports to be used as ‘data’ interfaces,
           # based on displayed linux port name, pci address and device type.
           ~(keystone_admin)$ system host-port-list ${NODE}

           # List host’s auto-configured ‘ethernet’ interfaces,
           # find the interfaces corresponding to the ports identified in previous step, and
           # take note of their UUID
           ~(keystone_admin)$ system host-if-list -a ${NODE}

           # Modify configuration for these interfaces
           # Configuring them as ‘data’ class interfaces, MTU of 1500 and named data#
           ~(keystone_admin)$ system host-if-modify -m 1500 -n data0 -c data ${NODE} <data0-if-uuid>
           ~(keystone_admin)$ system host-if-modify -m 1500 -n data1 -c data ${NODE} <data1-if-uuid>

           # Create Data Networks that vswitch 'data' interfaces will be connected to
           ~(keystone_admin)$ DATANET0='datanet0'
           ~(keystone_admin)$ DATANET1='datanet1'
           ~(keystone_admin)$ system datanetwork-add ${DATANET0} vlan
           ~(keystone_admin)$ system datanetwork-add ${DATANET1} vlan

           # Assign Data Networks to Data Interfaces
           ~(keystone_admin)$ system interface-datanetwork-assign ${NODE} <data0-if-uuid> ${DATANET0}
           ~(keystone_admin)$ system interface-datanetwork-assign ${NODE} <data1-if-uuid> ${DATANET1}


*****************************************
Optionally Configure PCI-SRIOV Interfaces
*****************************************

#. **Optionally**, configure |PCI|-SRIOV interfaces for controller-0.

   This step is **optional** for Kubernetes. Do this step if using |SRIOV|
   network attachments in hosted application containers.

   .. only:: openstack

      This step is **optional** for OpenStack. Do this step if using |SRIOV|
      vNICs in hosted application VMs. Note that |PCI|-SRIOV interfaces can
      have the same Data Networks assigned to them as vswitch data interfaces.


   * Configure the |PCI|-SRIOV interfaces for controller-0.

     .. code-block:: bash

        ~(keystone_admin)$ export NODE=controller-0

        # List inventoried host’s ports and identify ports to be used as ‘pci-sriov’ interfaces,
        # based on displayed linux port name, pci address and device type.
        ~(keystone_admin)$ system host-port-list ${NODE}

        # List host’s auto-configured ‘ethernet’ interfaces,
        # find the interfaces corresponding to the ports identified in previous step, and
        # take note of their UUID
        ~(keystone_admin)$ system host-if-list -a ${NODE}

        # Modify configuration for these interfaces
        # Configuring them as ‘pci-sriov’ class interfaces, MTU of 1500 and named sriov#
        ~(keystone_admin)$ system host-if-modify -m 1500 -n sriov0 -c pci-sriov ${NODE} <sriov0-if-uuid> -N <num_vfs>
        ~(keystone_admin)$ system host-if-modify -m 1500 -n sriov1 -c pci-sriov ${NODE} <sriov1-if-uuid> -N <num_vfs>

        # If not already created, create Data Networks that the 'pci-sriov' interfaces will
        # be connected to
        ~(keystone_admin)$ DATANET0='datanet0'
        ~(keystone_admin)$ DATANET1='datanet1'
        ~(keystone_admin)$ system datanetwork-add ${DATANET0} vlan
        ~(keystone_admin)$ system datanetwork-add ${DATANET1} vlan

        # Assign Data Networks to PCI-SRIOV Interfaces
        ~(keystone_admin)$ system interface-datanetwork-assign ${NODE} <sriov0-if-uuid> ${DATANET0}
        ~(keystone_admin)$ system interface-datanetwork-assign ${NODE} <sriov1-if-uuid> ${DATANET1}


   * **For Kubernetes Only:** To enable using |SRIOV| network attachments for
     the above interfaces in Kubernetes hosted application containers:

     * Configure the Kubernetes |SRIOV| device plugin.

       ::

          ~(keystone_admin)$ system host-label-assign controller-0 sriovdp=enabled

     * If you are planning on running |DPDK| in Kubernetes hosted application
       containers on this host, configure the number of 1G Huge pages required
       on both |NUMA| nodes.

       .. code-block:: bash

          # assign 10x 1G huge page on processor/numa-node 0 on controller-0 to applications
          ~(keystone_admin)$ system host-memory-modify -f application controller-0 0 -1G 10

          # assign 10x 1G huge page on processor/numa-node 1 on controller-0 to applications
          ~(keystone_admin)$ system host-memory-modify -f application controller-0 1 -1G 10


***************************************************************
If required, initialize a Ceph-based Persistent Storage Backend
***************************************************************

A persistent storage backend is required if your application requires
|PVCs|.

.. only:: openstack

   .. important::

      The StarlingX OpenStack application **requires** |PVCs|.

.. only:: starlingx

   There are two options for persistent storage backend: the host-based Ceph
   solution and the Rook container-based Ceph solution.

For host-based Ceph:

#. Add host-based Ceph backend:

   ::

      ~(keystone_admin)$ system storage-backend-add ceph --confirmed

#. Add an |OSD| on controller-0 for host-based Ceph:

   .. code-block:: bash

      # List host’s disks and identify disks you want to use for CEPH OSDs, taking note of their UUID
      # By default, /dev/sda is being used as system disk and can not be used for OSD.
      ~(keystone_admin)$ system host-disk-list controller-0

      # Add disk as an OSD storage
      ~(keystone_admin)$ system host-stor-add controller-0 osd <disk-uuid>

      # List OSD storage devices
      ~(keystone_admin)$ system host-stor-list controller-0


.. only:: starlingx

   For Rook container-based Ceph:

   #. Add Rook container-based backend:

      ::

         ~(keystone_admin)$ system storage-backend-add ceph-rook --confirmed

   #. Assign Rook host labels to controller-0 in support of installing the
      rook-ceph-apps manifest/helm-charts later:

      ::

         ~(keystone_admin)$ system host-label-assign controller-0 ceph-mon-placement=enabled
         ~(keystone_admin)$ system host-label-assign controller-0 ceph-mgr-placement=enabled


   .. incl-config-controller-0-openstack-specific-aio-simplex-end:


-------------------
Unlock controller-0
-------------------

.. incl-unlock-controller-0-aio-simplex-start:

Unlock controller-0 to bring it into service:

::

  ~(keystone_admin)$ system host-unlock controller-0

Controller-0 will reboot in order to apply configuration changes and come into
service. This can take 5-10 minutes, depending on the performance of the host
machine.

.. incl-unlock-controller-0-aio-simplex-end:

.. only:: starlingx

   -----------------------------------------------------------------------------------------------
   If using Rook container-based Ceph, finish configuring the ceph-rook Persistent Storage Backend
   -----------------------------------------------------------------------------------------------

   On controller-0:

   #. Wait for application rook-ceph-apps to be uploaded

      ::

       $ source /etc/platform/openrc
       ~(keystone_admin)$  system application-list
       +---------------------+---------+-------------------------------+---------------+----------+-----------+
       | application         | version | manifest name                 | manifest file | status   | progress  |
       +---------------------+---------+-------------------------------+---------------+----------+-----------+
       | oidc-auth-apps      | 1.0-0   | oidc-auth-manifest            | manifest.yaml | uploaded | completed |
       | platform-integ-apps | 1.0-8   | platform-integration-manifest | manifest.yaml | uploaded | completed |
       | rook-ceph-apps      | 1.0-1   | rook-ceph-manifest            | manifest.yaml | uploaded | completed |
       +---------------------+---------+-------------------------------+---------------+----------+-----------+

   #. Configure rook to use /dev/sdb disk on controller-0 as a ceph |OSD|.

      ::

       ~(keystone_admin)$ system host-disk-wipe -s --confirm controller-0 /dev/sdb

      ``values.yaml`` for rook-ceph-apps.

      .. code-block:: yaml

         cluster:
           storage:
             nodes:
             - name: controller-0
               devices:
               - name: /dev/disk/by-path/pci-0000:00:03.0-ata-2.0

      ::

       ~(keystone_admin)$ system helm-override-update rook-ceph-apps rook-ceph kube-system --values values.yaml

   #. Apply the rook-ceph-apps application.

      ::

       ~(keystone_admin)$ system application-apply rook-ceph-apps

   #. Wait for |OSDs| pod to be ready.

      ::

       ~(keystone_admin)$ kubectl get pods -n kube-system
       rook--ceph-crashcollector-controller-0-764c7f9c8-bh5c7   1/1     Running     0          62m
       rook--ceph-mgr-a-69df96f57-9l28p                         1/1     Running     0          63m
       rook--ceph-mon-a-55fff49dcf-ljfnx                        1/1     Running     0          63m
       rook--ceph-operator-77b64588c5-nlsf2                     1/1     Running     0          66m
       rook--ceph-osd-0-7d5785889f-4rgmb                        1/1     Running     0          62m
       rook--ceph-osd-prepare-controller-0-cmwt5                0/1     Completed   0          2m14s
       rook--ceph-tools-5778d7f6c-22tms                         1/1     Running     0          64m
       rook--discover-kmv6c                                     1/1     Running     0          65m

.. only:: starlingx

   ----------
   Next steps
   ----------

   .. include:: /_includes/kubernetes_install_next.txt


.. only:: partner

   .. include:: /_includes/72hr-to-license.rest

Complete system configuration by reviewing procedures in:

- :ref:`index-security-kub-81153c1254c3`
- :ref:`index-sysconf-kub-78f0e1e9ca5a`
- :ref:`index-admintasks-kub-ebc55fefc368`
