
.. noc1590162360081
.. _configuring-kubernetes-update-orchestration:

==============================================================
Create Kubernetes Version Upgrade Cloud Orchestration Strategy
==============================================================

You can configure *Kubernetes Version Upgrade Orchestration Strategy* using the
:command:`sw-manager` CLI.

.. note::
    You require administrator privileges to use :command:`sw-manager`. You must
    log in to the active controller as **user sysadmin** and source the script
    by using the command, source ``/etc/platform/openrc`` to obtain administrator
    privileges. Do not use :command:`sudo`.

.. note::
    Management-affecting alarms cannot be ignored using relaxed alarm rules
    during an orchestrated Kubernetes version upgrade operation. For a list of
    management-affecting alarms, see |fault-doc|: :ref:`Alarm Messages
    <100-series-alarm-messages>`. To display management-affecting active
    alarms, use the following command:

    .. code-block:: none

        ~(keystone_admin)$ fm alarm-list --mgmt_affecting

During an orchestrated Kubernetes version upgrade operation, the following
alarms are ignored even when the default strict restrictions are selected:


.. _noc1590162360081-ul-vhg-jxs-tlb:

- 100.103: Memory threshold exceeded.

- 200.001: Locked host.

- 280.001: Subcloud resource off-line.

- 280.002: Subcloud resource out-of-sync.

- 700.004: |VM| stopped.

- 750.006: Configuration change requires reapply of cert-manager.

- 900.001: Patch in progress.

- 900.007: Kube upgrade in progress.

- 900.401: kube-upgrade-auto-apply-inprogress.


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

-   Hosts that need to be upgraded must be in the ``unlocked-enabled`` state.

-   If you are using NetApp Trident, ensure that your NetApp version is
    compatible with Trident 22.01 before upgrading Kubernetes to version
    |kube-ver| and after updating |prod| to version |prod-ver|. For more
    information, see :ref:`Upgrade the NetApp Trident Software
    <upgrade-the-netapp-trident-software-c5ec64d213d3>`.


.. only:: partner

   .. include:: /_includes/configuring-kubernetes-update-orchestration.rest


.. rubric:: |proc|

#. List available upgrades.

   .. code-block:: none

      ~(keystone_admin)$ system kube-version-list
       +-----------------+--------+-------------+
       | version         | target | state       |
       +-----------------+--------+-------------+
       | v1.18.1         | True   | active      |
       | v1.19.13        | False  | available   |
       | v1.20.9         | False  | unavailable |
       | v1.21.8         | False  | unavailable |
       +-----------------+--------+-------------+

#.  Confirm that the system is healthy.

    Check the current system health status, resolve any alarms and other issues
    reported by the :command:`system health-query-kube-upgrade` command, then
    recheck the system health status to confirm that all **System Health**
    fields are set to **OK**.

    By default, the upgrade process cannot be run and is not recommended to be
    run with active alarms present. Use the :command:`system kube-upgrade-start --force`
    command to force the upgrade process to start and ignore non-management-affecting
    alarms.

    .. note::
        It is strongly recommended that you clear your system of any and all
        alarms before doing an upgrade. While the :command:`--force` option is
        available to run the upgrade, it is a best practice to clear any
        alarms.

    .. code-block:: none

        ~(keystone_admin)]$ system health-query-kube-upgrade
            System Health:
            All hosts are provisioned: [OK]
            All hosts are unlocked/enabled: [OK]
            All hosts have current configurations: [OK]
            All hosts are patch current: [OK]
            Ceph Storage Healthy: [OK]
            No alarms: [OK]
            All kubernetes nodes are ready: [OK]
            All kubernetes control plane pods are ready: [OK]
            Required patches are applied: [OK]
            License valid for upgrade: [OK]
            No instances running on controller-1: [OK]
            All kubernetes applications are in a valid state: [OK]
            Active controller is controller-0: [OK]

#.  Create the strategy.

    The *Kubernetes Version Upgrade Orchestration Strategy* :command:`create`
    command creates a series of stages with steps that apply the Kubernetes
    version upgrade.

    Kubernetes Version upgrade requires a reboot. Therefore, the created strategy
    includes steps that automatically lock and unlock the host to bring the new
    image function into service.

    .. code-block:: none

        ~(keystone_admin)$ sw-manager kube-upgrade-strategy create --to-version v1.19.13
        Strategy Kubernetes Upgrade Strategy:
          strategy-uuid:                          f7585178-cea6-4d2f-bda0-e0972145ebcf
          controller-apply-type:                  serial
          storage-apply-type:                     ignore
          worker-apply-type:                      serial
          default-instance-action:                migrate
          alarm-restrictions:                     strict
          current-phase:                          build
          current-phase-completion:               0%
          state:                                  building
          inprogress:                             true

    where:

    ``--to-version``
       The version of Kubernetes to upgrade to. For example, ``v1.19.13``.
       This argument is required.

    ``--controller-apply-type`` and ``--storage-apply-type``
       These options cannot be changed from ``serial`` because Kubernetes
       upgrade concurrency is only supported for worker hosts.

       .. note::
          Kubernetes version upgrade is currently only supported for hosts with
          worker function. Any attempt to modify the controller or storage
          apply type is rejected.

    ``--worker-apply-type``
       This option specifies the host concurrency of the Kubernetes version
       upgrade strategy:

       -   serial \(default\): worker hosts will be patched one at a time

       -   parallel: worker hosts will be upgraded in parallel

           -   At most, ``parallel`` will be upgraded at the same time

           -   At most, half of the hosts in a host aggregate will be upgraded
               at the same time

       -   ignore: worker hosts will not be upgraded; strategy create will fail

       Worker hosts with no instances are upgraded before worker hosts with
       instances.

    ``--max-parallel-worker-hosts``
       This option applies to the parallel worker apply type selection to
       specify the maximum worker hosts to upgrade in parallel \(minimum: 2,
       maximum: 10\).

    ``–instance-action``
       This option only has significance when the |prefix|-openstack
       application is loaded and there are instances running on worker hosts.
       It specifies how the strategy deals with worker host instances over the
       strategy execution.

    ``stop-start`` \(default\)
       Instances will be stopped before the host lock operation following the
       upgrade and then started again following the host unlock.

       .. warning::
           Using the ``stop-start`` option will result in an outage for each
           instance, as it is stopped while the worker host is locked/unlocked.
           In order to ensure this does not impact service, instances MUST be
           grouped into anti-affinity \(or anti-affinity best effort\) server
           groups, which will ensure that only a single instance in each server
           group is stopped at a time.

    ``migrate``
       Instances will be migrated off a host before it is patched \(this
       applies to reboot patching only\).

    ``--alarm-restrictions``
       This option sets how the how the Kubernetes version upgrade
       orchestration behaves when alarms are present.

       To display management-affecting active alarms, use the following
       command:

       .. code-block:: none

           ~(keystone_admin)$ fm alarm-list --mgmt_affecting

    ``strict`` \(default\)
       The default strict option will result in patch orchestration failing if
       there are any alarms present in the system \(except for a small list of
       alarms\).

    ``relaxed``
       This option allows orchestration to proceed if alarms are present, as
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
          strategy-uuid:                          f7585178-cea6-4d2f-bda0-e0972145ebcf
          controller-apply-type:                  serial
          storage-apply-type:                     ignore
          worker-apply-type:                      serial
          default-instance-action:                migrate
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

    *Kubernetes Version Upgrade Orchestration Strategy* :command:`apply` command
    executes the strategy stages and steps consecutively until the Kubernetes
    upgrade on all the hosts in the strategy is complete.


    -   Use the ``-stage-id`` option to specify a specific stage to apply; one
        at a time.

        .. note::
            When applying a single stage, only the next stage will be applied;
            you cannot skip stages.


    .. code-block:: none

        ~(keystone_admin)$ sw-manager kube-upgrade-strategy apply
        Strategy Kubernetes upgrade Strategy:
          strategy-uuid:                          3e43c018-9c75-4ba8-a276-472c3bcbb268
          controller-apply-type:                  ignore
          storage-apply-type:                     ignore
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
        | uuid         | 3d2da123-bff4-4b3a-a64a-b320c3b498cc |
        | from_version | v1.18.1                              |
        | to_version   | v1.19.13                             |
        | state        | downloading-images                   |
        | created_at   | 2021-02-23T00:08:24.579257+00:00     |
        | updated_at   | 2021-02-23T00:09:35.413307+00:00     |
        +--------------+--------------------------------------+

    You will see the ``state`` property transition through values such as
    ``downloading-images``, ``downloaded-images``, ``upgrading-first-master``,
    ``upgraded-first-master``, etc.

#.  |optional| Abort the strategy, if required. This is only used to stop, and
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
       | uuid         | 426d7e11-2de2-40ba-b482-ed3691625383 |
       | from_version | v1.18.1                              |
       | to_version   | v1.19.13                             |
       | state        | upgrade-complete                     |
       | created_at   | 2021-04-12T17:58:36.492523+00:00     |
       | updated_at   | 2021-04-12T18:49:11.673259+00:00     |
       +--------------+--------------------------------------+

       ~(keystone_admin)$ system kube-version-list
       +-----------------+--------+-------------+
       | version         | target | state       |
       +-----------------+--------+-------------+
       | v1.18.1         | True   | unavailable |
       | v1.19.13        | False  | active      |
       | v1.20.9         | False  | available   |
       | v1.21.8         | False  | unavailable |
       +-----------------+--------+-------------+

#.  Delete the strategy.

    .. note::
        After the *Kubernetes Version Upgrade Orchestration Strategy* has been
        applied \(or aborted\) it must be deleted before another Kubernetes
        version upgrade strategy can be created. If a Kubernetes version
        upgrade strategy application fails, you must address the issue that
        caused the failure, then delete and re-create the strategy before
        attempting to apply it again.

    .. code-block:: none

        ~(keystone_admin)$ sw-manager kube-upgrade-strategy delete
        Strategy deleted.

