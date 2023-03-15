
.. maj1552680619436
.. _unsuppressing-an-alarm-using-the-cli:

=================================
Unsuppress an Alarm Using the CLI
=================================

If you need to reactivate a suppressed alarm, you can do so using the CLI.

.. rubric:: |proc|

-   Use the :command:`fm event-unsuppress` CLI command to unsuppress a
    currently suppressed alarm.

    .. code-block:: none

        ~(keystone_admin)$ fm event-unsuppress [--nowrap] --alarm_id <alarm-id>[,<alarm-id>] \
        [--nopaging] [--uuid]

    where

    ``<alarm-id>``
        is a comma separated **Alarm ID** list of alarms to unsuppress.

    ``--nowrap``
        disables output wrapping.

    ``--nopaging``
        disables paged output

    ``--uuid``
        includes the alarm type UUIDs in the output.

    Alarm type\(s) with the specified <alarm-id\(s)> will be unsuppressed.

    You can unsuppress all currently suppressed alarms using the following command:

    .. code-block:: none

        ~(keystone_admin)$ fm event-unsuppress -all [--nopaging] [--uuid]