
.. lnl1559819027423
.. _removing-a-data-network-using-the-cli:

===================================
Remove a Data Network Using the CLI
===================================

Before you can delete a data network, you must remove any interface
associations.

.. rubric:: |context|

Complete the following steps to delete a data interface.

.. rubric:: |prereq|

The following procedure requires that the host be locked.

.. rubric:: |proc|

#.  Remove the data network from the interface.

    #.  Identify the interface to be removed.

        For example:

        .. code-block:: none

            ~(keystone_admin)$ system interface-datanetwork-list controller-1
            +--------------+--------------------------------------+--------+------------------+
            | hostname     | uuid                                 | ifname | datanetwork_name |
            +--------------+--------------------------------------+--------+------------------+
            | controller-1 | 212d5afc-e417-49fe-919a-d94e9b46c236 | sriov0 | group0-data0     |
            | controller-1 | 6c2f7066-3889-4291-8928-5fb4b2bccfee | data0  | group0-data0     |
            | controller-1 | c4ac3c62-283e-491f-a08b-2e4a5ece205c | pthru0 | group0-data0     |
            +--------------+--------------------------------------+--------+------------------+

    #.  Remove the network.

        For example:

        .. code-block:: none

            ~(keystone_admin)$ system interface-datanetwork-remove c4ac3c62-283e-491f-a08b-2e4a5ece205c
            Deleted Interface DataNetwork: c4ac3c62-283e-491f-a08b-2e4a5ece205c

#.  Delete the data network from the system.

    .. code-block:: none

        ~[keystone_admin]$ system datanetwork-delete <datanetworkUUID>

    where <datanetworkUUID> is the UUID of the data network.