
.. wic1511538154740
.. _vxlan-data-networks:

===================
VXLAN Data Networks
===================

Virtual eXtensible Local Area Networks \(|VXLANs|\) data networks are an
alternative to |VLAN| data networks.

A |VXLAN| data network is implemented over a range of |VXLAN| Network
Identifiers \(|VNIs|.\) This is similar to the |VLAN| option, but allows
multiple data networks to be defined over the same physical network using
unique |VNIs| defined in segmentation ranges.

Packets sent between |VMs| over virtual project networks backed by a |VXLAN|
data network are encapsulated with IP, |UDP|, and |VXLAN| headers and sent as
Layer 3 packets. The IP addresses of the source and destination compute nodes
are included in the outer IP header.

.. only:: starlingx

    |prod-os| supports two configurations for |VXLANs|:

.. only:: partner

    .. include:: ../../_includes/vxlan-data-networks.rest
    
.. _vxlan-data-networks-ul-rzs-kqf-zbb:

-   Dynamic |VXLAN|, see :ref:`Dynamic VXLAN <dynamic-vxlan>`

-   Static |VXLAN|, see :ref:`Static VXLAN <static-vxlan>`


.. _vxlan-data-networks-section-N10067-N1001F-N10001:

.. rubric:: |prereq|

Before you can create project networks on a |VXLAN| provider network, you must
define at least one network segment range.

-   :ref:`Dynamic VXLAN <dynamic-vxlan>`  

-   :ref:`Static VXLAN <static-vxlan>`  

-   :ref:`Differences Between Dynamic and Static VXLAN Modes <differences-between-dynamic-and-static-vxlan-modes>`  
