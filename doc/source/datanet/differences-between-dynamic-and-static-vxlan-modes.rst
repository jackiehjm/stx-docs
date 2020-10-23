
.. xoq1512159092473
.. _differences-between-dynamic-and-static-vxlan-modes:

==================================================
Differences Between Dynamic and Static VXLAN Modes
==================================================

This section summarizes the differences between dynamic and static VXLAN modes.

.. _differences-between-dynamic-and-static-vxlan-modes-table-exv-tbr-1bb:

.. list-table:: Differences between the Dynamic and Static VXLAN modes
    :widths: auto
    :header-rows: 1

    * - Destination MAC\\mode
      - Static VXLAN mode
      - Dynamic VXLAN mode
    * - Known MAC address
      - Unicast packet is sent to destination worker node.
      - Unicast packet is sent to destination worker node.
    * - Unknown MAC address
      - The packet is dropped.
      - A multicast packet is sent to all registered nodes.
    * - Broadcast MAC address
      - #.  If the packet is an IPv4 ARP packet, and the target IP address is
            known, then a reply packet is created and sent to the originator
            directly without involving the intended recipient or destination
            VTEP node.
        #.  Otherwise the packet is cloned and a copy is sent to each
            registered/known worker node on that data network.
      - A multicast packet is sent to all registered nodes.
    * - Multicast MAC address
      - #.  If the packet is an ICMPv6 ND packet, and the target IP address is
            known, then a reply packet is created and sent to the originator
            directly without involving the intended recipient or destination
            VTEP node.
        #.  Otherwise the packet is cloned and a copy is sent to each
            registered/known worker node on that data network.
      - A multicast packet is sent to all registered nodes.