=================================
Bare metal All-in-one Duplex R2.0
=================================

.. contents::
   :local:
   :depth: 1

-----------
Description
-----------

.. include:: virtual_aio_duplex.rst
   :start-after: incl-aio-duplex-intro-start:
   :end-before: incl-aio-duplex-intro-end:

.. include:: virtual_aio_simplex.rst
   :start-after: incl-ipv6-note-start:
   :end-before: incl-ipv6-note-end:

---------------------
Hardware requirements
---------------------

The recommended minimum requirements for the Bare Metal Servers for the various
host types are:

+-------------------------+-----------------------------------------------------------+
| Minimum Requirement     | All-in-one Controller Node                                |
+=========================+===========================================================+
| Number of Servers       | 2                                                         |
+-------------------------+-----------------------------------------------------------+
| Minimum Processor Class | - Dual-CPU Intel® Xeon® E5 26xx Family (SandyBridge)      |
|                         |   8 cores/socket                                          |
|                         |                                                           |
|                         | or                                                        |
|                         |                                                           |
|                         | - Single-CPU Intel® Xeon® D-15xx family, 8 cores          |
|                         |   (low-power/low-cost option)                             |
+-------------------------+-----------------------------------------------------------+
| Minimum Memory          | 64 GB                                                     |
+-------------------------+-----------------------------------------------------------+
| Primary Disk            | 500 GB SDD or NVMe                                        |
+-------------------------+-----------------------------------------------------------+
| Additional Disks        | - 1 or more 500 GB (min. 10K RPM) for Ceph OSD            |
|                         | - Recommended, but not required: 1 or more SSDs or NVMe   |
|                         |   drives for Ceph journals (min. 1024 MiB per OSD journal)|
|                         | - For OpenStack, recommend 1 or more 500 GB (min. 10K RPM)|
|                         |   for VM local ephemeral storage                          |
+-------------------------+-----------------------------------------------------------+
| Minimum Network Ports   | - Mgmt/Cluster: 1x10GE                                    |
|                         | - OAM: 1x1GE                                              |
|                         | - Data: 1 or more x 10GE                                  |
+-------------------------+-----------------------------------------------------------+
| BIOS Settings           | - Hyper-Threading technology enabled                      |
|                         | - Virtualization technology enabled                       |
|                         | - VT for directed I/O enabled                             |
|                         | - CPU power and performance policy set to performance     |
|                         | - CPU C state control disabled                            |
|                         | - Plug & play BMC detection disabled                      |
+-------------------------+-----------------------------------------------------------+

---------------
Prepare Servers
---------------

.. include:: bare_metal_aio_simplex.rst
   :start-after: incl-prepare-servers-start:
   :end-before: incl-prepare-servers-end:

--------------------
StarlingX Kubernetes
--------------------

*******************************
Installing StarlingX Kubernetes
*******************************

^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Create a bootable USB with the StarlingX ISO
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Create a bootable USB with the StarlingX ISO.

Refer to :doc:`/deploy_install_guides/bootable_usb` for instructions on how to
create a bootable USB on your system.

^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Install software on controller-0
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. include:: bare_metal_aio_simplex.rst
   :start-after: incl-install-software-controller-0-start:
   :end-before: incl-install-software-controller-0-end:

^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Bootstrap system on controller-0
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. include:: bare_metal_aio_simplex.rst
   :start-after: incl-bootstrap-sys-controller-0-start:
   :end-before: incl-bootstrap-sys-controller-0-end:

^^^^^^^^^^^^^^^^^^^^^^
Configure controller-0
^^^^^^^^^^^^^^^^^^^^^^

.. include:: bare_metal_aio_simplex.rst
   :start-after: incl-config-controller-0-start:
   :end-before: incl-config-controller-0-end:

^^^^^^^^^^^^^^^^^^^
Unlock controller-0
^^^^^^^^^^^^^^^^^^^

.. incl-unlock-controller-0-start:

Unlock controller-0 in order to bring it into service:

::

  system host-unlock controller-0

Controller-0 will reboot in order to apply configuration changes and come into
service. This can take 5-10 minutes, depending on the performance of the host machine.

.. incl-unlock-controller-0-end:

^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Install software on controller-1 node
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

#. Power on the controller-1 server and force it to network boot with the
   appropriate BIOS boot options for your particular server.

#. As controller-1 boots, a message appears on its console instructing you to
   configure the personality of the node.

#. On the console of controller-0, list hosts to see newly discovered controller-1
   host, that is, host with hostname of None:

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

^^^^^^^^^^^^^^^^^^^^^^
Configure controller-1
^^^^^^^^^^^^^^^^^^^^^^

#. Configure the OAM and MGMT interfaces of controller-1 and specify the
   attached networks. Use the OAM and MGMT port names, e.g. eth0, applicable to
   your deployment environment:

   (Note that the MGMT interface is partially set up automatically by the network
   install procedure.)

   ::

      OAM_IF=<OAM-PORT>
      MGMT_IF=<MGMT-PORT>
      system host-if-modify controller-1 $OAM_IF -c platform
      system interface-network-assign controller-1 $OAM_IF oam
      system interface-network-assign controller-1 $MGMT_IF cluster-host

#. Configure data interfaces for controller-1. Use the DATA port names, e.g.
   eth0, applicable to your deployment environment.

   .. note::

      This step is **required** for OpenStack and optional for Kubernetes. For
      example, do this step if using SRIOV network attachments in application
      containers.

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
      export COMPUTE=controller-1
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

#. Add an OSD on controller-1 for ceph:

   ::

      echo ">>> Add OSDs to primary tier"
      system host-disk-list controller-1
      system host-disk-list controller-1 | awk '/\/dev\/sdb/{print $2}' | xargs -i system host-stor-add controller-1 {}
      system host-stor-list controller-1

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
OpenStack-specific host configuration
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. warning::

   The following configuration is required only if the StarlingX OpenStack
   application (stx-openstack) will be installed.

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

      export COMPUTE=controller-1

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

^^^^^^^^^^^^^^^^^^^
Unlock controller-1
^^^^^^^^^^^^^^^^^^^

Unlock controller-1 in order to bring it into service:

::

  system host-unlock controller-1

Controller-1 will reboot in order to apply configuration changes and come into
service. This can take 5-10 minutes, depending on the performance of the host machine.

When it completes, your Kubernetes cluster is up and running.

***************************
Access StarlingX Kubernetes
***************************

.. include:: virtual_aio_simplex.rst
   :start-after: incl-access-starlingx-kubernetes-start:
   :end-before: incl-access-starlingx-kubernetes-end:

-------------------
StarlingX OpenStack
-------------------

***************************
Install StarlingX OpenStack
***************************

.. include:: virtual_aio_simplex.rst
   :start-after: incl-install-starlingx-openstack-start:
   :end-before: incl-install-starlingx-openstack-end:

**************************
Access StarlingX OpenStack
**************************

.. include:: virtual_aio_simplex.rst
   :start-after: incl-access-starlingx-openstack-start:
   :end-before: incl-access-starlingx-openstack-end:

*****************************
Uninstall StarlingX OpenStack
*****************************

.. include:: virtual_aio_simplex.rst
   :start-after: incl-uninstall-starlingx-openstack-start:
   :end-before: incl-uninstall-starlingx-openstack-end:

----------------------------------------------
Extending capacity with worker / compute nodes
----------------------------------------------

**************************************************
Install software on controller-1 and compute nodes
**************************************************

#. Power on the compute servers and force them to network boot with the
   appropriate BIOS boot options for your particular server.

#. As the compute servers boot, a message appears on their console instructing
   you to configure the personality of the node.

#. On the console of controller-0, list hosts to see newly discovered compute hosts,
   that is, hosts with hostname of None:

   ::

      system host-list
      +----+--------------+-------------+----------------+-------------+--------------+
      | id | hostname     | personality | administrative | operational | availability |
      +----+--------------+-------------+----------------+-------------+--------------+
      | 1  | controller-0 | controller  | unlocked       | enabled     | available    |
      | 2  | controller-0 | controller  | unlocked       | enabled     | available    |
      | 3  | None         | None        | locked         | disabled    | offline      |
      | 4  | None         | None        | locked         | disabled    | offline      |
      +----+--------------+-------------+----------------+-------------+--------------+

#. Using the host id, set the personality of this host to 'controller':

   ::

      system host-update 3 personality=worker hostname=compute-0
      system host-update 4 personality=worker hostname=compute-1

   This initiates the install of software on compute nodes.
   This can take 5-10 minutes, depending on the performance of the host machine.

#. Wait for the install of software on the computes to complete, the computes to
   reboot and to both show as locked/disabled/online in 'system host-list'.

   ::

      system host-list
      +----+--------------+-------------+----------------+-------------+--------------+
      | id | hostname     | personality | administrative | operational | availability |
      +----+--------------+-------------+----------------+-------------+--------------+
      | 1  | controller-0 | controller  | unlocked       | enabled     | available    |
      | 2  | controller-1 | controller  | unlocked       | enabled     | available    |
      | 3  | compute-0    | compute     | locked         | disabled    | online       |
      | 4  | compute-1    | compute     | locked         | disabled    | online       |
      +----+--------------+-------------+----------------+-------------+--------------+

***********************
Configure compute nodes
***********************

#. Assign the cluster-host network to the MGMT interface for the compute nodes:

   (Note that the MGMT interfaces are partially set up automatically by the
   network install procedure.)

   ::

      for COMPUTE in compute-0 compute-1; do
         system interface-network-assign $COMPUTE mgmt0 cluster-host
      done

#. Configure data interfaces for compute nodes. Use the DATA port names, e.g.
   eth0, applicable to your deployment environment.

   ::

      DATA0IF=<DATA-0-PORT>
      DATA1IF=<DATA-1-PORT>
      PHYSNET0='physnet0'
      PHYSNET1='physnet1'
      SPL=/tmp/tmp-system-port-list
      SPIL=/tmp/tmp-system-host-if-list

      # configure the datanetworks in sysinv, prior to referencing it
      # in the ``system host-if-modify`` command'.
      system datanetwork-add ${PHYSNET0} vlan
      system datanetwork-add ${PHYSNET1} vlan

      for COMPUTE in compute-0 compute-1; do
        echo "Configuring interface for: $COMPUTE"
        set -ex
        system host-port-list ${COMPUTE} --nowrap > ${SPL}
        system host-if-list -a ${COMPUTE} --nowrap > ${SPIL}
        DATA0PCIADDR=$(cat $SPL | grep $DATA0IF |awk '{print $8}')
        DATA1PCIADDR=$(cat $SPL | grep $DATA1IF |awk '{print $8}')
        DATA0PORTUUID=$(cat $SPL | grep ${DATA0PCIADDR} | awk '{print $2}')
        DATA1PORTUUID=$(cat $SPL | grep ${DATA1PCIADDR} | awk '{print $2}')
        DATA0PORTNAME=$(cat $SPL | grep ${DATA0PCIADDR} | awk '{print $4}')
        DATA1PORTNAME=$(cat $SPL | grep ${DATA1PCIADDR} | awk '{print $4}')
        DATA0IFUUID=$(cat $SPIL | awk -v DATA0PORTNAME=$DATA0PORTNAME '($12 ~ DATA0PORTNAME) {print $2}')
        DATA1IFUUID=$(cat $SPIL | awk -v DATA1PORTNAME=$DATA1PORTNAME '($12 ~ DATA1PORTNAME) {print $2}')
        system host-if-modify -m 1500 -n data0 -c data ${COMPUTE} ${DATA0IFUUID}
        system host-if-modify -m 1500 -n data1 -c data ${COMPUTE} ${DATA1IFUUID}
        system interface-datanetwork-assign ${COMPUTE} ${DATA0IFUUID} ${PHYSNET0}
        system interface-datanetwork-assign ${COMPUTE} ${DATA1IFUUID} ${PHYSNET1}
        set +ex
      done

^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
OpenStack-specific host configuration
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. warning::

   The following configuration is required only if the StarlingX OpenStack
   application (stx-openstack) will be installed.

#. **For OpenStack only:** Assign OpenStack host labels to the compute nodes in
   support of installing the stx-openstack manifest and helm-charts later.

   ::

      for NODE in compute-0 compute-1; do
        system host-label-assign $NODE  openstack-compute-node=enabled
        system host-label-assign $NODE  openvswitch=enabled
        system host-label-assign $NODE  sriov=enabled
      done

#. **For OpenStack only:** Setup disk partition for nova-local volume group,
   needed for stx-openstack nova ephemeral disks.

   ::

      for COMPUTE in compute-0 compute-1; do
        echo "Configuring Nova local for: $COMPUTE"
        ROOT_DISK=$(system host-show ${COMPUTE} | grep rootfs | awk '{print $4}')
        ROOT_DISK_UUID=$(system host-disk-list ${COMPUTE} --nowrap | grep ${ROOT_DISK} | awk '{print $2}')
        PARTITION_SIZE=10
        NOVA_PARTITION=$(system host-disk-partition-add -t lvm_phys_vol ${COMPUTE} ${ROOT_DISK_UUID} ${PARTITION_SIZE})
        NOVA_PARTITION_UUID=$(echo ${NOVA_PARTITION} | grep -ow "| uuid | [a-z0-9\-]* |" | awk '{print $4}')
        system host-lvg-add ${COMPUTE} nova-local
        system host-pv-add ${COMPUTE} nova-local ${NOVA_PARTITION_UUID}
      done

      for COMPUTE in compute-0 compute-1; do
        echo ">>> Wait for partition $NOVA_PARTITION_UUID to be ready."
        while true; do system host-disk-partition-list $COMPUTE --nowrap | grep $NOVA_PARTITION_UUID | grep Ready; if [ $? -eq 0 ]; then break; fi; sleep 1; done
      done

********************
Unlock compute nodes
********************

Unlock compute nodes in order to bring them into service:

::

  for COMPUTE in compute-0 compute-1; do
     system host-unlock $COMPUTE
  done

The compute nodes will reboot to apply configuration changes and come into
service. This can take 5-10 minutes, depending on the performance of the host machine.

