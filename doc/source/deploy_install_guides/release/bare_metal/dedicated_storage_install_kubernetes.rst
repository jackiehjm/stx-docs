|hideable|

.. _dedicated_storage_install_kubernetes_r7:


==============================================================
Install Kubernetes Platform on Standard with Dedicated Storage
==============================================================

.. contents::
   :local:
   :depth: 1

.. only:: partner

   .. include:: /_includes/install-kubernetes-null-labels.rest

--------
Overview
--------

.. _ded-installation-prereqs:

.. include:: /shared/_includes/desc_dedicated_storage.txt

-----------------------------
Minimum hardware requirements
-----------------------------

.. include:: /shared/_includes/prepare-servers-for-installation-91baad307173.rest
   :start-after: begin-min-hw-reqs-ded
   :end-before: end-min-hw-reqs-ded

.. _installation-prereqs-dedicated:

--------------------------
Installation Prerequisites
--------------------------

.. include:: /shared/_includes/installation-prereqs.rest
   :start-after: begin-install-prereqs
   :end-before: end-install-prereqs


--------------------------------
Prepare Servers for Installation
--------------------------------

.. include:: /shared/_includes/prepare-servers-for-installation-91baad307173.rest
   :start-after: start-prepare-servers-common
   :end-before: end-prepare-servers-common

--------------------------------
Install Software on Controller-0
--------------------------------

.. include:: /shared/_includes/inc-install-software-on-controller.rest
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

   .. only:: starlingx

     .. Note::

        A node with Edgeworker personality is also available. See
        :ref:`deploy-edgeworker-nodes` for details.

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

   .. code-block:: bash

    for NODE in storage-0 storage-1; do
       system interface-network-assign $NODE mgmt0 cluster-host
    done

#. Add |OSDs| to storage-0.

   .. code-block:: bash

     HOST=storage-0

     # List host’s disks and identify disks you want to use for CEPH OSDs, taking note of their UUID
     # By default, /dev/sda is being used as system disk and can not be used for OSD.
     system host-disk-list ${HOST}

     # Add disk as an OSD storage
     system host-stor-add ${HOST} osd <disk-uuid>

     # List OSD storage devices and wait for configuration of newly added OSD to complete.
     system host-stor-list ${HOST}

#. Add |OSDs| to storage-1.

   .. code-block:: bash

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

.. code-block:: bash

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

   .. code-block:: bash

    for NODE in worker-0 worker-1; do
       system interface-network-assign $NODE mgmt0 cluster-host
    done

.. only:: openstack

   *************************************
   OpenStack-specific host configuration
   *************************************

   .. important::

      These steps are required only if the |prod-os| application
      (|prefix|-openstack) will be installed.

   #. **For OpenStack only:** Assign OpenStack host labels to the worker nodes in
      support of installing the |prefix|-openstack manifest and helm-charts later.

      .. parsed-literal::

         for NODE in worker-0 worker-1; do
           system host-label-assign $NODE  openstack-compute-node=enabled
           kubectl taint nodes $NODE openstack-compute-node:NoSchedule
           system host-label-assign $NODE  |vswitch-label|
           system host-label-assign $NODE  sriov=enabled
         done

   #. **For OpenStack only:** Configure the host settings for the vSwitch.

      If using |OVS-DPDK| vSwitch, run the following commands:

      Default recommendation for worker node is to use node two cores on
      numa-node 0 for |OVS-DPDK| vSwitch; physical NICs are typically on first
      numa-node. This should have been automatically configured, if not run
      the following command.

      .. code-block:: bash

        for NODE in worker-0 worker-1; do

            # assign 2 cores on processor/numa-node 0 on worker-node to vswitch
            system host-cpu-modify -f vswitch -p0 2 $NODE

        done

      When using |OVS-DPDK|, configure 1G of huge pages for vSwitch memory on
      each |NUMA| node on the host. It is recommended to configure 1x 1G huge
      page (-1G 1) for vSwitch memory on each |NUMA| node on the host.

      However, due to a limitation with Kubernetes, only a single huge page
      size is supported on any one host. If your application |VMs| require 2M
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
         this host, the following commands are an example that assumes that 1G
         huge page size is being used on this host:

         .. code-block:: bash

            for NODE in worker-0 worker-1; do

              # assign 10x 1G huge page on processor/numa-node 0 on worker-node to applications
              system host-memory-modify -f application -1G 10 $NODE 0

              # assign 10x 1G huge page on processor/numa-node 1 on worker-node to applications
              system host-memory-modify -f application -1G 10 $NODE 1

            done

   #. **For OpenStack only:** Add an instances filesystem OR Set up a disk
      based nova-local volume group, which is needed for |prefix|-openstack
      nova ephemeral disks. NOTE: both cannot exist ast the same time

      Add an 'instances' filesystem

      .. code-block:: bash

         # Create ‘instances’ filesystem
         for NODE in worker-0 worker-1; do
            system host-fs-add ${NODE} instances=<size>
         done

      OR add a 'nova-local' volume group

      .. code-block:: bash

         for NODE in worker-0 worker-1; do
             # Create ‘nova-local’ local volume group
             system host-lvg-add ${NODE} nova-local

             # Get UUID of an unused DISK to to be added to the ‘nova-local’ volume
             # group. CEPH OSD Disks can NOT be used. Assume /dev/sdb is unused
             # on all workers
             DISK_UUID=$(system host-disk-list ${NODE} | awk '/sdb/{print $2}')

             # Add the unused disk to the ‘nova-local’ volume group
            system host-pv-add ${NODE} nova-local ${DISK_UUID}
         done

   #. **For OpenStack only:** Configure data interfaces for worker nodes.
      Data class interfaces are vswitch interfaces used by vswitch to provide
      |VM| virtio vNIC connectivity to OpenStack Neutron Tenant Networks on the
      underlying assigned Data Network.

      .. important::

         A compute-labeled worker host **MUST** have at least one Data class
         interface.

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
      vNICs in hosted application |VMs|.  Note that pci-sriov interfaces can
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
           system host-if-modify -m 1500 -n sriov0 -c pci-sriov ${NODE} <sriov0-if-uuid> -N <num_vfs>
           system host-if-modify -m 1500 -n sriov1 -c pci-sriov ${NODE} <sriov1-if-uuid> -N <num_vfs>

           # If not created already, create Data Networks that the 'pci-sriov'
           # interfaces will be connected to
           DATANET0='datanet0'
           DATANET1='datanet1'
           system datanetwork-add ${DATANET0} vlan
           system datanetwork-add ${DATANET1} vlan

           # Assign Data Networks to PCI-SRIOV Interfaces
           system interface-datanetwork-assign ${NODE} <sriov0-if-uuid> ${DATANET0}
           system interface-datanetwork-assign ${NODE} <sriov1-if-uuid> ${DATANET1}


   * **For Kubernetes only:** To enable using |SRIOV| network attachments for
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

The worker nodes will reboot in order to apply configuration changes and come
into service. This can take 5-10 minutes, depending on the performance of the
host machine.

.. only:: starlingx

   ----------
   Next steps
   ----------

   .. include:: /_includes/kubernetes_install_next.txt


.. only:: partner

   .. include:: /_includes/72hr-to-license.rest


Complete system configuration by reviewing procedures in:

- :ref:`index-security-kub-81153c1254c3`
- :ref:`index-sysconf-kub-78f0e1e9ca5a`
- :ref:`index-admintasks-kub-ebc55fefc368`
