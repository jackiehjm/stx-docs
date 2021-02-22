
.. kvs1552675659310
.. _interface-provisioning:

======================
Interface Provisioning
======================

Before you can unlock and use the additional controller, worker, or storage
nodes, you must configure their interfaces to attach them to networks.

Some interfaces require manual provisioning before the nodes can be unlocked.

.. _interface-provisioning-ul-ecp-4fk-lr:

-   For the second controller node, you must attach an interface to
    the |OAM| network, and to the cluster-host network if used, before you can
    unlock the node.

-   For a storage node, you must attach an interface to the cluster-host
    network before you can unlock the node.

-   For a worker node, you must attach an interface to the cluster-host
    network before you can unlock the node.

    .. note::
        For the |prod-os| OpenStack application and an openstack-compute
        labeled worker node, you must also attach at least one 'data' class
        data networks before you can unlock the node. The data networks must
        be set up beforehand. For more information,
        see :ref:`Interface Settings <interface-settings>`.

-   On a network that uses static addressing, you must assign an IP address
    to the interface. For more information,
    see :ref:`Interface IP Address Provisioning Using the CLI
    <interface-ip-address-provisioning-using-the-cli>`.

    .. code-block:: none

        ~(keystone_admin)$ system host-addr-add <node> <ifname> <ip_address> <prefix>

    where the following options can be used:

    **node**
        The name or UUID of the worker node.

    **ifname**
        The name of the interface.

    **ip\_address**
        An IPv4 or IPv6 address.

    **prefix**
        The netmask length for the address.

|prod| supports three types of interfaces:

**Ethernet interfaces**
    These are created automatically for each port on the host. You must
    configure Ethernet interfaces by specifying the interface class.

**Aggregated Ethernet interfaces**
    For link protection, you can create an aggregated Ethernet interface with
    two or more ports, and configure it with the interface class.

**VLAN interfaces**
    To support multiple interfaces on the same physical Ethernet or
    aggregated Ethernet interface, you can create |VLAN| interfaces and
    configure them with the interface class.

The procedure for attaching an interface depends on the interface type.

Logical interfaces of network types **oam** and **mgmt** cannot be deleted.
They can only be modified to use different physical ports when required.

.. xbooklink For more information on interfaces,
   see |planning-doc|: `Ethernet Interfaces <about-ethernet-interfaces>`.

.. note::
    On the second worker and storage nodes, the Ethernet interface for the
    internal management network is attached automatically to support
    installation using |PXE| booting. On the initial controller node, the
    interface for the internal management network is attached according to the
    settings specified during the Ansible bootstrapping of the system.
