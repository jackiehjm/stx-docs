
.. jow1404333732592
.. _os-planning-the-ethernet-mtu:

================
The Ethernet MTU
================

The |MTU| of an Ethernet frame is a configurable attribute in |prod-os|.
Changing its default size must be done in coordination with other network
elements on the Ethernet link.

In the context of |prod-os|, the |MTU| refers to the largest possible payload
on the Ethernet frame on a particular network link. The payload is enclosed by
the Ethernet header (14 bytes) and the CRC (4 bytes), resulting in an
Ethernet frame that is 18 bytes longer than the |MTU| size.

The original IEEE 802.3 specification defines a valid standard Ethernet frame
size to be from 64 to 1518 bytes, accommodating payloads ranging in size from
46 to 1500 bytes. Ethernet frames with a payload larger than 1500 bytes are
considered to be jumbo frames.

For a |VLAN| network, the frame also includes a 4-byte |VLAN| ID header,
resulting in a frame size 22 bytes longer than the |MTU| size.

For a |VXLAN| network, the frame is either 54 or 74 bytes longer, depending on
whether IPv4 or IPv6 protocol is used. This is because, in addition to the
Ethernet header and CRC, the payload is enclosed by an IP header (20 bytes for
Ipv4 or 40 bytes for IPv6), a |UDP| header (8 bytes), and a |VXLAN| header
\(8 bytes).

In |prod-os|, you can configure the |MTU| size for the following interfaces and
networks:

.. _the-ethernet-mtu-ul-qmn-yvn-m4:

-   The management and |OAM| network interfaces on the controller. The |MTU|
    size for these interfaces is set during initial installation; for more
    information, see the |prod-os| installation guide for your system. To make
    changes after installation, see |sysconf-doc|: :ref:`Change the MTU of an
    OAM Interface <changing-the-mtu-of-an-oam-interface-using-the-cli>`.

-   Data interfaces on compute nodes. For more information, see :ref:`Change
    the MTU of a Data Interface <changing-the-mtu-of-a-data-interface>`.

-   Data networks. For more information, see |datanet-doc|: :ref:`Data Networks
    <data-network-management-data-networks>`.

In all cases, the default |MTU| size is 1500. The minimum value is 576, and the
maximum is 9216.

.. note::
    You cannot change the |MTU| for a cluster-host interface. The default |MTU|
    of 1500 must always be used.

Because data interfaces are defined over physical interfaces connecting to data
networks, it is important that you consider the implications of modifying the
default |MTU| size:

.. _the-ethernet-mtu-ul-hsq-2f4-m4:

-   The |MTU| sizes for a data interface and the corresponding Ethernet
    interface on the edge router or switch must be compatible. You must ensure
    that each side of the link is configured to accept the maximum frame size
    that can be delivered from the other side. For example, if the data
    interface is configured with a |MTU| size of 9216 bytes, the corresponding
    switch interface must be configured to accept a maximum frame size of 9238
    bytes, assuming a |VLAN| tag is present.

    The way switch interfaces are configured varies from one switch
    manufacturer to another. In some cases you configure the |MTU| size
    directly, while in some others you configure the maximum Ethernet frame
    size instead. In the latter case, it is often unclear whether the frame
    size includes |VLAN| headers or not. In any case, you must ensure that both
    sides are configured to accept the expected maximum frame sizes.

-   For a |VXLAN| network, the additional IP, |UDP|, and |VXLAN| headers are
    invisible to the data interface, which expects a frame only 18 bytes larger
    than the |MTU|. To accommodate the larger frames on a |VXLAN| network, you
    must specify a larger nominal |MTU| on the data interface. For simplicity,
    and to avoid issues with stacked |VLAN| tagging, some third party vendors
    recommend rounding up by an additional 100 bytes for calculation purposes.
    For example, to attach to a |VXLAN| data network with an |MTU| of 1500, a
    data interface with an |MTU| of 1600 is recommended.

-   A data network can only be associated with a compute node data interface
    with an |MTU| of equal or greater value.

-   The |MTU| size of a compute node data interface cannot be modified to be
    less than the |MTU| size of any of its associated data networks.

-   The |MTU| size of a data network is automatically propagated to new project
    networks. Changes to the data network |MTU| are *not* propagated to
    existing project networks.

-   The Neutron L3 and |DHCP| agents automatically propagate the |MTU| size of
    their networks to their Linux network interfaces.

-   The Neutron |DHCP| agent makes the option interface-mtu available to any
    |DHCP| client request from a virtual machine. The request response from the
    server is the current interface's |MTU| size, which can then be used by the
    client to adjust its own interface |MTU| size.

..  .. only:: partner

.. include:: /_includes/the-ethernet-mtu.rest
