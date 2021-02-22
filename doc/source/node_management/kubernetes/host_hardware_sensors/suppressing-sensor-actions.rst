
.. zhk1552676591410
.. _suppressing-sensor-actions:

=======================
Suppress Sensor Actions
=======================

You can suppress the configured **Action** for individual sensors or
groups of sensors

If a sensor is faulty, or is generating frequent minor alarms for a known
condition that cannot be addressed immediately, you can prevent it from
generating further alarms. Suppressed sensors are still audited, and their
status is reported in the **Sensors** list.

For more information about sensors and sensor groups,
see :ref:`Sensors Tab <sensors-tab>`.

To use the command-line interface,
see :ref:`CLI Commands for Managing Sensors <cli-commands-for-managing-sensors>`.

.. rubric:: |proc|

.. _suppressing-sensor-actions-steps-zdg-53f-4t:

#.  Open the **Host Detail** page for the host.

    #.  Open the Host Inventory page, available from **Admin** \>
        **Platform** \> **Host Inventory** in the left-hand pane.

    #.  Select the **Hosts** tab, and then in the **Host Name** column,
        click the name of the host.

#.  Select the **Sensors** tab.

#.  Use the controls on the **Sensors** tab to suppress actions for
    individual sensors or sensor groups.

    .. table::
        :widths: auto

        +------------------------------+--------------------------------------------------------------------------------------------------------------------------------+
        | **For a group of sensors**   | To suppress actions for a group of sensors, open the **Actions** menu for the group, and then select **Suppress SensorGroup**. |
        |                              |                                                                                                                                |
        |                              | .. figure:: ../figures/jow1443890971677.png                                                                                    |
        +------------------------------+--------------------------------------------------------------------------------------------------------------------------------+
        | **For an individual sensor** | To suppress actions for an individual sensor, locate the sensor in the **Sensors** list, and click **Suppress Sensor**.        |
        |                              |                                                                                                                                |
        |                              | .. figure:: ../figures/jow1443890898358.png                                                                                    |
        +------------------------------+--------------------------------------------------------------------------------------------------------------------------------+

.. rubric:: |result|

The **Suppression** field in the list is updated to show that actions are
suppressed for the sensor.
