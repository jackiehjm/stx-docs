========
Contents
========

------------
Introduction
------------

.. toctree::
   :maxdepth: 2

   displaying-worker-host-information


------------------------
The life cycle of a host
------------------------

.. toctree::
   :maxdepth: 1

   the-life-cycle-of-a-host
   host-status-and-alarms-during-system-configuration-changes

--------------
Host inventory
--------------

.. toctree::
   :maxdepth: 1

   host_inventory/hosts-tab
   host_inventory/host-details-page
   host_inventory/overview-tab
   host_inventory/processor-tab
   host_inventory/memory-tab
   host_inventory/storage-tab
   host_inventory/filesystems-tab
   host_inventory/ports-tab
   host_inventory/interfaces-tab
   host_inventory/lldp-tab
   host_inventory/sensors-tab
   host_inventory/devices-tab
   host_inventory/labels-tab

-----------------
Common host tasks
-----------------

*******************************
Common host tasks using Horizon
*******************************

.. toctree::
   :maxdepth: 1

   common_host_tasks/locking-a-host-using-horizon
   common_host_tasks/force-locking-a-host-using-horizon
   common_host_tasks/swacting-a-master-controller-using-horizon
   common_host_tasks/unlocking-a-host-using-horizon
   common_host_tasks/rebooting-a-host-using-horizon
   common_host_tasks/powering-off-a-host-using-horizon
   common_host_tasks/powering-on-a-host-using-horizon
   common_host_tasks/reinstalling-a-host-using-horizon
   common_host_tasks/resetting-a-host-using-horizon
   common_host_tasks/deleting-a-host-using-horizon

*******************************
Common host tasks using the CLI
*******************************

.. toctree::
   :maxdepth: 1

   common_host_tasks/locking-a-host-using-the-cli
   common_host_tasks/force-locking-a-host-using-the-cli
   common_host_tasks/swacting-a-master-controller-using-the-cli
   common_host_tasks/unlocking-a-host-using-the-cli
   common_host_tasks/rebooting-a-host-using-the-cli
   common_host_tasks/powering-off-a-host-using-the-cli
   common_host_tasks/powering-on-a-host-using-the-cli
   common_host_tasks/resetting-a-host-using-the-cli
   common_host_tasks/deleting-a-host-using-the-cli

--------------------------------
Configuring CPU core assignments
--------------------------------

.. toctree::
   :maxdepth: 1

   configuring_cpu_core_assignments/changing-the-hyper-threading-status
   configuring_cpu_core_assignments/configuring-cpu-core-assignments

------------------------
Host memory provisioning
------------------------

.. toctree::
   :maxdepth: 1

   host_memory_provisioning/about-host-memory-provisioning
   host_memory_provisioning/allocating-host-memory-using-horizon
   host_memory_provisioning/allocating-host-memory-using-the-cli

---------------
Node interfaces
---------------

********************
Provision interfaces
********************

.. toctree::
   :maxdepth: 1

   node_interfaces/interface-provisioning
   node_interfaces/interface-settings
   node_interfaces/editing-interface-settings

*****************
Create interfaces
*****************

.. toctree::
   :maxdepth: 1

   node_interfaces/creating-interfaces

*****************
Delete interfaces
*****************

.. toctree::
   :maxdepth: 1

   node_interfaces/deleting-or-disabling-interfaces-using-horizon
   node_interfaces/deleting-or-disabling-interfaces-using-the-cli

*****************************
Configure Ethernet interfaces
*****************************

.. toctree::
   :maxdepth: 1

   node_interfaces/configuring-ethernet-interfaces-using-horizon
   node_interfaces/attaching-ethernet-interfaces-to-networks-using-the-cli

******************************
Aggregated Ethernet interfaces
******************************

.. toctree::
   :maxdepth: 1

   node_interfaces/configuring-aggregated-ethernet-interfaces-using-horizon
   node_interfaces/configuring-aggregated-ethernet-interfaces-using-the-cli
   node_interfaces/changing-a-management-interface-to-aggregated-using-the-cli
   node_interfaces/link-aggregation-settings

*************************
Configure VLAN interfaces
*************************

.. toctree::
   :maxdepth: 1

   node_interfaces/configuring-vlan-interfaces-using-horizon
   node_interfaces/configuring-vlan-interfaces-using-the-cli

***************************
PCI-SRIOV interface support
***************************

.. toctree::
   :maxdepth: 1

   node_interfaces/provisioning-sr-iov-interfaces-using-the-cli
   node_interfaces/provisioning-sr-iov-vf-interfaces-using-the-cli

*********************************
Interface IP address provisioning
*********************************

.. toctree::
   :maxdepth: 1

   node_interfaces/interface-ip-address-provisioning-using-the-cli

----
LLDP
----

.. toctree::
   :maxdepth: 1

   lldp/lldp-overview
   lldp/viewing-lldp-information-using-horizon
   lldp/viewing-lldp-neighbor-information-using-the-cli

---------------------
Host hardware sensors
---------------------

.. toctree::
   :maxdepth: 1

   host_hardware_sensors/relearning-sensor-models
   host_hardware_sensors/adjusting-sensor-actions-and-audit-intervals
   host_hardware_sensors/suppressing-sensor-actions
   host_hardware_sensors/cli-commands-for-managing-sensors

---------------------
Configure node labels
---------------------

.. toctree::
   :maxdepth: 1

   configuring_node_labels/configuring-node-labels-using-horizon
   configuring_node_labels/listing-node-labels-from-the-cli
   configuring_node_labels/assigning-node-labels-from-the-cli
   configuring_node_labels/removing-node-labels-from-the-cli

----------------------------------------
Change a worker host performance profile
----------------------------------------

.. toctree::
   :maxdepth: 1

   changing-a-worker-host-performance-profile

----------------------------
Resize filesystems on a host
----------------------------

.. toctree::
   :maxdepth: 1

   resizing-filesystems-on-a-host

--------------------------
Customize host life cycles
--------------------------

.. toctree::
   :maxdepth: 1

   customizing_the_host_life_cycles/adjusting-the-boot-timeout-interval
   customizing_the_host_life_cycles/reboot-limits-for-host-unlock
   customizing_the_host_life_cycles/adjusting-the-host-heartbeat-interval-and-heartbeat-response-thresholds
   customizing_the_host_life_cycles/configuring-heartbeat-failure-action
   customizing_the_host_life_cycles/configuring-multi-node-failure-avoidance

--------------------
Node inventory tasks
--------------------

.. toctree::
   :maxdepth: 1

   node_inventory_tasks/starting-starlingx
   node_inventory_tasks/shutting-down-starlingx

-----------------------------
Hardware acceleration devices
-----------------------------

.. toctree::
   :maxdepth: 1

   hardware_acceleration_devices/uploading-a-device-image
   hardware_acceleration_devices/listing-uploaded-device-images
   hardware_acceleration_devices/listing-device-labels
   hardware_acceleration_devices/removing-a-device-image
   hardware_acceleration_devices/removing-a-device-label
   hardware_acceleration_devices/initiating-a-device-image-update-for-a-host
   hardware_acceleration_devices/displaying-the-status-of-device-images

************************
Intel N3000 FPGA support
************************

.. toctree::
   :maxdepth: 1

   hardware_acceleration_devices/n3000-overview
   hardware_acceleration_devices/updating-an-intel-n3000-fpga-image
   hardware_acceleration_devices/n3000-fpga-forward-error-correction
   hardware_acceleration_devices/showing-details-for-an-fpga-device

------------------------
Host hardware management
------------------------

.. toctree::
   :maxdepth: 1

   host_hardware_management/changing-hardware-components-for-a-controller-host
   host_hardware_management/changing-hardware-components-for-a-storage-host
   host_hardware_management/changing-hardware-components-for-a-worker-host
   host_hardware_management/configuration-changes-requiring-re-installation

-----------------------------------------
Run the node feature discovery helm chart
-----------------------------------------

.. toctree::
   :maxdepth: 1

   running-the-node-feature-discovery-helm-chart

-------------
Provision BMC
-------------

***************************
Provision BMC using Horizon
***************************

.. toctree::
   :maxdepth: 1

   provisioning_bmc/provisioning-board-management-control-from-horizon
   provisioning_bmc/deprovisioning-board-management-control-from-horizon

***************************
Provision BMC using the CLI
***************************

.. toctree::
   :maxdepth: 1

   provisioning_bmc/provisioning-board-management-control-using-the-cli
   provisioning_bmc/provisioning-bmc-when-adding-a-host
   provisioning_bmc/provisioning-bmc-after-adding-a-host
   provisioning_bmc/deprovisioning-board-management-control-from-the-cli

-------------------------------------
CLI commands for managing PCI devices
-------------------------------------

.. toctree::
   :maxdepth: 1

   cli-commands-for-managing-pci-devices
