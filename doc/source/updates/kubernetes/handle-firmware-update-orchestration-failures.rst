
.. jkf159018462371
.. _handle-firmware-update-orchestration-failures:

=============================================
Handle Firmware Update Orchestration Failures
=============================================

The creation or application of a strategy could fail for any of the listed
reasons described in this section. Follow the suggested actions in each case to
resolve the issue.

-------------------------
Strategy creation failure
-------------------------

.. _jkf1590184623714-ul-fvs-vnq-5lb:

-   **Reason**: build failed with no reason

    -   **Action**:

        -   verify that the **--worker-apply-type** was not set to '**ignore**'

        -   check recent logs added to /var/log/nfv-vim.log

-   **Reason**: alarms from platform are present

    -   **Action**:

        -   query for management affecting alarms and take actions to clear them

            .. code-block:: none

                ~(keystone_admin)$ fm alarm-list --mgmt_affecting

        -   if there are no management affecting alarms present take actions to
            clear other reported alarms or try creating the strategy with the
            '**relaxed**' alarms restrictions option **--alarm-restrictions
            relaxed**

-   **Reason**: no firmware update required

    -   **Action**:

        -   verify that the firmware device image has been applied for the
            worker hosts that require updating

            .. note::
                If the strategy create failed. After resolving the strategy
                create failure you must delete the failed strategy before
                trying to create another strategy.

----------------------
Strategy apply failure
----------------------

.. _jkf1590184623714-ul-rdf-4pq-5lb:

-   **Reason**: alarms from platform are present

    -   **Action**: suggests that an alarm has been raised since the creation
        of the strategy. Address the cause of the new alarm, delete the strategy
        and try creating and applying a new strategy

-   **Reason**: unable to migrate instances

    -   **Action**: See :ref:`Firmware Update Operations Requiring Manual
        Migration <firmware-update-operations-requiring-manual-migration>` for
        steps to resolve migration issues.

-   **Reason**: firmware update failed. Suggests that the firmware update for
    the specified host has failed

    -   **Action**: For more information, see |prod| Node Management:
        :ref:`Display Worker Host Information <displaying-worker-host-information>`

-   **Reason**: lock host failed

    -   **Action**:

        -   investigate the /var/log/sysinv.log, and /var/log/nfv-vim.log files

        -   address the underlying issue

        -   manually lock and unlock the host

        -   try recreating and re-applying the firmware update strategy to
            automatically finish the update process

-   **Reason**: unlock host failed

    -   **Action**:

        -   investigate /var/log/mtcAgent.log file for cause logs files

        -   address the underlying issue

        -   manually lock and unlock the host to recover

        -   try recreating and re-applying the firmware update strategy to
            automatically finish the update process

.. note::
    If the strategy :command:`apply` fails, you must resolve the
    strategy:command:`apply` failure, and delete the failed strategy before
    trying to create and apply another strategy.

