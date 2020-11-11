
.. pgb1579292662158
.. _400-series-customer-log-messages:

================================
400 Series Customer Log Messages
================================

The Customer Logs include events that do not require immediate user action.

The following types of events are included in the Customer Logs. The severity
of the events is represented in the table by one or more letters, as follows:

.. _400-series-customer-log-messages-ul-jsd-jkg-vp:

-   C: Critical

-   M: Major

-   m: Minor

-   W: Warning

-   NA: Not applicable

.. _400-series-customer-log-messages-table-zgf-jvw-v5:

.. list-table::
   :widths: 6 15
   :header-rows: 0

   * - **Alarm ID: 400.003**
     - License key has expired or is invalid

       or

       Evaluation license key will expire on <date>

       or

       License key is valid
   * - Entity Instance
     - host=<host\_name>
   * - Severity:
     - C

-----

.. list-table::
   :widths: 6 15
   :header-rows: 0

   * - **Alarm ID: 400.005**
     - Communication failure detected with peer over port <port> on host
       <host name>

       or

       Communication failure detected with peer over port <port> on host
       <host name> within the last <X> seconds

       or

       Communication established with peer over port <port> on host <host name>
   * - Entity Instance
     - host=<host\_name>.network=<network>
   * - Severity:
     - C

-----

.. list-table::
   :widths: 6 15
   :header-rows: 0

   * - **Alarm ID: 400.007**
     - Swact or swact-force
   * - Entity Instance
     - host=<host\_name>
   * - Severity:
     - C