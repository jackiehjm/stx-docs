
.. ecd1551800000867
.. _configuring-vlan-interfaces-using-the-cli:

=======================================
Configure VLAN Interfaces Using the CLI
=======================================

You can use the CLI to attach |VLAN| interfaces to networks.

.. rubric:: |proc|

.. _configuring-vlan-interfaces-using-the-cli-steps-rf5-5wh-lkb:

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


#.  Create a |VLAN| interface.

    Use a command of the following form:

    .. code-block:: none

        ~(keystone_admin)$ system host-if-add <hostname> -V <--vlan_id> -c <--ifclass> <interface name> <ethname> [<datanetwork>]

    where the following options are available:

    **interface name**
        A name or UUID for the interface \(Required\).

        .. caution::
            To avoid potential internal inconsistencies, do not use upper
            case characters when creating interface names. Some components
            normalize all interface names to lower case.

    **vlan\_id**
        The |VLAN| identifier for the network.

    **hostname**
        The name or UUID of the host.

    **ifclass**
        The class of the interface. The valid classes are **platform**,
        **data**, **pci-sriov**, and **pci-passthrough**.

    **ethname**
        The name or UUID of the Ethernet interface to use.

    **datanetworks**
        A list of data networks, delimited by quotes and separated by commas;
        for example, "net-a, net-b". To specify a single data network,
        omit the quotes. This parameter is required only if the <networktype>
        is set to data,pci-sriov or pci-passthru.

    **network**
        The name or ID of the network to assign the interface to

    For example, to attach a |VLAN| interface named **clusterhost0** with
    |VLAN| ID **22** to the cluster-host network using Ethernet interface
    **enp0s8** on **storage-0**:

    .. code-block:: none

        ~(keystone_admin)$ system host-if-add storage-0 -V 22 -c platform clusterhost0 vlan enp0s8
        +------------------+----------------------------------------+
        | Property         | Value                                  |
        +------------------+----------------------------------------+
        | ifname           | clusterhost0                           |
        | ifclass          | platform                               |
        | iftype           | vlan                                   |
        | ports            | []                                     |
        | providernetworks | None                                   |
        | imac             | 08:00:27:f2:0d:68                      |
        | imtu             | 1500                                   |
        | aemode           | None                                   |
        | schedpolicy      | None                                   |
        | txhashpolicy     | None                                   |
        | uuid             | 8ca9854e-a18e-4a3c-8afe-f050da702fdf   |
        | ihost_uuid       | 3d207384-7d30-4bc0-affe-d68ab6a00a5b   |
        | vlan_id          | 22                                     |
        | uses             | [u'enp0s8']                            |
        | used_by          | []                                     |
        | created_at       | 2015-02-04T16:23:28.917084+00:00       |
        | updated_at       | None                                   |
        +------------------+----------------------------------------+

#.  Attach the newly created |VLAN| interface to a network.

    Use a command of the following format:

    .. code-block:: none

        ~(keystone_admin)$ system interface-network-assign <hostname> <interface name> <network>

    For example:

    .. code-block:: none

        ~(keystone_admin)$ system interface-network-assign storage-0 clusterhost0 cluster-host
