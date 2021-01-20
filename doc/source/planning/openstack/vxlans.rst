
.. ovi1474997555122
.. _vxlans:

======
VXLANs
======

You can use |VXLANs| to connect |VM| instances across non-contiguous Layer 2
segments \(that is, Layer 2 segments connected by one or more Layer 3
routers\).

A |VXLAN| is a Layer 2 overlay network scheme on a Layer 3 network
infrastructure. Packets originating from |VMs| and destined for other |VMs| are
encapsulated with IP, |UDP|, and |VXLAN| headers and sent as Layer 3 packets.
The IP addresses of the source and destination compute nodes are included in
the headers.

