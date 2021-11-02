
.. btn1592861794542
.. _upgrading-all-in-one-duplex-or-standard:

======================================
Upgrade All-in-One Duplex / Standard
======================================

You can upgrade the |prod| Duplex or Standard configurations with a new release
of |prod| software.

.. rubric:: |prereq|

.. _upgrading-all-in-one-duplex-or-standard-ul-ezb-b11-cx:

-   Perform a full backup to allow recovery.

    .. note::
       Back up files in the /home/sysadmin and /root directories prior
       to doing an upgrade. Home directories are not preserved during backup or
       restore operations, blade replacement, or upgrades.

-   The system must be "patch current". All updates available for the current
    release running on the system must be applied, and all patches must be
    committed. To find and download applicable updates, visit the |dnload-loc|.

-   Transfer the new release software load to controller-0 \(or onto a USB
    stick\); controller-0 must be active.

-   Transfer the new release software license file to controller-0, \(or onto a
    USB stick\).

-   Transfer the new release software signature to controller-0 \(or onto a USB
    stick\).

-   Unlock all hosts.

    -   All nodes must be unlocked. The upgrade cannot be started when there
        are locked nodes \(the health check prevents it\).

.. note::
    The upgrade procedure includes steps to resolve system health issues.

.. rubric:: |proc|

#.  Ensure that controller-0 is the active controller.

#.  Install the license file for the release you are upgrading to, for example,
    21.05.

    .. code-block:: none

        ~(keystone_admin)]$ system license-install <license_file>

    For example,

    .. code-block:: none

        ~(keystone_admin)]$ system license-install license.lic

#.  Import the new release.


    #.  Run the :command:`load-import` command on **controller-0** to import
        the new release.

        First, source /etc/platform/openrc. Also, you must specify an exact
        path to the \*.iso bootimage file and to the \*.sig bootimage signature
        file.

        .. code-block:: none

            $ source /etc/platform/openrc
            ~(keystone_admin)]$ system load-import /home/sysadmin/<bootimage>.iso \
            <bootimage>.sig
            +--------------------+-----------+
            | Property           | Value     |
            +--------------------+-----------+
            | id                 | 2         |
            | state              | importing |
            | software_version   | nn.nn     |
            | compatible_version | nn.nn     |
            | required_patches   |           |
            +--------------------+-----------+

        The :command:`load-import` must be done on **controller-0** and accepts
        relative paths.

        .. note::
            This can take a few minutes to complete.

    #.  Check to ensure the load was successfully imported.

        .. code-block:: none

            ~(keystone_admin)]$ system load-list
            +----+----------+------------------+
            | id | state    | software_version |
            +----+----------+------------------+
            | 1  | active   | nn.nn            |
            | 2  | imported | nn.nn            |
            +----+----------+------------------+

#.  Apply any required software updates.

    The system must be 'patch current'. All software updates related to your
    current |prod| software release must be uploaded, applied, and installed.

    All software updates to the new |prod| release, only need to be uploaded
    and applied. The install of these software updates will occur automatically
    during the software upgrade procedure as the hosts are reset to load the
    new release of software.

    To find and download applicable updates, visit the |dnload-loc|.

    For more information, see :ref:`Manage Software Updates
    <managing-software-updates>`.

#.  Confirm that the system is healthy.

    Check the current system health status, resolve any alarms and other issues
    reported by the :command:`system health-query-upgrade` command, then
    recheck the system health status to confirm that all **System Health**
    fields are set to **OK**. For example:

    .. code-block:: none

        ~(keystone_admin)]$ system health-query-upgrade

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

    By default, the upgrade process cannot be run and is not recommended to be
    run with Active Alarms present. However, management affecting alarms can be
    ignored with the :command:`--force` option with the :command:`system
    upgrade-start` command to force the upgrade process to start.

    .. note::
        It is strongly recommended that you clear your system of any and all
        alarms before doing an upgrade. While the :command:`--force` option is
        available to run the upgrade, it is a best practice to clear any
        alarms.

#.  Start the upgrade from controller-0.

    Make sure that controller-0 is the active controller, and you are logged
    into controller-0 as **sysadmin** and your present working directory is
    your home directory.

    .. code-block:: none

        ~(keystone_admin)]$ system upgrade-start
        +--------------+--------------------------------------+
        | Property     | Value                                |
        +--------------+--------------------------------------+
        | uuid         | 61e5fcd7-a38d-40b0-ab83-8be55b87fee2 |
        | state        | starting                             |
        | from_release | nn.nn                                |
        | to_release   | nn.nn                                |
        +--------------+--------------------------------------+

    This will make a copy of the system data to be used in the upgrade.
    Configuration changes are not allowed after this point until the swact to
    controller-1 is completed.

    The following upgrade state applies once this command is executed:

    -   started:

        -   State entered after :command:`system upgrade-start` completes.

        -   Release nn.nn system data \(for example, postgres databases\) has
            been exported to be used in the upgrade.

        -   Configuration changes must not be made after this point, until the
            upgrade is completed.

    As part of the upgrade, the upgrade process checks the health of the system
    and validates that the system is ready for an upgrade.

    The upgrade process checks that no alarms are active before starting an
    upgrade.

    .. note::
        Use the command :command:`system upgrade-start --force` to force the
        upgrades process to start and to ignore management affecting alarms.
        This should ONLY be done if you feel these alarms will not be an issue
        over the upgrades process.

    On systems with Ceph storage, it also checks that the Ceph cluster is
    healthy.

#.  Upgrade controller-1.

    #.  Lock controller-1.

        .. code-block:: none

            ~(keystone_admin)]$ system host-lock controller-1

    #.  Upgrade controller-1.

        Controller-1 installs the update and reboots, then performs data
        migration.

        .. code-block:: none

            ~(keystone_admin)]$ system host-upgrade controller-1

        Wait for controller-1 to reinstall with the load N+1 and becomes
        **locked-disabled-online** state.

        The following data migration states apply when this command is
        executed:

        -   data-migration:

            -   State entered when :command:`system host-upgrade controller-1`
                is executed.

            -   System data is being migrated from release N to release N+1.

            .. note::
                The upgrade process will take a minimum of 20 to 30 minutes to
                complete.

                You can view the upgrade progress on controller-1 using the
                BMC console.

        -   data-migration-complete or upgrading-controllers:

            -   State entered when controller-1 upgrade is complete.

            -   System data has been successfully migrated from release nn.nn
                to release nn.nn.

        -   data-migration-failed:

            -   State entered if data migration on controller-1 fails.

            -   Upgrade must be aborted.

            .. note::
                Review the /var/log/sysinv.log on the active controller for
                more details on data migration failure.

    #.  Check the upgrade state.

        .. code-block:: none

            ~(keystone_admin)]$ system upgrade-show

            +--------------+--------------------------------------+
            | Property     | Value                                |
            +--------------+--------------------------------------+
            | uuid         | e7c8f6bc-518c-46d4-ab81-7a59f8f8e64b |
            | state        | data-migration-complete              |
            | from_release | nn.nn                                |
            | to_release   | nn.nn                                |
            +--------------+--------------------------------------+

        If the :command:`upgrade-show` status indicates
        'data-migration-failed', then there is an issue with the data
        migration. Check the issue before proceeding to the next step.

    #.  Unlock controller-1.

        .. code-block:: none

            ~(keystone_admin)]$ system host-unlock controller-1

        Wait for controller-1 to become **unlocked-enabled**. Wait for the DRBD
        sync **400.001** Services-related alarm is raised and then cleared.

        The following states apply when this command is executed.

        -   upgrading-controllers:

            -   State entered when controller-1 has been unlocked and is
                running release nn.nn software.

        If it transitions to **unlocked-disabled-failed**, check the issue
        before proceeding to the next step. The alarms may indicate a
        configuration error. Check the result of the configuration logs on
        controller-1, \(for example, Error logs in controller1:/var/log/puppet\).

#.  Set controller-1 as the active controller. Swact to controller-1.

    .. code-block:: none

        ~(keystone_admin)]$ system host-swact controller-0

    Wait until services have gone active on the new active controller-1 before
    proceeding to the next step. When all services on controller-1 are
    enabled-active, the swact is complete.

#.  Upgrade **controller-0**.

    #.  Lock **controller-0**.

        .. code-block:: none

            ~(keystone_admin)]$ system host-lock controller-0

    #.  Upgrade **controller-0**.

        .. code-block:: none

            ~(keystone_admin)]$ system host-upgrade controller-0


    #.  Unlock **controller-0**.

        .. code-block:: none

            ~(keystone_admin)]$ system host-unlock controller-0

        Wait until the DRBD sync **400.001** Services-related alarm is raised
        and then cleared before proceeding to the next step.

        -   upgrading-hosts:

            -   State entered when both controllers are running release nn.nn
                software.

        .. note::
            |AIO-DX| or Controllers of Standard configurations can be
            upgraded, using steps 1-9 above.

#.  Check the system health to ensure that there are no unexpected alarms.

    .. code-block:: none

        ~(keystone_admin)]$ fm alarm-list

    Clear all alarms unrelated to the upgrade process.

#.  If using Ceph storage backend, upgrade the storage nodes one at a time.

    .. note::
        Proceed to step 13 if no storage/worker node is present.

    The storage node must be locked and all OSDs must be down in order to do
    the upgrade.

    #.  Lock storage-0.

        .. code-block:: none

            ~(keystone_admin)]$ system host-lock storage-0

    #.  Verify that the OSDs are down after the storage node is locked.

        In the Horizon interface, navigate to **Admin** \> **Platform** \>
        **Storage Overview** to view the status of the OSDs.

    #.  Upgrade storage-0.

        .. code-block:: none

            ~(keystone_admin)]$ system host-upgrade storage-0

        The upgrade is complete when the node comes online, and at that point,
        you can safely unlock the node.

        After upgrading a storage node, but before unlocking, there are Ceph
        synchronization alarms \(that appear to be making progress in
        synching\), and there are infrastructure network interface alarms
        \(since the infrastructure network interface configuration has not been
        applied to the storage node yet, as it has not been unlocked\).

        Unlock the node as soon as the upgraded storage node comes online.

    #.  Unlock storage-0.

        .. code-block:: none

            ~(keystone_admin)]$ system host-unlock storage-0

        Wait for all alarms to clear after the unlock before proceeding to
        upgrade the next storage host.

    #.  Repeat the above steps for each storage host.

        .. note::
            After upgrading the first storage node you can expect alarm
            **800.003**. The alarm is cleared after all storage nodes are
            upgraded.

#.  Upgrade worker hosts, one at a time, if any.

    #.  Lock worker-0.

        .. code-block:: none

            ~(keystone_admin)]$ system host-lock worker-0

    #.  Upgrade worker-0.

        .. code-block:: none

            ~(keystone_admin)]$ system host-upgrade worker-0

        Wait for the host to run the installer, reboot, and go online before
        unlocking it in the next step.

    #.  Unlock worker-0.

        .. code-block:: none

            ~(keystone_admin)]$ system host-unlock worker-0

        Wait for all alarms to clear after the unlock before proceeding to the
        next worker host.

    #.  Repeat the above steps for each worker host.

#.  Set controller-0 as the active controller. Swact to controller-0.

    .. code-block:: none

        ~(keystone_admin)]$ system host-swact controller-1

    Wait until services have gone active on the active controller-0 before
    proceeding to the next step. When all services on controller-0 are
    enabled-active, the swact is complete.

#.  Activate the upgrade.

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

    During the running of the :command:`upgrade-activate` command, new
    configurations are applied to the controller. 250.001 \(**hostname
    Configuration is out-of-date**\) alarms are raised and are cleared as the
    configuration is applied. The upgrade state goes from **activating** to
    **activation-complete** once this is done.

    The following states apply when this command is executed.

    **activation-requested**
        State entered when :command:`system upgrade-activate` is executed.

    **activating**
        State entered when we have started activating the upgrade by applying
        new configurations to the controller and compute hosts.

    **activating-hosts**
        State entered when applying host-specific configurations. This state is
        entered only if needed.

    **activation-complete**
        State entered when new configurations have been applied to all
        controller and compute hosts.

    #.  Check the status of the upgrade again to see it has reached
        **activation-complete**.

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

    .. note::
        This can take more than half an hour to complete.

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

    .. include:: /_includes/upgrading-all-in-one-duplex-or-standard.rest
        :start-after: upgradeDX-begin
        :end-before: upgradeDX-end
