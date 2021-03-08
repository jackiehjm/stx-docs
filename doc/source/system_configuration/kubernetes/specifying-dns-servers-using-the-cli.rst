
.. ocy1552673225265
.. _specifying-dns-servers-using-the-cli:

=================================
Specify DNS Servers Using the CLI
=================================

You can use the CLI to add or update up to three DNS servers.

To view the existing DNS server configuration, use the following command:

.. code-block:: none

    ~(keystone_admin)]$ system dns-show
    +--------------+--------------------------------------+
    | Property     | Value                                |
    +--------------+--------------------------------------+
    | uuid         | cffcde8c-2124-4d19-881f-764ddafc8558 |
    | nameservers  | 8.8.8.8                              |
    | isystem_uuid | e1f955a1-2dee-492e-8c72-8b88a8b08558 |
    | created_at   | 2017-06-23T00:34:38.353023+00:00     |
    | updated_at   | 2017-06-24T20:52:13.307660+00:00     |
    +--------------+--------------------------------------+

To change the list of DNS servers, use the following command syntax. The
nameservers option takes a comma-delimited list of IP addresses.

.. code-block:: none

    ~(keystone_admin)]$ system dns-modify nameservers=<IP_address_1[,IP_address_2][,IP_address_3]>

For example:

.. code-block:: none

    ~(keystone_admin)]$ system dns-modify nameservers=8.8.8.8,8.8.4.4
