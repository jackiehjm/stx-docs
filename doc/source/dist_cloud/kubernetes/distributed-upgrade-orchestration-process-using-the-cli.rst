.. Greg updates required for -High Security Vulnerability Document Updates

.. pek1594745988225
.. _distributed-upgrade-orchestration-process-using-the-cli:

=======================================================
Distributed Upgrade Orchestration Process using the CLI
=======================================================

Distributed upgrade orchestration can be initiated after the System Controller
has been successfully upgraded.

For more information on Prestaging Subcloud Orchestration see,
:ref:`prestage-subcloud-orchestration-eb516473582f`.

.. rubric:: |context|

The user first creates a distributed upgrade orchestration strategy, or plan,
for the automated upgrade procedure. This customizes the upgrade orchestration,
using parameters to specify:


.. _distributed-upgrade-orchestration-process-using-the-cli-ul-eyw-fyr-31b:

-   whether to stop on failure of a subcloud upgrade or continue with the next
    subcloud

-   whether to upgrade hosts serially or in parallel


Based on these parameters, and the state of the subclouds, the upgrade
orchestration creates a number of stages for the overall upgrade strategy. All
the subclouds that are included in the same stage will be upgraded in parallel.

.. rubric:: |prereq|

Distributed upgrade orchestration can only be done on a system that meets the
following conditions:

.. _distributed-upgrade-orchestration-process-using-the-cli-ul-blp-gcx-ry:

-   The subclouds must use the Redfish platform management service if it is an
    |AIO-SX| subcloud. The install values as well as `bmc_password`
    for each |AIO-SX| subcloud must have already been saved in the system
    controller database before the start of orchestrated subcloud upgrade.

    .. note::
        The following command is only required if the |AIO-SX| subcloud install
        values and `bmc_password` have never been provided using
        :command:`dcmanager CLI` command.

    .. code-block:: none

        ~(keystone_admin)]$ dcmanager subcloud update subcloud1 --install-values\
        install-values.yaml --bmc-password <password>

    For more information on :command:`install-values.yaml` file, see
    :ref:`Installing a Subcloud Using Redfish Platform Management Service
    <installing-a-subcloud-using-redfish-platform-management-service>`.

-   Duplex (|AIO-DX|/Standard) upgrades are supported, and they do not
    require remote install using Redfish.

-   All subclouds are clear of management-affecting alarms (with the exception of the alarm upgrade
    in progress).

-   All hosts of all subclouds must be unlocked, enabled, and available.

-   No distributed upgrade orchestration strategy exists, to verify use the
    command :command:`dcmanager upgrade-strategy-show`. An upgrade cannot be
    orchestrated while upgrade orchestration is in progress.

-   The size and format of the persistent filesystem, /opt/platform-backup, of
    each subcloud must be 30GiB (or larger) and ext4 respectively. From the shell
    on a subcloud, use the following command to view the details of its
    persistent file system:

    :command:`df -Th /opt/platform-backup`

    The type must be ext4 and the size must be 30GiB. For example, on
    controller-0, run the following command:

    .. code-block:: none

        ~(keystone_admin)]$ df -Th /opt/platform-backup
        Filesystem  Type    Size    Used     Avail  Use%  Mounted on
        /dev/sda1   ext4    29G     6.9G     21G    26%   /opt/platform-backup

-   **If a previous upgrade has been done on the subcloud**, from the shell on
    each subcloud, use the following command to remove the previous upgrade
    data:

    :command:`sudo rm /opt/platform-backup/upgrade_data\*`

You can configure an upgrade Distributed Cloud orchestration strategy using the
dcmanager CLI or the Horizon web interface. If you prefer to use Horizon, see
:ref:`create-an-upgrade-orchestration-using-horizon-9f8c6c2f3706`.


.. rubric:: |proc|

.. _distributed-upgrade-orchestration-process-using-the-cli-steps-vcm-pq4-3mb:

#.  Review the upgrade status for the subclouds.

    After the System Controller upgrade is completed, wait for 10 minutes for
    the **load_sync_status** of all subclouds to be updated.

    To identify which subclouds are upgrade-current \(in-sync\), use the
    :command:`subcloud list` command. For example:

    .. code-block:: none

        ~(keystone_admin)]$ dcmanager subcloud list
        +----+-----------+--------------+--------------------+-------------+
        | id | name      | management   | availability       | sync        |
        +----+-----------+--------------+--------------------+-------------+
        |  1 | subcloud-1| managed      | online             | out-of-sync |
        |  2 | subcloud-2| managed      | online             | out-of-sync |
        |  3 | subcloud-3| managed      | online             | out-of-sync |
        |  4 | subcloud-4| managed      | online             | out-of-sync |
        +----+-----------+--------------+--------------------+-------------+

    .. note::
        The subclouds are out-of-sync because the load-sync-status is out-of-sync.
        All of the above subclouds are not upgrade-current and, therefore, need
        to be upgraded.

    To see synchronization details for a subcloud, use the following command:

    .. code-block:: none

        ~(keystone_admin)]$ dcmanager subcloud show subcloud1
        +-----------------------------+------------------------------+
        | Field                       | Value                        |
        +-----------------------------+------------------------------+
        | id                          | 1                            |
        | name                        | subcloud-1                   |
        | description                 | None                         |
        | location                    | None                         |
        | software_version            | nn.nn                        |
        | management                  | managed                      |
        | availability                | online                       |
        | deploy_status               | complete                     |
        | management_subnet           | fd01:82::0/64                |
        | management_start_ip         | fd01:82::2                   |
        | management_end_ip           | fd01:82::11                  |
        | management_gateway_ip       | fd01:82::1                   |
        | systemcontroller_gateway_ip | fd01:81::1                   |
        | group_id                    | 1                            |
        | created_at                  | 2021-06-07 21:05:16.224664   |
        | updated_at                  | 2021-06-09 20:01:37.525012   |
        | dc-cert_sync_status         | in-sync                      |
        | firmware_sync_status        | in-sync                      |
        | identity_sync_status        | in-sync                      |
        | kubernetes_sync_status      | in-sync                      |
        | load_sync_status            | out-of-sync                  |
        | patching_sync_status        | in-sync                      |
        | platform_sync_status        | in-sync                      |
        +-----------------------------+------------------------------+

#.  To create an upgrade strategy, use the :command:`dcmanager upgrade-strategy create`
    command.

    The upgrade strategy for a |prod-dc| system controls how upgrades are
    applied to subclouds.

    .. code-block:: none

        ~(keystone_admin)]$ dcmanager upgrade-strategy create \
        [--subcloud-apply-type <type>] \
        [–-max-parallel-subclouds <i>] \
        [–-stop-on-failure <level>] \
        [--group group] \
        [--force] \
        [<subcloud>]

    where:

    **subcloud-apply-type**
        **parallel** or **serial**— determines whether the subclouds are
        upgraded in parallel, or serially.

        If this is not specified using the CLI, the values for
        :command:`subcloud_update_type` defined for each subcloud group will
        be used by default.

    **max-parallel-subclouds**
        Sets the maximum number of subclouds that can be upgraded in parallel
        \(default 20\).

        If this is not specified using the CLI, the values for
        :command:`max_parallel_subclouds` defined for each subcloud group
        will be used by default.

    **stop-on-failure**
        **true**\(default\) or **false**— determines whether upgrade
        orchestration failure for a subcloud prevents application to subsequent
        subclouds.

    **group**
        Optionally pass the name or ID of a subcloud group to the
        :command:`dcmanager upgrade-strategy create` command. This results in a
        strategy that is only applied to all subclouds in the specified group.
        The subcloud group values are used for subcloud apply type and max
        parallel subclouds parameters.

    **force**
        Upgrade both online and offline subclouds. Can be used for a single
        subcloud, or a subcloud group.

    For example:

    .. code-block:: none

        ~(keystone_admin)]$ dcmanager upgrade-strategy create
        +------------------------+----------------------------+
        | Field                  | Value                      |
        +------------------------+----------------------------+
        | strategy type          | upgrade                    |
        | subcloud apply type    | parallel                   |
        | max parallel subclouds | 2                          |
        | stop on failure        | False                      |
        | state                  | initial                    |
        | created_at             | 2020-06-10T17:16:51.857207 |
        | updated_at             | None                       |
        +------------------------+----------------------------+

#.  To show the settings for the upgrade strategy, use the
    :command:`dcmanager upgrade-strategy show` command.

    For example:

    .. code-block:: none

        ~(keystone_admin)]$ dcmanager upgrade-strategy show
        +------------------------+----------------------------+
        | Field                  | Value                      |
        +------------------------+----------------------------+
        | subcloud apply type    | parallel                   |
        | max parallel subclouds | 2                          |
        | stop on failure        | False                      |
        | state                  | initial                    |
        | created_at             | 2020-02-02T14:42:13.822499 |
        | updated_at             | None                       |
        +------------------------+----------------------------+

    .. note::
        The values for `subcloud apply type` and `max parallel subclouds` will
        be taken from the subcloud group if specified through the ``--group``
        parameter.

#.  Review the upgrade strategy for the subclouds.

    To show the subclouds that will be upgraded when the upgrade strategy is
    applied, use the :command:`dcmanager strategy-step list` command. For
    example:

    .. code-block:: none

        ~(keystone_admin)]$ dcmanager strategy-step list
        +------------------+-------+---------+---------+------------+-------------+
        | cloud            | stage | state   | details | started_at | finished_at |
        +------------------+-------+---------+---------+------------+-------------+
        | subcloud-1       |     1 | initial |         | None       | None        |
        | subcloud-4       |     1 | initial |         | None       | None        |
        | subcloud-5       |     2 | initial |         | None       | None        |
        | subcloud-6       |     2 | initial |         | None       | None        |
        +------------------+-------+---------+---------+------------+-------------+

    .. note::
        All the subclouds that are included in the same stage will be upgraded
        in parallel.

#.  To apply the upgrade strategy, use the :command:`dcmanager upgrade-strategy apply`
    command.

    .. code-block:: none

        ~(keystone_admin)]$ dcmanager upgrade-strategy apply
        +------------------------+----------------------------+
        | Field                  | Value                      |
        +------------------------+----------------------------+
        | subcloud apply type    | parallel                   |
        | max parallel subclouds | 2                          |
        | stop on failure        | False                      |
        | state                  | applying                   |
        | created_at             | 2020-02-02T14:42:13.822499 |
        | updated_at             | 2020-02-02T14:42:19.376688 |
        +------------------------+----------------------------+

    .. warning::
        Do not log in to the subcloud using the sysadmin account during an upgrade
        procedure. During an upgrade, the subcloud password is reset to the default
        value and is subsequently resynced, and any login attempt during the
        upgrade will fail. Also, consecutive unsuccessful login attempts may lock
        your account.

#.  To show the step currently being performed on each of the subclouds, use
    the :command:`dcmanager strategy-step list` command.

    For example:

    .. code-block:: none

        ~(keystone_admin)]$ dcmanager strategy-step list
        +------------------+-------+-----------------------+-------------------+----------------------------+----------------------------+
        | cloud            | stage | state                 | details           | started_at                 | finished_at                |
        +------------------+-------+-----------------------+-------------------+----------------------------+----------------------------+
        | subcloud-1       |     1 | complete              |                   | 2021-06-11 14:12:12.262001 | 2021-06-11 14:15:52.450908 |
        | subcloud-4       |     1 | activating upgrade    |                   | 2021-06-11 14:16:02.457588 | None                       |
        | subcloud-5       |     2 | initial               |                   | None                       | None                       |
        | subcloud-6       |     2 | initial               |                   | None                       | None                       |
        +------------------+-------+-------------+-----------------------------+----------------------------+----------------------------+

#.  To show the step currently being performed on a subcloud, use the
    :command:`dcmanager strategy-step show` <subcloud> command.

    .. code-block:: none

        ~(keystone_admin)]$ dcmanager strategy-step show <subcloud>

#.  When all the subclouds within the distributed upgrade orchestration indicate
    they have entered the complete state, delete the upgrade strategy, using
    the :command:`dcmanager upgrade-strategy delete` command.

    .. code-block:: none

        ~(keystone_admin)]$ dcmanager upgrade-strategy delete
        +------------------------+----------------------------+
        | Field                  | Value                      |
        +------------------------+----------------------------+
        | subcloud apply type    | parallel                   |
        | max parallel subclouds | 2                          |
        | stop on failure        | False                      |
        | state                  | deleting                   |
        | created_at             | 2020-03-23T20:04:50.992444 |
        | updated_at             | 2020-03-23T20:05:14.157352 |
        +------------------------+----------------------------+

.. note::
    Before attempting to log in to the subclouds using the sysadmin account,
    verify that the subcloud ``platform_sync_status`` is synced. This would
    ensure that the sysadmin password is successfully resynced to the subclouds
    and that login attempts do not fail.

.. only:: partner

   .. include:: /_includes/distributed-upgrade-orchestration-process-using-the-cli.rest
      :start-after: DMupgrade-begin
      :end-before: DMupgrade-end

