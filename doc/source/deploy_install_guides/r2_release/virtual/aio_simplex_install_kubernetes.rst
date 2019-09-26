==============================================
Install StarlingX Kubernetes on Virtual AIO-SX
==============================================

This section describes the steps to install the StarlingX Kubernetes platform
on a **StarlingX R2.0 virtual All-in-one Simplex** deployment configuration.

.. contents::
   :local:
   :depth: 1

--------------------------------
Install software on controller-0
--------------------------------

In the last step of "Prepare virtual environment and servers", the
controller-0 virtual server 'simplex-controller-0' was started by the
:command:`setup_configuration.sh` command.

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
#. Third menu: Select 'Standard Security Profile'

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

#. Specify user configuration overrides for the Ansible bootstrap playbook.

   Ansible is used to bootstrap StarlingX on controller-0. Key files for Ansible
   configuration are:

   ``/etc/ansible/hosts``
      The default Ansible inventory file. Contains a single host: localhost.

   ``/usr/share/ansible/stx-ansible/playbooks/bootstrap/bootstrap.yml``
      The Ansible bootstrap playbook.

   ``/usr/share/ansible/stx-ansible/playbooks/bootstrap/host_vars/default.yml``
      The default configuration values for the bootstrap playbook.

   sysadmin home directory ($HOME)
      The default location where Ansible looks for and imports user
      configuration override files for hosts. For example: ``$HOME/<hostname>.yml``.


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
        admin_password: <sysadmin-password>
        ansible_become_pass: <sysadmin-password>
        EOF


   Additional Ansible bootstrap configurations for advanced use cases are available:

   * :ref:`IPv6 <ansible_bootstrap_ipv6>`


#. Run the Ansible bootstrap playbook:

   ::

    ansible-playbook /usr/share/ansible/stx-ansible/playbooks/bootstrap/bootstrap.yml

   Wait for Ansible bootstrap playbook to complete.
   This can take 5-10 minutes, depending on the performance of the host machine.

----------------------
Configure controller-0
----------------------

On virtual controller-0:

#. Acquire admin credentials:

   ::

    source /etc/platform/openrc

#. Configure the OAM interface of controller-0:

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
    export COMPUTE=controller-0
    PHYSNET0='physnet0'
    PHYSNET1='physnet1'
    SPL=/tmp/tmp-system-port-list
    SPIL=/tmp/tmp-system-host-if-list
    system host-port-list ${COMPUTE} --nowrap > ${SPL}
    system host-if-list -a ${COMPUTE} --nowrap > ${SPIL}
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

    system host-if-modify -m 1500 -n data0 -c data ${COMPUTE} ${DATA0IFUUID}
    system host-if-modify -m 1500 -n data1 -c data ${COMPUTE} ${DATA1IFUUID}
    system interface-datanetwork-assign ${COMPUTE} ${DATA0IFUUID} ${PHYSNET0}
    system interface-datanetwork-assign ${COMPUTE} ${DATA1IFUUID} ${PHYSNET1}

#. Add an OSD on controller-0 for ceph:

   ::

    system host-disk-list controller-0
    system host-disk-list controller-0 | awk '/\/dev\/sdb/{print $2}' | xargs -i system host-stor-add controller-0 {}
    system host-stor-list controller-0

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

     export COMPUTE=controller-0

     echo ">>> Getting root disk info"
     ROOT_DISK=$(system host-show ${COMPUTE} | grep rootfs | awk '{print $4}')
     ROOT_DISK_UUID=$(system host-disk-list ${COMPUTE} --nowrap | grep ${ROOT_DISK} | awk '{print $2}')
     echo "Root disk: $ROOT_DISK, UUID: $ROOT_DISK_UUID"

     echo ">>>> Configuring nova-local"
     NOVA_SIZE=34
     NOVA_PARTITION=$(system host-disk-partition-add -t lvm_phys_vol ${COMPUTE} ${ROOT_DISK_UUID} ${NOVA_SIZE})
     NOVA_PARTITION_UUID=$(echo ${NOVA_PARTITION} | grep -ow "| uuid | [a-z0-9\-]* |" | awk '{print $4}')
     system host-lvg-add ${COMPUTE} nova-local
     system host-pv-add ${COMPUTE} nova-local ${NOVA_PARTITION_UUID}
     sleep 2

     echo ">>> Wait for partition $NOVA_PARTITION_UUID to be ready."
     while true; do system host-disk-partition-list $COMPUTE --nowrap | grep $NOVA_PARTITION_UUID | grep Ready; if [ $? -eq 0 ]; then break; fi; sleep 1; done

.. incl-config-controller-0-openstack-specific-aio-simplex-end:

-------------------
Unlock controller-0
-------------------

Unlock virtual controller-0 to bring it into service:

::

  system host-unlock controller-0

Controller-0 will reboot to apply configuration changes and come into
service. This can take 5-10 minutes, depending on the performance of the host machine.

----------
Next steps
----------

.. include:: ../kubernetes_install_next.txt