
.. sab1593196680415
.. _performing-an-orchestrated-upgrade:

===============================
Perform an Orchestrated Upgrade
===============================

You can perform a partially orchestrated Upgrade of a |prod| system using the
CLI and Horizon Web interface. Upgrade and stability of the initial controller
node must be done manually before using upgrade orchestration to orchestrate the
remaining nodes of the |prod|.

.. rubric:: |context|

.. note::
    Management-affecting alarms cannot be ignored at the indicated severity
    level or higher by using relaxed alarm rules during an orchestrated upgrade
    operation. For a list of management-affecting alarms, see |fault-doc|:
    :ref:`alarm-messages-overview-19c242d3d151`. To display
    management-affecting active alarms, use the following command:

    .. code-block:: none

        ~(keystone_admin)]$ fm alarm-list --mgmt_affecting

    During an orchestrated upgrade, the following alarms are ignored even when
    strict restrictions are selected:

    -   750.006, Generic alarm for any platform-managed applications as they are auto-applied

    -   900.005, Upgrade in progress

    -   900.201, Software upgrade auto apply in progress

.. _performing-an-orchestrated-upgrade-ul-qhy-q1p-v1b:

.. rubric:: |prereq|

See :ref:`Upgrading All-in-One Duplex / Standard
<upgrading-all-in-one-duplex-or-standard>`, and perform Steps 1-8, to manually
upgrade the initial controller node before doing the upgrade orchestration
described below to upgrade the remaining nodes of the |prod| system.

.. rubric:: |proc|

.. _performing-an-orchestrated-upgrade-steps-e45-kh5-sy:

#.  Select **Platform** \> **Software Management**, then select the **Upgrade
    Orchestration** tab.

#.  Click the **Create Strategy** button.

    The **Create Strategy** dialog appears.

#.  Create an upgrade strategy by specifying settings for the parameters in the
    **Create Strategy** dialog box.

    Create an upgrade strategy, specifying the following parameters:

    -   storage-apply-type:

        ``serial`` (default)
           Storage hosts will be upgraded one at a time.

        ``parallel``
           Storage hosts will be upgraded in parallel, ensuring that only one
           storage node in each replication group is upgraded at a time.

        ``ignore``
           Storage hosts will not be upgraded.

    -   worker-apply-type:

        ``serial`` (default):
           Worker hosts will be upgraded one at a time.

        ``parallel``
           Worker hosts will be upgraded in parallel, ensuring that:

           -   At most max-parallel-worker-hosts (see below) worker hosts
               will be upgraded at the same time.

           -   At most half of the hosts in a host aggregate will be upgraded
               at the same time.

           -   Worker hosts with no application pods are upgraded before
               worker hosts with application pods.

        ``ignore``
           Worker hosts will not be upgraded.

        ``max-parallel-worker-hosts``
           Specify the maximum worker hosts to upgrade in parallel (minimum:
           2, maximum: 10).

           .. note::
               For a maximum worker hosts condition in a Standard configuration
               (50), the value shall be at the maximum 2, which represents the
               minimum value.

        ``alarm-restrictions``
            This option lets you specify how upgrade orchestration behaves when
            alarms are present.

            You can use the CLI command :command:`fm alarm-list
            --mgmt_affecting` to view the alarms that are management affecting.

            ``Strict``
               The default strict option will result in upgrade orchestration
               failing if there are any alarms present in the system (except
               for a small list of alarms).

            ``Relaxed``
               This option allows orchestration to proceed if alarms are
               present, as long as none of these alarms are management
               affecting.

#.  Click **Create Strategy** to save the upgrade orchestration strategy.

    The upgrade strategy consists of one or more stages, which consist of one
    or more hosts to be upgraded at the same time. Each stage will be split
    into steps (for example, query-alarms, lock-hosts, upgrade-hosts).
    Following are some notes about stages:

    -   Controller-0 is upgraded first, followed by storage hosts and then
        worker hosts.

    -   Worker hosts with no application pods are upgraded before worker hosts
        with application pods.

    -   Pods will be moved off each worker host before it is upgraded.

    -   The final step in each stage is one of:

        **system-stabilize**
           This waits for a period of time (up to several minutes) and
           ensures that the system is free of alarms. This ensures that we do
           not continue to upgrade more hosts if the upgrade has caused an
           issue resulting in an alarm.

        **wait-data-sync**
           This waits for a period of time (up to many hours) and ensures
           that data synchronization has completed after the upgrade of a
           controller or storage node.

    Examine the upgrade strategy. Pay careful attention to:

    -   The sets of hosts that will be upgraded together in each stage.

    -   The sets of pods that will be impacted in each stage.

        .. note::
            It is likely that as each stage is applied, application pods will
            be relocated to worker hosts that have not yet been upgraded. That
            means that later stages will be migrating more pods than those
            originally listed in the upgrade strategy. The upgrade strategy is
            NOT updated, but any additional pods on each worker host will be
            relocated before it is upgraded.

#.  Apply the upgrade strategy. You can optionally apply a single stage at a
    time.

    While an upgrade strategy is being applied, it can be aborted. This results
    in:

    -   The current step will be allowed to complete.

    -   If necessary an abort phase will be created and applied, which will
        attempt to unlock any hosts that were locked.

    After an upgrade strategy has been applied (or aborted) it must be
    deleted before another upgrade strategy can be created. If an
    upgrade strategy application fails, you must address the issue that caused
    the failure, then delete/re-create the strategy before attempting to apply
    it again.

For more information, see: :ref:`Perform an Orchestrated Upgrade Using the CLI <performing-an-orchestrated-upgrade-using-the-cli>`

.. only:: partner

    .. include:: /_includes/performing-an-orchestrated-upgrade.rest
       :start-after: Orchupgrade-begin
       :end-before: Orchupgrade-end
