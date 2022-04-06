
.. kvt1552671101079
.. _l2-access-switches:

=============================
Kubernetes L2 Access Switches
=============================

L2 access switches connect the |prod| hosts to the different networks. Proper
configuration of the access ports is necessary to ensure proper traffic flow.

One or more L2 switches can be used to connect the |prod| hosts to the
different networks. When sharing a single L2 switch you must ensure proper
isolation of network traffic. A sample configuration for a shared L2 switch
could include:


.. _l2-access-switches-ul-obf-dyr-4n:

-   one port-based |VLAN| for the internal management network with internal
    cluster host network sharing this same L2 network \(default configuration\)

-   one port-based |VLAN| for the |OAM| network

-   one or more sets of |VLANs| for additional networks for external network
    connectivity

When using multiple L2 switches, there are several deployment possibilities:

.. _l2-access-switches-ul-qmd-wyr-4n:

-   A single L2 switch for the internal management cluster host and |OAM|
    networks. Port or |MAC|-based network isolation is mandatory.

-   An additional L2 switch for the one or more additional networks for
    external network connectivity.

-   Redundant L2 switches to support link aggregation, using either a failover
    model, or |VPC| for more robust redundancy. For more information, see
    :ref:`Redundant Top-of-Rack Switch Deployment Considerations
    <redundant-top-of-rack-switch-deployment-considerations>`.


Switch ports that send tagged traffic are referred to as trunk ports. They
participate in |STP| from the moment the link goes up, which results in a
several second delay before the trunk port moves to the forwarding state. This
delay will impact services such as |DHCP| and |PXE| that are used during
regular operations of |prod|.

You must consider configuring the switch ports, to which the management
interfaces are attached, to transition to the forwarding state immediately
after the link goes up. This option is referred to as a PortFast.

You should consider configuring these ports to prevent them from participating
on any |STP| exchanges. This is done by configuring them to avoid processing
inbound and outbound |BPDU| |STP| packets completely. Consult your switch's
manual for details.

.. seealso::

   :ref:`Redundant Top-of-Rack Switch Deployment Considerations <redundant-top-of-rack-switch-deployment-considerations>`
