
.. ziu1597089603252
.. _robust-error-handling-during-an-orchestrated-upgrade:

=============================================
Error Handling During An Orchestrated Upgrade
=============================================

This section describes the errors you may encounter during an orchestrated
upgrade and the steps you can use to troubleshoot the errors.

.. rubric:: |prereq|

For a successful orchestrated upgrade, ensure the upgrade prerequisites,
procedure, and postrequisites are met.

If a failure occurs, use the following general steps:


.. _robust-error-handling-during-an-orchestrated-upgrade-ol-l5y-mby-qmb:

#.  Allow the failed strategy to complete on its own.

#.  Check the output using the :command:`dcmanager strategy-step list` command
    for failures, if any.

#.  Address the cause of the failure. For more information, see :ref:`Failure
    During the Installation or Data Migration of N+1 Load on a Subcloud
    <failure-during-the-installation-or-data-migration-of-n+1-load-on-a-subcloud>`.

#.  Retry the orchestrated upgrade. For more information, see :ref:`Distributed
    Upgrade Orchestration Process Using the CLI
    <distributed-upgrade-orchestration-process-using-the-cli>`.

.. note::
    Orchestrated upgrade can be retried for a group of failed subclouds that
    are still **online** using the :command:`upgrade-strategy create --group
    <group-id>` command.
    Failed subclouds that are **offline** must be retried one at a time.

.. seealso::

    :ref:`Failure Prior to the Installation of N+1 Load on a Subcloud
    <failure-prior-to-the-installation-of-n+1-load-on-a-subcloud>`

    :ref:`Failure During the Installation or Data Migration of N+1 Load on a
    Subcloud <failure-during-the-installation-or-data-migration-of-n+1-load-on-a-subcloud>`