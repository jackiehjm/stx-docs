
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

    For example, to list all the interfaces on the system, use the
    :command:`system host-if-list` and include the ``-a`` flag:

    .. code-block:: none

        ~(keystone_admin)$ system host-if-list -a controller-1
        +-------------+-----------+-----------+----------+------+----------------+-------------+----------------------------+---------------------------+
        | uuid        | name      | class     | type     | vlan | ports          | uses i/f    | used by i/f                | attributes                |
        |             |           |           |          | id   |                |             |                            |                           |
        +-------------+-----------+-----------+----------+------+----------------+-------------+----------------------------+---------------------------+
        | 0aa20d82-...| sriovvf2  | pci-sriov | vf       | None | []             | [u'sriov0'] | []                         | MTU=1500,max_tx_rate=100  |
        | 0e5f162d-...| mgmt0     | platform  | vlan     | 163  | []             | [u'sriov0'] | []                         | MTU=1500                  |
        | 14f2ed53-...| sriov0    | pci-sriov | ethernet | None | [u'enp24s0f0'] | []          | [u'sriovnet1', u'oam0',    | MTU=9216                  |
        |             |           |           |          |      |                |             | u'sriovnet2', u'sriovvf2', |                           |
        |             |           |           |          |      |                |             | u'sriovvf1', u'mgmt0',     |                           |
        |             |           |           |          |      |                |             | u'pxeboot0']               |                           |
        |             |           |           |          |      |                |             |                            |                           |
        | 163592bd-...| data1     | data      | ethernet | None | [u'enp24s0f1'] | []          | []                         | MTU=1500,accelerated=True |
        | 1831571d-...| sriovnet2 | pci-sriov | vf       | None | []             | [u'sriov0'] | []                         | MTU=1956,max_tx_rate=100  |
        | 5741318f-...| eno2      | None      | ethernet | None | [u'eno2']      | []          | []                         | MTU=1500                  |
        | 5bd79fbd-...| enp26s0f0 | None      | ethernet | None | [u'enp26s0f0'] | []          | []                         | MTU=1500                  |
        | 623d5494-...| oam0      | platform  | vlan     | 103  | []             | [u'sriov0'] | []                         | MTU=1500                  |
        | 78b4080a-...| enp26s0f1 | None      | ethernet | None | [u'enp26s0f1'] | []          | []                         | MTU=1500                  |
        | a6f1f901-...| eno1      | None      | ethernet | None | [u'eno1']      | []          | []                         | MTU=1500                  |
        | f37eac1b-...| pxeboot0  | platform  | ethernet | None | []             | [u'sriov0'] | []                         | MTU=1500                  |
        | f7c62216-...| sriovnet1 | pci-sriov | vf       | None | []             | [u'sriov0'] | []                         | MTU=1500,max_tx_rate=100  |
        | fcbe3aca-...| sriovvf1  | pci-sriov | vf       | None | []             | [u'sriov0'] | []                         | MTU=1956,max_tx_rate=100  |
        +-------------+-----------+-----------+----------+------+----------------+-------------+----------------------------+---------------------------+

#.  Modify the interface and attach it to a network.

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
        (static or pool.)

    **ip6\_mode**
        The mode for assigning IPv6 addresses to a data interface
        (static or pool.)

    **addr_pool**
        The name of an IPv4 or IPv6 address pool, for use with the pool mode
        of IP address assignment for data interfaces.

    For valid values, see :ref:`Interface Settings <interface-settings>`.

    For example, to attach an interface named **enp0s3** to
    the |OAM| network, using Ethernet interface **enp0s3** on **controller-1**:

    #.  Lock the host:

        .. code-block:: none

            ~(keystone_admin)]$ system host-lock controller-1

    #.  To modify the interface enp0s3 class type from ``none`` to ``platform``,
        execute the following:

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

    #.  To assign enp0s3 interface to |OAM| network, execute the following:

        .. code-block:: none

            ~(keystone_admin)$ system interface-network-assign controller-1 enp0s3 oam

    #.  Unlock the host:

        .. code-block:: none

            ~(keystone_admin)$ system host-unlock controller-1