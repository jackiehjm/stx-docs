
.. khl1551798962540
.. _attaching-ethernet-interfaces-to-networks-using-the-cli:

====================================================
Attach Ethernet Interfaces to Networks Using the CLI
====================================================

You can use the CLI to attach Ethernet
interfaces to networks.

Ethernet interfaces are created automatically.

.. rubric:: |proc|

.. _attaching-ethernet-interfaces-to-networks-using-the-cli-steps-twz-gsh-lkb:

#.  List the attached interfaces.

    To list all interfaces, use the :command:`system host-if-list` command
    and include the ``-a`` flag.

    .. code-block:: none

        ~(keystone_admin)$ system host-if-list -a controller-0
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

#.  Attach an interface to a network.

    Use a command sequence of the following form:

    .. code-block:: none

        ~(keystone_admin)$ system host-if-modify -n <ifname> -m <mtu> -c <ifclass> <hostname> <ethname> [--ipv4-mode=ip4_mode [ipv4-pool addr_pool]] [--ipv6-mode=ip6_mode [ipv6-pool addr_pool]]
        ~(keystone_admin)$ system interface-network-assign <hostname> <ifname> <network>

    where the following options are available:

    **ifname**
        A name for the interface.

    **mtu**
        The |MTU| for the interface.

    **ifclass**
        The class of the interface. The valid classes are **platform**,
        **data**, **pci-sriov**, and **pci-passthrough**.

    **network**
        The name or ID of the network to assign the interface to.

    **hostname**
        The name or UUID of the host.

    **ethname**
        The name or UUID of the Ethernet interface to use.

    **ip4\_mode**
        The mode for assigning IPv4 addresses to a data interface
        \(static or pool.\)

    **ip6\_mode**
        The mode for assigning IPv6 addresses to a data interface
        \(static or pool.\)

    **addr\_pool**
        The name of an IPv4 or IPv6 address pool, for use with the pool mode
        of IP address assignment for data interfaces.

    For valid values, see :ref:`Interface Settings <interface-settings>`.

    For example, to attach an interface named **enp0s3** to
    the |OAM| network, using Ethernet interface **enp0s3** on **controller-1**:

    .. code-block:: none

        ~(keystone_admin)$ system host-if-modify -n enp0s3 -c platform controller-1 enp0s3
        +-------------------+---------------------------------------+
        | Property          | Value                                 |
        +-------------------+---------------------------------------+
        | ifname            | enp0s3                                |
        | ifclass           | platform                              |
        | iftype            | ethernet                              |
        | ports             | [u'enp0s3']                           |
        | providernetworks  | None                                  |
        | imac              | 08:00:27:58:0c:e5                     |
        | imtu              | 1500                                  |
        | aemode            | None                                  |
        | schedpolicy       | None                                  |
        | txhashpolicy      | None                                  |
        | uuid              | 14300770-13bf-48fd-b9af-756ec7d8adc1  |
        | ihost_uuid        | e1c47086-3230-4b92-91d0-208c55130a52  |
        | vlan_id           | None                                  |
        | uses              | []                                    |
        | used_by           | []                                    |
        | created_at        | 2015-12-10T14:24:25.967362+00:00      |
        | updated_at        | 2015-12-10T17:01:08.761323+00:00      |
        | sriov_numvfs      | 0                                     |
        | accelerated       | [u'True']                             |
        +-------------------+---------------------------------------+
        ~(keystone_admin)$ interface-network-assign controller-1 enp0s3 oam
