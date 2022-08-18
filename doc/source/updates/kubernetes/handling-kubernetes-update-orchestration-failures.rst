
.. jkf1590184623714
.. _handling-kubernetes-update-orchestration-failures:

========================================================
Handle Kubernetes Version Upgrade Orchestration Failures
========================================================

The creation or application of a strategy could fail for any of the listed
reasons described in this section. Follow the suggested actions in each case to
resolve the issue.

.. _jkf1590184623714-section-fhk-nnq-5lb:

-------------------------
Strategy creation failure
-------------------------

.. _jkf1590184623714-ul-fvs-vnq-5lb:

-   **Reason**: Build failed with no reason.

    -   **Action**:

        -   Verify that the ``--worker-apply-type`` was not set to ``ignore``.

        -   Check recent logs added to /var/log/nfv-vim.log.


-   **Reason**: Alarms from platform are present.

    -   **Action**:

        -   Query for management affecting alarms and take actions to clear
            them.

            .. code-block:: none

                ~(keystone_admin)$ fm alarm-list --mgmt_affecting

        -   If there are no management affecting alarms present, take actions
            to clear other reported alarms or try creating the strategy with
            the ``relaxed`` alarms restrictions option ``--alarm-restrictions
            relaxed``.

-   **Reason**: No Kubernetes version upgrade required.

    -   **Action**:

        -   Verify that the Kubernetes patches have been uploaded and applied.
            Verify the version of Kubernetes on the hosts by executing "system
            kube-host-upgrade-list.

            .. note::
               If the strategy create failed, first you must resolve it. You
               must delete the failed strategy before you create another
               strategy.


.. _jkf1590184623714-section-ppt-gpq-5lb:

----------------------
Strategy Apply Failure
----------------------

.. _jkf1590184623714-ul-rdf-4pq-5lb:

-   **Reason**: Alarms from platform are present.

    -   **Action**: This suggests that an alarm has been raised since the
        creation of the strategy. Address the cause of the new alarm, delete the
        strategy and try creating and applying a new strategy.


-   **Reason**: Unable to migrate instances.

    -   **Action**: See :ref:`Kubernetes Version Upgrade Operations Requiring
        Manual Migration
        <kubernetes-update-operations-requiring-manual-migration>` for steps to
        resolve migration issues.

-   **Reason**: Kubernetes version upgrade failed. Suggests that the Kubernetes
    upgrade for the specified host has failed.

    .. only:: starlingx

        -   **Action**: Consult the `StarlingX community
            <https://www.starlingx.io/community/>`_.

    .. only:: partner

        .. include:: /_includes/handling-kubernetes-update-orchestration-failures.rest

-   **Reason**: Lock host failed.

    -   **Action**:

        -   Investigate the ``/var/log/sysinv.log``, and ``/var/log/nfv-vim.log``
            files.

        -   Address the underlying issue.

        -   Manually lock and unlock the host.

        -   Try recreating and re-applying the Kubernetes version upgrade
            strategy to automatically finish the upgrade process.


-   **Reason**: Unlock host failed.

    -   **Action**:

        -   Investigate ``/var/log/mtcAgent.log`` file for cause logs files.

        -   Address the underlying issue.

        -   Manually lock and unlock the host to recover.

        -   Try recreating and re-applying the Kubernetes version upgrade
            strategy to automatically finish the upgrade process.

.. note::
    If the strategy :command:`apply` fails, you must resolve the
    strategy:command:`apply` failure, and delete the failed strategy before
    trying to create and apply another strategy.
