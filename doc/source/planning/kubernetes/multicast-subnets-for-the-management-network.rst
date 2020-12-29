
.. osh1552670597082
.. _multicast-subnets-for-the-management-network:

============================================
Multicast Subnets for the Management Network
============================================

A multicast subnet specifies the range of addresses that the system can use for
multicast messaging on the network. You can use this subnet to prevent
multicast leaks in multi-region environments. Addresses for the affected
services are allocated automatically from the subnet.

The requirements for multicast subnets are as follows:


.. _multicast-subnets-for-the-management-network-ul-ubf-ytc-b1b:

-   IP multicast addresses must be in the range of 224.0.0.0 through
    239.255.255.255

    For IPv6, the recommended range is ffx5::/16.

-   IP multicast address ranges for a particular region must not conflict or
    overlap with the IP multicast address ranges of other regions.

-   IP multicast address ranges must not conflict or overlap with the
    well-known multicast addresses listed at:

    `https://en.wikipedia.org/wiki/Multicast_address
    <https://en.wikipedia.org/wiki/Multicast_address>`__

-   IP multicast addresses must be unique within the network.

-   The lower 23-bits of the IP multicast address, used to construct the
    multicast MAC address, must be unique within the network.

-   When interfaces of different regions are on the same L2 network / IP
    subnet, a separate multicast subnet is required for each region.

-   The minimum multicast network range is 16 host entries.


.. note::
    Addresses used within the IP multicast address range apply to services
    using IP multicast, not to hosts.

.. warning::
    |ToR| switches with snooping enabled on this network segment require a
    |IGMP|/|MLD| querier on that network to prevent nodes from being dropped
    from the multicast group.

The default setting for the multicast subnet is 239.1.1.0/28. The default for
IPv6 is ff05::14:1:1:0/124.
