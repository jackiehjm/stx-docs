=================================================
Install StarlingX Kubernetes on Bare Metal AIO-SX
=================================================

This section describes the steps to install the StarlingX Kubernetes platform
on a **StarlingX R3.0 bare metal All-in-one Simplex** deployment configuration.

.. contents::
   :local:
   :depth: 1

---------------------
Create a bootable USB
---------------------

Refer to :doc:`/deploy_install_guides/bootable_usb` for instructions on how to
create a bootable USB with the StarlingX ISO on your system.

--------------------------------
Install software on controller-0
--------------------------------

.. incl-install-software-controller-0-aio-simplex-start:

#. Insert the bootable USB into a bootable USB port on the host you are
   configuring as controller-0.

#. Power on the host.

#. Attach to a console, ensure the host boots from the USB, and wait for the
   StarlingX Installer Menus.

#. Make the following menu selections in the installer:

   #. First menu: Select 'All-in-one Controller Configuration'.
   #. Second menu: Select 'Graphical Console' or 'Serial Console' depending on
      your terminal access to the console port.

      .. figure:: ../figures/starlingx-aio-controller-configuration.png
         :alt: starlingx-controller-configuration

         *Figure 1: StarlingX Controller Configuration*


      .. figure:: ../figures/starlingx-aio-serial-console.png
         :alt: starlingx-serial-console

         *Figure 2: StarlingX Serial Console*

Wait for non-interactive install of software to complete and server to reboot.
This can take 5-10 minutes, depending on the performance of the server.

.. incl-install-software-controller-0-aio-simplex-end:

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

   Refer to :doc:`/deploy_install_guides/r3_release/ansible_bootstrap_configs`
   for information on additional Ansible bootstrap configurations for advanced
   Ansible bootstrap scenarios, such as Docker proxies when deploying behind a
   firewall, etc. Refer to :doc:`/../../configuration/docker_proxy_config` for
   details about Docker proxy settings.

#. Run the Ansible bootstrap playbook:

   ::

      ansible-playbook /usr/share/ansible/stx-ansible/playbooks/bootstrap.yml

   Wait for Ansible bootstrap playbook to complete.
   This can take 5-10 minutes, depending on the performance of the host machine.

   The image below shows a typical successful run.

   .. figure:: ../figures/starlingx-release3-ansible-bootstrap-simplex.png
      :alt: ansible bootstarp install screen
      :width: 800

      *Figure 3: StarlingX Ansible Bootstrap*

----------------------
Configure controller-0
----------------------

#. Acquire admin credentials:

   ::

     source /etc/platform/openrc

#. At this stage, you can see the controller status, it will be in the locked state.

   ::

    [sysadmin@localhost ~(keystone_admin)]$ system host-list
    +----+--------------+-------------+----------------+-------------+--------------+
    | id | hostname     | personality | administrative | operational | availability |
    +----+--------------+-------------+----------------+-------------+--------------+
    | 1  | controller-0 | controller  | locked         | disabled    | online       |
    +----+--------------+-------------+----------------+-------------+--------------+

#. Configure the OAM interface of controller-0 and specify the attached network
   as "oam". Use the OAM port name that is applicable to your deployment
   environment, for example eth0:

   ::

     OAM_IF=<OAM-PORT>
     system host-if-modify controller-0 $OAM_IF -c platform
     system interface-network-assign controller-0 $OAM_IF oam

#. If the system is a subcloud in a distributed cloud environment, then the mgmt
   network and cluster-host networks must be configured on an actual interface
   and not left on the loopback interface.

   .. important::

      Complete this step only if the system is a subcloud in a distributed cloud
      environment!

   For example:

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

#. Configure NTP Servers for network time synchronization:

   ::

      system ntp-modify ntpservers=0.pool.ntp.org,1.pool.ntp.org

#. Configure data interfaces for controller-0. Use the DATA port names, for example
   eth0, applicable to your deployment environment.

   .. important::

      This step is **required** for OpenStack.

      This step is optional for Kubernetes: Do this step if using SRIOV network
      attachments in hosted application containers.

   For Kubernetes SRIOV network attachments:

   * Configure the SRIOV device plugin

     ::

       system host-label-assign controller-0 sriovdp=enabled

   * If planning on running DPDK in containers on this host, configure the number
     of 1G Huge pages required on both NUMA nodes.

     ::

       system host-memory-modify controller-0 0 -1G 100
       system host-memory-modify controller-0 1 -1G 100

   For both Kubernetes and OpenStack:

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

#. Add an OSD on controller-0 for Ceph. The following example adds an OSD
   to the `sdb` disk:

   ::

     echo ">>> Add OSDs to primary tier"
     system host-disk-list controller-0
     system host-disk-list controller-0 | awk '/\/dev\/sdb/{print $2}' | xargs -i system host-stor-add controller-0 {}
     system host-stor-list controller-0

#. If required, and not already done as part of bootstrap, configure Docker to
   use a proxy server.

   #. List Docker proxy parameters:

      ::

       system service-parameter-list platform docker

   #. Refer to :doc:`/../../configuration/docker_proxy_config` for
      details about Docker proxy settings.

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

#. **For OpenStack only:** Set up disk partition for nova-local volume group,
   which is needed for stx-openstack nova ephemeral disks.

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

Unlock controller-0 in order to bring it into service:

::

  system host-unlock controller-0

Controller-0 will reboot in order to apply configuration changes and come into
service. This can take 5-10 minutes, depending on the performance of the host machine.

.. note::

   Once the controller comes back up, check the status of controller-0. It should
   now show "unlocked", "enabled", "available" and "provisioned".

::

 [sysadmin@controller-0 ~(keystone_admin)]$ system host-list
 +----+--------------+-------------+----------------+-------------+--------------+
 | id | hostname     | personality | administrative | operational | availability |
 +----+--------------+-------------+----------------+-------------+--------------+
 | 1  | controller-0 | controller  | unlocked       | enabled     | available    |
 +----+--------------+-------------+----------------+-------------+--------------+
 [sysadmin@controller-0 ~(keystone_admin)]$

 ===============================================
  [sysadmin@controller-0 ~(keystone_admin)]$ system host-show controller-0
 +-----------------------+------------------------------------------------------------ ----------+
 | Property              | Value                                                                |
 +-----------------------+------------------------------------------------------------ ----------+
 | action                | none                                                                 |
 | administrative        | unlocked                                                             |
 | availability          | available                                                            |
 | bm_ip                 | None                                                                 |
 | bm_type               | none                                                                 |
 | bm_username           | None
 | boot_device           | /dev/disk/by-path/pci-0000:00:1f.2-ata-1.0                           |
 | capabilities          | {u'stor_function': u'monitor', u'Personality': u'Controller-Active'} |
 | clock_synchronization | ntp                                                                  |
 | config_applied        | 03e22d8b-1b1f-4c52-9500-96afad295d9a                                 |
 | config_status         | None                                                                 |
 | config_target         | 03e22d8b-1b1f-4c52-9500-96afad295d9a                                 |
 | console               | ttyS0,115200                                                         |
 | created_at            | 2020-03-09T12:34:34.866469+00:00                                     |
 | hostname              | controller-0                                                         |
 | id                    | 1                                                                    |
 | install_output        | text                                                                 |
 | install_state         | None                                                                 |
 | install_state_info    | None                                                                 |
 | inv_state             | inventoried                                                          |
 | invprovision          | provisioned                                                          |
 | location              | {}                                                                   |
 | mgmt_ip               | 192.168.204.2                                                        |
 | mgmt_mac              | 00:00:00:00:00:00                                                    |
 | operational           | enabled                                                              |
 | personality           | controller                                                           |
 | reserved              | False                                                                |
 | rootfs_device         | /dev/disk/by-path/pci-0000:00:1f.2-ata-1.0                           |
 | serialid              | None                                                                 |
 | software_load         | 19.12                                                                |
 | subfunction_avail     | available                                                            |
 | subfunction_oper      | enabled                                                              |
 | subfunctions          | controller,worker                                                    |
 | task                  |                                                                      |
 | tboot                 | false                                                                |
 | ttys_dcd              | None                                                                 |
 | updated_at            | 2020-03-09T14:10:42.362846+00:00                                     |
 | uptime                | 991                                                                  |
 | uuid                  | 66aa842e-84a2-4041-b93e-f0275cde8784                                 |
 | vim_progress_status   | services-enabled                                                     |
 +-----------------------+------------------------------------------------------------ ----------+

.. incl-unlock-controller-0-aio-simplex-end:

----------
Next steps
----------

.. include:: ../kubernetes_install_next.txt
