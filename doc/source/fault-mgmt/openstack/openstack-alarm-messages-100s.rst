
.. slf1579788051430
.. _alarm-messages-100s:

=====================
Alarm Messages - 100s
=====================

The system inventory and maintenance service reports system changes with
different degrees of severity. Use the reported alarms to monitor the overall
health of the system.

For more information, see :ref:`Overview
<openstack-fault-management-overview>`.

In the following tables, the severity of the alarms is represented by one or
more letters, as follows:

.. _alarm-messages-100s-ul-jsd-jkg-vp:

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

.. _alarm-messages-100s-ul-dsf-dxn-bhb:

-   References to provider networks in alarms refer to data networks.

-   References to data networks in alarms refer to physical networks.

-   References to tenant networks in alarms refer to project networks.


.. _alarm-messages-100s-table-zrd-tg5-v5:

.. table:: Table 1. Alarm Messages
    :widths: auto

    +----------+-------------------------------------------------------------------------------------+----------+---------------------------------------------------------------------------------------------------+
    | Alarm ID | Description                                                                         | Severity | Proposed Repair Action                                                                            |
    +          +-------------------------------------------------------------------------------------+----------+---------------------------------------------------------------------------------------------------+
    |          | Entity Instance ID                                                                                                                                                                                 |
    +==========+=====================================================================================+==========+===================================================================================================+
    | 100.005  | <fs_name> filesystem is not added on both controllers and/or does not have the same | C/M\*    | Add image-conversion filesystem on both controllers.                                              |
    |          | size: <hostname>.                                                                   |          | Consult the System Administration Manual for more details.                                        |
    |          |                                                                                     |          | If problem persists, contact next level of support.                                               |
    +          +-------------------------------------------------------------------------------------+----------+---------------------------------------------------------------------------------------------------+
    |          | fs_name=<image-conversion>                                                                                                                                                                         |
    +----------+-------------------------------------------------------------------------------------+----------+---------------------------------------------------------------------------------------------------+
    | 100.012  | 'DATA-VRS' Port down.                                                               | M        | Check cabling and far-end port configuration and status on adjacent equipment.                    |
    +          +-------------------------------------------------------------------------------------+----------+---------------------------------------------------------------------------------------------------+
    |          | host=<hostname>.port=<port-name>                                                                                                                                                                   |
    +----------+-------------------------------------------------------------------------------------+----------+---------------------------------------------------------------------------------------------------+
    | 100.013  | 'DATA-VRS' Interface degraded OR 'DATA-VRS' Interface down.                         | C or M\* | Check cabling and far-end port configuration and status on adjacent equipment.                    |
    +          +-------------------------------------------------------------------------------------+----------+---------------------------------------------------------------------------------------------------+
    |          | host=<hostname>.interface=<if-name>                                                                                                                                                                |
    +----------+-------------------------------------------------------------------------------------+----------+---------------------------------------------------------------------------------------------------+
