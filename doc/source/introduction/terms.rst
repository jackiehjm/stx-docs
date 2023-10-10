=================
Basic Terminology
=================

The following definitions describe key concepts and terminology that are
commonly used in the |org| community and in this documentation.

.. glossary::
   :sorted:

   All-in-one Controller Node
     A single physical node that provides a controller function, worker
     function, and storage function.

   Bare Metal
     A node running without Kubelet or hypervisors (for example, application
     workloads run directly on the operating system which runs directly on
     the hardware).

   Worker
     A node within a |prod| edge cloud that is dedicated to running application
     workloads. There can be 0 to |max-workers| worker nodes in a |prod| edge
     cloud.

     In a configuration running OpenStack, a worker node:

     - is labeled as 'compute' 
     - may be referred to as a compute node.
     - runs virtual switch for realizing virtual networks.
     - provides L3 routing and NET services.


   Controller
     A node within a |prod| edge cloud that runs the cloud management software
     (*control plane*). There can be either one or two controller nodes in a
     |prod| edge cloud.

     - Runs cloud control functions for managing cloud resources.
     - Runs all Kubernetes control functions such as kube-apiserver,
       kube-controller-manager and kube-schedule
     - Runs all OpenStack control functions, such as managing images, virtual
       volumes, virtual network, and virtual machines.
     - Can be part of a two-node |HA| control node cluster for running control
       functions either active/active or active/standby.

   Data Network(s)
     Networks attached to pci-passthrough and/or sriov interfaces that are made 
     available to hosted containers or hosted |VMs| for pci-passthrough and/or |SRIOV|
     interfaces.

     Networks attached to data interfaces of the OpenStack vSwitch, on which the
     OpenStack / Neutron provider networks are realized and become the |VM| tenant
     networks.

     Only worker-type and all-in-one-type nodes, which host end-user containers
     and/or |VMs| would have data network(s) attached.

     In the case of openstack-compute labelled worker nodes, a data network MUST be
     attached to at lease one 'data' (vSwitch) interface.

   Deployment Tools
     Tools that make the process of distributing, installing, and managing
     updates.

   Edge Computing
     The delivery of computing capabilities to the logical extremes of a
     network in order to improve the performance, operating cost and
     reliability of applications and services. By shortening the distance
     between devices and the resources that serve them, and also reducing
     network hops, edge computing mitigates the latency and bandwidth
     constraints of today's Internet, ushering in new classes of applications.

     From `Open Glossary of Edge Computing <https://github.com/State-of-the-
     Edge/glossary/blob/master/edge-glossary.md#edge-computing>`_

   Infra Network
     A deprecated optional network that was historically used for access to the
     storage cluster.

     If this optional network is used, all node types are required to be
     connected to the INFRA network.

   IoT (Internet of Things)
     A system of computing devices that can operate with little/no human
     interaction.

   IPMI Network
     An optional network on which |IPMI| interfaces of all nodes are connected.
     The network must be reachable using L3/IP from the controller's OAM
     interfaces.

     You can optionally connect all node types to the |IPMI| network.

   Kubernetes Cluster
     A set of machines that has a common control plane for running orchestrated
     applications.

   Management Network
     A private network (that is, not connected externally), typically 10GE,
     used for the following:

     - Internal StarlingX Infrastructure management monitoring and control
     - in the case of openstack, it is also used by |VM| I/O access to
       virtualized disks in Ceph Storage Cluster

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

   |OAM| Network
     The network on which all external |prod| platform APIs are exposed, (that
     is, REST APIs, Horizon web server, |SSH|, and |SNMP|), typically 1GE.

     Only controller type nodes are required to be connected to the OAM
     network.

   .. only:: starlingx

      Open Source StarlingX
        A set of services that can be used to build cloud infrastructure. The
        source code of the services is available under an open source license
        that allows access and re-distribution of the codebase. The software
        components are created and maintained with an open development process
        through collaboration.

   PXEBoot Network
     An optional network for controllers to boot/install other nodes over the
     network.

     By default, controllers use the management network for boot/install of
     other nodes in the OpenStack cloud. If this optional network is used, all
     node types are required to be connected to the PXEBoot network.

     A PXEBoot network is required for a variety of special case situations:

     - Cases where the management network must be IPv6:

       - IPv6 does not support PXEBoot. Therefore, you must configure an IPv4
         PXEBoot network.

     - Cases where the management network must be |VLAN| tagged:

       - Most server's BIOS do not support PXEBooting over tagged networks.
         Therefore, you must configure an untagged PXEBoot network.

     - Cases where a management network must be shared across regions but
       individual regions' controllers want to only network boot/install nodes
       of their own region:

       - You must configure separate, per-region PXEBoot networks.

   StarlingX
     StarlingX is an open source, complete cloud infrastructure software stack
     for the edge used by the most demanding applications in industrial |IoT|,
     telecom, and other use cases. The platform creates a fusion between
     OpenStack and Kubernetes to provide a robust and flexible environment for
     all kinds of workloads, including containerized, virtualized or bare
     metal.

   Storage
     A node within a |prod| edge cloud that is dedicated to providing file and
     object storage to application workloads. There can be 0 or more storage
     nodes within a |prod| edge cloud.

     - Runs CEPH distributed storage software.
     - Part of an |HA| multi-node CEPH storage cluster supporting a replication
       factor of two or three, journal caching, and class tiering.
     - Provides |HA| persistent storage for images, virtual volumes (that is,
       block storage), and object storage.

   Virtualization
     The act of creating a virtual version of CPU, network or storage device.

   Virtual Machines (VM)
     An instance of a node provided by software (a hypervisor), which runs
     within the host operating system and hardware.

   Rollback 
     The process of reverting changes made to a system or database to a
     previous state. For |prod|, *Rollback* is a capability that is supported
     during an upgrade or update.

   Restore
     Bringing back a system or data from a backup or a previously saved state.
     For |prod|, *Restore* can be used for current release (*N*) or (*N*-1).

   Downgrade
     The process of moving from a higher version or a newer release of a
     software, firmware, or operating system to a lower version or an older
     release.

   Precheck
     A system state checks intended to confirm the system health for an
     impending operation.  This check can be performed at any time prior to the
     system operation execution, but is intended to be executed just prior to
     confirming that it can be scheduled before actually attempting the operation.

   Prestaging
     System software media is prepopulated on the system in preparation for an
     impending operation. *Prestaging* is currently supported for installation
     and upgrade operation.

   Preinstallation
     New deployments for a system that is installed in the factory.
     *Preinstallation* also refers to software media that is installed alongside
     the existing deployment in preparation for an upgrade.

   Shared NIC
     A single physical port that can be shared by two or more system networks (oam, mgmt., 
     cluster-host, pxeboot and data)
     For more information, see :ref:`sriov-port-sharing`.