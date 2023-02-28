
.. wsr1614111675912
.. _configuring-vlan-type-interfaces-using-the-sriov-interface-from-the-cli:

========================================================================
Configure VLAN Type Interfaces Using the SR-IOV Interface From the CLI
========================================================================

You can use the CLI to attach |VLAN| interfaces to networks.

.. rubric:: |context|

.. rubric:: |prereq|

You must create an |SRIOV| interface before you can provision a vlan interface.
For more information, see :ref:`Provisioning SR-IOV VF Interfaces using the CLI
<provisioning-sr-iov-vf-interfaces-using-the-cli>`.

.. rubric:: |proc|

.. _configuring-vlan-type-interfaces-using-the-sriov-interface-from-the-cli-steps-rf5-5wh-lkb:

#.  Lock the host.

    .. code-block:: none

        ~(keystone_admin)$ host-lock controller-0

#.  List the attached interfaces.

    To list all interfaces, use the :command:`system host-if-list` command and
    include the ``-a`` flag.

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

#.  Create a |VLAN| interface.

    Use a command of the following form:

    .. code-block:: none

        ~(keystone_admin)$ system host-if-add <hostname> -V <vlan_id> \
        -c <--ifclass> <interface name> <sriov_intf_name> [<datanetwork>]


    where the following options are available:

    **interface name**
        A name or |UUID| for the interface (Required).

        .. caution::
            To avoid potential internal inconsistencies, do not use upper case
            characters when creating interface names. Some components normalize
            all interface names to lower case.

    **vlan_id**
        The |VLAN| identifier for the network.

    **hostname**
        The name or |UUID| of the host.

    **ifclass**
        The class of the interface. The valid classes are **platform**,
        **data**, **pci-sriov**, and **pci-passthrough**.

    **sriov_intf_name**
        The name of the |SRIOV| interface.

    **datanetworks**
        A list of data networks, delimited by quotes and separated by commas;
        for example, "net-a, net-b". To specify a single data network, omit the
        quotes. This parameter is required only if the <networktype> is set to
        data,pci-sriov or pci-passthru.

    **network**
        The name or ID of the network to assign the interface to

    For example, to attach a |VLAN| interface named cluster0 with |VLAN| ID 164 to
    the cluster-host network using |SRIOV| interface sriov0 on controller-0:

    .. code-block:: none

        ~(keystone_admin)$ system host-if-add controller-0 -V 164 -c platform cluster0 vlan sriov0
        +-----------------+--------------------------------------+
        | Property        | Value                                |
        +-----------------+--------------------------------------+
        | ifname          | cluster0                             |
        | iftype          | vlan                                 |
        | ports           | []                                   |
        | imac            | 3c:fd:fe:ac:60:44                    |
        | imtu            | 1500                                 |
        | ifclass         | platform                             |
        | ptp_role        | none                                 |
        | aemode          | None                                 |
        | schedpolicy     | None                                 |
        | txhashpolicy    | None                                 |
        | uuid            | 6fa5015f-bcd3-4059-8fc1-9cdbbbe31d39 |
        | ihost_uuid      | 1b67fe83-5010-4eac-bcca-6a6e6f2bd197 |
        | vlan_id         | 164                                  |
        | uses            | [u'sriov0']                          |
        | used_by         | []                                   |
        | created_at      | 2021-02-24T15:04:48.116079+00:00     |
        | updated_at      | None                                 |
        | sriov_numvfs    | 0                                    |
        | sriov_vf_driver | None                                 |
        | max_tx_rate     | None                                 |
        | ipv4_mode       | None                                 |
        | ipv6_mode       | None                                 |
        | accelerated     | [True]                               |
        +-----------------+--------------------------------------+

#.  Attach the newly created |VLAN| interface to a network.

    Use a command of the following format:

    .. code-block:: none

        ~(keystone_admin)$ system interface-network-assign <hostname> <interface name> <network>

    For example:

    .. code-block:: none

        ~(keystone_admin)$ system interface-network-assign controller-0 cluster0 cluster-host

#.  Unlock the host.

    .. code-block:: none

        ~(keystone_admin)$ host-unlock controller-0


