=================
Basic Terminology
=================

The following definitions describe key concepts and terminology that are
commonly used in the StarlingX community and in this documentation.

All-in-one Controller Node
  A single physical node that provides a controller function, worker function,
  and storage function.

Bare Metal
  A node running without hypervisors (for example, application workloads run
  directly on the operating system which runs directly on the hardware).

Worker
  A node within a StarlingX edge cloud that is dedicated to running application
  workloads. There can be 0 to 99 worker nodes in a StarlingX edge cloud.

  - Runs virtual switch for realizing virtual networks.
  - Provides L3 routing and NET services.

  In a configuration running OpenStack, a worker node is labeled as 'compute' and
  may be referred to as a compute node.

Controller
  A node within a StarlingX edge cloud that runs the cloud management software
  (*control plane*). There can be either one or two controller nodes in a
  StarlingX edge cloud.

  - Runs cloud control functions for managing cloud resources.
  - Runs all OpenStack control functions, such as managing images, virtual
    volumes, virtual network, and virtual machines.
  - Can be part of a two-node HA control node cluster for running control
    functions either active/active or active/standby.

Data Network(s)
  Networks on which the OpenStack / Neutron provider networks are realized and
  become the VM tenant networks.

  Only worker-type and all-in-one-type nodes are required to be connected to
  the data network(s). These node types require one or more interface(s) on the
  data network(s).

Infra Network
  A deprecated optional network that was historically used for access to the
  storage cluster.

  If this optional network is used, all node types are required to be connected
  to the INFRA network.

IPMI Network
  An optional network on which Intelligent Platform Management Interface
  (IPMI) interfaces of all nodes are connected. The network must be reachable
  using L3/IP from the controller's OAM interfaces.

  You can optionally connect all node types to the IPMI network.

Management Network
  A private network (that is, not connected externally), typically 10GE, used
  for the following:

  - Internal OpenStack / StarlingX monitoring and control.
  - VM I/O access to a storage cluster.

  All nodes are required to be connected to the management network.

Node
  A computer that is usually a server-class system.

Node Interfaces
  All nodes' network interfaces can, in general, optionally be either:

  - Untagged single port.
  - Untagged two-port LAG and optionally split between redundant L2 switches
    running vPC (Virtual Port-Channel), also known as multichassis
    EtherChannel (MEC).
  - VLAN on either single-port ETH interface or two-port LAG interface.

OAM Network
  The network on which all external StarlingX platform APIs are exposed,
  (that is, REST APIs, Horizon web server, SSH, and SNMP), typically 1GE.

  Only controller type nodes are required to be connected to the OAM network.

PXEBoot Network
  An optional network for controllers to boot/install other nodes over the
  network.

  By default, controllers use the management network for boot/install of other
  nodes in the OpenStack cloud. If this optional network is used, all node
  types are required to be connected to the PXEBoot network.

  A PXEBoot network is required for a variety of special case situations:

  - Cases where the management network must be IPv6:

    - IPv6 does not support PXEBoot. Therefore, you must configure an IPv4
      PXEBoot network.

  - Cases where the management network must be VLAN tagged:

    - Most server's BIOS do not support PXEBooting over tagged networks.
      Therefore, you must configure an untagged PXEBoot network.

  - Cases where a management network must be shared across regions but
    individual regions' controllers want to only network boot/install nodes of
    their own region:

    - You must configure separate, per-region PXEBoot networks.

Storage
  A node within a StarlingX edge cloud that is dedicated to providing file and
  object storage to application workloads. There can be 0 or more storage nodes
  within a StarlingX edge cloud.

  - Runs CEPH distributed storage software.
  - Part of an HA multi-node CEPH storage cluster supporting a replication
    factor of two or three, journal caching, and class tiering.
  - Provides HA persistent storage for images, virtual volumes (that is, block
    storage), and object storage.

Virtual Machines (VM)
  An instance of a node provided by software (a hypervisor), which runs within
  the host operating system and hardware.
