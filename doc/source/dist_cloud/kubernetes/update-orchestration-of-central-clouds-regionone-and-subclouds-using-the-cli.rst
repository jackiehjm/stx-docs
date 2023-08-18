
.. fql1558615252466
.. _update-orchestration-of-central-clouds-regionone-and-subclouds-using-the-cli:

===============================================
Update Orchestration of Subclouds Using the CLI
===============================================

For |prod-dc| update orchestration, you can use the :command:`dcmanager`
commands from the command line interface. These are similar to the
:command:`sw-manager` commands used to define and execute update strategies on
non-distributed systems, or on the SystemController RegionOne.

.. contents:: |minitoc|
   :local:
   :depth: 1

To use the Horizon Web interface instead, see
:ref:`update-orchestration-of-central-clouds-regionone-and-subclouds`.

.. note::

    Before you can use |prod-dc| update orchestration, you must upload and
    apply one or more updates to the SystemController / central update
    repository, and then update the RegionOne. For more information, see
    :ref:`uploading-and-applying-updates-to-systemcontroller-using-the-cli`.



.. _update-orchestration-of-central-clouds-regionone-and-subclouds-using-the-cli-section-N10087-N10029-N10001:

-----------------------
Patch Strategy Settings
-----------------------

The update strategy for a |prod-dc| system controls how updates are applied to
the subclouds. The following settings are
available:

**subcloud apply type**
    parallel or serial — determines whether the subclouds are updated in
    parallel, or serially.

    If this is not specified using the |CLI|, the values for
    :command:`subcloud_update_type` defined for each subcloud group will be
    used by default.

**maximum parallel subclouds**
    Sets the maximum number of subclouds that can be updated in parallel (default 20).

    If this is not specified using the |CLI|, the values for
    :command:`max_parallel_subclouds` defined for each subcloud group will be
    used by default.

**stop on failure**
    true (default) or false — determines whether update orchestration failure
    for a subcloud prevents application to subsequent subclouds.

**upload only**
    the patch strategy will only upload the necessary patches to the subclouds,
    without executing the other steps (apply, install, reboot, etc.).


.. _update-orchestration-of-central-clouds-regionone-and-subclouds-using-the-cli-ul-blq-nmx-fdb:

-   To create a update strategy, use the :command:`patch-strategy create` command.

    .. code-block:: none

        ~(keystone_admin)]$ dcmanager patch-strategy create \
        [--subcloud-apply-type <type>] \
        [–-max-parallel-subclouds <i>] \
        [–-stop-on-failure <level>] \
        [--upload-only] \
        [--group group] \
        [<subcloud>]


    For example:

    .. code-block:: none

        ~(keystone_admin)]$ dcmanager patch-strategy create --group 10
        +------------------------+----------------------------+
        | Field                  | Value                      |
        +------------------------+----------------------------+
        | subcloud apply type    | parallel                   |
        | max parallel subclouds | 10                         |
        | stop on failure        | False                      |
        | state                  | initial                    |
        | created_at             | 2021-01-07T14:54:58.634476 |
        | updated_at             | None                       |
        +------------------------+----------------------------+

    .. note::

        You can optionally pass the name or ID of a subcloud group to the
        :command:`patch-strategy create` command. This results in a strategy
        that is applied only to all subclouds in the specified group. The
        subcloud group values are used for subcloud apply type and max parallel
        subclouds parameters.

    To only upload the necessary patches to the subclouds, without executing
    the other steps (apply, install, reboot, etc.), use the
    :command:`patch-strategy create --upload-only` command.

    .. code-block:: none

        ~(keystone_admin)]$ dcmanager patch-strategy create --upload-only
        +------------------------+----------------------------+
        | Field                  | Value                      |
        +------------------------+----------------------------+
        | strategy type          | patch                      |
        | subcloud apply type    | None                       |
        | max parallel subclouds | None                       |
        | stop on failure        | False                      |
        | upload only            | True                       |
        | state                  | initial                    |
        | created_at             | 2023-03-08T13:58:50.130629 |
        | updated_at             | None                       |
        +------------------------+----------------------------+

    .. note::

        This is useful to reduce the total time it takes to run the
        orchestration during a system maintenance window by enabling the user
        to upload the patches to the subclouds before the system maintenance
        window.

        If the ``--upload-only`` option is used, the ``updating patches`` state
        skips directly to the ``complete`` state once the patches are uploaded
        to the subclouds.

-   To show the settings for the update strategy, use the
    :command:`patch-strategy show` command.

    For example:

    .. code-block:: none

        ~(keystone_admin)]$ dcmanager patch-strategy show
        +------------------------+----------------------------+
        | Field                  | Value                      |
        +------------------------+----------------------------+
        | subcloud apply type    | parallel                   |
        | max parallel subclouds | 20                         |
        | stop on failure        | False                      |
        | state                  | initial                    |
        | created_at             | 2018-02-02T14:42:13.822499 |
        | updated_at             | None                       |
        +------------------------+----------------------------+


    .. note::

        A value of **None** for **subcloud apply type**, and **max parallel
        subclouds** indicates that subcloud group values are being used.

-   To apply the update strategy, use the :command:`patch-strategy apply` command.

    .. code-block:: none

        ~(keystone_admin)]$ dcmanager patch-strategy apply
        +------------------------+----------------------------+
        | Field                  | Value                      |
        +------------------------+----------------------------+
        | subcloud apply type    | parallel                   |
        | max parallel subclouds | 20                         |
        | stop on failure        | False                      |
        | state                  | applying                   |
        | created_at             | 2018-02-02T14:42:13.822499 |
        | updated_at             | 2018-02-02T14:42:19.376688 |
        +------------------------+----------------------------+


-   To show the step currently being performed on each of the subclouds, use
    the :command:`strategy-step list` command.

    For example:

    .. code-block:: none

        ~(keystone_admin)]$ dcmanager strategy-step list
            +------------------+-------+-------------+-----------------------------+----------------------------+----------------------------+
            | cloud            | stage | state       | details                     | started_at                 | finished_at                |
            +------------------+-------+-------------+-----------------------------+----------------------------+----------------------------+
            | subcloud-1       |     1 | applying... | apply phase is 66% complete | 2018-03-13 14:16:02.457588 | None                       |
            | subcloud-4       |     1 | applying... | apply phase is 83% complete | 2018-03-13 14:16:02.463213 | None                       |
            | subcloud-5       |     1 | finishing   |                             | 2018-03-13 14:16:02.473669 | None                       |
            | subcloud-6       |     1 | applying... | apply phase is 66% complete | 2018-03-13 14:16:02.483422 | None                       |
            +------------------+-------+-------------+-----------------------------+----------------------------+----------------------------+

-   To show the step currently being performed on a subcloud, use the
    :command:`strategy-step show` <subcloud> command.

    .. code-block:: none

        ~(keystone_admin)]$ dcmanager strategy-step show <subcloud>

-   To abort the current update orchestration operation, use the
    :command:`patch-strategy abort` command.

    .. note::

        The :command:`dcmanager patch-strategy abort` command completes the
        current updating stage before aborting, to prevent hosts from being
        left in a locked state requiring manual intervention.

    .. code-block:: none

        ~(keystone_admin)]$ dcmanager patch-strategy abort

-   To delete a update strategy, use the :command:`patch-strategy delete` command.

    .. code-block:: none

        ~(keystone_admin)]$ dcmanager patch-strategy delete
        +------------------------+----------------------------+
        | Field                  | Value                      |
        +------------------------+----------------------------+
        | subcloud apply type    | parallel                   |
        | max parallel subclouds | 20                         |
        | stop on failure        | False                      |
        | state                  | deleting                   |
        | created_at             | 2018-03-23T20:04:50.992444 |
        | updated_at             | 2018-03-23T20:05:14.157352 |
        +------------------------+----------------------------+


.. _update-orchestration-of-central-clouds-regionone-and-subclouds-using-the-cli-section-N1022D-N10029-N10001:

------------------------------------
Configuration for Specific Subclouds
------------------------------------

To determine how updates are applied to the nodes on each subcloud, the update
strategy refers to separate configuration settings. The following settings are
applied by default:


.. _update-orchestration-of-central-clouds-regionone-and-subclouds-using-the-cli-ul-sgb-p34-gdb:

-   storage apply type: parallel

-   worker apply type: parallel

-   max parallel workers: 10

-   alarm restriction type: relaxed

-   default instance action: migrate


To update the default values, use the :command:`dcmanager patch-strategy-config
update` command. You can also use this command to configure custom behavior for
individual subclouds.

.. note::

    Since re-location is not possible on a single-node |prod| Simplex system,
    you must change the configuration to set default_instance_action to
    stop-start.

.. _update-orchestration-of-central-clouds-regionone-and-subclouds-using-the-cli-ul-xfb-bfz-fdb:

-   To list the default update strategy and any custom configurations
    configured for individual subclouds, use the :command:`patch-strategy-config
    list` command.

    For example:

    .. code-block:: none

        ~(keystone_admin)]$ dcmanager patch-strategy-config list
        +--------------------+--------------------+--------------------+-----------------------+------------------------+------------------+
        | cloud              | storage apply type | worker apply type  | max parallel workers  | alarm restriction type | default instance |
        |                    |                    |                    |                       |                        | action           |
        +--------------------+--------------------+--------------------+-----------------------+------------------------+------------------+
        | all clouds default | parallel           | parallel           |                    10 | relaxed                | migrate          |
        | subcloud-6         | parallel           | parallel           |                     2 | relaxed                | stop-start       |
        +--------------------+--------------------+--------------------+-----------------------+------------------------+------------------+

-   To show the configuration settings applicable to all subclouds by default,
    use the :command:`patch-strategy-config show` command.

    .. code-block:: none

        ~(keystone_admin)]$ dcmanager patch-strategy-config show
        +-------------------------+--------------------+
        | Field                   | Value              |
        +-------------------------+--------------------+
        | cloud                   | all clouds default |
        | storage apply type      | parallel           |
        | worker apply type       | parallel           |
        | max parallel workers    | 10                 |
        | alarm restriction type  | relaxed            |
        | default instance action | migrate            |
        | created_at              | None               |
        | updated_at              | None               |
        +-------------------------+--------------------+


-   To update the settings, or to create a custom configuration for a subcloud,
    use the :command:`patch-strategy-config update` command.

    .. code-block:: none

        ~(keystone_admin)]$ dcmanager patch-strategy-config update \
         \
        –-storage-apply-type <type> \
        –-worker-apply-type <type> \
        –-max-parallel-workers <i> \
        –-alarm-restriction-type <level> \
        –-default-instance-action <action> \
        [<subcloud_name>]

    where

    **storage apply type**
        parallel or serial — determines whether storage nodes are updated in
        parallel or serially.

    **worker apply type**
        parallel or serial — determines whether worker nodes are updated in
        parallel or serially.

    **max parallel workers**
        Set the maximum number of worker nodes that can be updated in parallel.

    **alarm restriction type**
        relaxed or strict — determines whether the orchestration is aborted for
        alarms that are not management-affecting. For more information, refer
        to |updates-doc|: :ref:`configuring-update-orchestration`.

    **default instance action**
        .. note::

            This parameter is only applicable to hosted application VMs with
            the |prefix|-openstack application.

        migrate or stop-start — determines whether hosted application VMs are
        migrated or stopped and restarted when a worker host is upgraded.

    **subcloud_name**
        The name of the subcloud to use the custom strategy. If this omitted,
        the default update strategy is updated.

    .. note::

        You must specify all of the settings.

-   To show the configuration settings for a subcloud, use the
    :command:`patch-strategy-config show` <subcloud> command.

    .. code-block:: none

        ~(keystone_admin)]$ dcmanager patch-strategy-config show [<name>]


    For example:

    .. code-block:: none

        ~(keystone_admin)]$ dcmanager patch-strategy-config show subcloud-6
        +-------------------------+----------------------------+
        | Field                   | Value                      |
        +-------------------------+----------------------------+
        | cloud                   | subcloud-6                 |
        | storage apply type      | parallel                   |
        | worker apply type       | parallel                   |
        | max parallel workers    | 2                          |
        | alarm restriction type  | relaxed                    |
        | default instance action | stop-start                 |
        | created_at              | 2018-03-12 20:08:48.917866 |
        | updated_at              | None                       |
        +-------------------------+----------------------------+


    If custom configuration settings have not been created for the subcloud,
    the following message is displayed:

    .. code-block:: none

        ERROR (app) No options found for Subcloud with id 1, defaults will be used.
