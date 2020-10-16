
.. bcr1473342191677
.. _configuring-aggregated-ethernet-interfaces-using-the-cli:

======================================================
Configure Aggregated Ethernet Interfaces Using the CLI
======================================================

You can use the CLI to attach aggregated
Ethernet interfaces to networks.

|prod| supports up to four ports in a |LAG|.

.. note::
    You must use |AVS| accelerated
    data interfaces to use |LACP|
    or active/standby mode on a data interface attached to a data network
    when running the |prod-os| application with
    the |prod| |AVS| vSwitch. For
    non-accelerated data interfaces, only load-balanced mode is supported.

For more about link aggregation modes and policies,
see :ref:`Link Aggregation Settings <link-aggregation-settings>`.

.. rubric:: |proc|

.. _configuring-aggregated-ethernet-interfaces-using-the-cli-steps-exz-hvh-lkb:

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

#.  Create an aggregated Ethernet interface and attach it to a network.

    Use a command of the following form:

    .. code-block:: none

        ~(keystone_admin)$ system host-if-add <hostname> -m <mtu>  -a <aemode> -x <txhashpolicy> <ifname> ae <ethname1> <ethname2>

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
        The link aggregation mode.

    **policy**
        The balanced tx distribution hash policy.

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
