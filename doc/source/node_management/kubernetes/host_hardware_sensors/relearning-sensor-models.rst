
.. nam1552676625070
.. _relearning-sensor-models:

=====================
Relearn Sensor Models
=====================

You can relearn the sensor models used to monitor board health. This is
advisable after upgrading |BMC| firmware or making other |BMC|-related changes
on a host.

The sensor model used on a host is defined by the installed |BMC| module. It is
read initially by |prod| when the |BMC| is provisioned, and used to populate
the Sensors tab for the host. At initial provisioning, this can take about five
minutes.

You may need to update the information on the Sensors tab manually if the
sensor model changes for any reason (for example, because the |BMC| firmware
is upgraded). An out-of-date sensor model can cause false alarms or errors.

You can update sensor information from the Horizon Web interface using the
**Relearn Sensor Model** button. To use the command-line interface, see
|node-doc|: :ref:`CLI Commands for Managing Sensors
<cli-commands-for-managing-sensors>`.

The relearn operation clears any existing sensor alarms, and updates the list
of sensor groups and sensors for the host. Existing sensor groups retain the
same **action** and **audit interval**. If any new sensor groups are added,
they are assigned a default **action**, and inherit the **audit interval**
in effect for all sensor groups. For more about these settings,
see :ref:`Adjust Sensor Actions and Audit Intervals
<adjusting-sensor-actions-and-audit-intervals>`.

For more information about sensor monitoring, see |node-doc|: :ref:`Sensors Tab
<sensors-tab>`. For more about |BMCs|, see the |prod| installation guide
for your system.

.. rubric:: |proc|

#.  Open the **Host Detail** page for the host.

    #.  Open the Host Inventory page, available from **Admin** \>
        **Platform** \> **Host Inventory** in the left-hand pane.

    #.  Select the **Hosts** tab, and then in the **Host Name** column,
        click the name of the host.

#.  Select the **Sensors** tab.

#.  On the Sensors page, click **Relearn Sensor Model**.

    .. figure:: /node_management/kubernetes/figures/eoc1497190198018.png
        :scale: 100%

    Allow about two minutes for the sensor information to be updated.

    When the update is completed, the **State** for all sensor groups and
    sensors is shown as **enabled**. Any existing sensor alarms are cleared.
