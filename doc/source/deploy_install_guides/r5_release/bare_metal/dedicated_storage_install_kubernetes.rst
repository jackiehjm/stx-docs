

.. _dedicated_storage_install_kubernetes:

.. only:: partner

   .. include:: /_includes/install-kubernetes-null-labels.rest

==============================================================
Install Kubernetes Platform on Standard with Dedicated Storage
==============================================================

This section describes the steps to install the |prod| Kubernetes platform on a
**Standard with Dedicated Storage** deployment configuration.

.. contents::
   :local:
   :depth: 1

.. only:: starlingx

   -------------------
   Create bootable USB
   -------------------

   Refer to :ref:`Bootable USB <bootable_usb>` for instructions on how to
   create a bootable USB with the StarlingX ISO on your system.

   --------------------------------
   Install software on controller-0
   --------------------------------

   .. include:: inc-install-software-on-controller.rest
      :start-after: incl-install-software-controller-0-standard-start
      :end-before: incl-install-software-controller-0-standard-end

--------------------------------
Bootstrap system on controller-0
--------------------------------

.. include:: controller_storage_install_kubernetes.rst
   :start-after: incl-bootstrap-sys-controller-0-standard-start:
   :end-before: incl-bootstrap-sys-controller-0-standard-end:

----------------------
Configure controller-0
----------------------

.. include:: controller_storage_install_kubernetes.rst
   :start-after: incl-config-controller-0-storage-start:
   :end-before: incl-config-controller-0-storage-end:

-------------------
Unlock controller-0
-------------------

.. important::

  Make sure the Ceph storage backend is configured. If it is
  not configured, you will not be able to configure storage
  nodes.

Unlock controller-0 in order to bring it into service:

::

  system host-unlock controller-0

Controller-0 will reboot in order to apply configuration changes and come into
service. This can take 5-10 minutes, depending on the performance of the host
machine.

-----------------------------------------------------------------
Install software on controller-1, storage nodes, and worker nodes
-----------------------------------------------------------------

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

   This initiates the install of software on controller-1.
   This can take 5-10 minutes, depending on the performance of the host machine.

#. While waiting for the previous step to complete, power on the storage-0 and
   storage-1 servers. Set the personality to 'storage' and assign a unique
   hostname for each.

   For example, power on storage-0 and wait for the new host (hostname=None) to
   be discovered by checking 'system host-list':

   ::

        system host-update 3 personality=storage

   Repeat for storage-1. Power on storage-1 and wait for the new host
   (hostname=None) to be discovered by checking 'system host-list':

   ::

        system host-update 4 personality=storage

   This initiates the software installation on storage-0 and storage-1.
   This can take 5-10 minutes, depending on the performance of the host machine.

#. While waiting for the previous step to complete, power on the worker nodes.
   Set the personality to 'worker' and assign a unique hostname for each.

   For example, power on worker-0 and wait for the new host (hostname=None) to
   be discovered by checking 'system host-list':

   ::

     system host-update 5 personality=worker hostname=worker-0

   Repeat for worker-1. Power on worker-1 and wait for the new host
   (hostname=None) to be discovered by checking 'system host-list':

   ::

     system host-update 6 personality=worker hostname=worker-1

   This initiates the install of software on worker-0 and worker-1.

#. Wait for the software installation on controller-1, storage-0, storage-1,
   worker-0, and worker-1 to complete, for all servers to reboot, and for all to
   show as locked/disabled/online in 'system host-list'.

   ::

     system host-list
     +----+--------------+-------------+----------------+-------------+--------------+
     | id | hostname     | personality | administrative | operational | availability |
     +----+--------------+-------------+----------------+-------------+--------------+
     | 1  | controller-0 | controller  | unlocked       | enabled     | available    |
     | 2  | controller-1 | controller  | locked         | disabled    | online       |
     | 3  | storage-0    | storage     | locked         | disabled    | online       |
     | 4  | storage-1    | storage     | locked         | disabled    | online       |
     | 5  | worker-0     | worker      | locked         | disabled    | online       |
     | 6  | worker-1     | worker      | locked         | disabled    | online       |
     +----+--------------+-------------+----------------+-------------+--------------+

----------------------
Configure controller-1
----------------------

.. include:: controller_storage_install_kubernetes.rst
   :start-after: incl-config-controller-1-start:
   :end-before: incl-config-controller-1-end:

-------------------
Unlock controller-1
-------------------

.. include:: controller_storage_install_kubernetes.rst
   :start-after: incl-unlock-controller-1-start:
   :end-before: incl-unlock-controller-1-end:

.. include:: /_includes/bootstrapping-and-deploying-starlingx.rest

-----------------------
Configure storage nodes
-----------------------

#. Assign the cluster-host network to the MGMT interface for the storage nodes:

   (Note that the MGMT interfaces are partially set up automatically by the
   network install procedure.)

   ::

    for NODE in storage-0 storage-1; do
       system interface-network-assign $NODE mgmt0 cluster-host
    done

#. Add |OSDs| to storage-0.

   ::

     HOST=storage-0

     # List host’s disks and identify disks you want to use for CEPH OSDs, taking note of their UUID
     # By default, /dev/sda is being used as system disk and can not be used for OSD.
     system host-disk-list ${HOST}

     # Add disk as an OSD storage
     system host-stor-add ${HOST} osd <disk-uuid>

     # List OSD storage devices and wait for configuration of newly added OSD to complete.
     system host-stor-list ${HOST}

#. Add |OSDs| to storage-1.

   ::

     HOST=storage-1

     # List host’s disks and identify disks you want to use for CEPH OSDs, taking note of their UUID
     # By default, /dev/sda is being used as system disk and can not be used for OSD.
     system host-disk-list ${HOST}

     # Add disk as an OSD storage
     system host-stor-add ${HOST} osd <disk-uuid>

     # List OSD storage devices and wait for configuration of newly added OSD to complete.
     system host-stor-list ${HOST}

--------------------
Unlock storage nodes
--------------------

Unlock storage nodes in order to bring them into service:

::

    for STORAGE in storage-0 storage-1; do
       system host-unlock $STORAGE
    done

The storage nodes will reboot in order to apply configuration changes and come
into service. This can take 5-10 minutes, depending on the performance of the
host machine.

----------------------
Configure worker nodes
----------------------

#. The MGMT interfaces are partially set up by the network install procedure;
   configuring the port used for network install as the MGMT port and
   specifying the attached network of "mgmt".

   Complete the MGMT interface configuration of the worker nodes by specifying
   the attached network of "cluster-host".

   ::

    for NODE in worker-0 worker-1; do
       system interface-network-assign $NODE mgmt0 cluster-host
    done

.. only:: openstack

   *************************************
   OpenStack-specific host configuration
   *************************************

   .. important::

      **These steps are required only if the StarlingX OpenStack application
      (stx-openstack) will be installed.**

   #. **For OpenStack only:** Assign OpenStack host labels to the worker nodes in
      support of installing the stx-openstack manifest and helm-charts later.

      ::

         for NODE in worker-0 worker-1; do
           system host-label-assign $NODE  openstack-compute-node=enabled
           system host-label-assign $NODE  openvswitch=enabled
           system host-label-assign $NODE  sriov=enabled
         done

   #. **For OpenStack only:** Configure the host settings for the vSwitch.

      **If using OVS-DPDK vswitch, run the following commands:**

      Default recommendation for worker node is to use a single core on each
      numa-node for |OVS|-|DPDK| vswitch.  This should have been automatically
      configured, if not run the following command.

      ::

        for NODE in worker-0 worker-1; do

           # assign 1 core on processor/numa-node 0 on worker-node to vswitch
           system host-cpu-modify -f vswitch -p0 1 $NODE

           # assign 1 core on processor/numa-node 1 on worker-node to vswitch
           system host-cpu-modify -f vswitch -p1 1 $NODE

        done


      When using |OVS|-|DPDK|, configure 1x 1G huge page for vSwitch memory on
      each |NUMA| node where vswitch is running on this host, with the
      following command:

      ::

         for NODE in worker-0 worker-1; do

           # assign 1x 1G huge page on processor/numa-node 0 on worker-node to vswitch
           system host-memory-modify -f vswitch -1G 1 $NODE 0

           # assign 1x 1G huge page on processor/numa-node 0 on worker-node to vswitch
           system host-memory-modify -f vswitch -1G 1 $NODE 1

         done


      .. important::

         |VMs| created in an |OVS|-|DPDK| environment must be configured to use
         huge pages to enable networking and must use a flavor with property:
         hw:mem_page_size=large

         Configure the huge pages for |VMs| in an |OVS|-|DPDK| environment for
         this host with the command:

         ::

            for NODE in worker-0 worker-1; do

              # assign 10x 1G huge page on processor/numa-node 0 on worker-node to applications
              system host-memory-modify -f application -1G 10 $NODE 0

              # assign 10x 1G huge page on processor/numa-node 1 on worker-node to applications
              system host-memory-modify -f application -1G 10 $NODE 1

            done

   #. **For OpenStack only:** Setup disk partition for nova-local volume group,
      needed for stx-openstack nova ephemeral disks.

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

   #. **For OpenStack only:** Configure data interfaces for worker nodes.
      Data class interfaces are vswitch interfaces used by vswitch to provide
      VM virtio vNIC connectivity to OpenStack Neutron Tenant Networks on the 
      underlying assigned Data Network.
   
      .. important::
   
         A compute-labeled worker host **MUST** have at least one Data class interface.
   
      * Configure the data interfaces for worker nodes.
   
        ::
   
           # Execute the following lines with
           export NODE=worker-0
           # and then repeat with
           export NODE=worker-1

              # List inventoried host’s ports and identify ports to be used as ‘data’ interfaces,
              # based on displayed linux port name, pci address and device type.
              system host-port-list ${NODE}

              # List host’s auto-configured ‘ethernet’ interfaces,
              # find the interfaces corresponding to the ports identified in previous step, and
              # take note of their UUID
              system host-if-list -a ${NODE}

              # Modify configuration for these interfaces
              # Configuring them as ‘data’ class interfaces, MTU of 1500 and named data#
              system host-if-modify -m 1500 -n data0 -c data ${NODE} <data0-if-uuid>
              system host-if-modify -m 1500 -n data1 -c data ${NODE} <data1-if-uuid>

              # Create Data Networks that vswitch 'data' interfaces will be connected to
              DATANET0='datanet0'
              DATANET1='datanet1'
              system datanetwork-add ${DATANET0} vlan
              system datanetwork-add ${DATANET1} vlan

              # Assign Data Networks to Data Interfaces
              system interface-datanetwork-assign ${NODE} <data0-if-uuid> ${DATANET0}
              system interface-datanetwork-assign ${NODE} <data1-if-uuid> ${DATANET1}

*****************************************
Optionally Configure PCI-SRIOV Interfaces
*****************************************

#. **Optionally**, configure pci-sriov interfaces for worker nodes.

   This step is **optional** for Kubernetes. Do this step if using |SRIOV|
   network attachments in hosted application containers.

   .. only:: openstack

      This step is **optional** for OpenStack.  Do this step if using |SRIOV| 
      vNICs in hosted application VMs.  Note that pci-sriov interfaces can
      have the same Data Networks assigned to them as vswitch data interfaces.


   * Configure the pci-sriov interfaces for worker nodes.

     ::

        # Execute the following lines with
        export NODE=worker-0
        # and then repeat with
        export NODE=worker-1

           # List inventoried host’s ports and identify ports to be used as ‘pci-sriov’ interfaces,
           # based on displayed linux port name, pci address and device type.
           system host-port-list ${NODE}

           # List host’s auto-configured ‘ethernet’ interfaces,
           # find the interfaces corresponding to the ports identified in previous step, and
           # take note of their UUID
           system host-if-list -a ${NODE}

           # Modify configuration for these interfaces
           # Configuring them as ‘pci-sriov’ class interfaces, MTU of 1500 and named sriov#
           system host-if-modify -m 1500 -n sriov0 -c pci-sriov ${NODE} <sriov0-if-uuid>
           system host-if-modify -m 1500 -n sriov1 -c pci-sriov ${NODE} <sriov1-if-uuid>

           # Create Data Networks that the 'pci-sriov' interfaces will be connected to
           DATANET0='datanet0'
           DATANET1='datanet1'
           system datanetwork-add ${DATANET0} vlan
           system datanetwork-add ${DATANET1} vlan

           # Assign Data Networks to PCI-SRIOV Interfaces
           system interface-datanetwork-assign ${NODE} <sriov0-if-uuid> ${DATANET0}
           system interface-datanetwork-assign ${NODE} <sriov1-if-uuid> ${DATANET1}


   * To enable using |SRIOV| network attachments for the above interfaces in
     Kubernetes hosted application containers:

     * Configure the Kubernetes |SRIOV| device plugin.

       ::

          for NODE in worker-0 worker-1; do
             system host-label-assign $NODE sriovdp=enabled
          done

     * If planning on running |DPDK| in Kubernetes hosted application
       containers on this host, configure the number of 1G Huge pages required
       on both |NUMA| nodes.

       ::

          for NODE in worker-0 worker-1; do

             # assign 10x 1G huge page on processor/numa-node 0 on worker-node to applications
             system host-memory-modify -f application $NODE 0 -1G 10

             # assign 10x 1G huge page on processor/numa-node 1 on worker-node to applications
             system host-memory-modify -f application $NODE 1 -1G 10

          done


-------------------
Unlock worker nodes
-------------------

Unlock worker nodes in order to bring them into service:

::

    for NODE in worker-0 worker-1; do
       system host-unlock $NODE
    done

The worker nodes will reboot in order to apply configuration changes and come
into service. This can take 5-10 minutes, depending on the performance of the
host machine.

----------
Next steps
----------

.. include:: ../kubernetes_install_next.txt
