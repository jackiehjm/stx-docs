
.. slf1579788051430
.. _alarm-messages-300s:

=====================
Alarm Messages - 300s
=====================

.. include:: ../_includes/openstack-alarm-messages-xxxs.rest

.. _alarm-messages-300s-table-zrd-tg5-v5:

.. list-table::
   :widths: 6 15
   :header-rows: 0

   * - **Alarm ID: 300.003**
     - Networking Agent not responding.
   * - Entity Instance
     - host=<hostname>.agent=<agent-uuid>
   * - Severity:
     - M\*
   * - Proposed Repair Action
     - If condition persists, attempt to clear issue by administratively locking and unlocking the Host.

.. list-table::
   :widths: 6 15
   :header-rows: 0

   * - **Alarm ID: 300.004**
     - No enabled compute host with connectivity to provider network.
   * - Entity Instance
     - host=<hostname>.providernet=<pnet-uuid>
   * - Severity:
     - M\*
   * - Proposed Repair Action
     - Enable compute hosts with required provider network connectivity.

.. list-table::
   :widths: 6 15
   :header-rows: 0

   * - **Alarm ID: 300.005**
     - Communication failure detected over provider network x% for ranges y% on host z%.

       or

       Communication failure detected over provider network x% on host z%.
   * - Entity Instance
     - providernet=<pnet-uuid>.host=<hostname>
   * - Severity:
     -  M\*
   * - Proposed Repair Action
     - Check neighbor switch port VLAN assignments.

.. list-table::
   :widths: 6 15
   :header-rows: 0

   * - **Alarm ID: 300.010**
     - ML2 Driver Agent non-reachable

       or

       ML2 Driver Agent reachable but non-responsive

       or

       ML2 Driver Agent authentication failure

       or

       ML2 Driver Agent is unable to sync Neutron database
   * - Entity Instance
     - host=<hostname>.ml2driver=<driver>
   * - Severity:
     -  M\*
   * - Proposed Repair Action
     - Monitor and if condition persists, contact next level of support.

.. list-table::
   :widths: 6 15
   :header-rows: 0

   * - **Alarm ID: 300.012**
     - Openflow Controller connection failed.
   * - Entity Instance
     - host=<hostname>.openflow-controller=<uri>
   * - Severity:
     -  M\*
   * - Proposed Repair Action
     - Check cabling and far-end port configuration and status on adjacent equipment.

.. list-table::
   :widths: 6 15
   :header-rows: 0

   * - **Alarm ID: 300.013**
     - No active Openflow controller connections found for this network.

       or

       One or more Openflow controller connections in disconnected state for this network.
   * - Entity Instance
     - host=<hostname>.openflow-network=<name>
   * - Severity:
     -  C, M\*
   * - Proposed Repair Action
     - host=<hostname>.openflow-network=<name>

.. list-table::
   :widths: 6 15
   :header-rows: 0

   * - **Alarm ID: 300.015**
     - No active OVSDB connections found.
   * - Entity Instance
     - host=<hostname>
   * - Severity:
     -  C\*
   * - Proposed Repair Action
     - Check cabling and far-end port configuration and status on adjacent equipment.

.. list-table::
   :widths: 6 15
   :header-rows: 0

   * - **Alarm ID: 300.016**
     - Dynamic routing agent x% lost connectivity to peer y%
   * - Entity Instance
     - host=<hostname>,agent=<agent-uuid>,bgp-peer=<bgp-peer>
   * - Severity:
     -  M\*
   * - Proposed Repair Action
     - If condition persists, fix connectivity to peer.