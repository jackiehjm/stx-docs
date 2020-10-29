
.. xti1552680491532
.. _adding-an-snmp-community-string-using-the-cli:

==========================================
Add an SNMP Community String Using the CLI
==========================================

To enable SNMP services you need to define one or more SNMP community strings
using the command line interface.

.. rubric:: |context|

No default community strings are defined on |prod| after the initial
commissioning of the cluster. This means that no SNMP operations are enabled
by default.

The following exercise illustrates the system commands available to manage and
query SNMP community strings. It uses the string **commstr1** as an example.

.. caution::
    For security, do not use the string **public**, or other community strings
    that could easily be guessed.

.. rubric:: |prereq|

All commands must be executed on the active controller's console, which can be
accessed using the OAM floating IP address. You must acquire Keystone **admin**
credentials in order to execute the commands.

.. rubric:: |proc|

#.  Add the SNMP community string commstr1 to the system.

    .. code-block:: none

        ~(keystone_admin)$ system snmp-comm-add -c commstr1
        +-----------+--------------------------------------+
        | Property  | Value                                |
        +-----------+--------------------------------------+
        | access    | ro                                   |
        | uuid      | eccf5729-e400-4305-82e2-bdf344eb868d |
        | community | commstr1                             |
        | view      | .1                                   |
        +-----------+--------------------------------------+


    The following are attributes associated with the new community string:

    **access**
        The SNMP access type. In |prod| all community strings provide read-only
        access.

    **uuid**
        The UUID associated with the community string.

    **community**
        The community string value.

    **view**
        The is always the full MIB tree.

#.  List available community strings.

    .. code-block:: none

        ~(keystone_admin)$ system snmp-comm-list
        +----------------+--------------------+--------+
        | SNMP community | View               | Access |
        +----------------+--------------------+--------+
        | commstr1       | .1                 | ro     |
        +----------------+--------------------+--------+

#.  Query details of a specific community string.

    .. code-block:: none

        ~(keystone_admin)$ system snmp-comm-show commstr1
        +------------+--------------------------------------+
        | Property   | Value                                |
        +------------+--------------------------------------+
        | access     | ro                                   |
        | created_at | 2014-08-14T21:12:10.037637+00:00     |
        | uuid       | eccf5729-e400-4305-82e2-bdf344eb868d |
        | community  | commstr1                             |
        | view       | .1                                   |
        +------------+--------------------------------------+

#.  Delete a community string.

    .. code-block:: none

        ~(keystone_admin)$ system snmp-comm-delete commstr1
        Deleted community commstr1

.. rubric:: |result|

Community strings in |prod| provide query access to any SNMP monitor
workstation that can reach the controller's OAM address on UDP port 161.

You can verify SNMP access using any monitor tool. For example, the freely
available command :command:`snmpwalk` can be issued from any host to list
the state of all SNMP Object Identifiers \(OID\):

.. code-block:: none

    $ snmpwalk -v 2c -c commstr1 10.10.10.100 > oids.txt

In this example, 10.10.10.100 is the |prod| OAM floating IP address. The output,
which is a large file, is redirected to the file oids.txt.

