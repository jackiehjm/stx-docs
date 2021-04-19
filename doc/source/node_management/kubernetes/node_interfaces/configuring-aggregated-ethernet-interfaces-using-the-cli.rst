
.. bcr1473342191677
.. _configuring-aggregated-ethernet-interfaces-using-the-cli:

======================================================
Configure Aggregated Ethernet Interfaces Using the CLI
======================================================

You can use the CLI to attach aggregated
Ethernet interfaces to networks.

|prod| supports up to four ports in a |LAG|.

.. only:: partner

    ../../../_includes/configuring-aggregated-ethernet-interfaces-using-the-cli.rest

For more about link aggregation modes and policies, see :ref:`Link Aggregation
Settings <link-aggregation-settings>`.

.. rubric:: |proc|

.. _configuring-aggregated-ethernet-interfaces-using-the-cli-steps-exz-hvh-lkb:

#.  List the attached interfaces.

    To list all interfaces, use the :command:`system host-if-list` command
    and include the ``-a`` flag.

    .. code-block:: none

        ~(keystone_admin)$ system host-if-list -a controller-0
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

#.  Create an aggregated Ethernet interface and attach it to a network.

    Use a command of the following form:

    .. code-block:: none

        ~(keystone_admin)$ system host-if-add <hostname> -m <mtu>  -a <aemode> -x <txhashpolicy> --primary-reselect <reselect_option> <ifname> ae <ethname1> <ethname2>

    where the following options are available:

    **ifname**
        A name for the interface.

        .. caution::
            To avoid potential internal inconsistencies, do not use upper
            case characters when creating interface names. Some components
            normalize all interface names to lower case.

    **mtu**
        The |MTU| for the interface.

        .. note::
            For a data interface, the |MTU| must be equal to or larger than the
            |MTU| of the provider network to which the interface is attached.

    **aemode**
        The link aggregation mode. For information on valid values, see :ref:`Link Aggregation Settings <link-aggregation-settings>`.

    **policy**
        The balanced tx distribution hash policy. For information on valid values, see :ref:`Link Aggregation Settings <link-aggregation-settings>`.

    **reselect_option**
        The parameter that specifies the reselection policy for the primary
        slave of an aggregated ethernet active standby interface. For
        information on valid values, see :ref:`Link Aggregation Settings
        <link-aggregation-settings>`.

    **hostname**
        The name or UUID of the host.

    **datanetworks**
        A list of data networks, delimited by quotes and separated by commas;
        for example, "net-a, net-b". To specify a single data network, omit
        the quotes. This parameter is required only if the networktype is set
        to data, pci-sriov or pci-passhtru.

        .. note::
            For networks other than data networks, the value **none** is
            required.

    **ethname1, ethname2**
        The names or UUIDs of the member interfaces.

    For example, to attach an aggregated Ethernet interface named **ae0** to
    data networks **net-a** and **net-b**, using member interfaces **enp0s9**
    and **enp0s10** on **controller-0**:

    .. code-block:: none

        ~(keystone_admin)$ system host-if-add controller-0 -a balanced -x layer2 ae0 ae enp0s9 enp0s10
        ~(keystone_admin)$ system interface-datanetwork-assign controller-0 ae0 providernet-net-a
        ~(keystone_admin)$ system interface-datanetwork-assign controller-0 ae0 providernet-net-b

    For example, to attach an aggregated Ethernet interface named **bond0** to
    the platform management network, using member interfaces **enp0s8**
    and **enp0s11** on **controller-0**:

    .. code-block:: none

        ~(keystone_admin)$ system host-if-add controller-0 -c platform -a active_standby --primary-reselect failure bond0 ae enp0s8 enp0s11
        ~(keystone_admin)$ system interface-network-assign controller-0 bond0 mgmt


.. only:: partner

    ../../../_includes/configuring-aggregated-ethernet-interfaces-using-the-cli.rest
