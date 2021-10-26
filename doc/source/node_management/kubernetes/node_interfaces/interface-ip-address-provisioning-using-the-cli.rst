
.. zto1559767850528
.. _interface-ip-address-provisioning-using-the-cli:

===============================================
Interface IP Address Provisioning Using the CLI
===============================================

On a network that uses static addressing, you must assign an IP address to
the interface using the :command:`system host-addr-add` command.

The procedure for adding an IP address depends on the interface type.

|prod| supports the following types of interfaces:

**Ethernet interfaces**
    These are created automatically for each port on the host. You must
    configure Ethernet interfaces by specifying the interface class.

**Aggregated Ethernet interfaces**
    For link protection, you can create an aggregated Ethernet interface with
    two or more ports, and configure it with the interface class.

    .. code-block:: none

        ~(keystone_admin)$ system host-if-add <hostname> -m mtu -a aemode -x txhashpolicy ifname ae <ethname1> <ethname2>

**VLAN interfaces**
    To support multiple interfaces on the same physical Ethernet or
    aggregated Ethernet interface, you can create |VLAN| interfaces and
    configure them with the interface class.

    .. code-block:: none

        ~(keystone_admin)$ systemhost-if-add <hostname> -V --vlan_id -c --ifclass <interfacename> <ethname>

**Virtual Function interfaces**
    You can create an |SRIOV| |VF| interface on top of an existing |SRIOV| |VF|
    interface in order to configure a subset of virtual functions with
    different drivers. For example, if the ethernet |SRIOV| interface is
    configured with the kernel VF driver, you can create a |VF| interface to
    configure a subset of virtual functions with the vfio driver that can be
    used with userspace libraries such as |DPDK|.

    .. code-block:: none

        ~(keystone_admin)$ system host-if-add -c pci-sriov <hostname> <interfacename> vf <parentinterfacename> -N numvfs --vf-driver=drivername


Logical interfaces of network types **oam** and **mgmt** cannot be deleted.
They can only be modified to use different physical ports when required.

.. xbooklink For more information on interfaces,
   .. see |planning-doc|: `Ethernet Interfaces <about-ethernet-interfaces>`.

.. note::
    On the second worker and storage nodes, the Ethernet interface for the
    internal management network is attached automatically to support
    installation using |PXE| booting.
    
    On the initial controller node, the interface for the internal management
    network is attached according to the settings specified during the
    Ansible bootstrapping of the system.

.. rubric:: |proc|

.. _interface-ip-address-provisioning-using-the-cli-steps-ovd-413-lkb:

#.  Lock the node.

#.  Add the IP address to the interface using
    the :command:`system host-addr-add` command.

    .. code-block:: none

        ~(keystone_admin)$ system host-addr-add <node> <ifname> <ip_address> <prefix>

    where the following options are available:

    ``node``
        The name or |UUID| of the worker node.

    ``ifname``
        The name of the interface.

    ``ip_address``
        An IPv4 or IPv6 address.

    ``prefix``
        The netmask length for the address.

#.  Unlock the node and wait for it to become available.
