==============================================
Install StarlingX Kubernetes on Virtual AIO-SX
==============================================

This section describes the steps to install the StarlingX Kubernetes platform
on a **StarlingX R3.0 virtual All-in-one Simplex** deployment configuration.

.. contents::
   :local:
   :depth: 1

--------------------------------
Install software on controller-0
--------------------------------

In the last step of :doc:`aio_simplex_environ`, the controller-0 virtual server
'simplex-controller-0' was started by the :command:`setup_configuration.sh`
command.

On the host, attach to the console of virtual controller-0 and select the
appropriate installer menu options to start the non-interactive install of
StarlingX software on controller-0.

.. note::

   When entering the console, it is very easy to miss the first installer menu
   selection. Use ESC to navigate to previous menus, to ensure you are at the
   first installer menu.

::

  virsh console simplex-controller-0

Make the following menu selections in the installer:

#. First menu: Select 'All-in-one Controller Configuration'
#. Second menu: Select 'Serial Console'

   .. figure:: ../figures/starlingx-aio-controller-configuration.png
      :alt: starlingx-controller-configuration

      *Figure 1: StarlingX Controller Configuration*


   .. figure:: ../figures/starlingx-aio-serial-console.png
      :alt: starlingx--serial-console

      *Figure 2: StarlingX Serial Console*

   Wait for the non-interactive install of software to complete and for the server
   to reboot. This can take 5-10 minutes, depending on the performance of the host
   machine.

--------------------------------
Bootstrap system on controller-0
--------------------------------

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

#. External connectivity is required to run the Ansible bootstrap playbook.

   ::

    export CONTROLLER0_OAM_CIDR=10.10.10.3/24
    export DEFAULT_OAM_GATEWAY=10.10.10.1
    sudo ip address add $CONTROLLER0_OAM_CIDR dev enp7s1
    sudo ip link set up dev enp7s1
    sudo ip route add default via $DEFAULT_OAM_GATEWAY dev enp7s1

   Check the configured network:

   ::

    localhost:~$ ifconfig
    enp7s1: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
    inet 10.10.10.3  netmask 255.255.255.0  broadcast 0.0.0.0
    inet6 fe80::5054:ff:feb6:10d6  prefixlen 64  scopeid 0x20<link>
    ether 52:54:00:b6:10:d6  txqueuelen 1000  (Ethernet)
    RX packets 10  bytes 1151 (1.1 KiB)
    RX errors 0  dropped 0  overruns 0  frame 0
    TX packets 94  bytes 27958 (27.3 KiB)
    TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

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
        system_mode: simplex

        dns_servers:
        - 8.8.8.8
        - 8.8.4.4

        external_oam_subnet: 10.10.10.0/24
        external_oam_gateway_address: 10.10.10.1
        external_oam_floating_address: 10.10.10.2

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

On virtual controller-0:

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
   as "oam". Use the OAM port name, for example eth0, that is applicable to your
   deployment environment:

   ::

     OAM_IF=enp7s1
     system host-if-modify controller-0 $OAM_IF -c platform
     system interface-network-assign controller-0 $OAM_IF oam

#. Configure NTP Servers for network time synchronization:

   .. note::

      In a virtual environment, this can sometimes cause Ceph clock skew alarms.
      Also, the virtual instances clock is synchronized with the host clock,
      so it is not absolutely required to configure NTP in this step.

   ::

    system ntp-modify ntpservers=0.pool.ntp.org,1.pool.ntp.org

#. Configure data interfaces for controller-0.

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

#. Add an OSD on controller-0 for Ceph:

   ::

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
   support of installing the stx-openstack manifest/helm-charts later.

   ::

     system host-label-assign controller-0 openstack-control-plane=enabled
     system host-label-assign controller-0 openstack-compute-node=enabled
     system host-label-assign controller-0 openvswitch=enabled
     system host-label-assign controller-0 sriov=enabled

#. **For OpenStack only:** A vSwitch is required.

   The default vSwitch is containerized OVS that is packaged with the
   stx-openstack manifest/helm-charts. StarlingX provides the option to use
   OVS-DPDK on the host, however, in the virtual environment OVS-DPDK is NOT
   supported, only OVS is supported. Therefore, simply use the default OVS
   vSwitch here.

#. **For OpenStack Only:** Set up disk partition for nova-local volume group,
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

.. incl-unlock-controller-0-virt-aio-simplex-start:

Unlock virtual controller-0 to bring it into service:

::

  system host-unlock controller-0

Controller-0 will reboot to apply configuration changes and come into
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
 | bm_username           | None                                                                 |
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

.. incl-unlock-controller-0-virt-aio-simplex-end:

----------
Next steps
----------

.. include:: ../kubernetes_install_next.txt
