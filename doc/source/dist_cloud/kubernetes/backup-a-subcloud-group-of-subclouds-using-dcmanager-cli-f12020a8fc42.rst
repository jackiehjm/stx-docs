.. _backup-a-subcloud-group-of-subclouds-using-dcmanager-cli-f12020a8fc42:

========================================================
Backup a Subcloud/Group of Subclouds using DCManager CLI
========================================================

A subcloud's system data and optionally container images (from registry.local)
can be backed up using dcmanager command line interface (|CLI|). The subcloud's
system backup data can either be stored locally on the subcloud or on the
system controller. The subcloud's container image backup (from registry.local)
can only be stored locally on the subcloud to avoid overloading central storage
and the network with large amount of data transfer.

By default, the system controller is used as backup archive storage. Once the
system data backup file has been generated on the subcloud, it will be
transferred to the system controller and stored at a dedicated central location
``/opt/dc-vault/backups/<subcloud-name>/<release-version>``.

Backup data creation requires the subcloud to be online, managed, and in
healthy state.

.. rubric:: |context|

The |CLI| command :command:`dcmanager subcloud-backup create` can be used to
backup a subcloud or a group of subclouds. The command accepts the following
parameters/options:

``--local-only``
    Generate a local backup archive and do not transfer to central storage
    (default storage location:
    ``/opt/platform-backup/backups/<release-version>``). If not specified,
    default is to transfer backup archive to central storage on
    systemController.

``--registry-images``
    Generate backup of container images from registry.local (local storage
    only. Default storage location:
    ``/opt/platform-backup/backups/<release-version``>)

``--subcloud <subcloud-name>``
    The subcloud to perform the backup operation on.

``--group <subcloud-group-name>``
    The group of subclouds to perform backup operations on.

``--backup-values <yaml-file>``
    The yaml file containing the customization parameters for the backup
    operation.

    -   ``exclude_dirs=/opt/patching/**/*``: To exclude patch data from being
        included in the Backup.
        
        .. warning::
        
            Patch data should only be excluded for |AIO-SX| subcloud deployments
            when optimized Restore is used.
            
        .. note::
            Excluding patch data can save a significant amount of storage space,
            transfer time, and compress/decompress the compute node.


    See :ref:`Run Ansible Backup Playbook Locally on the Controller
    <running-ansible-backup-playbook-locally-on-the-controller>` for the list
    of configurable system backup parameters

``--sysadmin-password <sysadmin-password>``
    If not specified, user will be prompted for the password. Recommend that
    this option is ONLY used for automation; i.e., for interactive use, don't
    use option and specify password on prompting, so as to avoid sysadmin
    password getting into log files.


The ``--subcloud/--group`` is a mandatory parameter.

When ``--registry-images`` option is applied, the entire registry filesystem
which contains both platform and user container images will be backed up.

Backup data of at most 2 software releases can be retained. Data of the oldest
software release will be removed to make room for data of the newest software
release. At most one set of backup data is stored for each release. The newly
generated set will replace the old one if exists.

The local storage location of backup data files can be customized using
``--backup-values <yaml-file>`` option. The ``--backup-values <yaml-file>``is
specified on the systemController every time you execute ``dcmanager
subcloud-backup create``, so the backup values are easily re-applied to a
subcloud regardless of whether it has been re-installled or not.Storage
location customization and/or backup filename customization can also lead to
complications in restoring a group of subclouds.

It is not possible to customize the central storage location. Backup data of
all subclouds stored centrally will have the same naming convention and be
stored at ``/opt/dc-vault/backups/<subcloud>/<release>/``.

Back up a single subcloud
-------------------------

.. rubric:: |prereq|

-   The System Controller is healthy and ready to accept dcmanager related
    commands.

-   For central storage, the ``dc-vault`` filesystem has enough storage to
    accommodate new subcloud backup files.

-   For local storage, the ``/opt/platform-backup`` partition on the subcloud
    has enough storage to accommodate new subcloud backup files(s).

-   The subcloud is managed, online and healthy.

.. rubric:: |proc|

To backup a subcloud system data and store the backup file in the central
storage:

.. code-block:: none

    ~(keystone_admin)]$ dcmanager subcloud-backup create --subcloud <subcloud> --sysadmin-password <sysadmin-password>

To backup a subcloud system data and store the backup file in default local
storage:

.. code-block:: none

    ~(keystone_admin)]$ dcmanager subcloud-backup create --subcloud <subcloud> --local-only --sysadmin-password <sysadmin-password>

To backup a subcloud system data as well as all container images and store the
backup files in default local storage:

.. code-block:: none

    ~(keystone_admin)]$ dcmanager subcloud-backup create --subcloud <subcloud> --local-only --registry-images --sysadmin-password <sysadmin-password>

.. note::

    -   The ``--registry-images`` option must only be used with ``--local-only``
        option.

    -   The images backup file will contain both platform and user/custom
        images that are in the subcloud local registry.


To backup a subcloud system data with a custom filename and store the backup
file in default local storage:

#.  Create a yaml file e.g. ``backup_overrides.yaml`` with the following
    content:

    .. code-block:: none

        platform_backup_filename_prefix: test_backup

#.  Then, run the command:

    .. code-block:: none

        ~(keystone_admin)]$ dcmanager subcloud-backup create --subcloud <subcloud> --local-only --backup-values backup_overrides.yaml --sysadmin-password <sysadmin_password>

Sample response to a single subcloud backup:

.. code-block:: none

    +-----------------------------+----------------------------+
    | Field                       | Value                      |
    +-----------------------------+----------------------------+
    | id                          | 7                          |
    | name                        | subcloud1                  |
    | description                 | None                       |
    | location                    | None                       |
    | software_version            | 22.12                      |
    | management                  | managed                    |
    | availability                | online                     |
    | deploy_status               | complete                   |
    | management_subnet           | fd01:176::0/64             |
    | management_start_ip         | fd01:176::2                |
    | management_end_ip           | fd01:176::11               |
    | management_gateway_ip       | fd01:176::1                |
    | systemcontroller_gateway_ip | fd01:1::1                  |
    | group_id                    | 1                          |
    | created_at                  | 2022-12-13 00:09:44.543494 |
    | updated_at                  | 2022-12-13 01:25:16.343380 |
    | backup_status               | initial                    |
    | backup_datetime             | None                       |
    +-----------------------------+----------------------------+

To view the progress of subcloud backup, use :command:`dcmanager subcloud show`
or :command:`dcmanager subcloud list` command:

.. code-block:: none

    ~(keystone_admin)]$ dcmanager subcloud show subcloud1

    +-----------------------------+----------------------------+
    | Field                       | Value                      |
    +-----------------------------+----------------------------+
    | id                          | 7                          |
    | name                        | subcloud1                  |
    | description                 | None                       |
    | location                    | None                       |
    | software_version            | 22.12                      |
    | management                  | managed                    |
    | availability                | online                     |
    | deploy_status               | complete                   |
    | management_subnet           | fd01:176::0/64             |
    | management_start_ip         | fd01:176::2                |
    | management_end_ip           | fd01:176::11               |
    | management_gateway_ip       | fd01:176::1                |
    | systemcontroller_gateway_ip | fd01:1::1                  |
    | group_id                    | 1                          |
    | created_at                  | 2022-12-13 00:09:44.543494 |
    | updated_at                  | 2022-12-13 04:13:46.462597 |
    | backup_status               | backing-up                 |
    | backup_datetime             | None                       |
    | dc-cert_sync_status         | in-sync                    |
    | firmware_sync_status        | in-sync                    |
    | identity_sync_status        | in-sync                    |
    | kubernetes_sync_status      | in-sync                    |
    | kube-rootca_sync_status     | in-sync                    |
    | load_sync_status            | in-sync                    |
    | patching_sync_status        | in-sync                    |
    | platform_sync_status        | in-sync                    |
    +-----------------------------+----------------------------+

If the backup operation completes successfully, the backup_status field will
show as complete and where the backup file is stored (central vs local); and
the ``backup_datetime`` will show the time the backup was taken.

For example:

.. code-block:: none

    ~(keystone_admin)]$ dcmanager subcloud list

    +----+-----------+------------+--------------+---------------+---------+------------------+----------------------------+
    | id | name      | management | availability | deploy status | sync    | backup status    | backup datetime            |
    +----+-----------+------------+--------------+---------------+---------+------------------+----------------------------+
    |  4 | subcloud1 | managed    | online       | complete      | in-sync | complete-local   | 2022-12-12 18:47:10.221813 |
    |  7 | subcloud2 | managed    | online       | complete      | in-sync | complete-central | 2022-12-13 04:17:15.281068 |
    +----+-----------+------------+--------------+---------------+---------+------------------+----------------------------+

If the backup operation fails, :command:`dcmanager subcloud errors` command can
be used to view the error.

Back up a group of subclouds
----------------------------

The above ``subcloud-backup create`` operations can be performed for a group of
subclouds simultaneously by replacing ``--subcloud`` option with ``--group``
option. For instance, to backup system data for a group of subclouds and store
the backup files in the central storage:

.. code-block:: none

    ~(keystone_admin)]$ dcmanager subcloud-backup create --group <group> --sysadmin-password <sysadmin-password>

If all subclouds in the group are unmanaged or offline, an error message will
be displayed. If some of the subclouds in the group meet backup operation
criteria, a list will be displayed.

Sample group backup response:

.. code-block:: none

    +----+-----------+-------------+----------+------------------+------------+--------------+---------------+-------------------+---------------------+-------------------+-----------------------+-----------------------------+----------+----------------------------+----------------------------+---------------+-----------------+
    | id | name      | description | location | software_version | management | availability | deploy_status | management_subnet | management_start_ip | management_end_ip | management_gateway_ip | systemcontroller_gateway_ip | group_id | created_at                 | updated_at                 | backup_status | backup_datetime |
    +----+-----------+-------------+----------+------------------+------------+--------------+---------------+-------------------+---------------------+-------------------+-----------------------+-----------------------------+----------+----------------------------+----------------------------+---------------+-----------------+
    |  8 | subcloud1 | None        | None     | 22.12            | managed    | online       | complete      | fd01:15::0/64     | fd01:15::2          | fd01:15::11       | fd01:15::1            | fd01:1::1                   |        2 | 2022-12-13 18:23:03.883068 | 2022-12-13 21:28:10.190154 | initial       | None            |
    |  9 | subcloud2 | None        | None     | 22.12            | managed    | online       | complete      | fd01:176::0/64    | fd01:176::2         | fd01:176::11      | fd01:176::1           | fd01:1::1                   |        2 | 2022-12-13 19:27:55.115604 | 2022-12-13 21:28:17.221334 | initial       | None            |
    +----+-----------+-------------+----------+------------------+------------+--------------+---------------+-------------------+---------------------+-------------------+-----------------------+-----------------------------+----------+----------------------------+----------------------------+---------------+-----------------+

To view the progress of subcloud group backup, use :command:`dcmanager subcloud list`
or :command:`dcmanager subcloud-group list-subclouds` command.

.. code-block:: none

    ~(keystone_admin)]$ watch dcmanager subcloud list

    +----+-----------+------------+--------------+---------------+---------+---------------+-----------------+
    | id | name      | management | availability | deploy status | sync    | backup status | backup datetime |
    +----+-----------+------------+--------------+---------------+---------+---------------+-----------------+
    |  8 | subcloud1 | managed    | online       | complete      | in-sync | backing-up    | None            |
    |  9 | subcloud2 | managed    | online       | complete      | in-sync | backing-up    | None            |
    +----+-----------+------------+--------------+---------------+---------+---------------+-----------------+

