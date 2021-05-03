
.. _aio_duplex_install_kubernetes:

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
      :ref:`Docker Proxy Configurations <docker_proxy_config>` for details
      about Docker proxy settings.

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

#. Configure the |OAM| and MGMT interfaces of controller-0 and specify the
   attached networks. Use the |OAM| and MGMT port names, for example eth0, that
   are applicable to your deployment environment.

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

#. Configure |NTP| servers for network time synchronization:

   ::

     system ntp-modify ntpservers=0.pool.ntp.org,1.pool.ntp.org

**************************************************************
Optionally, initialize a Ceph-based Persistent Storage Backend
**************************************************************

.. important::

    A persistent storage backend is required if your application requires
    Persistent Volume Claims (PVCs). The StarlingX OpenStack application
    (stx-openstack) requires |PVCs|, therefore if you plan on using the
    stx-openstack application, then you must configure a persistent storage
    backend.

    .. only:: starlingx

       There are two options for persistent storage backend:
       1) the host-based Ceph solution and
       2) the Rook container-based Ceph solution.

       The Rook container-based Ceph backend is installed after both
       AIO-Controllers are configured and unlocked.

For host-based Ceph:

#. Initialize with add ceph backend:

   ::

      system storage-backend-add ceph --confirmed

#. Add an |OSD| on controller-0 for host-based Ceph:

   ::

      system host-disk-list controller-0
      system host-disk-list controller-0 | awk '/\/dev\/sdb/{print $2}' | xargs -i system host-stor-add controller-0 {}
      system host-stor-list controller-0

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

   #. Configure data interfaces for controller-0. Use the DATA port names, for example
      eth0, applicable to your deployment environment.

      .. important::

         This step is **required** for OpenStack.

         This step is optional for Kubernetes: Do this step if using |SRIOV| network
         attachments in hosted application containers.

   For Kubernetes |SRIOV| network attachments:

   * Configure the |SRIOV| device plugin.

     ::

         system host-label-assign controller-0 sriovdp=enabled

   * If planning on running |DPDK| in containers on this host, configure the number
     of 1G Huge pages required on both |NUMA| nodes.

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

   #. If required, and not already done as part of bootstrap, configure Docker to
      use a proxy server.

      #. List Docker proxy parameters:

         ::

          system service-parameter-list platform docker

      #. Refer to :ref:`Docker Proxy Configuration <docker_proxy_config>` for
         details about Docker proxy settings.

.. only:: starlingx

   *************************************
   OpenStack-specific host configuration
   *************************************

   .. include:: inc-openstack-specific-host-config.rest


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

#. Configure the |OAM| and MGMT interfaces of controller-1 and specify the
   attached networks. Use the |OAM| and MGMT port names, for example eth0, that are
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

      This step is optional for Kubernetes: Do this step if using |SRIOV|
      network attachments in hosted application containers.

   For Kubernetes |SRIOV| network attachments:

   * Configure the |SRIOV| device plugin:

     ::

        system host-label-assign controller-1 sriovdp=enabled

   * If planning on running DPDK in containers on this host, configure the number
     of 1G Huge pages required on both NUMA nodes:

     ::

        system host-memory-modify controller-1 0 -1G 100
        system host-memory-modify controller-1 1 -1G 100

   .. only:: starlingx

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

*************************************************************************************
Optionally, configure host-specific details for Ceph-based Persistent Storage Backend
*************************************************************************************

For host-based Ceph:

#. Add an |OSD| on controller-1 for host-based Ceph:

   ::

      system host-disk-list controller-1
      system host-disk-list controller-1 | awk '/\/dev\/sdb/{print $2}' | xargs -i system host-stor-add controller-1 {}
      system host-stor-list controller-1

.. only:: starlingx

   For Rook container-based Ceph:

   #. Assign Rook host labels to controller-1 in support of installing the
      rook-ceph-apps manifest/helm-charts later:

      ::

         system host-label-assign controller-1 ceph-mon-placement=enabled
         system host-label-assign controller-1 ceph-mgr-placement=enabled

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

.. only:: starlingx

   --------------------------------------------------------------------------
   Optionally, finish configuration of Ceph-based Persistent Storage Backend
   --------------------------------------------------------------------------

   For host-based Ceph:  Nothing else is required.

   For Rook container-based Ceph:

   On **virtual** controller-0 and controller-1:

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

   ----------
   Next steps
   ----------

   .. include:: ../kubernetes_install_next.txt
