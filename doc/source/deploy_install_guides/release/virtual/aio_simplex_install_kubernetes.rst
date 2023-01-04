==============================================
Install StarlingX Kubernetes on Virtual AIO-SX
==============================================

This section describes the steps to install the StarlingX Kubernetes platform
on a **StarlingX R7.0 virtual All-in-one Simplex** deployment configuration.

.. contents::
   :local:
   :depth: 1

--------------------------------
Install software on controller-0
--------------------------------

In the last step of :doc:`aio_simplex_environ`, the controller-0 virtual server 'simplex-controller-0'
was started by the :command:`setup_configuration.sh` command.

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

   ``/usr/share/ansible/stx-ansible/playbooks/bootstrap.yml``
      The Ansible bootstrap playbook.

   ``/usr/share/ansible/stx-ansible/playbooks/host_vars/bootstrap/default.yml``
      The default configuration values for the bootstrap playbook.

   ``sysadmin home directory ($HOME)``
      The default location where Ansible looks for and imports user
      configuration override files for hosts. For example: ``$HOME/<hostname>.yml``.

   .. include:: /shared/_includes/ansible_install_time_only.txt

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

   Refer to :ref:`Ansible Bootstrap Configurations <ansible_bootstrap_configs_r7>`
   for information on additional Ansible bootstrap configurations for advanced
   Ansible bootstrap scenarios, such as Docker proxies when deploying behind a
   firewall, etc. Refer to :ref:`Docker Proxy Configuration <docker_proxy_config>`
   for details about Docker proxy settings.

#. Run the Ansible bootstrap playbook:

   ::

    ansible-playbook /usr/share/ansible/stx-ansible/playbooks/bootstrap.yml

   Wait for Ansible bootstrap playbook to complete.
   This can take 5-10 minutes, depending on the performance of the host machine.

----------------------
Configure controller-0
----------------------

On virtual controller-0:

#. Acquire admin credentials:

   ::

     source /etc/platform/openrc

#. Configure the OAM interface of controller-0 and specify the attached network
   as "oam". Use the OAM port name, for example eth0, that is applicable to your
   deployment environment:

   ::

     OAM_IF=enp7s1
     system host-if-modify controller-0 $OAM_IF -c platform
     system interface-network-assign controller-0 $OAM_IF oam

#. Configure NTP servers for network time synchronization:

   .. note::

      In a virtual environment, this can sometimes cause Ceph clock skew alarms.
      Also, the virtual instances clock is synchronized with the host clock,
      so it is not absolutely required to configure NTP in this step.

   ::

    system ntp-modify ntpservers=0.pool.ntp.org,1.pool.ntp.org

**************************************************************
Optionally, initialize a Ceph-based Persistent Storage Backend
**************************************************************

.. important::

    A persistent storage backend is required if your application requires
    Persistent Volume Claims (PVCs). The StarlingX OpenStack application
    (|prefix|-openstack) requires PVCs, therefore if you plan on using the
    |prefix|-openstack application, then you must configure a persistent storage
    backend.

    There are two options for persistent storage backend:
    1) the host-based Ceph solution and
    2) the Rook container-based Ceph solution.

    The Rook container-based Ceph backend is installed after both
    AIO-Controllers are configured and unlocked.

For host-based Ceph,

#. Initialize with add ceph backend:

   ::

      system storage-backend-add ceph --confirmed

#. Add an OSD on controller-0 for host-based Ceph:

   ::

      system host-disk-list controller-0
      system host-disk-list controller-0 | awk '/\/dev\/sdb/{print $2}' | xargs -i system host-stor-add controller-0 {}
      system host-stor-list controller-0

   See :ref:`configure-ceph-osds-on-a-host <configure-ceph-osds-on-a-host>` for
   additional info on configuring the Ceph storage backend such as supporting
   SSD-backed journals, multiple storage tiers, and so on.

For Rook container-based Ceph:

#. Initialize with add ceph-rook backend:

   ::

     system storage-backend-add ceph-rook --confirmed

#. Assign Rook host labels to controller-0 in support of installing the
   rook-ceph-apps manifest/helm-charts later:

   ::

      system host-label-assign controller-0 ceph-mon-placement=enabled
      system host-label-assign controller-0 ceph-mgr-placement=enabled

#. Configure data interfaces for controller-0.

   .. important::

      This step is required only if the StarlingX OpenStack application
      (|prefix|-openstack) will be installed.

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

#. If required, and not already done as part of bootstrap, configure Docker to
   use a proxy server.

   #. List Docker proxy parameters:

      ::

       system service-parameter-list platform docker

   #. Refer to :ref:`docker_proxy_config` for
      details about Docker proxy settings.

*************************************
OpenStack-specific host configuration
*************************************

.. incl-config-controller-0-openstack-specific-aio-simplex-start:

.. important::

   This step is required only if the StarlingX OpenStack application
   (|prefix|-openstack) will be installed.

#. **For OpenStack only:** Assign OpenStack host labels to controller-0 in
   support of installing the |prefix|-openstack manifest/helm-charts later.

   .. parsed-literal::

     system host-label-assign controller-0 openstack-control-plane=enabled
     system host-label-assign controller-0 openstack-compute-node=enabled
     system host-label-assign controller-0 |vswitch-label|

   .. note::

      If you have a |NIC| that supports |SRIOV|, then you can enable it by
      using the following:

      .. code-block:: none

         system host-label-assign controller-0 sriov=enabled

#. **For OpenStack only:** A vSwitch is required.

   The default vSwitch is containerized |OVS| that is packaged with the
   |prefix|-openstack manifest/helm-charts. StarlingX provides the option to use
   |OVS-DPDK| on the host, however, in the virtual environment |OVS-DPDK| is
   NOT supported, only |OVS| is supported. Therefore, simply use the default
   |OVS| vSwitch here.

#. **For OpenStack only:** Set up a 'instances' filesystem,
   which is needed for |prefix|-openstack nova ephemeral disks.

   ::

     export NODE=controller-0
     system host-fs-add ${NODE} instances=34

.. incl-config-controller-0-openstack-specific-aio-simplex-end:

-------------------
Unlock controller-0
-------------------

Unlock virtual controller-0 to bring it into service:

::

  system host-unlock controller-0

Controller-0 will reboot to apply configuration changes and come into service.
This can take 5-10 minutes, depending on the performance of the host machine.

--------------------------------------------------------------------------
Optionally, finish configuration of Ceph-based Persistent Storage Backend
--------------------------------------------------------------------------

For host-based Ceph:  Nothing else is required.

For Rook container-based Ceph:

On **virtual** controller-0:

#. Wait for application rook-ceph-apps uploaded

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

#. Configure rook to use /dev/sdb disk on controller-0 as a ceph osd

   ::

    $ system host-disk-wipe -s --confirm controller-0 /dev/sdb


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

#. Wait for |OSDs| pod ready.

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

.. include:: /_includes/kubernetes_install_next.txt
