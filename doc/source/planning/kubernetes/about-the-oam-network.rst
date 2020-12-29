
.. ozd1552671198357
.. _about-the-oam-network:

=====================
About the OAM Network
=====================

The |OAM| network provides for control access.

You should ensure that the following services are available on the |OAM|
Network:

**DNS Service**
    Needed to facilitate the name resolution of servers reachable on the |OAM|
    Network.

    |prod| can operate without a configured DNS service. However, a DNS service
    should be in place to ensure that links to external references in the
    current and future versions of the Horizon Web interface work as expected.

**Docker Registry Service**
    A private or public Docker registry service needed to serve remote
    container image requests from Kubernetes and the underlying Docker service.

    This remote Docker registry must hold the required |prod| container images
    for the appropriate release, to fully install a |prod| system.

**NTP Service**
    |NTP| can be used by the |prod| controller nodes to synchronize their local
    clocks with a reliable external time reference. |org| strongly recommends
    that this service be available to ensure that system-wide log reports
    present a unified view of the day-to-day operations.

    The |prod| worker nodes and storage nodes always use the controller nodes
    as the de-facto time server for the entire |prod| cluster.

**PTP Service**
    As an alternative to |NTP| services, |PTP| can be used by the |prod|
    controller nodes to synchronize clocks in a network. It provides:

    -   more accurate clock synchronization

    -   the ability to extend the clock synchronization, not only to |prod|
        hosts \(controllers, workers, and storage nodes\), but also to hosted
        applications on |prod| hosts.

    When used in conjunction with hardware support on the |OAM| and Management
    network interface cards, |PTP| is capable of sub-microsecond accuracy.
    |org| strongly recommends that this service, or |NTP|, if available, be
    used to ensure that system-wide log reports present a unified view of the
    day-to-day operations, and that other time-sensitive operations are
    performed accurately.

    Various |NICs| and network switches provide the hardware support for |PTP|
    used by |OAM| and Management networks. This hardware provides an on-board
    clock that is synchronized to the |PTP| master. The computer's system clock
    is synchronized to the |PTP| hardware clock on the |NIC| used to stamp
    transmitted and received |PTP| messages. For more information, see the
    *IEEE 1588-2002* standard.

.. note::
    |NTP| and |PTP| can be configured on a per host basis.
