
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
'ifclass' as 'data' and assign one or more data networks to the node interface.

.. xreflink As an example for an Ethernet interface, repeat the procedure in
   |node-doc|: :ref:`Configuring Ethernet Interfaces
   <configuring-ethernet-interfaces-using-horizon>`.

.. rubric:: |proc|

.. _configuring-data-interfaces-steps-twz-gsh-lkb:

#.  List the attached interfaces.

    To list all interfaces, use the :command:`system host-if-list` command and
    include the ``-a`` flag.

    .. code-block:: none

        ~(keystone_admin)]$ system host-if-list -a controller-0
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

#.  Attach an interface to a network.

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
            The |MTU| must be equal to or larger than the |MTU| of the data network
            to which the interface is attached.

    **ifclass**
        The class of the interface. The valid classes are **platform**,
        **data**, **pci-sriov**, and **pci-passthrough**.

    **data network**
        The name or ID of the network to assign the interface to.

    **hostname**
        The name or |UUID| of the host.

    **ethname**
        The name or |UUID| of the Ethernet interface to use.

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