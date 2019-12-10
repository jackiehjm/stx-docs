==
fm
==

:command:`fm` is the command-line interface for Fault Management.

This page documents the :command:`fm` command in StarlingX R3.0.

.. contents::
   :local:
   :depth: 2

--------
fm usage
--------

::

  fm [--version] [--debug] [-v] [--timeout TIMEOUT]
          [--os-username OS_USERNAME] [--os-password OS_PASSWORD]
          [--os-tenant-id OS_TENANT_ID] [--os-tenant-name OS_TENANT_NAME]
          [--os-auth-url OS_AUTH_URL] [--os-region-name OS_REGION_NAME]
          [--os-auth-token OS_AUTH_TOKEN] [--fm-url FM_URL]
          [--fm-api-version FM_API_VERSION]
          [--os-service-type OS_SERVICE_TYPE]
          [--os-endpoint-type OS_ENDPOINT_TYPE]
          [--os-user-domain-id OS_USER_DOMAIN_ID]
          [--os-user-domain-name OS_USER_DOMAIN_NAME]
          [--os-project-id OS_PROJECT_ID] [--os-project-name OS_PROJECT_NAME]
          [--os-project-domain-id OS_PROJECT_DOMAIN_ID]
          [--os-project-domain-name OS_PROJECT_DOMAIN_NAME]
          <subcommand> ...

For a list of all :command:`fm` subcommands and options, enter:

::

  fm help

-----------
Subcommands
-----------

For a full description of usage and optional arguments for a specific
:command:`fm` command, enter:

::

  fm help COMMAND

***********************
Alarm and event display
***********************

The fault management (fm) alarm and event type commands enable the display of
active alarms and historical events.

``alarm-delete``
	Delete an active alarm.

``alarm-list``
	List all active alarms.

  An active alarm is an alarm that is currently set and typically needs operator
  attention in order to clear the alarm.

``alarm-show``
	Show an active alarm.

  An active alarm is an alarm that is currently set and typically needs operator
  attention in order to clear the alarm.

``alarm-summary``
	Show a summary of active alarms.

``event-list``
	List event logs. Displays alarm sets, alarm clears, and customer log type events.

``event-show``
	Show a event log. Displays alarm sets, alarm clears, and customer log type events.

``event-suppress``
	Suppress specified event IDs.

``event-suppress-list``
	List Suppressed event IDs

``event-unsuppress``
	Unsuppress specified event IDs.

``event-unsuppress-all``
	Unsuppress all event IDs.