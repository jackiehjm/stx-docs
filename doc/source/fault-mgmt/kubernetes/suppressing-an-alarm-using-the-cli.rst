
.. ani1552680633324
.. _suppressing-an-alarm-using-the-cli:

===============================
Suppress an Alarm Using the CLI
===============================

You can use the CLI to prevent a monitored system parameter from generating
unnecessary alarms.

.. rubric:: |proc|

#.  Use the :command:`fm event-suppress` to suppress a single alarm or
    multiple alarms by ID.

    .. code-block:: none

        ~(keystone_admin)$ fm event-suppress [--nowrap] --alarm_id <alarm_ id>[,<alarm-id>] \
        [--nopaging] [--uuid]

    where

    **<alarm-id>**
        is a comma separated list of alarm UUIDs.

    **--nowrap**
        disables output wrapping

    **--nopaging**
        disables paged output

    **--uuid**
        includes the alarm type UUIDs in the output

    An error message is generated in the case of an invalid
    <alarm-id>: **Alarm ID not found: <alarm-id\>**.

    If the specified number of Alarm IDs is greater than 1, and at least 1 is
    wrong, then the suppress command is not applied \(none of the specified
    Alarm IDs are suppressed\).

    .. note::
        Suppressing an Alarm will result in the system NOT notifying the
        operator of this particular fault.


