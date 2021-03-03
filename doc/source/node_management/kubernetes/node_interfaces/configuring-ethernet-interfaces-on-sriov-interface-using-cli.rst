
.. gtw1612788763384
.. _configuring-ethernet-interfaces-on-sriov-interface-using-cli:

=================================================================
Configure Ethernet Interfaces on SR-IOV interface Using the CLI
=================================================================

You can create new ethernet interfaces on an SR-IOV interface and attach them
to platform networks using the CLI.

.. rubric:: |proc|

#.  Lock the host.

    .. code-block:: none

        ~(keystone_admin)$ system host-lock controller-0

    To list all interfaces, use the :command:`system host-if-list` command and
    include the :command:`-a` flag.

    For example:

    .. code-block:: none

        ~(keystone_admin)$ system host-if-list controller-0
        +-----------+----------+-----------+----------+------+---------------+-------------+--------------------------------+------------+
        | uuid      | name     | class     | type     | vlan | ports         | uses i/f    | used by i/f                    | attributes |
        |           |          |           |          | id   |               |             |                                |            |
        +-----------+----------+-----------+----------+------+---------------+-------------+--------------------------------+------------+
        | 0c4b1cc...| sriov00  | pci-sriov | vf       | None | []            | [u'sriov0'] | []                             | MTU=1500   |
        | 3a191c4...| oam0     | platform  | vlan     | 200  | []            | [u'sriov0'] | []                             | MTU=1500   |
        | b295ee9...| sriov01  | pci-sriov | vf       | None | []            | [u'sriov0'] | []                             | MTU=1500   |
        | c178445...| mgmt0    | platform  | vlan     | 157  | []            | [u'sriov0'] | []                             | MTU=1500   |
        | d71ed2f...| sriov0   | pci-sriov | ethernet | None | [u'enp3s0f0'] | []          | [u'cluster0', u'sriov00',      | MTU=1500   |
        |           |          |           |          |      |               |             | u'sriov01', u'mgmt0', u'oam0'] |            |
        |           |          |           |          |      |               |             |                                |            |
        | e7bd04f...| cluster0 | platform  | vlan     | 158  | []            | [u'sriov0'] | []                             | MTU=1500   |
        +-----------+----------+-----------+----------+------+---------------+-------------+--------------------------------+------------+
        

#.  Create an Ethernet interface.

    Use the :command:`host-if-add` command with the following options:

    .. code-block:: none

        ~(keystone_admin)$ system host-if-add <hostname> -c platform <interfacename> ethernet <ethname>

    Where:

    **interfacename**
        is the name or |UUID| for the interface \(Required\).

    **hostname**
        is the name or |UUID| of the host.

    **ethname**
        is the name of the |SRIOV| interface.

    For example:

    .. code-block:: none

        ~(keystone_admin)$ system host-if-add controller-0 -c platform pxeboot0 ethernet sriov0
        +-----------------+--------------------------------------+
        | Property        | Value                                |
        +-----------------+--------------------------------------+
        | ifname          | pxeboot0                             |
        | iftype          | ethernet                             |
        | ports           | []                                   |
        | imac            | 00:1e:67:e6:c0:92                    |
        | imtu            | 1500                                 |
        | ifclass         | platform                             |
        | ptp_role        | none                                 |
        | aemode          | None                                 |
        | schedpolicy     | None                                 |
        | txhashpolicy    | None                                 |
        | uuid            | 1a511695-3514-49fb-8f1d-4f9d88e26949 |
        | ihost_uuid      | bfaa02c2-61e8-4da8-beac-d5f3a93decef |
        | vlan_id         | None                                 |
        | uses            | [u'sriov0']                          |
        | used_by         | []                                   |
        | created_at      | 2021-02-18T11:17:21.482023+00:00     |
        | updated_at      | None                                 |
        | sriov_numvfs    | 0                                    |
        | sriov_vf_driver | None                                 |
        | max_tx_rate     | None                                 |
        | ipv4_mode       | None                                 |
        | ipv6_mode       | None                                 |
        | accelerated     | []                                   |
        +-----------------+--------------------------------------+

        ~(keystone_admin)$ system host-if-list controller-0
        +------------+----------+-----------+----------+------+---------------+-------------+---------------------------------+------------+
        | uuid     | name     | class     | type     | vlan | ports         | uses i/f    | used by i/f                     | attributes |
        |          |          |           |          | id   |               |             |                                 |            |
        +------------+----------+-----------+----------+------+---------------+-------------+---------------------------------+------------+
        | 0c4b1cc  | sriov00  | pci-sriov | vf       | None | []            | [u'sriov0'] | []                              | MTU=1500   |
        | 1a51169  | pxeboot0 | platform  | ethernet | None | []            | [u'sriov0'] | []                              | MTU=1500   |
        | 3a191c4  | oam0     | platform  | vlan     | 200  | []            | [u'sriov0'] | []                              | MTU=1500   |
        | b295ee9  | sriov01  | pci-sriov | vf       | None | []            | [u'sriov0'] | []                              | MTU=1500   |
        | c178445  | mgmt0    | platform  | vlan     | 157  | []            | [u'sriov0'] | []                              | MTU=1500   |
        | d71ed2f  | sriov0   | pci-sriov | ethernet | None | [u'enp3s0f0'] | []          | [u'cluster0', u'pxeboot0',      | MTU=1500   |
        |          |          |           |          |      |               |             | u'sriov00', u'sriov01', u'oam0' |            |
        |          |          |           |          |      |               |             | , u'mgmt0']                     |            |
        |          |          |           |          |      |               |             |                                 |            |
        | e7bd04f  | cluster0 | platform  | vlan     | 158  | []            | [u'sriov0'] | []                              | MTU=1500   |
        +------------+----------+-----------+----------+------+---------------+-------------+---------------------------------+------------+


#.  Attach the ethernet interface to a platform network.

    .. code-block:: none

        ~(keystone_admin)$ system interface-network-assign <hostname> <interface> <name> <network>

    For example:

    .. code-block:: none

        ~(keystone_admin)$ system interface-network-assign controller-0 pxeboot0 pxeboot

#.  Unlock the host.

    .. code-block:: none

        ~(keystone_admin)$ system host-unlock controller-0


