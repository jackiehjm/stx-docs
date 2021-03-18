
.. vic1596720744539
.. _pci-sr-iov-ethernet-interface-devices:

=====================================
PCI SR-IOV Ethernet Interface Devices
=====================================

A |SRIOV| ethernet interface is a physical |PCI| ethernet |NIC| that implements
hardware-based virtualization mechanisms to expose multiple virtual network
interfaces that can be used by one or more virtual machines simultaneously.

The |PCI|-SIG Single Root I/O Virtualization and Sharing \(|SRIOV|\) specification
defines a standardized mechanism to create individual virtual ethernet devices
from a single physical ethernet interface. For each exposed virtual ethernet
device, formally referred to as a Virtual Function \(VF\), the |SRIOV| interface
provides separate management memory space, work queues, interrupts resources,
and |DMA| streams, while utilizing common resources behind the host interface.
Each VF therefore has direct access to the hardware and can be considered to be
an independent ethernet interface.

When compared with a |PCI| Passthrough ethernet interface, a |SRIOV| ethernet
interface:


.. _pci-sr-iov-ethernet-interface-devices-ul-tyq-ymg-rr:

-   Provides benefits similar to those of a |PCI| Passthrough ethernet interface,
    including lower latency packet processing.

-   Scales up more easily in a virtualized environment by providing multiple
    VFs that can be attached to multiple virtual machine interfaces.

-   Shares the same limitations, including the lack of support for |LAG|, |QoS|,
    |ACL|, and live migration.

-   Has the same requirements regarding the |VLAN| configuration of the access
    switches.

-   Provides a similar configuration workflow when used on |prod-os|.


The configuration of a |PCI| |SRIOV| ethernet interface is identical to
:ref:`Configure PCI Passthrough ethernet Interfaces
<configure-pci-passthrough-ethernet-interfaces>` except that


.. _pci-sr-iov-ethernet-interface-devices-ul-ikt-nvz-qmb:

-   you use **pci-sriov** instead of **pci-passthrough** when defining the
    network type of an interface

-   the segmentation ID of the project network\(s\) used is more significant
    here since this identifies the particular |VF| of the |SRIOV| interface

-   when creating the neutron port, you must use ``--vnic-typedirect``

-   when creating a neutron port backed by an |SRIOV| |VF|, you must use
    ``--vnic-type direct``


