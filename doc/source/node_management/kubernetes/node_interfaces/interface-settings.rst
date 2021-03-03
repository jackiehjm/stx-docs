
.. gal1551794954359
.. _interface-settings:

==================
Interface Settings
==================

The settings for creating or editing an interface on a node depend on the
type of interface class to which the interface is connected \(for example,
**platform**, **pci-sriov**, **pci-passthrough** or **data**\), as well as
the type of interface \(for example, **aggregated ethernet** or **vlan**\).

These settings are available on the **Edit Interface** and
**Create Interface** dialogs for a host, accessible from the
**Interfaces** tab of the Host Inventory page of the Horizon Web interface.

.. _interface-settings-interface-settings:

**Interface Name**
    A name used to identify the interface.

    .. caution::
        To avoid potential internal inconsistencies, do not use upper case
        characters when creating interface names. Some components normalize
        all interface names to lower case.

**Interface Class**
    The class of the interface. The valid classes are **platform**, **data**,
    **pci-sriov**, and **pci-passthrough**.

**mgmt**
    Attaches the interface to the internal management network.

    When a worker or storage node is added to |prod|, the interface used for
    |PXE| boot is assigned
    automatically to the internal management network. In the settings for
    this interface, **mgmt** is already selected. For other interfaces,
    this selection is not used.

**pxeboot**
    pxeboot platform network type

**cluster-host**
    Attaches the interface to the Kubernetes cluster network.

**oam**
    Attaches the interface to the |OAM| network.

    The |OAM| network is used by controller
    nodes for administrator remote access. It is not applicable to worker
    or storage nodes.

**Platform**
    A platform network that can be associated with a 'platform' class,
    including:

    -   Mgmt

    -   Pxeboot

    -   Cluster-host

    -   Oam

    -   Storage \(optional\)


    .. note::
        A **platform** class interface can also be used as an interface to an
        external network. In this case, no platform network would be
        associated with the **platform** class interface.

**data**
    This interface class is only applicable when running the |prod-os|
    OpenStack application. In general, it attaches the interface to an
    additional network for external connectivity.

    A data interface class attaches the interface to a data network providing
    the underlying network for OpenStack Neutron Tenant Networks.

**pci-passthrough**
    Provides for a direct connection to physical interface hardware connected
    to a data network\(s\). A single application \(i.e. a container or in the
    case of the Managed OpenStack application, a hosted application\) can
    directly access the physical interface.

**pci-sriov**
    Allows a direct connection to a virtual unit of physical interface
    hardware connected to a data network\(s\). Multiple applications
    \(containers, or in the case of Managed OpenStack application, hosted
    applications\) can directly access and share the same physical interface.
    For more information,
    see :ref:`Provision SR-IOV Interfaces using the CLI <provisioning-sr-iov-interfaces-using-the-cli>`.

**none**
    Clears the Interface Class setting.

**Interface Type**
    The type of interface \(Ethernet, aggregated Ethernet, or |VLAN|\).

**Aggregated Ethernet - Mode**
    \(Shown only when the **Interface Type** is set to
    **aggregated ethernet**\). The operational mode for link aggregation.

**Aggregated Ethernet - Tx Policy**
    \(Shown only when the **Aggregated Ethernet - Mode** is set to
    **balanced** or **802.3ad**\). The transmit policy for link aggregation.

**Vlan ID**
    \(Shown only when the **Interface Type** is set to **vlan**\) A unique
    |VLAN| identifier for the network.

**Port\(s\)**
    The physical port or ports used for the interface.

**Data Networks**
    \(Shown only when the **Interface Class** is set to **data**,
    **pci-passthrough**, or **pci-sriov**\). To attach the interface to a
    data network, select the desired data network.

**MTU**
    The maximum transmission unit for the interface.

    For a |prod-os| application data interface attached to a data
    network, this must be equal to or larger than the |MTU| of the data network
    to which the interface is attached.

.. xbooklink    For more information about |MTU|
    configuration, see |planning-doc|: `The Ethernet MTU <the-ethernet-mtu>`.

    .. note::
        You cannot change the |MTU| for an cluster-host interface. The value
        from the network resource is always used.

**IPv4 Addressing Mode**
    \(Shown only when the **Interface Class** is set to **data**\). The
    method for assigning an IP address to the interface.

    **Disabled**
        Do not assign an IPv4 address.

    **Static**
        Use a static IPv4 address.

    **Pool**
        Use an address from a pool of IPv4 addresses that has been defined
        and associated with the data interface.

**IPv4 Addressing Mode**
    \(Shown only when the **IPv4 Addressing Mode** is set to **pool**\). The
    pool from which to assign an IPv4 address.

**IPv6 Addressing Mode**
    \(Shown only when the **Interface Class** is set to **data**\). The
    method for assigning an IP address to the interface for use with |VXLAN|
    networks.

    .. note::
        For the |prod-os| application this is used for the IPv6
        Address of |VXLAN| tunnel endpoints for use with |VXLAN| data networks.

    **Disabled**
        Do not assign an IPv6 address.

    **Static**
        Use a static IPv6 address.

    **Pool**
        Use an address from a pool of IPv6 addresses that has been defined
        and associated with the data interface.

    **Automatic Assignment**
        Use an automatically assigned IPv6 address.

    **Link Local**
        Use a link local IPv6 address.

**IPv6 Address Pool**
    \(Shown only when the **IPv6 Addressing Mode** is set to **pool**\) The
    pool from which to assign an IPv6 address.

**Virtual Functions**
    \(Shown only when the **Interface Class** is set to **pci-sriov**\) The
    number of virtual interfaces to use.

**Maximum Virtual Functions**
    \(Shown only when the **Interface Class** is set to **pci-sriov**\)

    The maximum number of virtual interfaces available.
