
.. slf1579788051430
.. _alarm-messages-300s:

=====================
Alarm Messages - 300s
=====================

The system inventory and maintenance service reports system changes with
different degrees of severity. Use the reported alarms to monitor the overall
health of the system.

For more information, see :ref:`Overview
<openstack-fault-management-overview>`.

In the following tables, the severity of the alarms is represented by one or
more letters, as follows:

.. _alarm-messages-300s-ul-jsd-jkg-vp:

-   C: Critical

-   M: Major

-   m: Minor

-   W: Warning

A slash-separated list of letters is used when the alarm can be triggered with
one of several severity levels.

An asterisk \(\*\) indicates the management-affecting severity, if any. A
management-affecting alarm is one that cannot be ignored at the indicated
severity level or higher by using relaxed alarm rules during an orchestrated
patch or upgrade operation.

Differences exist between the terminology emitted by some alarms and that used
in the |CLI|, GUI, and elsewhere in the documentation:

.. _alarm-messages-300s-ul-dsf-dxn-bhb:

-   References to provider networks in alarms refer to data networks.

-   References to data networks in alarms refer to physical networks.

-   References to tenant networks in alarms refer to project networks.


.. _alarm-messages-300s-table-zrd-tg5-v5:

.. table:: Table 1. Alarm Messages
    :widths: auto

    +----------+-------------------------------------------------------------------------------------+----------+---------------------------------------------------------------------------------------------------+
    | Alarm ID | Description                                                                         | Severity | Proposed Repair Action                                                                            |
    +          +-------------------------------------------------------------------------------------+----------+---------------------------------------------------------------------------------------------------+
    |          | Entity Instance ID                                                                                                                                                                                 |
    +==========+=====================================================================================+==========+===================================================================================================+
    | 300.001  | 'Data' Port failed.                                                                 | M\*      | Check cabling and far-end port configuration and status on adjacent equipment.                    |
    +          +-------------------------------------------------------------------------------------+----------+---------------------------------------------------------------------------------------------------+
    |          | host=<hostname>.port=<port-uuid>                                                                                                                                                                   |
    +----------+-------------------------------------------------------------------------------------+----------+---------------------------------------------------------------------------------------------------+
    | 300.002  | 'Data' Interface degraded or 'Data' Interface failed.                               | C/M\*    | Check cabling and far-end port configuration and status on adjacent equipment.                    |
    +          +-------------------------------------------------------------------------------------+----------+---------------------------------------------------------------------------------------------------+
    |          | host=<hostname>.interface=<if-uuid>                                                                                                                                                                |
    +----------+-------------------------------------------------------------------------------------+----------+---------------------------------------------------------------------------------------------------+
    | 300.003  | Networking Agent not responding.                                                    | M\*      | If condition persists, attempt to clear issue by administratively locking and unlocking the Host. |
    +          +-------------------------------------------------------------------------------------+----------+---------------------------------------------------------------------------------------------------+
    |          | host=<hostname>.agent=<agent-uuid>                                                                                                                                                                 |
    +----------+-------------------------------------------------------------------------------------+----------+---------------------------------------------------------------------------------------------------+
    | 300.004  | No enabled compute host with connectivity to provider network.                      | M\*      | Enable compute hosts with required provider network connectivity.                                 |
    +          +-------------------------------------------------------------------------------------+----------+---------------------------------------------------------------------------------------------------+
    |          | service=networking.providernet=<pnet-uuid>                                                                                                                                                         |
    +----------+-------------------------------------------------------------------------------------+----------+---------------------------------------------------------------------------------------------------+
    | 300.005  | Communication failure detected over provider network x% for ranges y% on host z%.   | M\*      | Check neighbour switch port VLAN assignments.                                                     |
    |          |                                                                                     |          |                                                                                                   |
    |          | or                                                                                  |          |                                                                                                   |
    |          |                                                                                     |          |                                                                                                   |
    |          | Communication failure detected over provider network x% on host z%.                 |          |                                                                                                   |
    +          +-------------------------------------------------------------------------------------+----------+---------------------------------------------------------------------------------------------------+
    |          | host=<hostname>.service=networking.providernet=<pnet-uuid>                                                                                                                                         |
    +----------+-------------------------------------------------------------------------------------+----------+---------------------------------------------------------------------------------------------------+
    | 300.010  | ML2 Driver Agent non-reachable                                                      | M\*      | Monitor and if condition persists, contact next level of support.                                 |
    |          |                                                                                     |          |                                                                                                   |
    |          | or                                                                                  |          |                                                                                                   |
    |          |                                                                                     |          |                                                                                                   |
    |          | ML2 Driver Agent reachable but non-responsive                                       |          |                                                                                                   |
    |          |                                                                                     |          |                                                                                                   |
    |          | or                                                                                  |          |                                                                                                   |
    |          |                                                                                     |          |                                                                                                   |
    |          | ML2 Driver Agent authentication failure                                             |          |                                                                                                   |
    |          |                                                                                     |          |                                                                                                   |
    |          | or                                                                                  |          |                                                                                                   |
    |          |                                                                                     |          |                                                                                                   |
    |          | ML2 Driver Agent is unable to sync Neutron database                                 |          |                                                                                                   |
    +          +-------------------------------------------------------------------------------------+----------+---------------------------------------------------------------------------------------------------+
    |          | host=<hostname>.ml2driver=<driver>                                                                                                                                                                 |
    +----------+-------------------------------------------------------------------------------------+----------+---------------------------------------------------------------------------------------------------+
    | 300.012  | Openflow Controller connection failed.                                              | M\*      | Check cabling and far-end port configuration and status on adjacent equipment.                    |
    +          +-------------------------------------------------------------------------------------+----------+---------------------------------------------------------------------------------------------------+
    |          | host=<hostname>.openflow-controller=<uri>                                                                                                                                                          |
    +----------+-------------------------------------------------------------------------------------+----------+---------------------------------------------------------------------------------------------------+
    | 300.013  | No active Openflow controller connections found for this network.                   | C, M\*   | Check cabling and far-end port configuration and status on adjacent equipment.                    |
    |          |                                                                                     |          |                                                                                                   |
    |          | or                                                                                  |          |                                                                                                   |
    |          |                                                                                     |          |                                                                                                   |
    |          | One or more Openflow controller connections in disconnected state for this network. |          |                                                                                                   |
    +          +-------------------------------------------------------------------------------------+----------+---------------------------------------------------------------------------------------------------+
    |          | host=<hostname>.openflow-network=<name>                                                                                                                                                            |
    +----------+-------------------------------------------------------------------------------------+----------+---------------------------------------------------------------------------------------------------+
    | 300.015  | No active OVSDB connections found.                                                  | C\*      | Check cabling and far-end port configuration and status on adjacent equipment.                    |
    +          +-------------------------------------------------------------------------------------+----------+---------------------------------------------------------------------------------------------------+
    |          | host=<hostname>                                                                                                                                                                                    |
    +----------+-------------------------------------------------------------------------------------+----------+---------------------------------------------------------------------------------------------------+
    | 300.016  | Dynamic routing agent x% lost connectivity to peer y%                               | M\*      | If condition persists, fix connectivity to peer.                                                  |
    +          +-------------------------------------------------------------------------------------+----------+---------------------------------------------------------------------------------------------------+
    |          | host=<hostname>,agent=<agent-uuid>,bgp-peer=<bgp-peer>                                                                                                                                             |
    +----------+-------------------------------------------------------------------------------------+----------+---------------------------------------------------------------------------------------------------+
