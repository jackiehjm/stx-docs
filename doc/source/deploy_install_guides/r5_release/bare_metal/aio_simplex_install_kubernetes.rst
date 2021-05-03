
.. _aio_simplex_install_kubernetes:

================================================
Install Kubernetes Platform on Bare Metal AIO-SX
================================================

.. only:: partner

   .. include:: /_includes/install-kubernetes-null-labels.rest

.. only:: starlingx

   This section describes the steps to install the StarlingX Kubernetes
   platform on a **StarlingX R5.0 bare metal All-in-one Simplex** deployment
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

   .. only:: starlingx

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
        system_mode: simplex

        dns_servers:
          - 8.8.8.8
          - 8.8.4.4

        external_oam_subnet: <OAM-IP-SUBNET>/<OAM-IP-SUBNET-LENGTH>
        external_oam_gateway_address: <OAM-GATEWAY-IP-ADDRESS>
        external_oam_floating_address: <OAM-FLOATING-IP-ADDRESS>

        admin_username: admin
        admin_password: <admin-password>
        ansible_become_pass: <sysadmin-password>

        # Add these lines to configure Docker to use a proxy server
        # docker_http_proxy: http://my.proxy.com:1080
        # docker_https_proxy: https://my.proxy.com:1443
        # docker_no_proxy:
        #   - 1.2.3.4

        EOF

   .. only:: partner

      .. include:: ../../../_includes/install-playbook-values-aws.rest

   .. only:: starlingx

      Refer to :ref:`Ansible Bootstrap Configurations
      <ansible_bootstrap_configs>` for information on additional Ansible
      bootstrap configurations for advanced Ansible bootstrap scenarios, such
      as Docker proxies when deploying behind a firewall, etc. Refer to
      :ref:`Docker Proxy Configuration <docker_proxy_config>` for details about
      Docker proxy settings.

#. Run the Ansible bootstrap playbook:

   ::

      ansible-playbook /usr/share/ansible/stx-ansible/playbooks/bootstrap.yml

   Wait for Ansible bootstrap playbook to complete. This can take 5-10 minutes,
   depending on the performance of the host machine.

----------------------
Configure controller-0
----------------------

The newly installed controller needs to be configured.

#. Acquire admin credentials:

   ::

     source /etc/platform/openrc

#. Configure the |OAM| interface of controller-0 and specify the attached network
   as "oam". Use the |OAM| port name that is applicable to your deployment
   environment, for example eth0:

   ::

     OAM_IF=<OAM-PORT>
     system host-if-modify controller-0 $OAM_IF -c platform
     system interface-network-assign controller-0 $OAM_IF oam

#. Configure |NTP| servers for network time synchronization:

   ::

      system ntp-modify ntpservers=0.pool.ntp.org,1.pool.ntp.org

#. Configure data interfaces for controller-0. Use the DATA port names, for example
   eth0, applicable to your deployment environment.

   This step is **optional** for Kubernetes. Do this step if using |SRIOV|
   network attachments in hosted application containers.

   .. only:: starlingx

      .. important::

         This step is **required** for OpenStack.

   * Configure the data interfaces

     ::

        DATA0IF=<DATA-0-PORT>
        DATA1IF=<DATA-1-PORT>
        export NODE=controller-0
        PHYSNET0='physnet0'
        PHYSNET1='physnet1'
        SPL=/tmp/tmp-system-port-list
        SPIL=/tmp/tmp-system-host-if-list
        system host-port-list ${NODE} --nowrap > ${SPL}
        system host-if-list -a ${NODE} --nowrap > ${SPIL}
        DATA0PCIADDR=$(cat $SPL | grep $DATA0IF |awk '{print $8}')
        DATA1PCIADDR=$(cat $SPL | grep $DATA1IF |awk '{print $8}')
        DATA0PORTUUID=$(cat $SPL | grep ${DATA0PCIADDR} | awk '{print $2}')
        DATA1PORTUUID=$(cat $SPL | grep ${DATA1PCIADDR} | awk '{print $2}')
        DATA0PORTNAME=$(cat $SPL | grep ${DATA0PCIADDR} | awk '{print $4}')
        DATA1PORTNAME=$(cat  $SPL | grep ${DATA1PCIADDR} | awk '{print $4}')
        DATA0IFUUID=$(cat $SPIL | awk -v DATA0PORTNAME=$DATA0PORTNAME '($12 ~ DATA0PORTNAME) {print $2}')
        DATA1IFUUID=$(cat $SPIL | awk -v DATA1PORTNAME=$DATA1PORTNAME '($12 ~ DATA1PORTNAME) {print $2}')

        system datanetwork-add ${PHYSNET0} vlan
        system datanetwork-add ${PHYSNET1} vlan

        system host-if-modify -m 1500 -n data0 -c data ${NODE} ${DATA0IFUUID}
        system host-if-modify -m 1500 -n data1 -c data ${NODE} ${DATA1IFUUID}
        system interface-datanetwork-assign ${NODE} ${DATA0IFUUID} ${PHYSNET0}
        system interface-datanetwork-assign ${NODE} ${DATA1IFUUID} ${PHYSNET1}


   * To enable using |SRIOV| network attachments for the above interfaces in
     Kubernetes hosted application containers:

     * Configure the Kubernetes |SRIOV| device plugin.

       ::

          system host-label-assign controller-0 sriovdp=enabled

     * If planning on running |DPDK| in kubernetes hosted application
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

A persistent storage backend is required if your application requires
|PVCs|.

.. only:: starlingx

   .. important::

      The StarlingX OpenStack application **requires** |PVCs|.

   There are two options for persistent storage backend: the host-based Ceph solution and the Rook container-based Ceph solution.

For host-based Ceph:

#. Add host-based ceph backend:

   ::

      system storage-backend-add ceph --confirmed

#. Add an |OSD| on controller-0 for host-based Ceph:

   ::

      system host-disk-list controller-0
      system host-disk-list controller-0 | awk '/\/dev\/sdb/{print $2}' | xargs -i system host-stor-add controller-0 {}
      system host-stor-list controller-0

.. only:: starlingx

   For Rook container-based Ceph:

   #. Add Rook container-based backend:

      ::

         system storage-backend-add ceph-rook --confirmed

   #. Assign Rook host labels to controller-0 in support of installing the
      rook-ceph-apps manifest/helm-charts later:

      ::

         system host-label-assign controller-0 ceph-mon-placement=enabled
         system host-label-assign controller-0 ceph-mgr-placement=enabled

***********************************
If required, configure Docker Proxy
***********************************

StarlingX uses publicly available container runtime registries. If you are
behind a corporate firewall or proxy, you need to set docker proxy settings.

Refer to :ref:`Docker Proxy Configuration <docker_proxy_config>` for
details about configuring Docker proxy settings.

.. only:: starlingx

   *************************************
   OpenStack-specific host configuration
   *************************************

   .. incl-config-controller-0-openstack-specific-aio-simplex-start:

   .. important::

      **This step is required only if the StarlingX OpenStack application
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

      If you require better performance, |OVS|-|DPDK| (|OVS| with the Data Plane
      Development Kit, which is supported only on bare metal hardware) should be
      used:

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

      Default recommendation for an AIO-controller is to use a single core
      for |OVS|-|DPDK| vswitch.

      ::

        # assign 1 core on processor/numa-node 0 on controller-0 to vswitch
        system host-cpu-modify -f vswitch -p0 1 controller-0

      When using |OVS|-|DPDK|, configure 1x 1G huge page for vSwitch memory on each |NUMA| node
      where vswitch is running on this host, with the following command:

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

            # assign 1x 1G huge page on processor/numa-node 0 on controller-0 to applications
            system host-memory-modify -f application -1G 10 controller-0 0

            # assign 1x 1G huge page on processor/numa-node 1 on controller-0 to applications
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

   .. incl-config-controller-0-openstack-specific-aio-simplex-end:

-------------------
Unlock controller-0
-------------------

.. incl-unlock-controller-0-aio-simplex-start:

Unlock controller-0 to bring it into service:

::

  system host-unlock controller-0

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
       $ system application-list
       +---------------------+---------+-------------------------------+---------------+----------+-----------+
       | application         | version | manifest name                 | manifest file | status   | progress  |
       +---------------------+---------+-------------------------------+---------------+----------+-----------+
       | oidc-auth-apps      | 1.0-0   | oidc-auth-manifest            | manifest.yaml | uploaded | completed |
       | platform-integ-apps | 1.0-8   | platform-integration-manifest | manifest.yaml | uploaded | completed |
       | rook-ceph-apps      | 1.0-1   | rook-ceph-manifest            | manifest.yaml | uploaded | completed |
       +---------------------+---------+-------------------------------+---------------+----------+-----------+

   #. Configure rook to use /dev/sdb disk on controller-0 as a ceph |OSD|.

      ::

       system host-disk-wipe -s --confirm controller-0 /dev/sdb

      values.yaml for rook-ceph-apps.
      ::

       cluster:
         storage:
           nodes:
           - name: controller-0
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
       rook--ceph-crashcollector-controller-0-764c7f9c8-bh5c7   1/1     Running     0          62m
       rook--ceph-mgr-a-69df96f57-9l28p                         1/1     Running     0          63m
       rook--ceph-mon-a-55fff49dcf-ljfnx                        1/1     Running     0          63m
       rook--ceph-operator-77b64588c5-nlsf2                     1/1     Running     0          66m
       rook--ceph-osd-0-7d5785889f-4rgmb                        1/1     Running     0          62m
       rook--ceph-osd-prepare-controller-0-cmwt5                0/1     Completed   0          2m14s
       rook--ceph-tools-5778d7f6c-22tms                         1/1     Running     0          64m
       rook--discover-kmv6c                                     1/1     Running     0          65m

   ----------
   Next steps
   ----------

   .. include:: ../kubernetes_install_next.txt
