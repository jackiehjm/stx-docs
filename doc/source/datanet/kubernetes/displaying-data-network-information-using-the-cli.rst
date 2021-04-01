
.. anh1559818482640
.. _displaying-data-network-information-using-the-cli:

==============================================
Display Data Network Information Using the CLI
==============================================

You can display information about data networks from the CLI.

.. rubric:: |proc|

.. _displaying-data-network-information-using-the-cli-steps-zln-xky-hkb:

#.  Retrieve the names of the data networks.

    .. code-block:: none

        ~(keystone_admin)$ system datanetwork-list
        +--------------------------------------+--------------+----------+------+
        | uuid                                 | name         | network_ | mtu  |
        |                                      |              | type     |      |
        +--------------------------------------+--------------+----------+------+
        | 3a575af8-01a7-44ca-9519-edaa2f06c74b | group0-data0 | vlan     | 1500 |
        +--------------------------------------+--------------+----------+------+

#.  Review information for a data network from the CLI.

    .. code-block:: none

        ~(keystone_admin)$ system datanetwork-show <datanet>

    Where <datanet> is the name or UUID of the data network.

    For example:

    .. code-block:: none

        ~(keystone_admin)$ system datanetwork-show group0-data0