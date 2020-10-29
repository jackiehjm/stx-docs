
.. msm1579788069384
.. _alarm-messages-400s:

=====================
Alarm Messages - 400s
=====================

.. include:: ../_includes/openstack-alarm-messages-xxxs.rest

.. list-table::
   :widths: 6 15
   :header-rows: 0

   * - **Alarm ID: 400.001**
     - Service group failure; <list\_of\_affected\_services>.

       or

       Service group degraded; <list\_of\_affected\_services>

       or

       Service group Warning; <list\_of\_affected\_services>.
   * - Entity Instance
     - service\_domain=<domain\_name>.service\_group=<group\_name>.host=<hostname>
   * - Severity:
     - C/M/m\*
   * - Proposed Repair Action
     - Contact next level of support.

.. list-table::
   :widths: 6 15
   :header-rows: 0

   * - **Alarm ID: 400.002**
     - Service group loss of redundancy; expected <num> standby member<s> but only <num> standby member<s> available.

       or

       Service group loss of redundancy; expected <num> standby member<s> but only <num> standby member<s> available.

       or

       Service group loss of redundancy; expected <num> active member<s> but no active members available.

       or

       Service group loss of redundancy; expected <num> active member<s> but only <num> active member<s> available.
   * - Entity Instance
     - service\_domain=<domain\_name>.service\_group=<group\_name>
   * - Severity:
     - M\*
   * - Proposed Repair Action
     - Bring a controller node back in to service, otherwise contact next level of support.