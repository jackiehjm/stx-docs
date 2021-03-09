
.. lla1552670572043
.. _internal-management-network-planning:

===============================================
Kubernetes Internal Management Network Planning
===============================================

The internal management network is a private network, visible only to the hosts
in the cluster.

.. note::
    This network is not used with |prod| Simplex systems.

You must consider the following guidelines:

.. _internal-management-network-planning-ul-gqd-gj2-4n:

-   The internal management network is used for |PXE| booting of new hosts, and
    must be untagged. It is limited to IPv4, because the |prod| installer does
    not support IPv6 |PXE| booting. For example, if the internal management
    network needs to be on a |VLAN|-tagged network for deployment reasons, or
    if it must support IPv6, you can configure the optional untagged |PXE| boot
    network for |PXE| booting of new hosts using IPv4.

-   You can use any 1 GB or 10 GB interface on the hosts to connect to this
    network, provided that the interface supports network booting and can be
    configured from the BIOS as the primary boot device.

-   If static IP address assignment is used, you must use the :command:`system
    host-add` command to add new hosts, and to assign IP addresses manually. In
    this mode, new hosts are *not* automatically added to the inventory when
    they are powered on, and they display the following message on the host
    console:

    .. code-block:: none

        This system has been configured with static management
        and infrastructure IP address allocation. This requires
        that the node be manually provisioned in System
        Inventory using the 'system host-add' CLI, GUI, or
        stx API equivalent.

-   For the IPv4 address plan, use a private IPv4 subnet as specified in RFC
    1918. This helps prevent unwanted cross-network traffic on this network.

    It is suggested that you use the default subnet and addresses provided by
    the controller configuration script.

-   You can assign a range of addresses on the management subnet for use by the
    |prod|. If you do not assign a range, |prod| takes ownership of all
    available addresses.

-   On systems with two controllers, they use IP multicast messaging on the
    internal management network. To prevent loss of controller synchronization,
    ensure that the switches and other devices on these networks are configured
    with appropriate settings.

.. only:: partner

   .. include:: ../../_includes/subnet-sizing-restrictions.rest