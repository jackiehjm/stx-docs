==================
Deployment Options
==================

StarlingX provides a pre-defined set of standard configurations. These
configurations are:

All-in-one Simplex (*Simplex* or *AIO-SX*)
  The Simplex configuration runs all edge cloud functions (control, storage, and
  application workloads) on one node. This configuration is intended for very
  small and physically isolated edge sites that do not require high availability.

All-in-one Duplex (*Duplex* or *AIO-DX*)
  The Duplex configuration runs all edge cloud functions (control, storage, and
  application workloads) on one node. There is a second node in the system
  for Active / Standby based high availability for all platform and application
  services.

Standard with Controller Storage
  This configuration allows for 1 or 2 controller nodes that also provide
  storage for the edge cloud. The configuration also allows for between 1 and
  99 worker nodes to run application workloads. This configuration works best
  for edge clouds with smaller storage needs.

Standard with Dedicated Storage
  This configuration has dedicated storage nodes in addition to the controller
  and worker nodes. This configuration is used for edge clouds that require
  larger amounts of storage.

Standard with Ironic
  This configuration extends the standard configurations to add the OpenStack
  Ironic service, which allows application workloads to run on bare metal servers.

Distributed Cloud
  An upcoming feature for StarlingX that will allow one controller to control a
  number of remote nodes.
