
.. ccf1617821548674
.. _configuring-kubernetes-update-orchestration-on-distributed-cloud:

====================================================================
Configure Kubernetes Version Upgrade Distributed Cloud Orchestration
====================================================================

You can configure a Kubernetes Version Upgrade Distributed Cloud Orchestration
Strategy using the dcmanager CLI or the Horizon web interface.

If you want to use the Horizon Web interface, see
:ref:`create-a-kubernetes-upgrade-orchestration-using-horizon-16742b62ffb2`.


.. note::
    Management-affecting alarms cannot be ignored using relaxed alarm rules
    during an orchestrated Kubernetes version upgrade operation. For a list of
    management-affecting alarms, see |fault-doc|:
    :ref:`Alarm Messages <100-series-alarm-messages>`. To display
    management-affecting active alarms, use the following command:

.. code-block:: none

    ~(keystone_admin)$ fm alarm-list --mgmt_affecting

During an orchestrated Kubernetes version upgrade operation, the following
alarms are ignored even when the default strict restrictions are selected:


.. _ccf1617821548674-ul-vhg-jxs-tlb:

**100.103**
   Memory threshold exceeded

**200.001**
   Locked Host

**280.001**
   Subcloud resource off-line

**280.002**
   Subcloud resource out-of-sync

**700.004**
   VM stopped

**750.006**
   Automatic Application Re-Apply Is Pending

**900.001**
   Patching operation in progress

**900.007**
   Kubernetes upgrade in progress

**900.401**
   Kubernetes upgrade auto-apply inprogress


.. rubric:: |prereq|


.. _ccf1617821548674-ul-ls2-pxs-tlb:

Hosts that need to be upgraded must be in the **unlocked-enabled** state.

.. only:: starlingx

    Kubernetes has been upgraded on the system controller.
    The managed subclouds are all unlocked and online.

.. only:: partner

    .. include:: /_includes/configuring-kubernetes-update-orchestration-on-distributed-cloud.rest

All  :command:`dcmanager` strategies must be deleted.

The system controller should already be upgraded to the new version of
Kubernetes. This will cause the 'audit' for the subclouds note that they are
now out of sync.

Hosts that need to be upgraded must be in the unlocked-enabled state.

Patches related to Kubernetes version upgrade must be uploaded to the central
controller for access by subclouds. For example:

.. code-block:: none

    ~(keystone_admin)]$ sw-patch --os-region-name SystemController upload PLATFORM.1.patch
    ~(keystone_admin)]$ sw-patch --os-region-name SystemController upload KUBE.1.patch
    ~(keystone_admin)]$ sw-patch --os-region-name SystemController upload KUBE.2.patch


.. rubric:: |proc|

#.  Create the strategy.

    The *Kubernetes Version Upgrade Distributed Cloud Orchestration Strategy*
    :command:`create` command creates a series of stages with steps that apply
    the Kubernetes version upgrade to the hardware.

    A Kubernetes version upgrade requires a reboot. Therefore, the created
    strategy includes steps that automatically lock and unlock the host to
    bring the new image function into service.

    .. code-block:: none

        ~(keystone_admin)$ dcmanager kube-upgrade-strategy create
        +------------------------+----------------------------+
        | Field                  | Value                      |
        +------------------------+----------------------------+
        | strategy type          | kubernetes                 |
        | subcloud apply type    | None                       |
        | max parallel subclouds | None                       |
        | stop on failure        | False                      |
        | state                  | initial                    |
        | created_at             | 2020-11-09T23:00:07.210958 |
        | updated_at             | None                       |
        +------------------------+----------------------------+

    The syntax for the :command:`dcmanager kube-upgrade-strategy create` command
    is:

    .. code-block:: none

        dcmanager kube-upgrade-strategy create [-h]
                                                      [-f {json,shell,table,value,yaml}]
                                                      [-c COLUMN]
                                                      [--max-width <integer>]
                                                      [--fit-width] [--print-empty]
                                                      [--noindent] [--prefix PREFIX]
                                                      [--subcloud-apply-type {parallel,serial}]
                                                      [--max-parallel-subclouds MAX_PARALLEL_SUBCLOUDS]
                                                      [--stop-on-failure] [--force]
                                                      [--group GROUP]
                                                      [--to-version TO_VERSION]
                                                      [cloud_name]


    where the following are significant for performing an orchestrated Kubernetes
    upgrade:

    **--subcloud-apply-type**
        Determines whether the subclouds are upgraded in parallel, or serially. If
        this is not specified using the CLI, the values for subcloud_update_type
        defined for each subcloud group will be used by default.

    **--max-parallel-subclouds**
        Sets the maximum number of subclouds that can be upgraded in parallel
        \(default 20\). If this is not specified using the CLI, the values for
        max_parallel_subclouds defined for each subcloud group will be used by
        default.

    **--stop-on-failure**
        **true** \(default\) or **false** — determines whether upgrade
        orchestration failure for a subcloud prevents application to subsequent
        subclouds.

    **--group**
        Optionally pass the name or ID of a subcloud group to the
        :command:`dcmanager kube-upgrade-strategy` command. This results in a
        strategy that is only applied to all subclouds in the specified group. If
        not specified, all subcloud groups are upgraded.

    **--force**
        Ignore the audit status of subclouds when selecting them for
        orchestration. This allows subclouds that are in-sync to be orchestrated.

    **to-version**
        Specify a target version for Kubernetes orchestration. The subcloud
        will orchestrate to its 'available' version if the 'to-version' is
        greater or equal to the available version. The 'to-version' can be a
        partial version. For example, if the available version is 1.20.5,
        selecting 1.20 would upgrade to that version.

#.  Optional: Display the strategy in summary, if required. The Kubernetes
    upgrade strategy :command:`show` command displays the strategy in a summary.

    .. code-block:: none

        ~(keystone_admin)$ dcmanager kube-upgrade-strategy show
        +------------------------+----------------------------+
        | Field                  | Value                      |
        +------------------------+----------------------------+
        | strategy type          | kubernetes                 |
        | subcloud apply type    | None                       |
        | max parallel subclouds | None                       |
        | stop on failure        | False                      |
        | state                  | initial                    |
        | created_at             | 2020-11-09 23:00:07.210958 |
        | updated_at             | 2020-11-09 23:01:15.697763 |
        +------------------------+----------------------------+

    The strategy steps are displayed using the ``--details`` option.

#.  Apply the strategy.

    The scope of the subcloud orchestration is restricted through the 'group'
    argument.

    .. code-block:: none

        ~(keystone_admin)$ dcmanager kube-upgrade-strategy apply
        +------------------------+----------------------------+
        | Field                  | Value                      |
        +------------------------+----------------------------+
        | strategy type          | kubernetes                 |
        | subcloud apply type    | None                       |
        | max parallel subclouds | None                       |
        | stop on failure        | False                      |
        | state                  | applying                   |
        | created_at             | 2021-04-13T21:00:19.067829 |
        | updated_at             | 2021-04-13T21:00:38.527080 |
        +------------------------+----------------------------+

    -   Use the :command:`show` command to monitor Kubernetes version upgrade
        state and percentage completion.


    .. code-block:: none

        ~(keystone_admin)$ dcmanager kube-upgrade-strategy show
        +------------------------+----------------------------+
        | Field                  | Value                      |
        +------------------------+----------------------------+
        | strategy type          | kubernetes                 |
        | subcloud apply type    | None                       |
        | max parallel subclouds | None                       |
        | stop on failure        | False                      |
        | state                  | complete                   |
        | created_at             | 2020-11-09 23:00:07.210958 |
        | updated_at             | 2020-11-09 23:01:15.697763 |
        +------------------------+----------------------------+

#.  Monitor the progress of the strategy.

    .. code-block::

       ~(keystone_admin)$ dcmanager strategy-step list

       +------------------+-------+---------+---------+------------+-------------+
       | cloud            | stage | state   | details | started_at | finished_at |
       +------------------+-------+---------+---------+------------+-------------+
       | subcloud1        |     2 | initial |         | None       | None        |
       +------------------+-------+---------+---------+------------+-------------+

#.  Optional: Abort the strategy, if required. This is only used to stop, and
    abort the entire strategy.

    The Kubernetes Version Upgrade Distributed Cloud Orchestration strategy
    :command:`abort` command can be used to abort the Kubernetes Version
    Upgrade Distributed Cloud Orchestration strategy after the current step of
    the currently applying stage is completed.

#.  Delete the strategy.

    .. note::
        After the *Kubernetes Version Upgrade Distributed Cloud Orchestration
        Strategy* has been applied \(or aborted\) it must be deleted before
        another Kubernetes Version Upgrade Distributed Cloud Orchestration
        strategy can be created. If a Kubernetes upgrade strategy application
        fails, you must address the issue that caused the failure, then delete
        and re-create the strategy before attempting to apply it again.

    .. code-block:: none

        ~(keystone_admin)$ dcmanager kube-upgrade-strategy delete
        +------------------------+----------------------------+
        | Field                  | Value                      |
        +------------------------+----------------------------+
        | strategy type          | kubernetes                 |
        | subcloud apply type    | None                       |
        | max parallel subclouds | None                       |
        | stop on failure        | False                      |
        | state                  | deleting                   |
        | created_at             | 2020-11-09T23:00:07.210958 |
        | updated_at             | 2020-11-09T23:01:52.620362 |
        +------------------------+----------------------------+
