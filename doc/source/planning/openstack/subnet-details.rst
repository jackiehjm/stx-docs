
.. psa1412702861873
.. _subnet-details:

==============
Subnet Details
==============

You can adjust several options for project network subnets, including |DHCP|,
IP allocation pools, DNS server addresses, and host routes.

These options are available on the **Subnet Details** tab when you create or
edit a project network subnet.

.. note::
    IP addresses on project network subnets are always managed internally. For
    external address management, use project networks without subnets. For more
    information, see :ref:`Project Network IP Address Management
    <project-network-ip-address-management>`.

When creating a new IP subnet for a project network, you can specify the
following attributes:

**Enable DHCP**
    When this attribute is enabled, a virtual |DHCP| server becomes available
    when the subnet is created. It uses the (MAC address, IP address) pairs
    registered in the Neutron database to offer IP addresses in response to
    |DHCP| discovery requests broadcast on the subnet. |DHCP| discovery
    requests from unknown |MAC| addresses are ignored.

    When the |DHCP| attribute is disabled, all |DHCP| and DNS services, and all
    static routes, if any, must be provisioned externally.

**Allocation Pools**
    This a list attribute where each element in the list specifies an IP
    address range, or address pool, in the subnet address space that can be
    used for dynamic offering of IP addresses. By default, there is a single
    allocation pool comprised of the entire subnet's IP address space, with the
    exception of the default gateway's IP address.

    An external, non-Neutron, |DHCP| server can be attached to a subnet to
    support specific deployment needs as required. For example, it can be
    configured to offer IP addresses on ranges outside the Neutron allocation
    pools to service physical devices attached to the project network, such as
    testing equipment and servers.

**DNS Name Servers**
    You can reserve IP addresses for use by DNS servers.

**Host Routes**
    You can use this to specify host connections to routers on the subnet.
