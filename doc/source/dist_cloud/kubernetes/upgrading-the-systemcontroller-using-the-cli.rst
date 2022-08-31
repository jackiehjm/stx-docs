
.. vco1593176327490
.. _upgrading-the-systemcontroller-using-the-cli:

===========================================
Upgrade the System Controller Using the CLI
===========================================

You can upload and apply upgrades to the System Controller in order to upgrade
the central repository, from the CLI. The System Controller can be upgraded
using either a manual software upgrade procedure or by using the
non-distributed systems :command:`sw-manager` orchestration procedure.

.. rubric:: |context|

Follow the steps below to manually upgrade the System Controller:

.. rubric:: |proc|

.. _upgrading-the-systemcontroller-using-the-cli-steps-oq4-dgm-cmb:

#.  Source the platform environment.

    .. code-block:: none

        $ source /etc/platform/openrc
        ~(keystone_admin)]$

    .. only:: partner

        .. include:: /_includes/upgrading-the-systemcontroller-using-the-cli.rest
           :start-after: license-begin
           :end-before: license-end

#.  Transfer iso and signature files to controller-0 \(active controller\) and import the load.

    .. code-block:: none

        ~(keystone_admin)]$ system --os-region-name SystemController load-import <bootimage>.iso <bootimage>.sig

    For example,

    .. code-block:: none

        ~(keystone_admin)]$ system --os-region-name SystemController load-import <bootimage>.iso <bootimage>.sig

    .. note::
        This can take several minutes.

#.  Apply any required software updates. After the update is installed ensure
    controller-0 is active.

    The system must be 'patch current'. All software updates related to your
    current |prod| software release must be uploaded, applied, and installed.

    All software updates to the new |prod| release, only need to be uploaded
    and applied. The install of these software updates will occur automatically
    during the software upgrade procedure as the hosts are reset to load the
    new release of software.

    .. only:: partner

       .. include:: /_includes/upgrading-the-systemcontroller-using-the-cli.rest
          :start-after: wrsbegin
          :end-before: wrsend

    For more information, see |updates-doc|: :ref:`Managing Software Updates <managing-software-updates>`.

#.  Confirm that the system is healthy.

    Check the current system health status, resolve any alarms and other issues
    reported by the :command:`system health-query-upgrade` command then recheck
    the system health status to confirm that all **System Health** fields are
    set to **OK**.

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
            All kubernetes applications are in a valid state: [OK]
            Active controller is controller-0: [OK]

    By default, the upgrade process cannot run and is not recommended to run
    with active alarms present. It is strongly recommended that you clear your
    system of all alarms before doing an upgrade.

    .. note::

        Use the command :command:`system upgrade-start --force` to force the
        upgrade process to start and ignore non-management-affecting alarms.
        This should ONLY be done if these alarms do not cause an issue for the
        upgrades process.

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
    Configuration changes must not be made after this point, until the
    upgrade is completed.

    The following upgrade state applies once this command is executed. Run the
    :command:`system upgrade-show` command to verify the status of the upgrade.


    -   started:

        -   State entered after :command:`system upgrade-start` completes.

        -   Release <nn.nn> system data \(for example, postgres databases\) has
            been exported to be used in the upgrade.

    As part of the upgrade, the upgrade process checks the health of the system
    and validates that the system is ready for an upgrade.

    The upgrade process checks that no alarms are active before starting an
    upgrade.

    .. note::

        Use the command :command:`system upgrade-start --force` to force the
        upgrades process to start and to ignore management affecting alarms.
        This should ONLY be done if these alarms do not cause an issue for the
        upgrades process.

        The `fm alarm-list` will provide the specific alarms leading to the system
        health-query-upgrade alarms notes which may be blocking an orchestrated
        upgrade.

    On systems with Ceph storage, it also checks that the Ceph cluster is
    healthy.

#.  Upgrade controller-1.


    #.  Lock controller-1.

        .. code-block:: none

            ~(keystone_admin)]$ system host-lock controller-1

    #.  Start the upgrade on controller-1.

        Controller-1 installs the update and reboots, then performs data
        migration.

        .. code-block:: none

            ~(keystone_admin)]$ system host-upgrade controller-1

        Wait for controller-1 to reinstall with the load N+1 and becomes
        **locked-disabled-online** state.

        The following data migration states apply when this command is executed.


        -   data-migration:

            -   State entered when :command:`system host-upgrade controller-1`
                is executed.

            -   System data is being migrated from release N to release N+1.

        -   data-migration-complete or upgrading-controllers:

            -   State entered when controller-1 upgrade is complete.

            -   System data has been successfully migrated from release <nn.nn>
                to release <nn.nn>.

                where *nn.nn* in the update file name is the |prod| release number.

        -   data-migration-failed:

            -   State entered if data migration on controller-1 fails.

            -   Upgrade must be aborted.

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

        .. note::

            Do not unlock controller-1, before running :command:`system
            upgrade-show` to display the upgrade status
            "data-migration-complete".

    #.  Unlock controller-1.

        .. code-block:: none

            ~(keystone_admin)]$ system host-unlock controller-1

        Wait for controller-1 to become **unlocked-enabled**. Wait for the DRBD
        sync **400.001** Services-related alarm is raised and then cleared.

        The following states apply when this command is executed.


        -   upgrading-controllers:


            -   State entered when controller-1 has been unlocked and is
                running release nn.nn software.

                where *nn.nn* in the update file name is the |prod| release
                number.


        If it transitions to **unlocked-disabled-failed**, check the issue
        before proceeding to the next step. The alarms may indicate a
        configuration error. Check the result of the configuration logs on
        controller-1, (for example, Error logs in
        controller1:``/var/log/puppet``).

    #.  Run the :command:`system application-list`, and :command:`system
        host-upgrade-list` commands to view the current progress.

#.  Set controller-1 as the active controller. Swact to controller-1.

    .. code-block:: none

        ~(keystone_admin)]$ system host-swact controller-0

    Wait until services have gone active on the new active controller-1 before
    proceeding to the next step. When all services on controller-1 are
    enabled-active, the swact is complete.

    .. note::

        Continue the remaining steps below to manually upgrade or use upgrade
        orchestration to upgrade the remaining nodes.

#.  Upgrade **controller-0**.

    For more information, see :ref:`Updates and Upgrades
    <software-updates-and-upgrades-software-updates>`.

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

            -   State entered when both controllers are running release <nn.nn>
                software.


#.  Check the system health to ensure that there are no unexpected alarms.

    .. code-block:: none

        ~(keystone_admin)]$ fm alarm-list

    Clear all alarms unrelated to the upgrade process.

#.  If using Ceph storage backend, upgrade the storage nodes one at a time.

    The storage node must be locked and all |OSDs| must be down in order to do
    the upgrade.


    #.  Lock storage-0.

        .. code-block:: none

            ~(keystone_admin)]$ system host-lock storage-0

    #.  Verify that the |OSDs| are down after the storage node is locked.

        In the Horizon interface, navigate to **Admin** \> **Platform** \>
        **Storage Overview** to view the status of the |OSDs|.

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

#.  If worker nodes are present, upgrade worker hosts, serially or in parallel,
    if any.


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
        State entered when we have started activating the upgrade by
        applying new configurations to the controller and compute hosts.

    **activating-hosts**
        State entered when applying host-specific configurations. This state is
        entered only if needed.

    **activation-complete**
        State entered when new configurations have been applied to all
        controller and compute hosts.

    #.  Check the status of the upgrade again to see it has reached
        **activation-complete**, for example.

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

    .. note::

        Alarms are generated as the subcloud load sync_status is "out-of-sync".

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

    Run the :command:`system upgrade-show` command, and the status will display
    "no upgrade in progress". The subclouds will be out-of-sync.

.. only:: partner

    .. include:: /_includes/upgrading-the-systemcontroller-using-the-cli.rest
       :start-after: upgradeDM-begin
       :end-before: upgradeDM-end
