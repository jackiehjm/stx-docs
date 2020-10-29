
.. lzz1579291773073
.. _200-series-maintenance-customer-log-messages:

============================================
200 Series Maintenance Customer Log Messages
============================================

The Customer Logs include events that do not require immediate user action.

The following types of events are included in the Customer Logs. The severity
of the events is represented in the table by one or more letters, as follows:

.. _200-series-maintenance-customer-log-messages-ul-jsd-jkg-vp:

-   C: Critical

-   M: Major

-   m: Minor

-   W: Warning

-   NA: Not applicable

.. _200-series-maintenance-customer-log-messages-table-zgf-jvw-v5:


.. table:: Table 1. Customer Log Messages
    :widths: auto

    +-----------------+------------------------------------------------------------------+----------+
    | Log ID          | Description                                                      | Severity |
    +                 +------------------------------------------------------------------+----------+
    |                 | Entity Instance ID                                               |          |
    +=================+==================================================================+==========+
    | 200.020         | <hostname> has been 'discovered' on the network                  | NA       |
    |                 |                                                                  |          |
    |                 | host=<hostname>.event=discovered                                 |          |
    +-----------------+------------------------------------------------------------------+----------+
    | 200.020         | <hostname> has been 'added' to the system                        | NA       |
    |                 |                                                                  |          |
    |                 | host=<hostname>.event=add                                        |          |
    +-----------------+------------------------------------------------------------------+----------+
    | 200.020         | <hostname> has 'entered' multi-node failure avoidance            | NA       |
    |                 |                                                                  |          |
    |                 | host=<hostname>.event=mnfa\_enter                                |          |
    +-----------------+------------------------------------------------------------------+----------+
    | 200.020         | <hostname> has 'exited' multi-node failure avoidance             | NA       |
    |                 |                                                                  |          |
    |                 | host=<hostname>.event=mnfa\_exit                                 |          |
    +-----------------+------------------------------------------------------------------+----------+
    | 200.021         | <hostname> board management controller has been 'provisioned'    | NA       |
    |                 |                                                                  |          |
    |                 | host=<hostname>.command=provision                                |          |
    +-----------------+------------------------------------------------------------------+----------+
    | 200.021         | <hostname> board management controller has been 're-provisioned' | NA       |
    |                 |                                                                  |          |
    |                 | host=<hostname>.command=reprovision                              |          |
    +-----------------+------------------------------------------------------------------+----------+
    | 200.021         | <hostname> board management controller has been 'de-provisioned' | NA       |
    |                 |                                                                  |          |
    |                 | host=<hostname>.command=deprovision                              |          |
    +-----------------+------------------------------------------------------------------+----------+
    | 200.021         | <hostname> manual 'unlock' request                               | NA       |
    |                 |                                                                  |          |
    |                 | host=<hostname>.command=unlock                                   |          |
    +-----------------+------------------------------------------------------------------+----------+
    | 200.021         | <hostname> manual 'reboot' request                               | NA       |
    |                 |                                                                  |          |
    |                 | host=<hostname>.command=reboot                                   |          |
    +-----------------+------------------------------------------------------------------+----------+
    | 200.021         | <hostname> manual 'reset' request                                | NA       |
    |                 |                                                                  |          |
    |                 | host=<hostname>.command=reset                                    |          |
    +-----------------+------------------------------------------------------------------+----------+
    | 200.021         | <hostname> manual 'power-off' request                            | NA       |
    |                 |                                                                  |          |
    |                 | host=<hostname>.command=power-off                                |          |
    +-----------------+------------------------------------------------------------------+----------+
    | 200.021         | <hostname> manual 'power-on' request                             | NA       |
    |                 |                                                                  |          |
    |                 | host=<hostname>.command=power-on                                 |          |
    +-----------------+------------------------------------------------------------------+----------+
    | 200.021         | <hostname> manual 'reinstall' request                            | NA       |
    |                 |                                                                  |          |
    |                 | host=<hostname>.command=reinstall                                |          |
    +-----------------+------------------------------------------------------------------+----------+
    | 200.021         | <hostname> manual 'force-lock' request                           | NA       |
    |                 |                                                                  |          |
    |                 | host=<hostname>.command=force-lock                               |          |
    +-----------------+------------------------------------------------------------------+----------+
    | 200.021         | <hostname> manual 'delete' request                               | NA       |
    |                 |                                                                  |          |
    |                 | host=<hostname>.command=delete                                   |          |
    +-----------------+------------------------------------------------------------------+----------+
    | 200.021         | <hostname> manual 'controller switchover' request                | NA       |
    |                 |                                                                  |          |
    |                 | host=<hostname>.command=swact                                    |          |
    +-----------------+------------------------------------------------------------------+----------+
    | 200.022         | <hostname> is now 'disabled'                                     | NA       |
    |                 |                                                                  |          |
    |                 | host=<hostname>.state=disabled                                   |          |
    +-----------------+------------------------------------------------------------------+----------+
    | 200.022         | <hostname> is now 'enabled'                                      | NA       |
    |                 |                                                                  |          |
    |                 | host=<hostname>.state=enabled                                    |          |
    +-----------------+------------------------------------------------------------------+----------+
    | 200.022         | <hostname> is now 'online'                                       | NA       |
    |                 |                                                                  |          |
    |                 | host=<hostname>.status=online                                    |          |
    +-----------------+------------------------------------------------------------------+----------+
    | 200.022         | <hostname> is now 'offline'                                      | NA       |
    |                 |                                                                  |          |
    |                 | host=<hostname>.status=offline                                   |          |
    +-----------------+------------------------------------------------------------------+----------+
    | 200.022         | <hostname> is 'disabled-failed' to the system                    | NA       |
    |                 |                                                                  |          |
    |                 | host=<hostname>.status=failed                                    |          |
    +-----------------+------------------------------------------------------------------+----------+