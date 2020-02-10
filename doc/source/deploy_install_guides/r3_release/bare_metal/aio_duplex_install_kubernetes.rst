=================================================
Install StarlingX Kubernetes on Bare Metal AIO-DX
=================================================

This section describes the steps to install the StarlingX Kubernetes platform
on a **StarlingX R3.0 bare metal All-in-one Duplex** deployment configuration.

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

.. include:: aio_simplex_install_kubernetes.rst
   :start-after: incl-install-software-controller-0-aio-simplex-start:
   :end-before: incl-install-software-controller-0-aio-simplex-end:

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
        admin_password: <sysadmin-password>
        ansible_become_pass: <sysadmin-password>
        EOF

   Refer to :doc:`/deploy_install_guides/r3_release/ansible_bootstrap_configs`
   for information on additional Ansible bootstrap configurations for advanced
   Ansible bootstrap scenarios.

#. Run the Ansible bootstrap playbook:

   ::

      ansible-playbook /usr/share/ansible/stx-ansible/playbooks/bootstrap.yml

   Wait for Ansible bootstrap playbook to complete.
   This can take 5-10 minutes, depending on the performance of the host machine.

----------------------
Configure controller-0
----------------------

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

*************************************
OpenStack-specific host configuration
*************************************

.. include:: aio_simplex_install_kubernetes.rst
   :start-after: incl-config-controller-0-openstack-specific-aio-simplex-start:
   :end-before: incl-config-controller-0-openstack-specific-aio-simplex-end:

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

#. Wait for the software installation on controller-1 to complete, for controller-1 to
   reboot, and for controller-1 to show as locked/disabled/online in 'system host-list'.

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

#. Configure the OAM and MGMT interfaces of controller-1 and specify the
   attached networks. Use the OAM and MGMT port names, for example eth0, that are
   applicable to your deployment environment:

   (Note that the MGMT interface is partially set up automatically by the network
   install procedure.)

   ::

      OAM_IF=<OAM-PORT>
      MGMT_IF=<MGMT-PORT>
      system host-if-modify controller-1 $OAM_IF -c platform
      system interface-network-assign controller-1 $OAM_IF oam
      system interface-network-assign controller-1 mgmt0 cluster-host

#. Configure data interfaces for controller-1. Use the DATA port names, for example
   eth0, applicable to your deployment environment.

   .. important::

      This step is **required** for OpenStack.

      This step is optional for Kubernetes: Do this step if using SRIOV network
      attachments in hosted application containers.

   For Kubernetes SRIOV network attachments:

   * Configure the SRIOV device plugin:

     ::

        system host-label-assign controller-1 sriovdp=enabled

   * If planning on running DPDK in containers on this host, configure the number
     of 1G Huge pages required on both NUMA nodes:

     ::

        system host-memory-modify controller-1 0 -1G 100
        system host-memory-modify controller-1 1 -1G 100


   For both Kubernetes and OpenStack:

   ::

      DATA0IF=<DATA-0-PORT>
      DATA1IF=<DATA-1-PORT>
      export NODE=controller-1
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

#. Add an OSD on controller-1 for Ceph:

   ::

      echo ">>> Add OSDs to primary tier"
      system host-disk-list controller-1
      system host-disk-list controller-1 | awk '/\/dev\/sdb/{print $2}' | xargs -i system host-stor-add controller-1 {}
      system host-stor-list controller-1

*************************************
OpenStack-specific host configuration
*************************************

.. important::

   **This step is required only if the StarlingX OpenStack application
   (stx-openstack) will be installed.**

#. **For OpenStack only:** Assign OpenStack host labels to controller-1 in
   support of installing the stx-openstack manifest and helm-charts later.

   ::

      system host-label-assign controller-1 openstack-control-plane=enabled
      system host-label-assign controller-1 openstack-compute-node=enabled
      system host-label-assign controller-1 openvswitch=enabled
      system host-label-assign controller-1 sriov=enabled

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

-------------------
Unlock controller-1
-------------------

Unlock controller-1 in order to bring it into service:

::

  system host-unlock controller-1

Controller-1 will reboot in order to apply configuration changes and come into
service. This can take 5-10 minutes, depending on the performance of the host
machine.

----------
Next steps
----------

.. include:: ../kubernetes_install_next.txt
