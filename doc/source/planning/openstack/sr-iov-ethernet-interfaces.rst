
.. aqg1466081208315
.. _sr-iov-ethernet-interfaces:

==========================
SR-IOV Ethernet Interfaces
==========================

An |SRIOV| Ethernet interface is a physical |PCI| Ethernet |NIC| that
implements hardware-based virtualization mechanisms to expose multiple virtual
network interfaces that can be used by one or more virtual machines
simultaneously.

The PCI-SIG |SRIOV| specification defines a standardized mechanism to create
individual virtual Ethernet devices from a single physical Ethernet interface.
For each exposed virtual Ethernet device, formally referred to as a |VF|, the
|SRIOV| interface provides separate management memory space, work queues,
interrupts resources, and DMA streams, while utilizing common resources behind
the host interface. Each VF therefore has direct access to the hardware and can
be considered to be an independent Ethernet interface.

The following limitations apply to |SRIOV| interfaces:


.. _sr-iov-ethernet-interfaces-ul-mjs-m52-tp:

-   no support for |LAG|, |QoS|, |ACL|, or host interface monitoring

-   no support for live migration
