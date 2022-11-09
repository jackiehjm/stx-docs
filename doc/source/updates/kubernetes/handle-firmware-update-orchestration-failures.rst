
.. jkf159018462371
.. _handle-firmware-update-orchestration-failures:

=============================================
Handle Firmware Update Orchestration Failures
=============================================

The creation or application of a strategy could fail for any of the reasons
listed below. Follow the suggested actions in each case to resolve the issue.

-------------------------
Strategy creation failure
-------------------------

.. _jkf1590184623714-ul-fvs-vnq-5lb:

-   **Reason**: build failed with no reason

    -   **Action**:

        -   Verify that the ``--worker-apply-type`` was not set to ``ignore``.

        -   Check recent logs added to ``/var/log/nfv-vim.log``.

-   **Reason**: alarms from platform are present

    -   **Action**:

        -   Query for management affecting alarms and take actions to clear them.

            .. code-block:: none

                ~(keystone_admin)$ fm alarm-list --mgmt_affecting

        -   If there are no management affecting alarms present take actions to
            clear other reported alarms or try creating the strategy with the
            '**relaxed**' alarms restrictions option ``--alarm-restrictions
            relaxed``.

-   **Reason**: no firmware update required

    -   **Action**:

        -   Verify that the firmware device image has been applied for the
            worker hosts that require updating.

            .. note::
                If the strategy create failed. After resolving the strategy
                create failure you must delete the failed strategy before
                trying to create another strategy.

----------------------
Strategy apply failure
----------------------

.. _jkf1590184623714-ul-rdf-4pq-5lb:

-   **Reason**: Alarms from platform are present.

    -   **Action**: This suggests that an alarm has been raised since the
        creation of the strategy. Address the cause of the new alarm, delete the
        strategy and try creating and applying a new strategy.

-   **Reason**: Unable to migrate instances.

    -   **Action**: See :ref:`Firmware Update Operations Requiring Manual
        Migration <firmware-update-operations-requiring-manual-migration>` for
        steps to resolve migration issues.

-   **Reason**: Firmware update failed. Suggests that the firmware update for
    the specified host has failed

    -   **Action**: For more information, see |prod| Node Management:
        :ref:`Display Worker Host Information <displaying-worker-host-information>`

-   **Reason**: Lock host failed.

    -   **Action**:

        -   Investigate the ``/var/log/sysinv.log``, and
            ``/var/log/nfv-vim.log`` files.

        -   Address the underlying issue.

        -   Manually lock and unlock the host.

        -   Try recreating and re-applying the firmware update strategy to
            automatically finish the update process.

-   **Reason**: Unlock host failed.

    -   **Action**:

        -   Investigate the ``/var/log/mtcAgent.log`` file for cause logs files

        -   Address the underlying issue.

        -   Manually lock and unlock the host to recover.

        -   Try recreating and re-applying the firmware update strategy to
            automatically finish the update process.

.. note::
    If the strategy :command:`apply` fails, you must resolve the
    strategy:command:`apply` failure and delete the failed strategy before
    trying to create and apply another strategy.

