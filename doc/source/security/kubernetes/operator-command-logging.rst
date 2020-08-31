
.. blo1552681488499
.. _operator-command-logging:

========================
Operator Command Logging
========================

|prod| logs all REST API operator commands and SNMP commands.

The logs include the timestamp, tenant name \(if applicable\), user name,
command executed, and command status \(success or failure\).

The files are located under the /var/log directory, and are named using the
convention \*-api.log. Each component that generates its own API log files
\(for example, Keystone, Barbican, and so forth\) and each |prod| /
StarlingX -specific component, updating \(patching\) system, and SNMP agent
follows, this convention.

You can examine the log files locally on the controllers, or using a remote
log server if the remote logging feature is configured. The one exception is
patching-api.log. For updating robustness, the |prod| updating system uses
minimal system facilities and does not use **syslog**. Therefore its logs
are not available on a remote log server.


.. _operator-command-logging-section-N10047-N10023-N10001:

-------
Remarks
-------


.. _operator-command-logging-ul-plj-htv-1z:

-   For the |prod| :command:`system` command, whenever a REST API call is
    made that is either a POST, PATCH, PUT, or DELETE, |prod| logs these events
    into a new log file called /var/log/sysinv-api.log


    -   POST - means creating something

    -   PATCH - means partially updating \(modifying\) something

    -   PUT - means fully updating \(modifying\) something

    -   DELETE - means deleting something


    :command:`system modify --description="A TEST"` is logged to sysinv-api.log because it issues a REST POST call

    :command:`system snmp-comm-delete "TEST\_COMMUNITY1"` - is logged to sysinv-api.log because it issues a REST DELETE call

-   If the :command:`sysinv` command only issues a REST GET call, it is not logged.


    -   :command:`fm event-list` is not logged because this performs a sysinv REST GET call

    -   :command:`fm event-show<xx>` is not logged because this performs a sysinv REST GET call


-   All SNMP Commands are logged, including GET, GETNEXT, GETBULK and SET commands. SNMP TRAPs are not logged.


