
.. lbd1552676607625
.. _adjusting-sensor-actions-and-audit-intervals:

=========================================
Adjust Sensor Actions and Audit Intervals
=========================================

You can configure audit intervals and actions for groups of sensors.

For more information about sensors and sensor groups, see
:ref:`Sensors Tab <sensors-tab>`.

To use the command-line interface, see :ref:`CLI Commands for Managing Sensors
<cli-commands-for-managing-sensors>`.

.. rubric:: |proc|

.. _adjusting-sensor-actions-and-audit-intervals-steps-zdg-53f-4t:

#.  Open the **Host Detail** page for the host.

    #.  Open the Host Inventory page, available from **Admin** \>
        **Platform** \> **Host Inventory** in the left-hand pane.

    #.  Select the **Hosts** tab, and then in the **Host Name** column,
        click the name of the host.

#.  Select the **Sensors** tab.

#.  In the **Sensor Groups** list, click **Edit SensorGroup** for the
    group you want to configure.

    .. figure:: /node_management/kubernetes/figures/jow1443885204993.png
        :scale: 100%

    In the Edit SensorGroup dialog box, change the settings as required.

    **Audit Interval**
        The time, in seconds, to wait between sensor audits. At each audit,
        the sensor status reading is refreshed. Changes to the audit interval
        do not take effect until the current interval expires.

        .. note::
            A change to the audit interval for any one sensor group is also
            applied to all other sensor groups. This is because |IPMI| is used
            as the underlying communications protocol for improved
            standardization support.

    **Sensor Group Critical Actions**
        The action to take if the sensor status is **Critical**. If this is
        set to **Alarm**, then when this status is reported, a corresponding
        |prod| alarm is generated, and the host availability is set to
        **Degraded**.

    **Sensor Group Major Actions**
        The action to take if the sensor status is **Major**. If this is set
        to **Alarm**, then when this status is reported, a corresponding
        |prod| alarm is generated, and the host availability is set to
        **Degraded**.

    **Sensor Group Minor Actions**
        The action to take if the sensor status is **Minor**. If this is set
        to **Alarm**, then when this status is reported, a corresponding
        |prod| alarm is generated.
