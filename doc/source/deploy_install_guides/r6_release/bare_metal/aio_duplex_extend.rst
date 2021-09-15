=================================
Extend Capacity with Worker Nodes
=================================

This section describes the steps to extend capacity with worker nodes on a
|prod| All-in-one Duplex deployment configuration.

.. contents::
   :local:
   :depth: 1

--------------------------------
Install software on worker nodes
--------------------------------

#. Power on the worker node servers and force them to network boot with the
   appropriate BIOS boot options for your particular server.

#. As the worker nodes boot, a message appears on their console instructing
   you to configure the personality of the node.

#. On the console of controller-0, list hosts to see newly discovered worker
   node hosts (hostname=None):

   ::

      system host-list
      +----+--------------+-------------+----------------+-------------+--------------+
      | id | hostname     | personality | administrative | operational | availability |
      +----+--------------+-------------+----------------+-------------+--------------+
      | 1  | controller-0 | controller  | unlocked       | enabled     | available    |
      | 2  | controller-1 | controller  | unlocked       | enabled     | available    |
      | 3  | None         | None        | locked         | disabled    | offline      |
      | 4  | None         | None        | locked         | disabled    | offline      |
      +----+--------------+-------------+----------------+-------------+--------------+

#. Using the host id, set the personality of this host to 'worker':

   .. code-block:: bash

      system host-update 3 personality=worker hostname=worker-0
      system host-update 4 personality=worker hostname=worker-1

   This initiates the install of software on worker nodes.
   This can take 5-10 minutes, depending on the performance of the host machine.

   .. only:: starlingx

     .. Note::

        A node with Edgeworker personality is also available. See
        :ref:`deploy-edgeworker-nodes` for details.

#. Wait for the install of software on the worker nodes to complete, for the
   worker nodes to reboot, and for both to show as locked/disabled/online in
   'system host-list'.

   ::

      system host-list
      +----+--------------+-------------+----------------+-------------+--------------+
      | id | hostname     | personality | administrative | operational | availability |
      +----+--------------+-------------+----------------+-------------+--------------+
      | 1  | controller-0 | controller  | unlocked       | enabled     | available    |
      | 2  | controller-1 | controller  | unlocked       | enabled     | available    |
      | 3  | worker-0     | worker      | locked         | disabled    | online       |
      | 4  | worker-1     | worker      | locked         | disabled    | online       |
      +----+--------------+-------------+----------------+-------------+--------------+

----------------------
Configure worker nodes
----------------------

#. The MGMT interfaces are partially set up by the network install procedure;
   configuring the port used for network install as the MGMT port and
   specifying the attached network of "mgmt".

   Complete the MGMT interface configuration of the worker nodes by specifying
   the attached network of "cluster-host".

   .. code-block:: bash

      for NODE in worker-0 worker-1; do
         system interface-network-assign $NODE mgmt0 cluster-host
      done

.. only:: openstack

   *************************************
   OpenStack-specific host configuration
   *************************************

   .. important::

      **These steps are required only if the StarlingX OpenStack application
      (|prefix|-openstack) will be installed.**

   #. **For OpenStack only:** Assign OpenStack host labels to the worker nodes in
      support of installing the |prefix|-openstack manifest and helm-charts later.

      .. parsed-literal::

         for NODE in worker-0 worker-1; do
           system host-label-assign $NODE  openstack-compute-node=enabled
           system host-label-assign $NODE  |vswitch-label|
           system host-label-assign $NODE  sriov=enabled
         done

   #. **For OpenStack only:** Configure the host settings for the vSwitch.

      If using |OVS-DPDK| vswitch, run the following commands:

      Default recommendation for worker node is to use two cores on numa-node 0
      for |OVS-DPDK| vSwitch; physical |NICs| are typically on first numa-node.
      This should have been automatically configured, if not run the following
      command.

      .. code-block:: bash

        for NODE in worker-0 worker-1; do

           # assign 2 cores on processor/numa-node 0 on worker-node to vswitch
           system host-cpu-modify -f vswitch -p0 2 $NODE

        done

      When using |OVS-DPDK|, configure 1G of huge pages for vSwitch memory on
      each |NUMA| node on the host. It is recommended to configure 1x 1G huge
      page (-1G 1) for vSwitch memory on each |NUMA| node on the host.

      However, due to a limitation with Kubernetes, only a single huge page
      size is supported on any one host. If your application VMs require 2M
      huge pages, then configure 500x 2M huge pages (-2M 500) for vSwitch
      memory on each |NUMA| node on the host.

      .. code-block:: bash

         for NODE in worker-0 worker-1; do

           # assign 1x 1G huge page on processor/numa-node 0 on worker-node to vswitch
           system host-memory-modify -f vswitch -1G 1 $NODE 0

           # assign 1x 1G huge page on processor/numa-node 0 on worker-node to vswitch
           system host-memory-modify -f vswitch -1G 1 $NODE 1

         done


      .. important::

         |VMs| created in an |OVS-DPDK| environment must be configured to use
         huge pages to enable networking and must use a flavor with property:
         hw:mem_page_size=large

         Configure the huge pages for |VMs| in an |OVS-DPDK| environment on
         this host, assuming 1G huge page size is being used on this host, with
         the following commands:

         .. code-block:: bash

            for NODE in worker-0 worker-1; do

              # assign 10x 1G huge page on processor/numa-node 0 on worker-node to applications
              system host-memory-modify -f application -1G 10 $NODE 0

              # assign 10x 1G huge page on processor/numa-node 1 on worker-node to applications
              system host-memory-modify -f application -1G 10 $NODE 1

            done

   #. **For OpenStack only:** Setup disk partition for nova-local volume group,
      needed for |prefix|-openstack nova ephemeral disks.

      .. code-block:: bash

         for NODE in worker-0 worker-1; do
            system host-lvg-add ${NODE} nova-local

            # Get UUID of DISK to create PARTITION to be added to ‘nova-local’ local volume group
            # CEPH OSD Disks can NOT be used
            # For best performance, do NOT use system/root disk, use a separate physical disk.

            # List host’s disks and take note of UUID of disk to be used
            system host-disk-list ${NODE}
            # ( if using ROOT DISK, select disk with device_path of
            #   ‘system host-show ${NODE} | fgrep rootfs’   )

            # Create new PARTITION on selected disk, and take note of new partition’s ‘uuid’ in response
            # The size of the PARTITION needs to be large enough to hold the aggregate size of
            # all nova ephemeral disks of all VMs that you want to be able to host on this host,
            # but is limited by the size and space available on the physical disk you chose above.
            # The following example uses a small PARTITION size such that you can fit it on the
            # root disk, if that is what you chose above.
            # Additional PARTITION(s) from additional disks can be added later if required.
            PARTITION_SIZE=30

            system host-disk-partition-add -t lvm_phys_vol ${NODE} <disk-uuid> ${PARTITION_SIZE}

            # Add new partition to ‘nova-local’ local volume group
            system host-pv-add ${NODE} nova-local <NEW_PARTITION_UUID>
            sleep 2
         done

   #. **For OpenStack only:** Configure data interfaces for worker nodes.
      Data class interfaces are vswitch interfaces used by vswitch to provide
      |VM| virtio vNIC connectivity to OpenStack Neutron Tenant Networks on the
      underlying assigned Data Network.

      .. important::

         A compute-labeled worker host **MUST** have at least one Data class interface.

      * Configure the data interfaces for worker nodes.

        .. code-block:: bash

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

     .. code-block:: bash

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

          # If not already created, create Data Networks that the 'pci-sriov'
          # interfaces will be connected to
          DATANET0='datanet0'
          DATANET1='datanet1'
          system datanetwork-add ${DATANET0} vlan
          system datanetwork-add ${DATANET1} vlan

          # Assign Data Networks to PCI-SRIOV Interfaces
          system interface-datanetwork-assign ${NODE} <sriov0-if-uuid> ${DATANET0}
          system interface-datanetwork-assign ${NODE} <sriov1-if-uuid> ${DATANET1}


   * **For Kubernetes only** To enable using |SRIOV| network attachments for
     the above interfaces in Kubernetes hosted application containers:

     * Configure the Kubernetes |SRIOV| device plugin.

       .. code-block:: bash

          for NODE in worker-0 worker-1; do
             system host-label-assign $NODE sriovdp=enabled
          done

     * If planning on running |DPDK| in Kubernetes hosted application
       containers on this host, configure the number of 1G Huge pages required
       on both |NUMA| nodes.

       .. code-block:: bash

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

.. code-block:: bash

  for NODE in worker-0 worker-1; do
     system host-unlock $NODE
  done

The worker nodes will reboot to apply configuration changes and come into
service. This can take 5-10 minutes, depending on the performance of the host
machine.
