.. _restore-a-subcloud-group-of-subclouds-from-backup-data-using-dcmanager-cli-f10c1b63a95e:

==========================================================================
Restore a Subcloud/Group of Subclouds from Backup Data Using DCManager CLI
==========================================================================

A subcloud can be restored from its backup data previously stored centrally on
the system controller or locally on the subcloud using dcmanager command line
interface (|CLI|). The subcloud install data must be available for this
operation to proceed. The subcloud must support Redfish Virtual Media Service
(version 1.2 or higher) if remote installation is required.

.. rubric:: |context|

The |CLI| command :command:`dcmanager subcloud-backup restore` can be used to
restore a subcloud or a group of subclouds. By default, the restore is done
from subcloud backup data on the central systemController. The command accepts
the following parameters/options:

``--with-install``
    Perform remote installation of the subcloud prior to execution of restore
    procedure. The subcloud must support Redfish Virutal Media Service (version
    1.2 or higher) to use this option.

``--local-only``
    Use the local backup archive (default local storage
    ``/opt/platform-backup/backups/<release-version>``). If not specified, the
    subcloud backup archive on the central systemController will be used.

``--registry-images``
    Restore saved container images to registry.local as part of restore
    procedure (local storage only)

``--subcloud <subcloud-name>``
    The subcloud to restore.

``--group <subcloud-group-name>``
    The group of subclouds to restore.

``--restore-values <yaml-file>``
    The yaml file containing the customization parameters.

    -   ``wipe_ceph_osds=false``: To keep the Ceph cluster data intact.
    -   ``wipe_ceph_osds=true``: To wipe the Ceph cluster entirely.
    -   ``on_box_data=true``: To indicate that the backup data file is under
        /opt/platform-backup directory on the local machine.
    -   ``bootstrap_address``: List of subclouds and their corresponding
        bootstrap addresses for connectivity.

        .. code-block:: none

            bootstrap_address:
              <subcloud_name1>: <subcloud_bootstrap_address1>
              <subcloud_name2>: <subcloud_bootstrap_address2>
        
        .. note::

            The ``bootstrap_address`` key is only necessary for the restore of
            manually installed subclouds. For the subclouds installed via
            Redfish, the ``bootstrap_address`` is already available in the
            install values.

    See :ref:`Run Restore Playbook Locally on the Controller
    <running-restore-playbook-locally-on-the-controller>` for the list of
    configurable system restore parameters.

``--sysadmin-password <sysadmin-password>``
    If not specified, user will be prompted for the password. Recommend that
    this option is ONLY used for automation; i.e., for interactive use, don't
    use option and specify password on prompting, so as to avoid sysadmin
    password getting into log files.

The ``--subcloud/--group`` is a mandatory parameter.

"When ``--registry-images`` option is applied, the entire registry filesystem
which contains both platform and user container images will be restored.

After the subcloud has been re-installed with the desired release version, the
backup archive for that release will be transferred to the subcloud for the
restore operation by default. If ``--local-only`` option is specified, the local
backup archive for the release will be used instead.

It is possible to specify a custom location of the backup file that resides on
the subcloud using ``--restore-values`` option and by setting
``initial_backup_dir`` and ``backup_filename`` in the provided
``restore_values`` yaml file. Please ensure this custom backup file is not
corrupted and is compatible with software release the subcloud was installed
with.


To restore images from a custom backup file on the subcloud using
``--restore-values <yaml-file>`` option, the registry_backup_filename parameter
must be set in ``restore_values`` yaml file.


Restore a single subcloud
-------------------------

.. rubric:: |prereq|

-   The System Controller is healthy and ready to accept dcmanager related
    commands.

-   The subcloud is unmanaged and is in a valid state for restore operation
    (i.e. not being restored, installed, bootstrapped, deployed or rehomed).

-   The subcloud install data is available.

-   The backup file(s) exists and is compatible with the software release the
    subcloud is being restored to.


.. rubric:: |proc|

To restore a subcloud, including remote installation, from system backup data
in central storage:

.. code-block:: none

    ~(keystone_admin)]$ dcmanager subcloud-backup restore --subcloud <subcloud-name> --with-install --sysadmin-password <sysadmin-password>

To restore a pre-installed subcloud from system backup data in central storage:

.. code-block:: none

    ~(keystone_admin)]$ dcmanager subcloud-backup restore --subcloud <subcloud-name> --sysadmin-password <sysadmin-password>

To restore a subcloud, including remote installation, from system backup data
stored in default local storage:

.. code-block:: none

    ~(keystone_admin)]$ dcmanager subcloud-backup restore --subcloud <subcloud-name> --with-install --local-only --sysadmin-password <sysadmin-password>

To restore a subcloud, including remote installation, from system backup and
images backup data in default local storage:

.. code-block:: none

    ~(keystone_admin)]$ dcmanager subcloud-backup restore --subcloud <subcloud-name> --local-only --registry-images --sysadmin-password <sysadmin-password>

.. note::

    The ``--registry-images`` option can only be used with ``--local-only``
    option.


To restore a pre-installed subcloud from system and images backup data stored
at custom location on the subcloud:

#.  Create a yaml file e.g. ``restore_overrides.yaml`` with the following
    content:

    .. code-block:: none

        initial_backup_dir: /home/sysadmin/mybackup_dir
        backup_filename: test_platform_backup.tgz
        registry_backup_filename: test_images_backup.tgz

#.  Then, run the command:

    .. code-block:: none

        ~(keystone_admin)]$ dcmanager subcloud-backup restore --subcloud subcloud1 --local-only –-registry-images --restore-values restore_overrides.yaml --sysadmin-password <sysadmin-password>

Sample response to a single subcloud restore:

.. code-block:: none

    +-----------------------------+----------------------------+
    | Field                       | Value                      |
    +-----------------------------+----------------------------+
    | id                          | 8                          |
    | name                        | subcloud1                  |
    | description                 | None                       |
    | location                    | None                       |
    | software_version            | 22.12                      |
    | management                  | unmanaged                  |
    | availability                | offline                    |
    | deploy_status               | restore-failed             |
    | management_subnet           | fd01:15::0/64              |
    | management_start_ip         | fd01:15::2                 |
    | management_end_ip           | fd01:15::11                |
    | management_gateway_ip       | fd01:15::1                 |
    | systemcontroller_gateway_ip | fd01:1::1                  |
    | group_id                    | 2                          |
    | created_at                  | 2022-12-12 05:29:23.807243 |
    | updated_at                  | 2022-12-13 16:39:48.904037 |
    | backup_status               | unknown                    |
    | backup_datetime             | None                       |
    +-----------------------------+----------------------------+

.. note::

    The subcloud can be restored or restored again while in a failed deploy
    state such as:

    -   data-migration-failed (upgrade failure)

    -   restore-failed (previous restore attempt failed due to a bad backup file)

    -   rehome-failed

To view the progress of subcloud restore, please use :command:`dcmanager subcloud show`
or :command:`dcmanager subcloud list` command:

.. code-block:: none

    ~(keystone_admin)]$ dcmanager subcloud show subcloud1

    +-----------------------------+----------------------------+
    | Field                       | Value                      |
    +-----------------------------+----------------------------+
    | id                          | 9                          |
    | name                        | subcloud2                  |
    | description                 | None                       |
    | location                    | None                       |
    | software_version            | 22.12                      |
    | management                  | unmanaged                  |
    | availability                | offline                    |
    | deploy_status               | restoring                  |
    | management_subnet           | fd01:176::0/64             |
    | management_start_ip         | fd01:176::2                |
    | management_end_ip           | fd01:176::11               |
    | management_gateway_ip       | fd01:176::1                |
    | systemcontroller_gateway_ip | fd01:1::1                  |
    | group_id                    | 2                          |
    | created_at                  | 2022-12-13 00:09:44.543494 |
    | updated_at                  | 2022-12-13 18:23:20.659138 |
    | backup_status               | unknown                    |
    | backup_datetime             | None                       |
    | dc-cert_sync_status         | unknown                    |
    | firmware_sync_status        | unknown                    |
    | identity_sync_status        | unknown                    |
    | kubernetes_sync_status      | unknown                    |
    | kube-rootca_sync_status     | unknown                    |
    | load_sync_status            | unknown                    |
    | patching_sync_status        | unknown                    |
    | platform_sync_status        | unknown                    |
    +-----------------------------+----------------------------+

If the restore operation completes successfully, the subcloud will become
online and the ``deploy_status`` will be set to 'complete'.

Please continue with :ref:`Post restore procedure <post-restore-procedure>`.

If the restore operation fails, :command:`dcmanager subcloud errors` command
can be used to view the error.


Restore a group of subclouds
----------------------------

The above subcloud-backup restore operations can be performed for a group of
subclouds simultaneously by replacing ``--subcloud`` option with ``--group``
option. For instance, to restore a group of subclouds with remote installation
from their system data in central storage:

.. code-block:: none

    ~(keystone_admin)]$ dcmanager subcloud-backup restore --group <group> --with-install --sysadmin-password <sysadmin-password>


If all subclouds in the group are not in the valid state for restore, an error
message will be displayed. If some of the subclouds in the group meet restore
operation criteria, a list will be displayed.

Sample group restore response:

.. code-block:: none

    +----+-----------+-------------+----------+------------------+------------+--------------+---------------+-------------------+---------------------+-------------------+-----------------------+-----------------------------+----------+----------------------------+----------------------------+----------------+----------------------------+
    | id | name      | description | location | software_version | management | availability | deploy_status | management_subnet | management_start_ip | management_end_ip | management_gateway_ip | systemcontroller_gateway_ip | group_id | created_at                 | updated_at                 | backup_status  | backup_datetime            |
    +----+-----------+-------------+----------+------------------+------------+--------------+---------------+-------------------+---------------------+-------------------+-----------------------+-----------------------------+----------+----------------------------+----------------------------+----------------+----------------------------+
    |  8 | subcloud6 | None        | None     | 22.12            | unmanaged  | online       | complete      | fd01:15::0/64     | fd01:15::2          | fd01:15::11       | fd01:15::1            | fd01:1::1                   |        2 | 2022-12-13 18:23:03.883068 | 2022-12-13 22:14:39.331199 | complete-local | 2022-12-13 22:04:06.232043 |
    |  9 | subcloud8 | None        | None     | 22.12            | unmanaged  | online       | complete      | fd01:176::0/64    | fd01:176::2         | fd01:176::11      | fd01:176::1           | fd01:1::1                   |        2 | 2022-12-13 19:27:55.115604 | 2022-12-13 22:15:09.287665 | complete-local | 2022-12-13 22:05:03.785280 |
    +----+-----------+-------------+----------+------------------+------------+--------------+---------------+-------------------+---------------------+-------------------+-----------------------+-----------------------------+----------+----------------------------+----------------------------+----------------+----------------------------+

After group restore is complete, continue with :ref:`Post restore procedure
<post-restore-procedure>` for each subcloud in the group.

.. _post-restore-procedure:

Post restore procedure
----------------------

**AIO-SX subcloud**

Resume subcloud audit with the command:

.. code-block:: none

    ~(keystone_admin)]$ dcmanager subcloud manage

**AIO-DX/Standard subcloud**

After the controller-0 has been restored and the subcloud becomes online,
follow the procedure :ref:`Restore Platform System Data and Storage
<restoring-starlingx-system-data-and-storage>` to restore the rest of the
subcloud nodes.

Resume subcloud audit with the command:

.. code-block:: none

    ~(keystone_admin)]$ dcmanager subcloud manage


