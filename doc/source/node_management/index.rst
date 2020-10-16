===============
Node Management
===============

----------
Kubernetes
----------

.. toctree::
   :maxdepth: 2

   starlingx-kubernetes/introduction
   starlingx-kubernetes/displaying-worker-host-information


************************
The life cycle of a host
************************

.. toctree::
   :maxdepth: 1

   starlingx-kubernetes/the-life-cycle-of-a-host
   starlingx-kubernetes/host-status-and-alarms-during-system-configuration-changes

**************
Host inventory
**************

.. toctree::
   :maxdepth: 1

   starlingx-kubernetes/host_inventory/hosts-tab
   starlingx-kubernetes/host_inventory/host-details-page
   starlingx-kubernetes/host_inventory/overview-tab
   starlingx-kubernetes/host_inventory/processor-tab
   starlingx-kubernetes/host_inventory/memory-tab
   starlingx-kubernetes/host_inventory/storage-tab
   starlingx-kubernetes/host_inventory/filesystems-tab
   starlingx-kubernetes/host_inventory/ports-tab
   starlingx-kubernetes/host_inventory/interfaces-tab
   starlingx-kubernetes/host_inventory/lldp-tab
   starlingx-kubernetes/host_inventory/sensors-tab
   starlingx-kubernetes/host_inventory/devices-tab
   starlingx-kubernetes/host_inventory/labels-tab

*****************
Common host tasks
*****************

Common host tasks using Horizon
*******************************

.. toctree::
   :maxdepth: 1

   starlingx-kubernetes/common_host_tasks/locking-a-host-using-horizon
   starlingx-kubernetes/common_host_tasks/force-locking-a-host-using-horizon
   starlingx-kubernetes/common_host_tasks/swacting-a-master-controller-using-horizon
   starlingx-kubernetes/common_host_tasks/unlocking-a-host-using-horizon
   starlingx-kubernetes/common_host_tasks/rebooting-a-host-using-horizon
   starlingx-kubernetes/common_host_tasks/powering-off-a-host-using-horizon
   starlingx-kubernetes/common_host_tasks/powering-on-a-host-using-horizon
   starlingx-kubernetes/common_host_tasks/reinstalling-a-host-using-horizon
   starlingx-kubernetes/common_host_tasks/resetting-a-host-using-horizon
   starlingx-kubernetes/common_host_tasks/deleting-a-host-using-horizon

Common host tasks using the CLI
*******************************

.. toctree::
   :maxdepth: 1

   starlingx-kubernetes/common_host_tasks/locking-a-host-using-the-cli
   starlingx-kubernetes/common_host_tasks/force-locking-a-host-using-the-cli
   starlingx-kubernetes/common_host_tasks/swacting-a-master-controller-using-the-cli
   starlingx-kubernetes/common_host_tasks/unlocking-a-host-using-the-cli
   starlingx-kubernetes/common_host_tasks/rebooting-a-host-using-the-cli
   starlingx-kubernetes/common_host_tasks/powering-off-a-host-using-the-cli
   starlingx-kubernetes/common_host_tasks/powering-on-a-host-using-the-cli
   starlingx-kubernetes/common_host_tasks/resetting-a-host-using-the-cli
   starlingx-kubernetes/common_host_tasks/deleting-a-host-using-the-cli

********************************
Configuring CPU core assignments
********************************

.. toctree::
   :maxdepth: 1

   starlingx-kubernetes/configuring_cpu_core_assignments/changing-the-hyper-threading-status
   starlingx-kubernetes/configuring_cpu_core_assignments/configuring-cpu-core-assignments

************************
Host memory provisioning
************************

.. toctree::
   :maxdepth: 1

   starlingx-kubernetes/host_memory_provisioning/about-host-memory-provisioning
   starlingx-kubernetes/host_memory_provisioning/allocating-host-memory-using-horizon
   starlingx-kubernetes/host_memory_provisioning/allocating-host-memory-using-the-cli

***************
Node interfaces
***************

Provision interfaces
********************

.. toctree::
   :maxdepth: 1

   starlingx-kubernetes/node_interfaces/interface-provisioning
   starlingx-kubernetes/node_interfaces/interface-settings
   starlingx-kubernetes/node_interfaces/editing-interface-settings

Create interfaces
*****************

.. toctree::
   :maxdepth: 1

   starlingx-kubernetes/node_interfaces/creating-interfaces

Delete interfaces
*****************

.. toctree::
   :maxdepth: 1

   starlingx-kubernetes/node_interfaces/deleting-or-disabling-interfaces-using-horizon
   starlingx-kubernetes/node_interfaces/deleting-or-disabling-interfaces-using-the-cli

Configure Ethernet interfaces
*****************************

.. toctree::
   :maxdepth: 1

   starlingx-kubernetes/node_interfaces/configuring-ethernet-interfaces-using-horizon
   starlingx-kubernetes/node_interfaces/attaching-ethernet-interfaces-to-networks-using-the-cli

Aggregated Ethernet interfaces
******************************

.. toctree::
   :maxdepth: 1

   starlingx-kubernetes/node_interfaces/configuring-aggregated-ethernet-interfaces-using-horizon
   starlingx-kubernetes/node_interfaces/configuring-aggregated-ethernet-interfaces-using-the-cli
   starlingx-kubernetes/node_interfaces/changing-a-management-interface-to-aggregated-using-the-cli
   starlingx-kubernetes/node_interfaces/link-aggregation-settings

Configure VLAN interfaces
*************************

.. toctree::
   :maxdepth: 1

   starlingx-kubernetes/node_interfaces/configuring-vlan-interfaces-using-horizon
   starlingx-kubernetes/node_interfaces/configuring-vlan-interfaces-using-the-cli

PCI-SRIOV interface support
***************************

.. toctree::
   :maxdepth: 1

   starlingx-kubernetes/node_interfaces/provisioning-sr-iov-interfaces-using-the-cli
   starlingx-kubernetes/node_interfaces/provisioning-sr-iov-vf-interfaces-using-the-cli

Interface IP address provisioning
*********************************

.. toctree::
   :maxdepth: 1

   starlingx-kubernetes/node_interfaces/interface-ip-address-provisioning-using-the-cli

****
LLDP
****

.. toctree::
   :maxdepth: 1

   starlingx-kubernetes/lldp/lldp-overview
   starlingx-kubernetes/lldp/viewing-lldp-information-using-horizon
   starlingx-kubernetes/lldp/viewing-lldp-neighbor-information-using-the-cli

*********************
Host hardware sensors
*********************

.. toctree::
   :maxdepth: 1

   starlingx-kubernetes/host_hardware_sensors/relearning-sensor-models
   starlingx-kubernetes/host_hardware_sensors/adjusting-sensor-actions-and-audit-intervals
   starlingx-kubernetes/host_hardware_sensors/suppressing-sensor-actions
   starlingx-kubernetes/host_hardware_sensors/cli-commands-for-managing-sensors

*********************
Configure node labels
*********************

.. toctree::
   :maxdepth: 1

   starlingx-kubernetes/configuring_node_labels/configuring-node-labels-using-horizon
   starlingx-kubernetes/configuring_node_labels/listing-node-labels-from-the-cli
   starlingx-kubernetes/configuring_node_labels/assigning-node-labels-from-the-cli
   starlingx-kubernetes/configuring_node_labels/removing-node-labels-from-the-cli

****************************************
Change a worker host performance profile
****************************************

.. toctree::
   :maxdepth: 1

   starlingx-kubernetes/changing-a-worker-host-performance-profile

****************************
Resize filesystems on a host
****************************

.. toctree::
   :maxdepth: 1

   starlingx-kubernetes/resizing-filesystems-on-a-host

**************************
Customize host life cycles
**************************

.. toctree::
   :maxdepth: 1

   starlingx-kubernetes/customizing_the_host_life_cycles/adjusting-the-boot-timeout-interval
   starlingx-kubernetes/customizing_the_host_life_cycles/reboot-limits-for-host-unlock
   starlingx-kubernetes/customizing_the_host_life_cycles/adjusting-the-host-heartbeat-interval-and-heartbeat-response-thresholds
   starlingx-kubernetes/customizing_the_host_life_cycles/configuring-heartbeat-failure-action
   starlingx-kubernetes/customizing_the_host_life_cycles/configuring-multi-node-failure-avoidance

********************
Node inventory tasks
********************

.. toctree::
   :maxdepth: 1

   starlingx-kubernetes/node_inventory_tasks/starting-starlingx
   starlingx-kubernetes/node_inventory_tasks/shutting-down-starlingx

*****************************
Hardware acceleration devices
*****************************

.. toctree::
   :maxdepth: 1

   starlingx-kubernetes/hardware_acceleration_devices/uploading-a-device-image
   starlingx-kubernetes/hardware_acceleration_devices/listing-uploaded-device-images
   starlingx-kubernetes/hardware_acceleration_devices/listing-device-labels
   starlingx-kubernetes/hardware_acceleration_devices/removing-a-device-image
   starlingx-kubernetes/hardware_acceleration_devices/removing-a-device-label
   starlingx-kubernetes/hardware_acceleration_devices/initiating-a-device-image-update-for-a-host
   starlingx-kubernetes/hardware_acceleration_devices/displaying-the-status-of-device-images

Intel N3000 FPGA support
************************

.. toctree::
   :maxdepth: 1

   starlingx-kubernetes/hardware_acceleration_devices/n3000-overview
   starlingx-kubernetes/hardware_acceleration_devices/updating-an-intel-n3000-fpga-image
   starlingx-kubernetes/hardware_acceleration_devices/n3000-fpga-forward-error-correction
   starlingx-kubernetes/hardware_acceleration_devices/showing-details-for-an-fpga-device

************************
Host hardware management
************************

.. toctree::
   :maxdepth: 1

   starlingx-kubernetes/host_hardware_management/changing-hardware-components-for-a-controller-host
   starlingx-kubernetes/host_hardware_management/changing-hardware-components-for-a-storage-host
   starlingx-kubernetes/host_hardware_management/changing-hardware-components-for-a-worker-host
   starlingx-kubernetes/host_hardware_management/configuration-changes-requiring-re-installation

*****************************************
Run the node feature discovery helm chart
*****************************************

.. toctree::
   :maxdepth: 1

   starlingx-kubernetes/running-the-node-feature-discovery-helm-chart

*************
Provision BCM
*************

Provision BCM using Horizon
***************************

.. toctree::
   :maxdepth: 1

   starlingx-kubernetes/provisioning_bmc/provisioning-board-management-control-from-horizon
   starlingx-kubernetes/provisioning_bmc/deprovisioning-board-management-control-from-horizon

Provision BCM using the CLI
***************************

.. toctree::
   :maxdepth: 1

   starlingx-kubernetes/provisioning_bmc/provisioning-board-management-control-using-the-cli
   starlingx-kubernetes/provisioning_bmc/provisioning-bmc-when-adding-a-host
   starlingx-kubernetes/provisioning_bmc/provisioning-bmc-after-adding-a-host
   starlingx-kubernetes/provisioning_bmc/deprovisioning-board-management-control-from-the-cli

*************************************
CLI commands for managing PCI devices
*************************************

.. toctree::
   :maxdepth: 1

   starlingx-kubernetes/cli-commands-for-managing-pci-devices

---------
OpenStack
---------

*****************************
Add an OpenStack compute node
*****************************

.. toctree::
   :maxdepth: 1

   starlingx-openstack/node-management-overview
   starlingx-openstack/adding-compute-nodes-to-an-existing-duplex-system
   starlingx-openstack/using-labels-to-identify-openstack-nodes
