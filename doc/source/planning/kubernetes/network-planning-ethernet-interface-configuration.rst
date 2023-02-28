
.. elj1552671053086
.. _network-planning-ethernet-interface-configuration:

================================
Ethernet Interface Configuration
================================

You can review and modify the configuration for physical or virtual Ethernet
interfaces using the Horizon Web interface or the CLI.

.. _network-planning-ethernet-interface-configuration-section-N1001F-N1001C-N10001:

----------------------------
Physical Ethernet Interfaces
----------------------------

The Physical Ethernet interfaces on |prod| nodes are configured to use the
following networks:

.. _network-planning-ethernet-interface-configuration-ul-lk1-b4j-zq:

-   the internal management network, with the cluster host network sharing this
    interface (default configuration)

-   the external |OAM| network

-   additional networks for container workload connectivity to external
    networks

A single interface can be configured to support more than one network using
|VLAN| tagging. See :ref:`Shared (VLAN or Multi-Netted) Ethernet Interfaces
<shared-vlan-or-multi-netted-ethernet-interfaces>` for more information.

On the controller nodes, all Ethernet interfaces are configured when the nodes
are initialized based on the information provided in the Ansible Bootstrap
Playbook.

.. include:: /_includes/ethernet-interface-configuration.rest

On worker and storage nodes, the Ethernet interface for the internal management
networks are configured. The remaining interfaces require manual configuration.

.. note::
    If a network attachment uses |LAG|, the corresponding interfaces on the
    storage and worker nodes must be configured manually to specify the
    interface type.

You can review and modify physical interface configurations from Horizon or the
CLI.

.. xbooklink For more information, see |node-doc|: :ref:`Edit Interface Settings <editing-interface-settings>`.

You can save the interface configurations for a particular node to use as a
profile or template when setting up other nodes.
