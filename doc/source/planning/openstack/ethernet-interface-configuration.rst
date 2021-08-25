
.. jow1423169316542
.. _ethernet-interface-configuration:

.. partner only ?

================================
Ethernet Interface Configuration
================================

You can review and modify the configuration for physical or virtual Ethernet
interfaces using the OpenStack Horizon Web interface or the CLI.

.. _ethernet-interface-configuration-section-N1001F-N1001C-N10001:

----------------------------
Physical Ethernet Interfaces
----------------------------

The physical Ethernet interfaces on |prod-os| nodes are configured to use the
following networks:

.. _ethernet-interface-configuration-ul-lk1-b4j-zq:

-   the internal management network

-   the internal cluster host network \(by default sharing the same L2
    interface as the internal management network\)

-   the external |OAM| network

-   one or more data networks

A single interface can optionally be configured to support more than one
network using |VLAN| tagging \(see :ref:`Shared (VLAN or Multi-Netted) Ethernet
Interfaces
<network-planning-shared-vlan-or-multi-netted-ethernet-interfaces>`\).

.. _ethernet-interface-configuration-section-N10059-N1001C-N10001:

---------------------------
Virtual Ethernet Interfaces
---------------------------

The virtual Ethernet interfaces for guest |VMs| running on |prod-os| are
defined when an instance is launched. They connect the |VM| to project
networks, which are virtual networks defined over data networks, which in turn
are abstractions associated with physical interfaces assigned to physical
networks on the compute nodes.

The following virtual network interfaces are available:

.. _ethernet-interface-configuration-ul-amy-z5z-zs:

-   |AVP|

-   ne2k\_pci \(NE2000 Emulation\)

-   pcnet \(AMD PCnet/|PCI| Emulation\)

-   rtl8139 \(Realtek 8139 Emulation\)

-   virtio \(VirtIO Network\)

-   pci-passthrough \(|PCI| Passthrough Device\)

-   pci-sriov \(|SRIOV| device\)


Unmodified guests can use Linux networking and virtio drivers. This provides a
mechanism to bring existing applications into the production environment
immediately.

.. xbooklink For more information about |AVP| drivers, see OpenStack VNF Integration: :ref:`Accelerated Virtual Interfaces <accelerated-virtual-interfaces>`.

|prod-os| incorporates |DPDK|-Accelerated Neutron Virtual Router L3 Forwarding
\(AVR\). Accelerated forwarding is used for directly attached project networks
and subnets, as well as for gateway, |SNAT| and floating IP functionality.

|prod-os| also supports direct guest access to |NICs| using |PCI| passthrough
or |SRIOV|, with enhanced |NUMA| scheduling options compared to standard
OpenStack. This offers very high performance, but because access is not managed
by |prod-os| or the vSwitch process, there is no support for live migration,
|prod-os|-provided |LAG|, host interface monitoring, |QoS|, or ACL. If |VLANs|
are used, they must be managed by the guests.

For further performance improvements, |prod-os| supports direct access to
|PCI|-based hardware accelerators, such as the Coleto Creek encryption
accelerator from Intel. |prod-os| manages the allocation of |SRIOV| VFs to
|VMs|, and provides intelligent scheduling to optimize |NUMA| node affinity.

.. only:: partner

   .. include:: /_includes/ethernet-interface-configuration.rest
