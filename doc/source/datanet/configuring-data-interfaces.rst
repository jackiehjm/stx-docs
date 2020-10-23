
.. lgk1559832444795
.. _configuring-data-interfaces:

=========================
Configure Data Interfaces
=========================

A **data** class interface attaches the host to a data network providing the
underlying network for OpenStack Neutron Tenant/Project Networks.

.. rubric:: |context|

.. See the following sections in |node-doc|:

.. _configuring-data-interfaces-ul-vvz-qst-wlb:

.. xreflink -   :ref:`Interface Provisioning <interface-provisioning>`

.. xreflink -   :ref:`Configuring Ethernet Interfaces <configuring-ethernet-interfaces-using-horizon>`

.. xreflink -   :ref:`Configuring Aggregated Interfaces <configuring-aggregated-ethernet-interfaces-using-horizon>`

.. xreflink -   :ref:`Configuring VLAN Interfaces <configuring-vlan-interfaces-using-the-cli>`

For each of the above procedures, configure the node interface specifying the
``ifclass`` as ``data`` and assign one or more data networks to the node
interface.

.. xreflink As an example for an Ethernet interface, repeat the procedure in
   |node-doc|: :ref:`Configuring Ethernet Interfaces
   <configuring-ethernet-interfaces-using-horizon>`.

.. rubric:: |proc|

.. _configuring-data-interfaces-steps-twz-gsh-lkb:

#.  List the attached interfaces.

    To list all interfaces, use the :command:`system host-if-list` command and
    include the -a flag.

    .. code-block:: none

        ~(keystone_admin)]$ system host-if-list -a controller-0
        +---...+----------+----------+...+---------------+...+-------------------+
        | uuid | name     | class    |   | ports         |   | data networks     |
        +---...+----------+----------+...+---------------+...+-------------------+
        | 68...| ens787f3 | None     |   | [u'ens787f3'] |   | []                |
        | 79...| data0    | data     |   | [u'ens787f0'] |   | [u'group0-data0'] |
        | 78...| cluster0 | platform |   | []            |   | []                |
        | 89...| ens513f3 | None     |   | [u'ens513f3'] |   | []                |
        | 97...| ens803f1 | None     |   | [u'ens803f1'] |   | []                |
        | d6...| pxeboot0 | platform |   | [u'eno2']     |   | []                |
        | d6...| mgmt0    | platform |   | []            |   | []                |
        +---...+----------+----------+...+---------------+...+-------------------+

#.  Attach an interface to a data network.

    Use a command sequence of the following form:

    .. code-block:: none

        ~(keystone_admin)]$ system host-if-modify -n <ifname> -m <mtu> -c <ifclass> <hostname> <ethname> [--ipv4-mode=ip4_mode [ipv4-pool addr_pool]] [--ipv6-mode=ip6_mode [ipv6-pool addr_pool]]
        ~(keystone_admin)]$ system interface-datanetwork-assign <hostname> <ifname> <data network>

    where the following options are available:

    **ifname**
        A name for the interface.

    **mtu**
        The MTU for the interface.

        .. note::
            The MTU must be equal to or larger than the MTU of the data network
            to which the interface is attached.

    **ifclass**
        The class of the interface. The valid classes are **platform**,
        **data**, **pci-sriov**, and **pci-passthrough**.

    **data network**
        The name or ID of the data network to assign the interface to.

    **hostname**
        The name or UUID of the host.

    **ethname**
        The name or UUID of the Ethernet interface to use.

    **ip4\_mode**
        The mode for assigning IPv4 addresses to a data interface \(static or
        pool.\)

    **ip6\_mode**
        The mode for assigning IPv6 addresses to a data interface \(static or
        pool.\)

    **addr\_pool**
        The name of an IPv4 or IPv6 address pool, for use with the pool mode
        of IP address assignment for data interfaces.

.. xreflink For valid values, see |node-doc|: :ref:`Interface
    Settings <interface-settings>`.

    The following example attaches an interface named **enp0s9** to a VLAN
    data network named **datanet-a**, using the Ethernet interface
    **enp0s9** on **worker-0**:

    .. code-block:: none

        ~(keystone_admin)]$ system host-if-modify -n enp0s9 -c data worker-0 enp0s9
        +-------------------+---------------------------------------+
        | Property          | Value                                 |
        +-------------------+---------------------------------------+
        | ifname            | enp0s3                                |
        | ifclass           | data                                  |
        | iftype            | ethernet                              |
        | ports             | [u'enp0s3']                           |
        | datanetworks      | datanet-a                             |
        | imac              | 08:00:27:66:38:c6                     |
        | imtu              | 1500                                  |
        | aemode            | None                                  |
        | schedpolicy       | None                                  |
        | txhashpolicy      | None                                  |
        | uuid              | 4ff97cc5-8e59-4763-9a85-c4be3996ddbe  |
        | ihost_uuid        | 327b2136-ffb6-4cd5-8fed-d2ec545302aa  |
        | vlan_id           | None                                  |
        | uses              | []                                    |
        | used_by           | []                                    |
        | created_at        | 2015-12-23T13:04:49.768322+00:00      |
        | updated_at        | 2015-12-23T16:16:19.540661+00:00      |
        | sriov_numvfs      | 0                                     |
        | ipv4_mode         | disabled                              |
        | ipv6_mode         | disabled                              |
        | accelerated       | [u'True']                             |
        +-------------------+---------------------------------------+
        ~(keystone_admin)]$ interface-datanetwork-assign controller-1 enp0s9 datanet-a