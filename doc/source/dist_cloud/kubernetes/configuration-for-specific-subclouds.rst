
.. jul1593180757282
.. _configuration-for-specific-subclouds:

====================================
Configuration for Specific Subclouds
====================================

To determine how upgrades are applied to the nodes on each subcloud, the
upgrade strategy refers to separate configuration settings.

The following settings are applied by default:


.. _configuration-for-specific-subclouds-ul-sgb-p34-gdb:

-   storage apply type: parallel

-   worker apply type: parallel

-   max parallel workers: 10

-   alarm restriction type: relaxed

-   default instance action: migrate \(This parameter is only applicable to
    hosted application |VMs| with the stx-openstack application.\)


To update the default values, use the :command:`dcmanager strategy-config
update` command. You can also use this command to configure custom behavior for
individual subclouds.

-   To list the default upgrade strategy and any custom configurations
    configured for individual subclouds, use the :command:`strategy-config
    list` command.

    For example:

    .. code-block:: none

        ~(keystone_admin)]$ dcmanager strategy-config list
        +--------------------+--------------------+--------------------+-----------------------+------------------------+------------------+
        | cloud              | storage apply type | worker apply type  | max parallel workers  | alarm restriction type | default instance |
        |                    |                    |                    |                       |                        | action           |
        +--------------------+--------------------+--------------------+-----------------------+------------------------+------------------+
        | all clouds default | parallel           | parallel           |                    10 | relaxed                | migrate          |
        | subcloud-6         | parallel           | parallel           |                     2 | relaxed                | stop-start       |
        +--------------------+--------------------+--------------------+-----------------------+------------------------+------------------+


-   To show the configuration settings applicable to all subclouds by default,
    use the :command:`strategy-config show` command.

    .. code-block:: none

        ~(keystone_admin)]$ dcmanager strategy-config show
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
    use the :command:`strategy-config update` command.

    .. code-block:: none

        ~(keystone_admin)]$ dcmanager strategy-config update \
         \
        --storage-apply-type <type> \
        --worker-apply-type <type> \
        --max-parallel-workers <i> \
        --alarm-restriction-type <level> \
        --default-instance-action <action> \
        [<subcloud_name>]

    where

    **storage apply type**
        parallel or serial — determines whether storage nodes are upgraded in
        parallel or serially.

    **worker apply type**
        parallel or serial — determines whether worker nodes are upgraded in
        parallel or serially.

    **max parallel workers**
        Set the maximum number of worker nodes that can be upgraded in
        parallel.

    **alarm restriction type**
        relaxed or strict — determines whether the orchestration is aborted for
        alarms that are not management-affecting. For more information, refer
        to the

.. xbooklink :ref:`|updates-doc| <software-updates-and-upgrades-software-updates>` guide.

    **default instance action**
        .. note::

            This parameter is only applicable to hosted application |VMs| with
            the stx-openstack application.

        migrate or stop-start — determines whether hosted application |VMs| are
        migrated or stopped and restarted when a worker host is upgraded

    **subcloud\_name**
        The name of the subcloud to use the custom strategy. If this omitted,
        the default upgrade strategy is updated.

    .. note::

        You must specify all of the settings.

-   To show the configuration settings for a subcloud, use the
    :command:`strategy-config show` <subcloud> command.

    .. code-block:: none

        ~(keystone_admin)]$ dcmanager strategy-config show [<name>]


    For example:

    .. code-block:: none

        ~(keystone_admin)]$ dcmanager strategy-config show subcloud-6
        +-------------------------+----------------------------+
        | Field                   | Value                      |
        +-------------------------+----------------------------+
        | cloud                   | subcloud-6                 |
        | storage apply type      | parallel                   |
        | worker apply type       | parallel                   |
        | max parallel workers    | 2                          |
        | alarm restriction type  | relaxed                    |
        | default instance action | stop-start                 |
        | created_at              | 2020-03-12 20:08:48.917866 |
        | updated_at              | None                       |
        +-------------------------+----------------------------+


    If custom configuration settings have not been created for the subcloud,
    the following message is displayed:

    .. code-block:: none

        ERROR (app) No options found for Subcloud with id 1, defaults will be
        used.


