
.. sjb1552680530874
.. _configuring-snmp-trap-destinations:

================================
Configure SNMP Trap Destinations
================================

:abbr:`SNMP (Simple Network Management Protocol)` trap destinations are hosts
configured in |prod| to receive unsolicited SNMP notifications.

.. rubric:: |context|

Destination hosts are specified by IP address, or by host name if it can be
properly resolved by |prod|. Notifications are sent to the hosts using a
designated community string so that they can be validated.

.. rubric:: |proc|

#.  Configure IP address 10.10.10.1 to receive SNMP notifications using the
    community string commstr1.

    .. code-block:: none

        ~(keystone_admin)$ system snmp-trapdest-add -c commstr1 --ip_address 10.10.10.1
        +------------+--------------------------------------+
        | Property   | Value                                |
        +------------+--------------------------------------+
        | uuid       | c7b6774e-7f45-40f5-bcca-3668de2a186f |
        | ip_address | 10.10.10.1                           |
        | community  | commstr1                             |
        | type       | snmpv2c_trap                         |
        | port       | 162                                  |
        | transport  | udp                                  |
        +------------+--------------------------------------+

    The following are attributes associated with the new community string:

    **uuid**
        The UUID associated with the trap destination object.

    **ip\_address**
        The trap destination IP address.

    **community**
        The community string value to be associated with the notifications.

    **type**
        snmpv2c\_trap, the only supported message type for SNMP traps.

    **port**
        The destination UDP port that SNMP notifications are sent to.

    **transport**
        The transport protocol used to send notifications.

#.  List defined trap destinations.

    .. code-block:: none

        ~(keystone_admin)$ system snmp-trapdest-list
        +------------+----------------+------+--------------+-----------+
        | IP Address  | SNMP Community | Port | Type         | Transport |
        +-------------+----------------+------+--------------+-----------+
        | 10.10.10.1  | commstr1       | 162  | snmpv2c_trap | udp       |
        +-------------+----------------+------+--------------+-----------+

#.  Query access details of a specific trap destination.

    .. code-block:: none

        ~(keystone_admin)$ system snmp-trapdest-show 10.10.10.1
        +------------+--------------------------------------+
        | Property   | Value                                |
        +------------+--------------------------------------+
        | uuid       | c7b6774e-7f45-40f5-bcca-3668de2a186f |
        | ip_address | 10.10.10.1                           |
        | community  | commstr1                             |
        | type       | snmpv2c_trap                         |
        | port       | 162                                  |
        | transport  | udp                                  |
        +------------+--------------------------------------+

#.  Disable the sending of SNMP notifications to a specific IP address.

    .. code-block:: none

        ~(keystone_admin)$ system snmp-trapdest-delete 10.10.10.1
        Deleted ip 10.10.10.1