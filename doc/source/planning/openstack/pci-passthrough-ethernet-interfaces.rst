
.. osb1466081265288
.. _pci-passthrough-ethernet-interfaces:

===================================
PCI Passthrough Ethernet Interfaces
===================================

A passthrough Ethernet interface is a physical |PCI| Ethernet |NIC| on a
compute node to which a virtual machine is granted direct access.

This minimizes packet processing delays but at the same time demands special
operational considerations.

For all purposes, a |PCI| passthrough interface behaves as if it were
physically attached to the virtual machine. Therefore, any potential throughput
limitations coming from the virtualized environment, such as the ones
introduced by internal copying of data buffers, are eliminated. However, by
bypassing the virtualized environment, the use of |PCI| passthrough Ethernet
devices introduces several restrictions that you must take into consideration.
They include:


.. _pci-passthrough-ethernet-interfaces-ul-mjs-m52-tp:

-   no support for |LAG|, |QoS|, |ACL|, or host interface monitoring

-   no support for live migration
