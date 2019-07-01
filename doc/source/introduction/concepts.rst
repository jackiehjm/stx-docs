============
Key concepts
============

The following are some of key concepts and terminology that are
commonly used in the StarlingX community and in this documentation.

Basic Terms
-----------

Node
  A computer which is usually a server-class system

Virutal Machines
  An instance of a node provided by software (a hypervisor)
  which runs within the host operating system and hardware.

Bare Metal
  A node running without hypervisors (e.g. application workloads run
  directly on the operating system which runs directly on the hardware).

Controller
  A node within a StarlingX Edge Cloud that runs the cloud
  management software ("control plane"). There can be
  either one or two Controller nodes in a StarlingX Edge Cloud.

Compute or Worker
  A node within a StarlingX Edge Cloud that is dedicated to running
  application workloads. There can be zero to ninety-nine Compute
  nodes in a StarlingX Edge Cloud.

Storage
  A node within a StarlingX Edge Cloud that is dedicated to providing
  file and object storage to application workloads. There can be zero
  or more Storage nodes within a StarlingX Edge Cloud.

Deployment options
------------------

StarlingX provides a pre-defined set of standard configurations. These
configurations are:

All-in-one Simplex ("Simplex" or "AIO-SX")
  The Simplex configuration runs all Edge Cloud functions (control,
  storage, and application workloads) on one node. This configuration
  is intended for very small and physically isolated Edge sites
  that do not require High Availability.

All-in-one Duplex ("Duplex" or "AIO-DX")
  The Duplex configuration runs all Edge Cloud functions (control,
  storage, and application workloads) on one node, but there is
  a second node in the system for Active / Standby based
  High Availability for all platform and application services.

All-in-one Duplex with up to 4 computes
  This configuration extends the Duplex configuration
  by providing a bit more flexibility, In particular it allows
  a small number of
  compute nodes to be added to the Edge Cloud after it has
  been created.

Standard with Controller Storage
  This configuration allows for 1 or 2 Controller nodes that
  also provide Storage for the Edge Cloud. The configuration
  also allows for between 1 and 99
  Compute nodes to run application workloads. This configuration
  works best for Edge Clouds with smaller Storage needs.

Standard with Dedicated Storage
  This configuration has dedicated Storage nodes in addition
  to the Controller and Compute nodes. You can use this
  configuration for Edge Clouds that require larger amounts of Storage.

Standard with Ironic
  This configuration extends the Standard configurations
  to add the OpenStack Ironic service, which allows application
  workloads to run on Bare Metal servers.

Multi-Region
  TBD

Distributed Cloud
  An upcoming feature for StarlingX that will allow one
  controller to control a number of remote nodes.
