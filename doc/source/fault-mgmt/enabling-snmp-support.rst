
.. nat1580220934509
.. _enabling-snmp-support:

===================
Enable SNMP Support
===================

:abbr:`SNMP (Simple Network Management Protocol)` support must be enabled
before you can begin using it to monitor a system.

.. rubric:: |context|

In order to have a workable SNMP configuration you must use the command line
interface on the active controller to complete the following steps.

.. rubric:: |proc|

#.  Define at least one SNMP community string.

    See |fault-doc|: :ref:`Adding an SNMP Community String Using the CLI
    <adding-an-snmp-community-string-using-the-cli>` for details.

#.  Configure at least one SNMP trap destination.

    This will allow alarms and logs to be reported as they happen.

    For more information, see :ref:`Configuring SNMP Trap Destinations
    <configuring-snmp-trap-destinations>`.