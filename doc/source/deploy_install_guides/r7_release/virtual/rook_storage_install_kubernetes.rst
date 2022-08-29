==================================================================
Install StarlingX Kubernetes on Virtual Standard with Rook Storage
==================================================================

This section describes the steps to install the StarlingX Kubernetes platform
on a **StarlingX R7.0 virtual Standard with Rook Storage** deployment configuration,
deploy rook ceph cluster replacing default native ceph cluster.

.. contents::
   :local:
   :depth: 1

--------------------------------
Install software on controller-0
--------------------------------

In the last step of :doc:`rook_storage_environ`, the controller-0 virtual
server 'rookstorage-controller-0' was started by the
:command:`setup_configuration.sh` command.

On the host, attach to the console of virtual controller-0 and select the appropriate
installer menu options to start the non-interactive install of
StarlingX software on controller-0.

.. note::

   When entering the console, it is very easy to miss the first installer menu
   selection. Use ESC to navigate to previous menus, to ensure you are at the
   first installer menu.

::

  virsh console rookstorage-controller-0

Make the following menu selections in the installer:

#. First menu: Select 'Standard Controller Configuration'
#. Second menu: Select 'Serial Console'

Wait for the non-interactive install of software to complete and for the server
to reboot. This can take 5-10 minutes depending on the performance of the host
machine.

--------------------------------
Bootstrap system on controller-0
--------------------------------

.. include:: controller_storage_install_kubernetes.rst
   :start-after: incl-bootstrap-controller-0-virt-controller-storage-start:
   :end-before: incl-bootstrap-controller-0-virt-controller-storage-end:

----------------------
Configure controller-0
----------------------

On virtual controller-0:

#. Acquire admin credentials:

   ::

      source /etc/platform/openrc

#. Configure the OAM and MGMT interfaces of controller-0 and specify the
   attached networks:

   ::

      OAM_IF=enp7s1
      MGMT_IF=enp7s2
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

#. Configure NTP servers for network time synchronization:

   .. note::

      In a virtual environment, this can sometimes cause Ceph clock skew alarms.
      Also, the virtual instance clock is synchronized with the host clock,
      so it is not absolutely required to configure NTP here.

   ::

      system ntp-modify ntpservers=0.pool.ntp.org,1.pool.ntp.org


*************************************
OpenStack-specific host configuration
*************************************

.. important::

   This step is required only if the StarlingX OpenStack application
   (|prefix|-openstack) will be installed.

#. **For OpenStack only:** Assign OpenStack host labels to controller-0 in
   support of installing the |prefix|-openstack manifest/helm-charts later:

   ::

    system host-label-assign controller-0 openstack-control-plane=enabled

#. **For OpenStack only:** A vSwitch is required.

   The default vSwitch is containerized OVS that is packaged with the
   |prefix|-openstack manifest/helm-charts. StarlingX provides the option to use
   OVS-DPDK on the host, however, in the virtual environment OVS-DPDK is NOT
   supported, only OVS is supported. Therefore, simply use the default OVS
   vSwitch here.

********************************
Rook-specific host configuration
********************************

.. important::

   **This step is required only if the StarlingX Rook application will be
   installed.**

**For Rook only:** Assign Rook host labels to controller-0 in support of
installing the rook-ceph-apps manifest/helm-charts later and add ceph-rook
as storage backend:

::

    system host-label-assign controller-0 ceph-mon-placement=enabled
    system host-label-assign controller-0 ceph-mgr-placement=enabled
    system storage-backend-add ceph-rook --confirmed

-------------------
Unlock controller-0
-------------------

Unlock virtual controller-0 in order to bring it into service:

::

  system host-unlock controller-0

Controller-0 will reboot in order to apply configuration changes and come into
service. This can take 5-10 minutes, depending on the performance of the host machine.

-----------------------------------------------------------------
Install software on controller-1 and worker nodes
-----------------------------------------------------------------

#. On the host, power on the controller-1 virtual server,
   'rookstorage-controller-1'. It will automatically attempt to network
   boot over the management network:

   ::

      virsh start rookstorage-controller-1

#. Attach to the console of virtual controller-1:

   ::

      virsh console rookstorage-controller-1

#. As controller-1 VM boots, a message appears on its console instructing you to
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

   This initiates software installation on controller-1.
   This can take 5-10 minutes, depending on the performance of the host machine.

#. While waiting on the previous step to complete, start up and set the personality
   for 'rookstorage-worker-0' and 'rookstorage-worker-1'. Set the
   personality to 'worker' and assign a unique hostname for each.

   For example, start 'rookstorage-worker-0' from the host:

   ::

      virsh start rookstorage-worker-0

   Wait for new host (hostname=None) to be discovered by checking
   ‘system host-list’ on virtual controller-0:

   ::

      system host-update 3 personality=worker hostname=rook-storage-0

   Repeat for 'rookstorage-worker-1'. On the host:

   ::

      virsh start rookstorage-worker-1

   And wait for new host (hostname=None) to be discovered by checking
   ‘system host-list’ on virtual controller-0:

   ::

      system host-update 4 personality=worker hostname=rook-storage-1

   This initiates software installation on storage-0 and storage-1.
   This can take 5-10 minutes, depending on the performance of the host machine.

#. While waiting on the previous step to complete, start up and set the personality
   for 'rookstorage-worker-2' and 'rookstorage-worker-3'. Set the
   personality to 'worker' and assign a unique hostname for each.

   For example, start 'rookstorage-worker-2' from the host:

   ::

      virsh start rookstorage-worker-2

   Wait for new host (hostname=None) to be discovered by checking
   ‘system host-list’ on virtual controller-0:

   ::

      system host-update 5 personality=worker hostname=worker-0

   Repeat for 'rookstorage-worker-3'. On the host:

   ::

      virsh start controllerstorage-worker-3

   And wait for new host (hostname=None) to be discovered by checking
   ‘system host-list’ on virtual controller-0:

   ::

      system host-update 6 personality=worker hostname=worker-1

   This initiates software installation on worker-0 and worker-1.

   .. only:: starlingx

     .. Note::

        A node with Edgeworker personality is also available. See
        :ref:`deploy-edgeworker-nodes` for details.

#. Wait for the software installation on controller-1, storage-0, storage-1,
   worker-0, and worker-1 to complete, for all virtual servers to reboot, and for all
   to show as locked/disabled/online in 'system host-list'.

   ::

      system host-list
      +----+----------------+-------------+----------------+-------------+--------------+
      | id | hostname       | personality | administrative | operational | availability |
      +----+----------------+-------------+----------------+-------------+--------------+
      | 1  | controller-0   | controller  | unlocked       | enabled     | available    |
      | 2  | controller-1   | controller  | unlocked       | enabled     | available    |
      | 3  | rook-storage-0 | worker      | locked         | disabled    | offline      |
      | 4  | rook-storage-1 | worker      | locked         | disabled    | offline      |
      | 5  | worker-0       | worker      | locked         | disabled    | offline      |
      | 6  | worker-1       | worker      | locked         | disabled    | offline      |
      +----+----------------+-------------+----------------+-------------+--------------+

----------------------
Configure controller-1
----------------------

.. include:: controller_storage_install_kubernetes.rst
   :start-after: incl-config-controller-1-virt-controller-storage-start:
   :end-before: incl-config-controller-1-virt-controller-storage-end:

********************************
Rook-specific host configuration
********************************

.. important::

   **This step is required only if the StarlingX Rook application will be
   installed.**

**For Rook only:** Assign Rook host labels to controller-1 in
support of installing the rook-ceph-apps manifest/helm-charts later:

::

    system host-label-assign controller-1 ceph-mon-placement=enabled
    system host-label-assign controller-1 ceph-mgr-placement=enabled

-------------------
Unlock controller-1
-------------------

.. include:: controller_storage_install_kubernetes.rst
   :start-after: incl-unlock-controller-1-virt-controller-storage-start:
   :end-before: incl-unlock-controller-1-virt-controller-storage-end:

-----------------------
Configure storage nodes
-----------------------

On virtual controller-0:

#. Assign the cluster-host network to the MGMT interface for the storage nodes.

   Note that the MGMT interfaces are partially set up by the network install procedure.

   ::

      for NODE in rook-storage-0 rook-storage-1; do
         system interface-network-assign $NODE mgmt0 cluster-host
      done

#. **For Rook only:** Assign Rook host labels to storage-0 in
   support of installing the rook-ceph-apps manifest/helm-charts later:

   ::

    system host-label-assign rook-storage-0 ceph-mon-placement=enabled

--------------------
Unlock storage nodes
--------------------

Unlock virtual storage nodes in order to bring them into service:

::

  for STORAGE in rook-storage-0 rook-storage-1; do
     system host-unlock $STORAGE
  done

The storage nodes will reboot in order to apply configuration changes and come
into service. This can take 5-10 minutes, depending on the performance of the host machine.

----------------------
Configure worker nodes
----------------------

On virtual controller-0:

#. Assign the cluster-host network to the MGMT interface for the worker nodes.

   Note that the MGMT interfaces are partially set up automatically by the
   network install procedure.

   ::

      for NODE in worker-0 worker-1; do
         system interface-network-assign $NODE mgmt0 cluster-host
      done

#. Configure data interfaces for worker nodes.

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
      PHYSNET0='physnet0'
      PHYSNET1='physnet1'
      SPL=/tmp/tmp-system-port-list
      SPIL=/tmp/tmp-system-host-if-list

   Configure the datanetworks in sysinv, prior to referencing it in the
   :command:`system host-if-modify` command.

   ::

        system datanetwork-add ${PHYSNET0} vlan
        system datanetwork-add ${PHYSNET1} vlan

        for NODE in worker-0 worker-1; do
          echo "Configuring interface for: $NODE"
          set -ex
          system host-port-list ${NODE} --nowrap > ${SPL}
          system host-if-list -a ${NODE} --nowrap > ${SPIL}
          DATA0PCIADDR=$(cat $SPL | grep $DATA0IF |awk '{print $8}')
          DATA1PCIADDR=$(cat $SPL | grep $DATA1IF |awk '{print $8}')
          DATA0PORTUUID=$(cat $SPL | grep ${DATA0PCIADDR} | awk '{print $2}')
          DATA1PORTUUID=$(cat $SPL | grep ${DATA1PCIADDR} | awk '{print $2}')
          DATA0PORTNAME=$(cat $SPL | grep ${DATA0PCIADDR} | awk '{print $4}')
          DATA1PORTNAME=$(cat $SPL | grep ${DATA1PCIADDR} | awk '{print $4}')
          DATA0IFUUID=$(cat $SPIL | awk -v DATA0PORTNAME=$DATA0PORTNAME '($12 ~ DATA0PORTNAME) {print $2}')
          DATA1IFUUID=$(cat $SPIL | awk -v DATA1PORTNAME=$DATA1PORTNAME '($12 ~ DATA1PORTNAME) {print $2}')
          system host-if-modify -m 1500 -n data0 -c data ${NODE} ${DATA0IFUUID}
          system host-if-modify -m 1500 -n data1 -c data ${NODE} ${DATA1IFUUID}
          system interface-datanetwork-assign ${NODE} ${DATA0IFUUID} ${PHYSNET0}
          system interface-datanetwork-assign ${NODE} ${DATA1IFUUID} ${PHYSNET1}
          set +ex
        done

*************************************
OpenStack-specific host configuration
*************************************

.. important::

   This step is required only if the StarlingX OpenStack application
   (|prefix|-openstack) will be installed.

#. **For OpenStack only:** Assign OpenStack host labels to the worker nodes in
   support of installing the |prefix|-openstack manifest/helm-charts later:

   ::

      for NODE in worker-0 worker-1; do
        system host-label-assign $NODE  openstack-compute-node=enabled
        kubectl taint nodes $NODE openstack-compute-node:NoSchedule
        system host-label-assign $NODE  openvswitch=enabled
        system host-label-assign $NODE  sriov=enabled
      done

#. **For OpenStack only:** Set up disk partition for nova-local volume group,
   which is needed for |prefix|-openstack nova ephemeral disks:

   ::

      for NODE in worker-0 worker-1; do
        echo "Configuring Nova local for: $NODE"
        ROOT_DISK=$(system host-show ${NODE} | grep rootfs | awk '{print $4}')
        ROOT_DISK_UUID=$(system host-disk-list ${NODE} --nowrap | grep ${ROOT_DISK} | awk '{print $2}')
        PARTITION_SIZE=10
        NOVA_PARTITION=$(system host-disk-partition-add -t lvm_phys_vol ${NODE} ${ROOT_DISK_UUID} ${PARTITION_SIZE})
        NOVA_PARTITION_UUID=$(echo ${NOVA_PARTITION} | grep -ow "| uuid | [a-z0-9\-]* |" | awk '{print $4}')
        system host-lvg-add ${NODE} nova-local
        system host-pv-add ${NODE} nova-local ${NOVA_PARTITION_UUID}
      done

-------------------
Unlock worker nodes
-------------------

Unlock virtual worker nodes to bring them into service:

::

  for NODE in worker-0 worker-1; do
     system host-unlock $NODE
  done

The worker nodes will reboot in order to apply configuration changes and come into
service. This can take 5-10 minutes, depending on the performance of the host machine.

-------------------------------------------------
Install Rook application manifest and helm-charts
-------------------------------------------------

On virtual storage-0 and storage-1:

#. Erase gpt header of disk sdb.

   ::

    $ system host-disk-wipe -s --confirm rook-storage-0 /dev/sdb
    $ system host-disk-wipe -s --confirm rook-storage-1 /dev/sdb

#. Wait for application "rook-ceph-apps" uploaded

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

#. Edit values.yaml for rook-ceph-apps.

   ::

    cluster:
      storage:
        nodes:
        - name: rook-storage-0
          devices:
          - name: /dev/disk/by-path/pci-0000:00:03.0-ata-2.0
        - name: rook-storage-1
          devices:
          - name: /dev/disk/by-path/pci-0000:00:03.0-ata-2.0

#. Update rook-ceph-apps override value.

   ::

    system helm-override-update rook-ceph-apps rook-ceph kube-system --values values.yaml

#. Apply the rook-ceph-apps application.

   ::

    system application-apply rook-ceph-apps

#. Wait for OSDs pod ready.

   ::

    kubectl get pods -n kube-system
    rook-ceph-mgr-a-ddffc8fbb-zkvln                     1/1     Running             0          66s
    rook-ceph-mon-a-c67fdb6c8-tlbvk                     1/1     Running             0          2m11s
    rook-ceph-mon-b-76969d8685-wcq62                    1/1     Running             0          2m2s
    rook-ceph-mon-c-5bc47c6cb9-vm4j8                    1/1     Running             0          97s
    rook-ceph-operator-6fc8cfb68b-bb57z                 1/1     Running             1          7m9s
    rook-ceph-osd-0-689b6f65b-2nvcx                     1/1     Running             0          12s
    rook-ceph-osd-1-7bfd69fdf9-vjqmp                    1/1     Running             0          4s
    rook-ceph-osd-prepare-rook-storage-0-hf28p          0/1     Completed           0          50s
    rook-ceph-osd-prepare-rook-storage-1-r6lsd          0/1     Completed           0          50s
    rook-ceph-tools-84c7fff88c-x5trx                    1/1     Running             0          6m11s

----------
Next steps
----------

.. include:: /_includes/kubernetes_install_next.txt
