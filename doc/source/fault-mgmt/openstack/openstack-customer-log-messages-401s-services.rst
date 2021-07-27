
.. hwr1579789203684
.. _customer-log-messages-401s-services:

=====================================
Customer Log Messages 401s - Services
=====================================

.. include:: /_includes/openstack-customer-log-messages-xxxs.rest

.. _customer-log-messages-401s-services-table-zgf-jvw-v5:

.. table:: Table 1. Customer Log Messages - Virtual Machines
    :widths: auto

    +-----------+--------------------------------------------------------------------------------------------------------------------+----------+
    | Log ID    | Description                                                                                                        | Severity |
    +           +--------------------------------------------------------------------------------------------------------------------+----------+
    |           | Entity Instance ID                                                                                                 |          |
    +===========+====================================================================================================================+==========+
    | 401.001   | Service group <group> state change from <state> to <state> on host <host_name>                                     | C        |
    |           |                                                                                                                    |          |
    |           | service_domain=<domain>.service_group=<group>.host=<host_name>                                                     |          |
    +-----------+--------------------------------------------------------------------------------------------------------------------+----------+
    | 401.002   | Service group <group> loss of redundancy; expected <X> standby member but no standby members available             | C        |
    |           |                                                                                                                    |          |
    |           | or                                                                                                                 |          |
    |           |                                                                                                                    |          |
    |           | Service group <group> loss of redundancy; expected <X> standby member but only <Y> standby member(s) available     |          |
    |           |                                                                                                                    |          |
    |           | or                                                                                                                 |          |
    |           |                                                                                                                    |          |
    |           | Service group <group> has no active members available; expected <X> active member(s).                              |          |
    |           |                                                                                                                    |          |
    |           | or                                                                                                                 |          |
    |           |                                                                                                                    |          |
    |           | Service group <group> loss of redundancy; expected <X> active member(s) but only <Y> active member(s) available.   |          |
    |           |                                                                                                                    |          |
    |           | service_domain=<domain>.service_group=<group>                                                                      |          |
    +-----------+--------------------------------------------------------------------------------------------------------------------+----------+
