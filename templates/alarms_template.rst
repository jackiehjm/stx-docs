head_format="

.. _<series-number>-series-alarm-messages-<Context>:

<over_score>
<series_number> Series Alarm Messages
<under_score>

.. include:: /shared/_includes/alarm-severities.rest

"

record_format="

.. list-table::
   :widths: 6 25
   :header-rows: 0

   * - **Alarm ID: <alarm_id>**
     - <Description>
   * - Entity Instance
     - <Entity_Instance_ID>
   * - Degrade Affecting Severity:
     - <Degrade_Affecting_Severity>
   * - Severity:
     - <Severity>
   * - Proposed Repair Action
     - <Proposed_Repair_Action>
   * - Management Affecting Severity
     - <Management_Affecting_Severity>

-----
"

foot_format="

.. raw:: html

   &#8202;

"

