
.. ooz1552671180591
.. _oam-network-planning:

====================
OAM Network Planning
====================

The |OAM| network enables ingress access to the Horizon Web interface, the
command-line management clients -- using |SSH| and |SNMP| interfaces, and the
REST APIs to remotely manage the |prod| cluster.

The |OAM| Network is also used for egress access to remote Docker Registries,
and for Elastic Beats connectivity to a Remote Log server if |prod| remote
logging is configured.

The |OAM| network provides access to the board management controllers.

The |OAM| network supports IPv4 or IPv6 addressing. Use the following
guidelines:

.. _oam-network-planning-ul-uj3-yk2-4n:

-   Dual-stack configuration is not supported. With the exception of the PXE
    boot network, all networks must use either IPv4 or IPv6 addressing.

-   Deploy proper firewall mechanisms to access this network. The primary
    concern of a firewall is to ensure that access to the |prod| management
    interfaces is not compromised.

    |prod| includes a default firewall for the |OAM| network, using Kubernetes
    Network Policies. You can configure the system to support additional rules.
    For more information, see :ref:`Firewall Options
    <network-planning-firewall-options>`.

-   Consider whether the |OAM| network needs access to the internet. Limiting
    access to an internal network might be advisable, although access to a
    configured DNS server, a remote Docker registry with at least the |prod|
    container images, and |NTP| or |PTP| servers may still be needed.

-   |VLAN| tagging is supported, enabling the network to share an interface
    with the internal management or infrastructure networks.

-   The IP addresses of the DNS, and |NTP|/|PTP| servers must match the IP
    address plan (IPv4 or IPv6) of the |OAM| network.

-   For an IPv4 address plan:

    -   The |OAM| floating IP address is the only address that needs to be
        visible externally. You must therefore plan for valid definitions of
        its IPv4 subnet and default gateway.

    -   The physical IPv4 addresses for the controllers do not need to be
        visible externally, unless you plan to use them during |SSH| sessions
        to prevent potential service breaks during the connection. You need to
        plan for their IPv4 subnet, but you can limit access to them as
        required.

    -   Outgoing packets from the active or secondary controller use the
        controller's IPv4 physical address, not the |OAM| floating IP address,
        as the source address.

-   For an IPv6 address plan:

    -   Outgoing packets from the active controller use the |OAM| floating IP
        address as the source address. Outgoing packets from the secondary
        controller use the secondary controller's IPv6 physical IP address.

-   Systems with two controllers use IP multicast messaging on the
    internal management network. To prevent loss of controller synchronization,
    ensure that the switches and other devices on these networks are configured
    with appropriate settings.

.. only:: partner

   .. include:: /_includes/subnet-sizing-restrictions.rest