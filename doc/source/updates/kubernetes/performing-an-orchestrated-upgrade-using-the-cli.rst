
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
   ``/etc/platform/openrc`` script to obtain administrator privileges. Do not use
   :command:`sudo`.

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

You can perform a partially orchestrated upgrade using the |CLI|. Upgrade
orchestration of other |prod| nodes can be initiated after the initial
controller host has been manually upgraded and returned to a stability state.

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

    -   900.005, Upgrade in progress

    -   900.201, Software upgrade auto apply in progress

.. _performing-an-orchestrated-upgrade-using-the-cli-ul-qhy-q1p-v1b:

.. rubric:: |prereq|

See :ref:`Upgrading All-in-One Duplex / Standard
<upgrading-all-in-one-duplex-or-standard>`, and perform Steps 1-8, to manually
upgrade the initial controller node before doing the upgrade orchestration
described below to upgrade the remaining nodes of the |prod|.

- The subclouds must use the Redfish platform management service if it is an
  All-in-one Simplex subcloud.

- Duplex (AIODX/Standard) upgrades are supported, and they do not require
  remote install via Redfish.

.. rubric:: |proc|

.. _performing-an-orchestrated-upgrade-using-the-cli-steps-e45-kh5-sy:

#.  Create a update strategy using the :command:`sw-manager upgrade-strategy create`
    command.

    .. code-block:: none

        ~(keystone_admin)]$ sw-manager upgrade-strategy create

        strategy-uuid:                          5435e049-7002-4403-acfb-7886f6da14af
        controller-apply-type:                  serial
        storage-apply-type:                     serial
        worker-apply-type:                      serial
        default-instance-action:                migrate
        alarm-restrictions:                     strict
        current-phase:                          build
        current-phase-completion:               0%
        state:                                  building
        inprogress:                             true

    Create an upgrade strategy, specifying the following parameters:

    -   storage-apply-type:

        -   ``serial`` (default): storage hosts will be upgraded one at a time

        -   ``parallel``: storage hosts will be upgraded in parallel, ensuring that
            only one storage node in each replication group is patched at a
            time.

        -   ``ignore``: storage hosts will not be upgraded

    -   worker-apply-type:

        ``serial`` (default)
           Worker hosts will be upgraded one at a time.

        ``ignore``
           Worker hosts will not be upgraded.

    -   Alarm Restrictions

        This option lets you determine how to handle alarm restrictions based
        on the management affecting statuses of any existing alarms, which
        takes into account the alarm type as well as the alarm's current
        severity. If set to relaxed, orchestration will be allowed to proceed
        if there are no management affecting alarms present.

        Performing management actions without specifically relaxing the alarm
        checks will still fail if there are any alarms present in the system
        (except for a small list of basic alarms for the orchestration actions
        such as an upgrade operation in progress alarm not impeding upgrade
        orchestration).

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
    into steps (for example, query-alarms, lock-hosts, upgrade-hosts).
    Following are some notes about stages:

    -   Controller-0 is upgraded first, followed by storage hosts and then
        worker hosts.

    -   Worker hosts with no instances are upgraded before worker hosts with
        application pods.

    -   Pods will be relocated off each worker host before it is upgraded.

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
            It is likely that as each stage is applied, pods will be relocated
            to worker hosts that have not yet been upgraded. That means that
            later stages will be relocating more pods than those originally
            listed in the upgrade strategy. The upgrade strategy is NOT
            updated, but any additional pods on each worker host will be
            relocated before it is upgraded.

#.  Run :command:`sw-manager upgrade-strategy show` command, to display the
    current-phase-completion percentage progress indicator in various
    increments. Once at 100%, it returns:

    .. code-block:: none

        ~(keystone_admin)]$ sw-manager upgrade-strategy show

        strategy-uuid:                          5435e049-7002-4403-acfb-7886f6da14af
        controller-apply-type:                  serial
        storage-apply-type:                     serial
        worker-apply-type:                      serial
        default-instance-action:                migrate
        alarm-restrictions:                     strict
        current-phase:                          build
        current-phase-completion:               100%
        state:                                  ready-to-apply
        build-result:                           success
        build-reason:

#.  Apply the upgrade strategy. You can optionally apply a single stage at a
    time.

    .. code-block:: none

        ~(keystone_admin)]$ sw-manager upgrade-strategy apply

        strategy-uuid:                          5435e049-7002-4403-acfb-7886f6da14af
        controller-apply-type:                  serial
        storage-apply-type:                     serial
        worker-apply-type:                      serial
        default-instance-action:                migrate
        alarm-restrictions:                     strict
        current-phase:                          apply
        current-phase-completion:               0%
        state:                                  applying
        inprogress:                             true

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

#.  Run :command:`sw-manager upgrade-strategy show` command, to display the
    current-phase-completion displaying the field goes from 0% to 100% in
    various increments. Once at 100%, it returns:

    .. code-block:: none

        ~(keystone_admin)]$ sw-manager upgrade-strategy show

        strategy-uuid:                          b91d8332-9ece-4578-b4dd-e9cf87b73f18
        controller-apply-type:                  serial
        storage-apply-type:                     serial
        worker-apply-type:                      serial
        default-instance-action:                migrate
        alarm-restrictions:                     strict
        current-phase:                          apply
        current-phase-completion:               100%
        state:                                  applied
        apply-result:                           success
        apply-reason:

#.  Activate the upgrade.

    During the running of the :command:`upgrade-activate` command, new
    configurations are applied to the controller. 250.001 (**hostname
    Configuration is out-of-date**) alarms are raised and are cleared as the
    configuration is applied. The upgrade state goes from **activating** to
    **activation-complete** once this is done.

    .. code-block:: none

        ~(keystone_admin)]$ system upgrade-activate
        +--------------+--------------------------------------+
        | Property     | Value                                |
        +--------------+--------------------------------------+
        | uuid         | 61e5fcd7-a38d-40b0-ab83-8be55b87fee2 |
        | state        | activating                           |
        | from_release | nn.nn                                |
        | to_release   | nn.nn                                |
        +--------------+--------------------------------------+

    The following states apply when this command is executed.

    **activation-requested**
        State entered when :command:`system upgrade-activate` is executed.

    **activating**
        State entered when we have started activating the upgrade by applying
        new configurations to the controller and compute hosts.

    **activation-complete**
        State entered when new configurations have been applied to all
        controller and compute hosts.

#.  Check the status of the upgrade again to see it has reached
    **activation-complete**

    .. code-block:: none

        ~(keystone_admin)]$ system upgrade-show
        +--------------+--------------------------------------+
        | Property     | Value                                |
        +--------------+--------------------------------------+
        | uuid         | 61e5fcd7-a38d-40b0-ab83-8be55b87fee2 |
        | state        | activation-complete                  |
        | from_release | nn.nn                                |
        | to_release   | nn.nn                                |
        +--------------+--------------------------------------+

#.  Complete the upgrade.

    .. code-block:: none

        ~(keystone_admin)]$ system upgrade-complete
        +--------------+--------------------------------------+
        | Property     | Value                                |
        +--------------+--------------------------------------+
        | uuid         | 61e5fcd7-a38d-40b0-ab83-8be55b87fee2 |
        | state        | completing                           |
        | from_release | nn.nn                                |
        | to_release   | nn.nn                                |
        +--------------+--------------------------------------+

#.  Delete the imported load.

    .. code-block:: none

        ~(keystone_admin)]$ system load-list
        +----+----------+------------------+
        | id | state    | software_version |
        +----+----------+------------------+
        | 1  | imported | nn.nn            |
        | 2  | active   | nn.nn            |
        +----+----------+------------------+

        ~(keystone_admin)]$ system load-delete 1
        Deleted load: load 1

.. only:: partner

    .. include:: /_includes/performing-an-orchestrated-upgrade-using-the-cli.rest
        :start-after: Orchupgradecli-begin
        :end-before: Orchupgradecli-end
