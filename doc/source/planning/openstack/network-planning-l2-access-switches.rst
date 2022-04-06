
.. jow1404333739778
.. _network-planning-l2-access-switches:

============================
OpenStack L2 Access Switches
============================

L2 access switches connect the |prod-os| hosts to the different networks.
Proper configuration of the access ports is necessary to ensure proper traffic
flow.

One or more L2 switches can be used to connect the |prod-os| hosts to the
different networks. When sharing a single L2 switch you must ensure proper
isolation of the network traffic. Here is an example of how to configure a
shared L2 switch:


.. _network-planning-l2-access-switches-ul-obf-dyr-4n:

-   one port-based |VLAN| for the internal management network and cluster host
    network

-   one port-based |VLAN| for the |OAM| network

-   one or more sets of |VLANs| for data networks. For example:

    -   one set of |VLANs| with good |QoS| for bronze projects

    -   one set of |VLANs| with better |QoS| for silver projects

    -   one set of |VLANs| with the best |QoS| for gold projects

When using multiple L2 switches, there are several deployment possibilities.
Here are some examples:

.. _network-planning-l2-access-switches-ul-qmd-wyr-4n:

-   A single L2 switch for the internal management, cluster host, and |OAM|
    networks. Port- or |MAC|-based network isolation is mandatory.

-   One or more L2 switches, not necessarily inter-connected, with one L2
    switch per data network.

-   Redundant L2 switches to support link aggregation, using either a failover
    model, or |VPC| for more robust redundancy.


See :ref:`Kubernetes Platform Planning <l2-access-switches>` for
additional considerations related to L2 switches.
