
.. lmy1552680547012
.. _traps:

=====
Traps
=====

|prod| supports SNMP traps. Traps send unsolicited information to monitoring
software when significant events occur.

The following traps are defined.

.. _traps-ul-p1j-tvn-c5:

-   **wrsAlarmCritical**

-   **wrsAlarmMajor**

-   **wrsAlarmMinor**

-   **wrsAlarmWarning**

-   **wrsAlarmMessage**

-   **wrsAlarmClear**

-   **wrsAlarmHierarchicalClear**

.. note::
    Customer Logs always result in **wrsAlarmMessage** traps.

For Critical, Major, Minor, Warning, and Message traps, all variables in the
active alarm table are included as varbinds \(variable bindings\), where each
varbind is a pair of fields consisting of an object identifier and a value
for the object.

For the Clear trap, varbinds include only the following variables:

.. _traps-ul-uks-byn-nkb:

-   <AlarmID>

-   <EntityInstanceID>

-   <DateAndTime>

-   <ReasonText>

For the HierarchicalClear trap, varbinds include only the following variables:

.. _traps-ul-isn-fyn-nkb:

-   <EntityInstanceID>

-   <DateAndTime>

-   <ReasonText>

For all alarms, the Notification Type is based on the severity of the trap or
alarm. This is done to facilitate the interaction with most SNMP trap viewers
which typically use the Notification Type to drive the coloring of traps, that
is, red for critical, yellow for minor, and so on.