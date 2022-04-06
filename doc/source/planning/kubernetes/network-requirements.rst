
.. jow1404333564380
.. _network-requirements:

====================
Network Requirements
====================

|prod| uses several different types of networks, depending on the size of the
system and the features in use.

Available networks include the optional |PXE| boot network, the internal
management network, the cluster host network, the |OAM| network, and other
optional networks for external network connectivity.

The internal management network is required by all deployment configurations
for internal communication.

The cluster host network is required by all deployment configurations to
support a Kubernetes cluster. It is used for private container-to-container
networking within a cluster. It can be used for external connectivity of
container workloads. If the cluster host network is not used for external
connectivity of container workloads, then either the |OAM| port or other
configured ports on both the controller and worker nodes can be used for
connectivity to external networks.

The |OAM| network is required for external control and board management access.
It can be required for container payload external connectivity, depending on
container payload application network requirements.

You can consolidate more than one network on a single physical interface. For
more information, see :ref:`Shared (VLAN or Multi-Netted) Ethernet Interfaces
<shared-vlan-or-multi-netted-ethernet-interfaces>`.

.. note::
    Systems with two controllers use IP multicast messaging on the internal
    management network. To prevent loss of controller synchronization, ensure
    that the switches and other devices on these networks are configured with
    appropriate settings.
