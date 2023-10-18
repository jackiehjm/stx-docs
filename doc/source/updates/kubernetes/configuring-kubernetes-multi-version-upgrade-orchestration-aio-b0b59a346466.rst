.. _configuring-kubernetes-multi-version-upgrade-orchestration-aio-b0b59a346466:

=========================================================================
Configure Kubernetes Multi-Version Upgrade Cloud Orchestration for AIO-SX
=========================================================================

You can configure Kubernetes multi-version upgrade orchestration strategy using
the :command:`sw-manager` command. This feature is enabled from
|prod| |k8s-multi-ver-orch-strategy-release| and is supported only for the |AIO-SX| system.

.. note::

    You require administrator privileges to use the :command:`sw-manager` command.
    You must log in to the active controller as **user sysadmin** and source the script
    by using the :command:`source /etc/platform/openrc` command to obtain administrator
    privileges. Do not use :command:`sudo`.

.. note::

    Management-affecting alarms cannot be ignored using relaxed alarm rules
    during an orchestrated Kubernetes version upgrade operation. For a list of
    management-affecting alarms, see |fault-doc|: :ref:`100-series-alarm-messages-starlingx`.
    To display management-affecting active alarms, use the :command:`fm alarm-list --mgmt_affecting`
    command.

During an orchestrated Kubernetes version upgrade operation, the following
alarms are ignored even when the default strict restrictions are selected:

.. _noc1590162360081-ul-vhg-jxs-tlb:

- 100.103: Memory threshold exceeded

- 200.001: Locked host

- 280.001: Subcloud resource off-line

- 280.002: Subcloud resource out-of-sync

- 700.004: |VM| stopped

- 750.006: Configuration change requires reapply of cert-manager

- 900.001: Patch in progress

- 900.007: Kube upgrade in progress

- 900.401: kube-upgrade-auto-apply-inprogress


You can use ``help`` for the overall commands and also for each sub-command.

For example:

.. code-block:: none

    ~(keystone_admin)$ sw-manager kube-upgrade-strategy –help
    usage: sw-manager kube-upgrade-strategy [-h]  ...
    optional arguments:
      -h, --help  show this help message and exit
    Kubernetes Update Commands:
        create    Create a strategy
        delete    Delete a strategy
        apply     Apply a strategy
        abort     Abort a strategy
        show      Show a strategy

.. rubric:: |prereq|

.. _noc1590162360081-ul-ls2-pxs-tlb:

-   Hosts that need to be upgraded must be in the **unlocked-enabled** state.

-   If you are using NetApp Trident, ensure that your NetApp version is
    compatible with Trident 22.07 before upgrading Kubernetes to version
    |kube-ver| and after updating |prod| to version |prod-ver|. For more
    information, see :ref:`upgrade-the-netapp-trident-software-c5ec64d213d3`.

.. only:: partner

   .. include:: /_includes/configuring-kubernetes-update-orchestration.rest

.. rubric:: |proc|

#. List available upgrades.

   .. code-block:: none

      ~(keystone_admin)$ system kube-version-list
       +-----------------+--------+-------------+
       | Version         | Target | State       |
       +-----------------+--------+-------------+
       | v1.21.8         | True   | active      |
       | v1.22.5         | False  | available   |
       | v1.23.1         | False  | available   |
       | v1.24.4         | False  | available   |
       +-----------------+--------+-------------+

#.  Confirm that the system is healthy.

    Check the current system health status, resolve any alarms and other issues
    reported by the :command:`system health-query-kube-upgrade` command. Then,
    recheck the system health status to confirm that all **System Health**
    fields are set to **OK**.

    By default, the upgrade process cannot be run and is not recommended to be
    run with active alarms present. Use the :command:`system kube-upgrade-start --force`
    command to force the upgrade process to start and ignore non-management-affecting
    alarms.

    .. note::

        It is strongly recommended that you clear your system of all alarms
        before doing an upgrade. While the :command:`--force` option is
        available to run the upgrade, it is a best practice to clear any
        alarms.

    .. code-block:: none

        ~(keystone_admin)]$ system health-query-kube-upgrade
            System Health:
            All hosts are provisioned: [OK]
            All hosts are unlocked/enabled: [OK]
            All hosts have current configurations: [OK]
            All hosts are patch current: [OK]
            No alarms: [OK]
            All kubernetes nodes are ready: [OK]
            All kubernetes control plane pods are ready: [OK]
            All kubernetes applications are in a valid state: [OK]

#.  Create the strategy.

    The Kubernetes multi-version upgrade orchestration strategy :command:`create`
    command creates a series of stages with steps that apply the Kubernetes
    version upgrade.

    Specify the desired Kubernetes version in ``--to-version``
    (usually the highest version available in the system).

    .. code-block:: none

        ~(keystone_admin)$ sw-manager kube-upgrade-strategy create --to-version v1.24.4
        Strategy Kubernetes Upgrade Strategy:
          strategy-uuid:                          f03f5944-ee79-4047-8d2e-68bfa6775210
          controller-apply-type:                  serial
          storage-apply-type:                     serial
          worker-apply-type:                      serial
          default-instance-action:                stop-start
          alarm-restrictions:                     strict
          current-phase:                          build
          current-phase-completion:               0%
          state:                                  building
          inprogress:                             true

    where:

    ``--to-version``
       The version of Kubernetes to upgrade to, for example, ``v1.24.4``.
       This argument is required.

    ``--controller-apply-type`` and ``--storage-apply-type``
       These options cannot be changed from ``serial`` because Kubernetes
       upgrade concurrency is only supported for worker hosts.

       .. note::

          Setting the Kubernetes version upgrade apply type is supported only
          for hosts with the worker function. Any attempt to modify the
          controller or storage apply type will be rejected.

    ``--worker-apply-type``
       This option specifies the host concurrency of the Kubernetes version
       upgrade strategy:

       -   serial (default): worker hosts will be patched one at a time

       -   parallel: worker hosts will be upgraded in parallel

           -   At most, ``parallel`` will be upgraded at the same time

           -   At most, half of the hosts in a host aggregate will be upgraded
               at the same time

       -   ignore: worker hosts will not be upgraded; strategy create will fail

       Worker hosts with no instances are upgraded before worker hosts with
       instances.

    ``--max-parallel-worker-hosts``
       This option applies to the parallel worker apply type selection to
       specify the maximum worker hosts to upgrade in parallel (minimum: 2, maximum: 10).

    ``--alarm-restrictions``
       This option sets how the Kubernetes version upgrade orchestration
       behaves when alarms are present.

       To display management-affecting active alarms, use the :command:`fm alarm-list --mgmt_affecting` command.

    ``strict`` (default)
       The default strict option will result in the failure of patch orchestration if
       there are any alarms present in the system (except for a small list of alarms).

    ``relaxed``
       This option allows orchestration to proceed even if alarms are present, as
       long as none of these alarms are management affecting.

    .. code-block:: none

       ~(keystone_admin)]$ sw-manager kube-upgrade-strategy create --help
       usage:sw-manager kube-upgrade-strategy  [-h]
                                                --to-version <kubernetesVersion>
                                                [--controller-apply-type {ignore}]
                                                [--storage-apply-type {ignore}]
                                                [--worker-apply-type
                                                {serial,parallel,ignore}]
                                                [--max-parallel-worker-hosts
                                                {2,3,4,5,6,7,8,9,10}]
                                                [--instance-action {migrate,stop-start}]
                                                [--alarm-restrictions {strict,relaxed}]

       optional arguments:
         -h, --help            show this help message and exit
         --controller-apply-type {serial,ignore}
                            defaults to serial
         --storage-apply-type {serial,ignore}
                            defaults to serial
         --worker-apply-type {serial,parallel,ignore}
                            defaults to serial
         --max-parallel-worker-hosts {2,3,4,5,6,7,8,9,10}
                            maximum worker hosts to update in parallel
         --instance-action {migrate,stop-start}
                            defaults to stop-start
         --alarm-restrictions {strict,relaxed}
                            defaults to strict


#.  |optional| Display the strategy in summary, if required. The Kubernetes
    upgrade strategy :command:`show` command displays the strategy in a summary.

    .. code-block:: none

        ~(keystone_admin)$ sw-manager kube-upgrade-strategy show
          Strategy Kubernetes Upgrade Strategy:
          strategy-uuid:                          f03f5944-ee79-4047-8d2e-68bfa6775210
          controller-apply-type:                  serial
          storage-apply-type:                     serial
          worker-apply-type:                      serial
          default-instance-action:                stop-start
          alarm-restrictions:                     strict
          current-phase:                          build
          current-phase-completion:               100%
          state:                                  ready-to-apply
          build-result:                           success
          build-reason:

    The :command:`show` strategy subcommand displays a summary of the current
    state of the strategy. A complete view of the strategy can be shown using
    the ``--details`` option.

    The strategy steps and stages are displayed using the ``--details`` option.

#.  Apply the strategy.

    Kubernetes multi-version upgrade orchestration strategy :command:`apply` command
    runs the strategy stages and steps consecutively until the Kubernetes
    upgrade on all the hosts in the strategy is completed.


    -   Use the ``-stage-id`` option to specify a specific stage to apply one
        at a time.

        .. note::

            When applying a single stage, only the next stage will be applied.
            You cannot skip stages.

    .. code-block:: none

        ~(keystone_admin)$ sw-manager kube-upgrade-strategy apply
        Strategy Kubernetes upgrade Strategy:
          strategy-uuid:                          f03f5944-ee79-4047-8d2e-68bfa6775210
          controller-apply-type:                  serial
          storage-apply-type:                     serial
          worker-apply-type:                      serial
          default-instance-action:                stop-start
          alarm-restrictions:                     strict
          current-phase:                          apply
          current-phase-completion:               0%
          state:                                  applying
          inprogress:                             true

    -   Use the :command:`kube-upgrade-show` command to monitor Kubernetes
        upgrade state and percentage completion.

    .. code-block:: none

        ~(keystone_admin)$ system kube-upgrade-show
        +--------------+--------------------------------------+
        | Property     | Value                                |
        +--------------+--------------------------------------+
        | uuid         | 1272e9cc-1a15-4a53-bb5a-d47494729068 |
        | from_version | v1.21.8                              |
        | to_version   | v1.24.4                              |
        | state        | downloading-images                   |
        | created_at   | 2023-09-25T18:32:10.820488+00:00     |
        | updated_at   | 2023-09-25T18:32:10.885709+00:00     |
        +--------------+--------------------------------------+

    You will see the ``state`` property transition through values, such as
    ``downloading-images``, ``downloaded-images``, ``upgraded-networking``,
    and ``upgraded-first-master``.

#.  |optional| Abort the strategy, if required. This is only used to stop and
    abort the entire strategy.

    The Kubernetes version upgrade strategy :command:`abort` command can be
    used to abort the Kubernetes version upgrade strategy after the current
    step of the currently applying stage is completed.

#.  Confirm that the upgrade has completed successfully.

    .. code-block:: none

       ~(keystone_admin)$ system kube-upgrade-show
       +--------------+--------------------------------------+
       | Property     | Value                                |
       +--------------+--------------------------------------+
       | uuid         | 1272e9cc-1a15-4a53-bb5a-d47494729068 |
       | from_version | v1.21.8                              |
       | to_version   | v1.24.4                              |
       | state        | upgrade-complete                     |
       | created_at   | 2023-09-25T18:52:10.885709+00:00     |
       | updated_at   | 2023-09-25T18:52:11.673259+00:00     |
       +--------------+--------------------------------------+

       ~(keystone_admin)$ system kube-version-list
       +-----------------+--------+-------------+
       | Version         | Target | State       |
       +-----------------+--------+-------------+
       | v1.21.8         | False  | unavailable |
       | v1.22.5         | False  | unavailable |
       | v1.23.1         | False  | unavailable |
       | v1.24.4         | True   | active      |
       +-----------------+--------+-------------+

#.  Delete the strategy.

    .. note::

        After the Kubernetes multi-version upgrade orchestration strategy has been
        applied (or aborted), it must be deleted before another Kubernetes
        version upgrade strategy can be created. If a Kubernetes version
        upgrade strategy application fails, you must address the issue that
        caused the failure, then delete and re-create the strategy before
        attempting to apply it again.

    .. code-block:: none

        ~(keystone_admin)$ sw-manager kube-upgrade-strategy delete
        Strategy deleted.