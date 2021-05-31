
.. kad1593196868935
.. _performing-an-orchestrated-upgrade-using-the-cli:

=============================================
Perform an Orchestrated Upgrade Using the CLI
=============================================

The upgrade orchestration CLI is :command:`sw-manager`.

.. rubric:: |context|

.. note::
   To use upgrade orchestration commands, you need administrator privileges.
   You must log in to the active controller as user **sysadmin** and source the
   /etc/platform/openrc script to obtain administrator privileges. Do not use
   **sudo**.

The upgrade strategy options are shown in the following output:

.. code-block:: none

    ~(keystone_admin)]$ sw-manager upgrade-strategy --help
    usage: sw-manager upgrade-strategy [-h]  ...

    optional arguments:
      -h, --help  show this help message and exit

    Software Upgrade Commands:

        create    Create a strategy
        delete    Delete a strategy
        apply     Apply a strategy
        abort     Abort a strategy
        show      Show a strategy

You can perform a partially orchestrated upgrade using the CLI. Upgrade and
stability of the initial controller node must be done manually before using
upgrade orchestration to orchestrate the remaining nodes of the |prod|.

.. note::
    Management-affecting alarms cannot be ignored at the indicated severity
    level or higher by using relaxed alarm rules during an orchestrated upgrade
    operation. For a list of management-affecting alarms, see |fault-doc|:
    :ref:`Alarm Messages <alarm-messages-overview>`. To display
    management-affecting active alarms, use the following command:

    .. code-block:: none

        ~(keystone_admin)]$ fm alarm-list --mgmt_affecting

    During an orchestrated upgrade, the following alarms are ignored even when
    strict restrictions are selected:

    -   900.005, Upgrade in progress

    -   900.201, Software upgrade auto apply in progress

.. _performing-an-orchestrated-upgrade-using-the-cli-ul-qhy-q1p-v1b:

.. rubric:: |prereq|

See :ref:`Upgrading All-in-One Duplex / Standard
<upgrading-all-in-one-duplex-or-standard>` to manually upgrade the initial
controller node before doing the upgrade orchestration described below to
upgrade the remaining nodes of the |prod|.

- The subclouds must use the Redfish platform management service if it is an All-in-one Simplex subcloud.

- Duplex \(AIODX/Standard\) upgrades are supported, and they do not require remote install via Redfish.

.. rubric:: |proc|

.. _performing-an-orchestrated-upgrade-using-the-cli-steps-e45-kh5-sy:

#.  Create a update strategy using the :command:`sw-manager` upgrade-strategy
    command.

    .. code-block:: none

        ~(keystone_admin)]$ sw-manager upgrade-strategy create

    Create an upgrade strategy, specifying the following parameters:


    -   storage-apply-type:


        -   serial \(default\): storage hosts will be upgraded one at a time

        -   parallel: storage hosts will be upgraded in parallel, ensuring that
            only one storage node in each replication group is patched at a
            time.

        -   ignore: storage hosts will not be upgraded

    -   worker-apply-type:

        **serial** \(default\)
           Worker hosts will be upgraded one at a time.

        **ignore**
           Worker hosts will not be upgraded.

    -   Alarm Restrictions

        This option lets you determine how to handle alarm restrictions based
        on the management affecting statuses of any existing alarms, which
        takes into account the alarm type as well as the alarm's current
        severity. If set to relaxed, orchestration will be allowed to proceed
        if there are no management affecting alarms present.

        Performing management actions without specifically relaxing the alarm
        checks will still fail if there are any alarms present in the system
        \(except for a small list of basic alarms for the orchestration actions
        such as an upgrade operation in progress alarm not impeding upgrade
        orchestration\).

        You can use the CLI command :command:`fm alarm-list --mgmt_affecting`
        to view the alarms that are management affecting.

        **Strict**
           Maintains alarm restrictions.

        **Relaxed**
           Relaxes the usual alarm restrictions and allows the action to
           proceed if there are no alarms present in the system with a severity
           equal to or greater than its management affecting severity.

    The upgrade strategy consists of one or more stages, which consist of one
    or more hosts to be upgraded at the same time. Each stage will be split
    into steps \(for example, query-alarms, lock-hosts, upgrade-hosts\).
    Following are some notes about stages:

    -   Controller-0 is upgraded first, followed by storage hosts and then
        worker hosts.

    -   Worker hosts with no instances are upgraded before worker hosts with
        application pods.

    -   Pods will be relocated off each worker host before it is upgraded.

    -   The final step in each stage is one of:

        **system-stabilize**
            This waits for a period of time \(up to several minutes\) and
            ensures that the system is free of alarms. This ensures that we do
            not continue to upgrade more hosts if the upgrade has caused an
            issue resulting in an alarm.

        **wait-data-sync**
           This waits for a period of time \(up to many hours\) and ensures
           that data synchronization has completed after the upgrade of a
           controller or storage node.

    Examine the upgrade strategy. Pay careful attention to:

    -   The sets of hosts that will be upgraded together in each stage.

    -   The sets of pods that will be impacted in each stage.

        .. note::
            It is likely that as each stage is applied, pods will be relocated
            to worker hosts that have not yet been upgraded. That means that
            later stages will be relocating more pods than those originally
            listed in the upgrade strategy. The upgrade strategy is NOT
            updated, but any additional pods on each worker host will be
            relocated before it is upgraded.

#.  Apply the upgrade-strategy. You can optionally apply a single stage at a time.

    .. code-block:: none

        ~(keystone_admin)]$ sw-manager upgrade-strategy apply

    While an upgrade-strategy is being applied, it can be aborted. This results
    in:


    -   The current step will be allowed to complete.

    -   If necessary an abort phase will be created and applied, which will
        attempt to unlock any hosts that were locked.

    After an upgrade-strategy has been applied \(or aborted\) it must be
    deleted before another upgrade-strategy can be created. If an
    upgrade-strategy application fails, you must address the issue that caused
    the failure, then delete/re-create the strategy before attempting to apply
    it again.
