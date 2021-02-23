
.. pky1552676578502
.. _cli-commands-for-managing-sensors:

=================================
CLI Commands for Managing Sensors
=================================

You can use the command-line interface to list sensor information, change
sensor settings, and relearn sensors.

The following CLI commands are available for working with sensors. For complete
syntax information, use the :command:`help` command.

:command:`system host-sensorgroup-relearn`
    Include the name or ID of the host as a parameter.

:command:`system host-sensor-list`
    List all the sensors.

:command:`system host-sensor-modify`
    You can modify sensors using the suppress parameter \(True or False\).

:command:`system host-sensor-show`

:command:`system host-sensorgroup-list`

:command:`system host-sensorgroup-modify`
    You can modify sensor groups using the following parameters:

    **actions\_critical\_group**
        Valid values are alarm or ignore.

    **actions\_major\_group**
        Valid values are alarm or ignore.

    **actions\_minor\_group**
        Valid values are alarm or ignore.

    **audit interval\_group**
        The time in seconds.

    **suppress**
        Valid values are True or False.

:command:`system host-sensorgroup-show`
    For example:

    .. code-block:: none

        ~(keystone_admin)$ system host-sensor-modify controller-0 d9af9433-44dd-4526-b0fd-8d7a0cdb877b suppress=True

.. seealso::
   :ref:`Sensors Tab <sensors-tab>`.
