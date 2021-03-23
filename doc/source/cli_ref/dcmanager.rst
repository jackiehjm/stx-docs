=========
dcmanager
=========

:command:`dcmanager` is the command-line interface for the |prod-dc|
Manager APIs. :command:`dcmanager` is applicable only in the `SystemController`
region of the central cloud in a distributed cloud configuration.

This page documents the :command:`dcmanager` command in StarlingX R3.0.

.. contents::
   :local:
   :depth: 2

---------------
dcmanager usage
---------------

::

   dcmanager [--version] [-v] [--log-file LOG_FILE] [-q] [-h] [--debug]
                 [--dcmanager-url DCMANAGER_URL]
                 [--dcmanager-api-version DCMANAGER_VERSION]
                 [--dcmanager-service-type SERVICE_TYPE]
                 [--os-endpoint-type ENDPOINT_TYPE] [--os-username USERNAME]
                 [--os-password PASSWORD] [--os-tenant-id TENANT_ID]
                 [--os-project-id PROJECT_ID] [--os-tenant-name TENANT_NAME]
                 [--os-project-name PROJECT_NAME] [--os-auth-token TOKEN]
                 [--os-project-domain-name PROJECT_DOMAIN_NAME]
                 [--os-project-domain-id PROJECT_DOMAIN_ID]
                 [--os-user-domain-name USER_DOMAIN_NAME]
                 [--os-user-domain-id USER_DOMAIN_ID] [--os-auth-url AUTH_URL]
                 [--os-cacert CACERT] [--insecure] [--profile HMAC_KEY]
                 <subcommand> ...

For a list of all :command:`dcmanager` subcommands and options, enter:

::

  dcmanager help

-----------
Subcommands
-----------

For a full description of usage and optional arguments for a specific
:command:`dcmanager` command, enter:

::

  dcmanager help COMMAND

************************************
Distributed cloud centralized alarms
************************************

Displays the aggregated counts of critical, major, minor, and warning alarms
across all subclouds.

``alarm summary``
	List alarm summaries of subclouds.

***************************************
Distributed cloud subcloud installation
***************************************

This set of commands provides subcloud management, including basic add, delete,
list, show, and update operations on a subcloud.

``subcloud add``
  Add a new subcloud.

  Note that this command will create the subcloud in the central cloud's
  database, run the Ansible bootstrap playbook on the new subcloud, and
  optionally run a deployment playbook.

``subcloud delete``
	Delete subcloud details from the database.

``subcloud-deploy upload``
    Upload the optional deployment playbook, helm chart, and overrides to be
    used with ``subcloud add``.

``subcloud list``
	List subclouds.

``subcloud manage``
	Manage a subcloud. Enables the active synchronization of data between the
	central cloud and the subcloud.

``subcloud reconfig``
  Re-run the deployment playbook on a subcloud using an updated configuration
  file.

``subcloud show``
	Show the details of a subcloud.

``subcloud unmanage``
	Unmanage a subcloud. Disables the active synchronization of data between the
	central cloud and the subcloud.

``subcloud update``
	Update attributes of a subcloud.

***********************************
Distributed cloud patching/updating
***********************************

.. important::

   The following commands are not supported upstream.

The :command:`patch-strategy` commands create, apply, and monitor the
orchestration of software patch application (or updates) across all subclouds
and all hosts of subclouds. :command:`patch-strategy` commands orchestrate
software updates across an entire distributed cloud solution.

``patch-strategy abort``
	Abort a patch strategy.

``patch-strategy apply``
	Apply a patch strategy.

``patch-strategy create``
	Create a patch strategy.

``patch-strategy delete``
	Delete patch strategy from the database.

``patch-strategy show``
	Show the details of a patch strategy for a subcloud.

``patch-strategy-config delete``
	Delete per subcloud patch options.

``patch-strategy-config list``
	List patch options.

``patch-strategy-config show``
	Show patch options, defaults or per subcloud.

``patch-strategy-config update``
	Update patch options, defaults or per subcloud.

``strategy-step list``
	List strategy steps.

``strategy-step show``
	Show the details of a strategy step.
