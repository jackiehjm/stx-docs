
.. nfq1592854955302
.. _upgrading-all-in-one-simplex:

==========================
Upgrade All-in-One Simplex
==========================

You can upgrade a |prod| Simplex configuration with a new release of |prod|
software.

.. rubric:: |prereq|

.. _upgrading-all-in-one-simplex-ul-ezb-b11-cx:

-   Perform a full backup to allow recovery.

    .. note::
       Back up files in the /home/sysadmin and /rootdirectories prior to doing
       an upgrade. Home directories are not preserved during backup or restore
       operations, blade replacement, or upgrades.

-   The system must be 'patch current'. All upgrades available for the current
    release running on the system must be applied. To find and download
    applicable upgrades, visit the |dnload-loc| site.

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

#.  Source the platform environment.

    .. code-block:: none

        $ source /etc/platform/openrc
        ~(keystone_admin)]$

#.  Install the license file for the release you are upgrading to, for example,
    20.06.

    .. code-block:: none

        ~(keystone_admin)]$ system license-install <license_file>

    For example,

    .. code-block:: none

        ~(keystone_admin)]$ system license-install license.lic

#.  Import the new release.

    #.  Run the :command:`load-import` command on **controller-0** to import
        the new release.

        First, source /etc/platform/openrc.

        You must specify an exact path to the \*.iso bootimage file and to the
        \*.sig bootimage signature file.

        .. code-block:: none

            $ source /etc/platform/openrc
            ~(keystone_admin)]$ system load-import /home/sysadmin/<bootimage>.iso \
            <bootimage>.sig
            +--------------------+-----------+
            | Property           | Value     |
            +--------------------+-----------+
            | id                 | 2         |
            | state              | importing |
            | software_version   | 20.06     |
            | compatible_version | 20.04     |
            | required_patches   |           |
            +--------------------+-----------+

        The :command:`load-import` must be done on **controller-0** and accepts
        relative paths.

    #.  Check to ensure the load was successfully imported.

        .. code-block:: none

            ~(keystone_admin)]$ system load-list

            +----+----------+------------------+
            | id | state    | software_version |
            +----+----------+------------------+
            | 1  | active   | 20.04            |
            | 2  | imported | 20.06            |
            +----+----------+------------------+

#.  Apply any required software updates.

    The system must be 'patch current'. All software updates related to your
    current |prod| software release must be, uploaded, applied, and installed.

    All software updates to the new |prod| release, only need to be uploaded
    and applied. The install of these software updates will occur automatically
    during the software upgrade procedure as the hosts are reset to load the
    new release of software.

    To find and download applicable updates, visit the |dnload-loc|.

    For more information, see :ref:`Manage Software Updates
    <managing-software-updates>`.

#.  Confirm that the system is healthy.

    Check the current system health status, resolve any alarms and other issues
    reported by the :command:`health-query-upgrade` command, then recheck the
    system health status to confirm that all **System Health** fields are set
    to **OK**.

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

    By default, the upgrade process cannot be run and is not recommended to be
    run with Active Alarms present. However, management affecting alarms can be
    ignored with the :command:`--force` option with the :command:`system
    upgrade-start` command to force the upgrade process to start.

    .. note::
        It is strongly recommended that you clear your system of any and all
        alarms before doing an upgrade. While the :command:`--force` option is
        available to run the upgrade, it is a best practice to clear any
        alarms.

#.  Start the upgrade.

    .. code-block:: none

        ~(keystone_admin)]$ system upgrade-start
        +--------------+--------------------------------------+
        | Property     | Value                                |
        +--------------+--------------------------------------+
        | uuid         | 61e5fcd7-a38d-40b0-ab83-8be55b87fee2 |
        | state        | starting                             |
        | from_release | 20.04                                |
        | to_release   | 20.06                                |
        +--------------+--------------------------------------+

    This will back up the system data and images to /opt/platform-backup.
    /opt/platform-backup is preserved when the host is reinstalled. With the
    platform backup, the size of /home/sysadmin must be less than 2GB.

    This process may take several minutes.

    When the upgrade state is upgraded to **started** the process is complete.

    Any changes made to the system after this point will be lost when the data
    is restored.

    The following upgrade state applies once this command is executed:

    -   started:

        -   State entered after :command:`system upgrade-start` completes.

        -   Release 20.04 system data \(for example, postgres databases\) has
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

#.  Check the upgrade state.

    .. code-block:: none

        ~(keystone_admin)]$ system upgrade-show
        +--------------+--------------------------------------+
        | Property     | Value                                |
        +--------------+--------------------------------------+
        | uuid         | 61e5fcd7-a38d-40b0-ab83-8be55b87fee2 |
        | state        | started                              |
        | from_release | 20.04                                |
        | to_release   | 20.06                                |
        +--------------+--------------------------------------+

#.  \(Optional\) Copy the upgrade data from the system to an alternate safe
    location \(such as a USB drive or remote server\).

    The upgrade data is located under /opt/platform-backup. Example file names
    are:

    **lost+found upgrade\_data\_2020-06-23T033950\_61e5fcd7-a38d-40b0-ab83-8be55b87fee2.tgz**

    .. code-block:: none

        ~(keystone_admin)]$ ls /opt/platform-backup/

#.  Lock controller-0.

    .. code-block:: none

        ~(keystone_admin)]$ system host-lock controller-0

#.  Start Upgrade controller-0.

    This is the point of no return. All data except /opt/platform-backup/ will
    be erased from the system. This will wipe the **rootfs** and reboot the
    host. The new release must then be manually installed \(via network or
    USB\).

    .. code-block:: none

        ~(keystone_admin)]$ system host-upgrade controller-0
        WARNING: THIS OPERATION WILL COMPLETELY ERASE ALL DATA FROM THE SYSTEM.
        Only proceed once the system data has been copied to another system.
        Are you absolutely sure you want to continue?  [yes/N]: yes

#.  Install the new release of |prod-long| Simplex software via network or USB.

#.  Restore the upgrade data.

    .. code-block:: none

        ~(keystone_admin)]$ ansible-playbook /usr/share/ansible/stx-ansible/playbooks/upgrade_platform.yml

    Once the host has installed the new load, this will restore the upgrade
    data and migrate it to the new load.

    The playbook can be run locally or remotely and must be provided with the
    following parameter:

    ``ansible_become_pass``

    The ansible playbook will check /home/sysadmin/<hostname\>.yml for these
    user configuration override files for hosts. For example, if running
    ansible locally, /home/sysadmin/localhost.yml.

    By default the playbook will search for the upgrade data file under
    /opt/platform-backup. If required, use the **upgrade\_data\_file**
    parameter to specify the path to the **upgrade\_data**.

    .. note::
        This playbook does not support replay.

    Once the data restoration is complete the upgrade state will be set to
    **upgrading-hosts**.

#.  Check the status of the upgrade.

    .. code-block:: none

        ~(keystone_admin)]$ system upgrade-show
        +--------------+--------------------------------------+
        | Property     | Value                                |
        +--------------+--------------------------------------+
        | uuid         | 61e5fcd7-a38d-40b0-ab83-8be55b87fee2 |
        | state        | upgrading-hosts                      |
        | from_release | 20.04                                |
        | to_release   | 20.06                                |
        +--------------+--------------------------------------+

#.  Unlock controller-0.

    .. code-block:: none

        ~(keystone_admin)]$ system host-unlock controller-0

    This step is required only for Simplex systems that are not a subcloud.

#.  Activate the upgrade.

    During the running of the :command:`upgrade-activate` command, new
    configurations are applied to the controller. 250.001 \(**hostname
    Configuration is out-of-date**\) alarms are raised and are cleared as the
    configuration is applied. The upgrade state goes from **activating** to
    **activation-complete** once this is done.

    .. code-block:: none

        ~(keystone_admin)]$ system upgrade-activate
        +--------------+--------------------------------------+
        | Property     | Value                                |
        +--------------+--------------------------------------+
        | uuid         | 61e5fcd7-a38d-40b0-ab83-8be55b87fee2 |
        | state        | activating                           |
        | from_release | 20.04                                |
        | to_release   | 20.06                                |
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
            | from_release | 20.04                                |
            | to_release   | 20.06                                |
            +--------------+--------------------------------------+

#.  Complete the upgrade.

    .. code-block:: none

        ~(keystone_admin)]$ system upgrade-complete
        +--------------+--------------------------------------+
        | Property     | Value                                |
        +--------------+--------------------------------------+
        | uuid         | 61e5fcd7-a38d-40b0-ab83-8be55b87fee2 |
        | state        | completing                           |
        | from_release | 20.04                                |
        | to_release   | 20.06                                |
        +--------------+--------------------------------------+

#.  Delete the imported load.

    .. code-block:: none

        ~(keystone_admin)]$ system load-list
        +----+----------+------------------+
        | id | state    | software_version |
        +----+----------+------------------+
        | 1  | imported | 20.04            |
        | 2  | active   | 20.06            |
        +----+----------+------------------+

        ~(keystone_admin)]$ system load-delete 1
        Deleted load: load 1
