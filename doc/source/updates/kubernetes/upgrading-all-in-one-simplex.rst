
.. nfq1592854955302
.. _upgrading-all-in-one-simplex:

==========================
Upgrade All-in-One Simplex
==========================

You can upgrade a |prod| Simplex configuration with a new release of |prod|
software.

.. rubric:: |prereq|


.. _upgrading-all-in-one-simplex-ul-ezb-b11-cx:

-   Validate the list of new images with the target release. If you are using a
    private registry for installs/upgrades, you must populate your private
    registry with the new images prior to bootstrap and/or patch application.

-   Perform a full backup to allow recovery.

    .. note::

       Back up files in the ``/root`` directory prior to doing an upgrade, the
       ``/home`` size limit is 2000 MB. Although container image sizes are
       preserved, ``/root`` directory is not preserved during backup or restore
       operations, server replacement, or upgrades.

       For more details on backup and what is included see :ref:`Back Up System
       Data <backing-up-starlingx-system-data>`.

    .. note::

       The backup and restore function of an upgrade is specific to an |AIO-SX|
       deployment only.

-   Ensure that the following conditions are met:

    -   The system is patch current.

    -   There should be sufficient free space in ``/opt/platform-backup.``.
        Remove any unused files if necessary.

    -   The new software load has been imported.

    -   A valid license file has been installed.

-   Transfer the new release software load to controller-0 (or onto a USB
    stick); controller-0 must be active.

    .. note::

        Make sure that the ``/home/sysadmin`` directory has enough space (at
        least 2GB of free space), otherwise the upgrade may fail once it starts.
        If more space is needed, it is recommended to delete the ``.iso``
        bootimage previously imported after the :command:`load-import`
        command.

-   Transfer the new release software license file to controller-0 (or onto a
    USB stick).

-   Transfer the new release software signature to controller-0 (or onto a USB
    stick).

.. note::
    The upgrade procedure includes steps to resolve system health issues.

End user container images in ``registry.local`` will be backed up during the
upgrade process. This only includes images other than |prod| system and
application images. These images are limited to 5 GB in total size. If the
system contains more than 5 GB of these images, the upgrade start will fail.
For more details, see :ref:`Contents of System Backup
<backing-up-starlingx-system-data-ul-s3t-bz4-kjb>`.

.. rubric:: |proc|

#.  Source the platform environment.

    .. code-block:: none

        $ source /etc/platform/openrc
        ~(keystone_admin)]$

#.  Install the license file for the release you are upgrading to.

    .. code-block:: none

        ~(keystone_admin)]$ system license-install <license_file>

    For example,

    .. code-block:: none

        ~(keystone_admin)]$ system license-install license.lic

#.  Import the new release.

    #.  Run the :command:`load-import` command on controller-0 to import
        the new release.

        Source ``/etc/platform/openrc``. Also, you can specify either the
        full file path or relative paths to the ``*.iso`` bootimage file and to
        the ``*.sig`` bootimage signature file.

        .. code-block:: none

            $ source /etc/platform/openrc
            ~(keystone_admin)]$ system load-import [--local] /home/sysadmin/<bootimage>.iso <bootimage>.sig

            +--------------------+-----------+
            | Property           | Value     |
            +--------------------+-----------+
            | id                 | 2         |
            | state              | importing |
            | software_version   | nn.nn     |
            | compatible_version | nn.nn     |
            | required_patches   |           |
            +--------------------+-----------+

        The :command:`load-import` must be done on controller-0.

        (Optional) If ``--local`` is specified, the ISO and sig files are
        uploaded directly from the active controller, where `<local_iso_file_path>`
        and `<local_sig_file_path>` are paths on the active controller to load
        ISO files and sig files respectively.

        .. note::

            If ``--local`` is specified, the ISO and sig files are transferred
            directly from the active controller filesystem to the load directory,
            if it is not specified, the files are transferred via the API.

        .. note::
            This will take a few minutes to complete.

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

    All software updates to the new |prod| release only need to be uploaded
    and applied. The install of these software updates will occur automatically
    during the software upgrade procedure as the hosts are reset to load the
    new release of software.

    To find and download applicable updates, visit the |dnload-loc|.

    For more information, see :ref:`Manage Software Updates
    <managing-software-updates>`.

#.  Confirm that the system is healthy.

    .. note::
        Do not modify protected filesystem directories before backup.

    Check the current system health status, resolve any alarms and other issues
    reported by the :command:`system health-query-upgrade` command, then
    recheck the system health status to confirm that all **System Health**
    fields are set to *OK*.

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
        All PodSecurityPolicies are removed: [OK]
        Required patches are applied: [OK]
        License valid for upgrade: [OK]
        No instances running on controller-1: [OK]
        All kubernetes applications are in a valid state: [OK]
        Active controller is controller-0: [OK]
        Disk space requirement: [OK]
        Boot Device and Root file system Device: [OK]

    By default, the upgrade process cannot be run with Active Alarms present.
    However, management affecting alarms can be ignored with the
    :command:`--force` option with the :command:`system upgrade-start` command
    to force the upgrade process to start.

    .. note::
        It is strongly recommended that you clear your system of all
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
        | from_release | nn.nn                                |
        | to_release   | nn.nn                                |
        +--------------+--------------------------------------+

    This will back up the system data and images to ``/opt/platform-backup.``.
    ``/opt/platform-backup.`` is preserved when the host is reinstalled. With the
    platform backup, the size of ``/home/sysadmin`` must be less than 2GB.

    This process may take several minutes.

    When the upgrade state is upgraded to *started* the process is complete.

    Any changes made to the system after this point will be lost when the data
    is restored.

    The following upgrade state applies once this command is executed:

    -   ``started``:

        -   State entered after :command:`system upgrade-start` completes.

        -   Release <nn>.<nn> system data (for example, postgres databases) has
            been exported to be used in the upgrade.

        -   Configuration changes must not be made after this point, until the
            upgrade is completed.

    The upgrade process checks the health of the system and validates that the
    system is ready for an upgrade.

    The upgrade process checks that no alarms are active before starting an
    upgrade.

    .. note::

        Use the command :command:`system upgrade-start --force` to force the
        upgrades process to start and to ignore management affecting alarms.
        This should **ONLY** be done if you have ascertained that these alarms
        will not interfere with the upgrades process.

#.  Check the upgrade state.

    .. code-block:: none

        ~(keystone_admin)]$ system upgrade-show
        +--------------+--------------------------------------+
        | Property     | Value                                |
        +--------------+--------------------------------------+
        | uuid         | 61e5fcd7-a38d-40b0-ab83-8be55b87fee2 |
        | state        | started                              |
        | from_release | nn.nn                                |
        | to_release   | nn.nn                                |
        +--------------+--------------------------------------+

    Ensure the upgrade state is *started*. It will take several minutes to
    transition to the *started* state.

#.  (Optional) Copy the upgrade data from the system to an alternate safe
    location (such as a USB drive or remote server).

    The upgrade data is located under ``/opt/platform-backup``. Example file names
    are:

    **lost+found upgrade_data_2020-06-23T033950\_61e5fcd7-a38d-40b0-ab83-8be55b87fee2.tgz**

    .. code-block:: none

        ~(keystone_admin)]$ ls /opt/platform-backup/

#.  Lock controller-0.

    .. code-block:: none

        ~(keystone_admin)]$ system host-lock controller-0

#.  Upgrade controller-0.

    This is the point of no return. All data except ``/opt/platform-backup/``
    will be erased from the system. This will wipe the ``rootfs`` and reboot the
    host. The new release must then be manually installed (via network or
    USB).

    .. code-block:: none

        ~(keystone_admin)]$ system host-upgrade controller-0
        WARNING: THIS OPERATION WILL COMPLETELY ERASE ALL DATA FROM THE SYSTEM.
        Only proceed once the system data has been copied to another system.
        Are you absolutely sure you want to continue?  [yes/N]: yes

#.  Install the new release of |prod-long| Simplex software via network or USB.

#.  Verify and configure IP connectivity. External connectivity is required to
    run the Ansible upgrade playbook. The |prod-long| boot image will |DHCP| out
    all interfaces so the server may have obtained an IP address and have
    external IP connectivity if a |DHCP| server is present in your environment.
    Verify this using the :command:`ip addr` command. Otherwise, manually
    configure an IP address and default IP route.

#.  Restore the upgrade data.

    .. code-block:: none

        ~(keystone_admin)]$ ansible-playbook /usr/share/ansible/stx-ansible/playbooks/upgrade_platform.yml

    .. only:: starlingx

        .. important::

            If you are upgrading from r7.0 to r8.0 use the command below instead:

            .. code-block:: none

                ansible-playbook /usr/share/ansible/stx-ansible/playbooks/upgrade_platform.yml -e "upgrade_mode=old"

    .. only:: partner

        .. include:: /_includes/upgrading-all-in-one-simplex.rest
           :start-after: note-upgrade-begin
           :end-before: note-upgrade-end

    Once the host has installed the new load, this will restore the upgrade
    data and migrate it to the new load.

    The playbook can be run locally or remotely and must be provided with the
    following parameter:

    ``ansible_become_pass``
       The ansible playbook will check ``/home/sysadmin/<hostname\>.yml`` for
       these user configuration override files for hosts. For example, if
       running ansible locally, ``/home/sysadmin/localhost.yml``.

    By default the playbook will search for the upgrade data file under
    ``/opt/platform-backup``. If required, use the ``upgrade_data_file``
    parameter to specify the path to the ``upgrade_data``.

    .. note::
        This playbook does not support replay.

    .. note::
        This can take more than one hour to complete.

    Once the data restoration is complete the upgrade state will be set to
    *upgrading-hosts*.

#.  Check the status of the upgrade.

    .. code-block:: none

        ~(keystone_admin)]$ system upgrade-show
        +--------------+--------------------------------------+
        | Property     | Value                                |
        +--------------+--------------------------------------+
        | uuid         | 61e5fcd7-a38d-40b0-ab83-8be55b87fee2 |
        | state        | upgrading-hosts                      |
        | from_release | nn.nn                                |
        | to_release   | nn.nn                                |
        +--------------+--------------------------------------+

#.  Unlock controller-0.

    .. code-block:: none

        ~(keystone_admin)]$ system host-unlock controller-0

    This step is required only for Simplex systems that are not a subcloud.

#.  Activate the upgrade.

    During the running of the :command:`upgrade-activate` command, new
    configurations are applied to the controller. 250.001 (**hostname
    Configuration is out-of-date**) alarms are raised and then cleared as the
    configuration is applied. The upgrade state goes from *activating* to
    *activation-complete* once this is done.

    .. only:: partner

        .. include:: /_includes/upgrading-all-in-one-simplex.rest
           :start-after: deploymentmanager-begin
           :end-before: deploymentmanager-end

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

    ``activation-requested``
        State entered when :command:`system upgrade-activate` is executed.

    ``activating``
        State entered when we have started activating the upgrade by applying
        new configurations to the controller and compute hosts.

    ``activating-hosts``
        State entered when applying host-specific configurations. This state is
        entered only if needed.

    ``activation-complete``
        State entered when new configurations have been applied to all
        controller and compute hosts.


    #.  Check the status of the upgrade again to see it has reached
        ``activation-complete``.


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

    **activation-failed**
        Check ``/var/log/sysinv.log`` for further information.

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

   .. include:: /_includes/upgrading-all-in-one-simplex.rest
       :start-after: upgradeAIO-begin
       :end-before: upgradeAIO-end
