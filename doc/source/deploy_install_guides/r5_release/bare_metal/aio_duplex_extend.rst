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
      | 2  | controller-0 | controller  | unlocked       | enabled     | available    |
      | 3  | None         | None        | locked         | disabled    | offline      |
      | 4  | None         | None        | locked         | disabled    | offline      |
      +----+--------------+-------------+----------------+-------------+--------------+

#. Using the host id, set the personality of this host to 'worker':

   ::

      system host-update 3 personality=worker hostname=worker-0
      system host-update 4 personality=worker hostname=worker-1

   This initiates the install of software on worker nodes.
   This can take 5-10 minutes, depending on the performance of the host machine.

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

   ::

      for NODE in worker-0 worker-1; do
         system interface-network-assign $NODE mgmt0 cluster-host
      done

#. Configure data interfaces for worker nodes. Use the DATA port names, for
   example eth0, that are applicable to your deployment environment.

   This step is optional for Kubernetes: Do this step if using |SRIOV| network
   attachments in hosted application containers.

   .. only:: starlingx

      .. important::

         This step is **required** for OpenStack.


   * Configure the data interfaces

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

         # Previously configured Data Networks
         PHYSNET0='physnet0'
         PHYSNET1='physnet1'
         system datanetwork-add ${PHYSNET0} vlan
         system datanetwork-add ${PHYSNET1} vlan

         # Assign Data Networks to Data Interfaces
         system interface-datanetwork-assign ${NODE} <data0-if-uuid> ${PHYSNET0}
         system interface-datanetwork-assign ${NODE} <data1-if-uuid> ${PHYSNET1}


   * To enable using |SRIOV| network attachments for the above interfaces in
     Kubernetes hosted application containers:

     * Configure |SRIOV| device plug in:

       ::

          for NODE in worker-0 worker-1; do
            system host-label-assign $NODE sriovdp=enabled
          done

     * If planning on running |DPDK| in containers on this host, configure the
       number of 1G Huge pages required on both |NUMA| nodes:

       ::

          for NODE in worker-0 worker-1; do

            # assign 10x 1G huge page on processor/numa-node 0 on worker-node to applications
            system host-memory-modify -f application $NODE 0 -1G 10

            # assign 10x 1G huge page on processor/numa-node 1 on worker-node to applications
            system host-memory-modify -f application $NODE 1 -1G 10

          done


.. only:: starlingx

   *************************************
   OpenStack-specific host configuration
   *************************************

   .. important::

      **This step is required only if the StarlingX OpenStack application
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


-------------------
Unlock worker nodes
-------------------

Unlock worker nodes in order to bring them into service:

::

  for NODE in worker-0 worker-1; do
     system host-unlock $NODE
  done

The worker nodes will reboot to apply configuration changes and come into
service. This can take 5-10 minutes, depending on the performance of the host
machine.

