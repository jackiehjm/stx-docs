
.. hwr1579789203684
.. _customer-log-messages-401s-services:

=====================================
Customer Log Messages 401s - Services
=====================================

.. include:: ../_includes/openstack-customer-log-messages-xxxs.rest

.. _customer-log-messages-401s-services-table-zgf-jvw-v5:

.. list-table::
   :widths: 6 15
   :header-rows: 0

   * - **Log Message: 401.001**
     - Service group <group> state change from <state> to <state> on host <host\_name>
   * - Entity Instance
     - service\_domain=<domain>.service\_group=<group>.host=<host\_name>
   * - Severity:
     - C

.. list-table::
   :widths: 6 15
   :header-rows: 0

   * - **Log Message: 401.002**
     - Service group <group> loss of redundancy; expected <X> standby member but no standby members available.

       or

       Service group <group> loss of redundancy; expected <X> standby member but only <Y> standby member\(s\) available.

       or

       Service group <group> has no active members available; expected <X> active member\(s\)

       or

       Service group <group> loss of redundancy; expected <X> active member\(s\) but only <Y> active member\(s\) available.
   * - Entity Instance
     - service\_domain=<domain>.service\_group=<group>
   * - Severity:
     - C
