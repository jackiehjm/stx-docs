
.. blo1552681488499
.. _operator-command-logging:

==================================
StarlingX Operator Command Logging
==================================

|prod| logs all StarlingX REST API operator commands, except commands that use
only GET requests. |prod| also logs all |SNMP| commands, including ``GET``
requests.



-------------------------------------------
StarlingX REST API Operator Command Logging
-------------------------------------------

The logs include the timestamp, tenant name \(if applicable\), user name,
command executed, and command status \(success or failure\).

The files are located under the ``/var/log`` directory and are named using the
convention ``*api.log``. The list of log files is presented below.


- ``/var/log/sysinv-api.log``

- ``/var/log/fm-api.log``

- ``/var/log/dcmanager/dcmanager-api.log``

- ``/var/log/nfv-vim-api.log``

- ``/var/log/patching-api.log``

- ``/var/log/mtcAgent_api.log``

- ``/var/log/hwmond_api.log``

- ``/var/log/barbican/barbican-api.log``

.. only:: starlingx

   You can examine the log files locally on the controllers.

.. only:: partner

   .. include:: /_includes/operator-command-logging.rest
      :start-after: begin-remote-log-server-options
      :end-before: end-remote-log-server-options


For example, if the following command is issued:

``system modify --description="TEST01 DESCRIPTION"``

The following log is generated in ``/var/log/sysinv-api.log``:

``sysinv 2022-03-09 11:03:46.238 108478 INFO sysinv.api.hooks.auditor [req-be0eb23d-c815-4bb7-938a-bfb8adba496b 76752e1b78b54f7b8409e2c54a6b6082 1ba4a349b9f941e0a5bd658df4e4d4f7] 192.168.204.2 "PATCH /v1/isystems/7b64c984-8b6e-42da-88e5-d9ee17c5178e HTTP/1.0" status: 200 len: 1151 time: 0.0395379066467 POST: [{u'path': u'/description', u'value': u'TEST01 DESCRIPTION', u'op': u'replace'}] host:192.168.204.1:6385 agent:Python-httplib2/0.9.2 (gzip) user: admin tenant: admin domain: Default``

REST API request methods that will be logged include:

``PATCH``
   The resource is being partially updated.

``POST``
   The resource is being created or fully updated.

``DELETE``
   The resource is being deleted.

``PUT``
   Similar to ``POST`` with the difference that ``PUT`` requests are
   idempotent, that is, multiple ``PUT`` calls produce the same result.


--------------------
SNMP Request Logging
--------------------

As the |SNMP| application is containerized, the logs of its commands are found
inside the container at file ``/var/log/snmpd.log``. Only basic information is
present in this log file, like command type, |SNMP| version and request status.
All |SNMP| requests are logged, including ``GET`` requests.

For example, if the following command is issued:

``SNMP GET OID .iso.3.6.1.2.1.1.1.0``

It will return the value:

``iso.3.6.1.2.1.1.1.0 = STRING: "22.02 5.10.74-200.1807.tis.el7.x86_64"``

And the following log is generated in ``/var/log/snmpd.log`` inside the |SNMP|
container:

.. code-block:: none

   snmp-auditor transport:udp remote:10.20.3.3 reqid:1367258771 msg-type:GET version:v3
   snmp-auditor    reqid:1367258771 oid:SNMPv2-MIB::sysDescr.0
   snmp-auditor    reqid:1367258771 oid:SNMPv2-MIB::sysDescr.0 status:pass

