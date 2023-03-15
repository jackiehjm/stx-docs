
.. lyt1552673679804
.. _interfaces-tab:

==============
Interfaces Tab
==============

The **Interfaces** tab on the Host Detail page presents details about the
logical L2 network interfaces on a node.

The following example is for an unlocked controller node:

.. figure:: /node_management/kubernetes/figures/hxu1567097201027.png
    :scale: 100%

On a configured worker node, the Interfaces tab may include additional
logical interfaces, for example, if the cluster host network is internal
and additional ports are configured for connecting to external networks.

.. note::
    When running the |prod-os| application, you can optimize
    vSwitch processing of packets to and from physical ports for data
    interfaces by using only ports that are connected to processors with
    vSwitch cores attached to data networks.

Information about interfaces is presented in several columns, as follows:

**Name**
    The name given to the logical L2 interface.

**Interface Class**
    The class of the interface. The interface class that the logical network
    interface is connected to. The valid classes are, **platform**,
    **data**, **pci-sriov**, and **pci-passthrough**.

    -   platform, can be mgmt, cluster-host, oam, pxeboot, or storage.

        -   mgmt, for the internal management network

        -   cluster-host, for the Kubernetes cluster network

        -   oam, for the |OAM| network

        -   pxeboot, for the pxeboot platform network

        -   storage, for the optional Netapp Plugin


    -   data, for a worker node data interface

    -   pci-sriov, for a |PCI| |SRIOV| interface

    -   pci-passthrough, for a |PCI| passthrough interface

    -   pci-passthrough, pci-sriov, for an interface that can be used in
        either configuration (dual use)

**Type**
    Ethernet, or aggregated Ethernet (|LAG|).

**Vlan ID**
    If the network uses a shared interface, the |VLAN| ID of the network is
    listed in the **Interface Class** column.

**Port\(s)**
    The physical ports on top of which the logical interface is built.
    Multiple ports are displayed when the logical interface uses |LAG|.

**Uses**
    If the network uses a shared interface, the interface used by the network
    is listed in the **Interface Class** column. The |VLAN| ID of the network
    is shown in the **Vlan ID** field.

**Used By**
    The networks that share the interface using |VLAN| tagging, if the
    interface is shared.

**Data Networks**
    This option is relevant for the |prod-os| application only,
    and specifically for the openstack-compute labeled worker nodes only, and
    for interfaces of the data interface class. It lists the data networks
    associated with the data interface.

**Attributes**
    Details including the current |MTU| size for the interface and whether the
    interface is |DPDK|-accelerated.

**Actions**
    On a locked node, you can modify a logical interface, and execute
    management operations on it. This is implemented using the
    **Edit Interface** and **More** buttons. These buttons are not
    available when the node is unlocked.
