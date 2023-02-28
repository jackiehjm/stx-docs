
.. acc1552590687558
.. _the-ethernet-mtu:

============
Ethernet MTU
============

The |MTU| of an Ethernet frame is a configurable attribute in |prod|. Changing
its default size must be done in coordination with other network elements on
the Ethernet link.

In the context of |prod|, the |MTU| refers to the largest possible payload on
the Ethernet frame on a particular network link. The payload is enclosed by the
Ethernet header (14 bytes) and the CRC (4 bytes), resulting in an Ethernet
frame that is 18 bytes longer than the |MTU| size.

The original IEEE 802.3 specification defines a valid standard Ethernet frame
size to be from 64 to 1518 bytes, accommodating payloads ranging in size from
46 to 1500 bytes. Ethernet frames with a payload larger than 1500 bytes are
considered to be jumbo frames.

For a |VLAN| network, the frame also includes a 4-byte |VLAN| ID header,
resulting in a frame size 22 bytes longer than the |MTU| size.

In |prod|, you can configure the |MTU| size for the following interfaces and
networks:

.. _the-ethernet-mtu-ul-qmn-yvn-m4:

-   The management, cluster host and |OAM| network interfaces on the
    controller. The |MTU| size for these interfaces is set during initial
    installation.

.. xbooklink For more information, see the `StarlingX Installation and Deployment Guide <https://docs.starlingx.io/deploy_install_guides/index.html>`__. To make changes after installation, see |sysconf-doc|: :ref:`Change the MTU of an OAM Interface Using Horizon <changing-the-mtu-of-an-oam-interface-using-horizon>`.

-   Additional interfaces configured for container workload connectivity to
    external networks,


In all cases, the default |MTU| size is 1500. The minimum value is 576, and the
maximum is 9216.

