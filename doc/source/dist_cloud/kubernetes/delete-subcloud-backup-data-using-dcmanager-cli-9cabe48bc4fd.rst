.. _delete-subcloud-backup-data-using-dcmanager-cli-9cabe48bc4fd:

===============================================
Delete Subcloud Backup Data Using DCManager CLI
===============================================

Subcloud backup data stored centrally or locally can be removed using dcmanager
command line interface (|CLI|). Backup data removal from the local storage
requires the subcloud to be managed and online. This restriction does not apply
to data removal from central storage.

When a subcloud is deleted, its backup data in central storage is automatically
removed.

.. rubric:: |context|

The |CLI| command :command:`dcmanager subcloud-backup delete` can be used to
delete backup data for a subcloud or a group of subclouds. By default, the
command removes the subcloud backup data on the central systemController. The
command accepts the following parameters/options:

``release``
    Mandatory parameter specifying the which release's backup to remove

``--local-only``
    Remove backup data for the specified release on the subcloud

``--subcloud <subcloud-name>``
    The subcloud whose backup data should be removed

``--group <subcloud-group-name>``
    The group of subclouds whose backup data should be removed

``--sysadmin-password <sysadmin_password>``
    Only required if using --local-only option. If not specified when using
    --local-only option, user will be prompted for the password. Recommend that
    this option is ONLY used for automation; i.e., for interactive use, do not
    use option and specify password on prompting, so as to avoid sysadmin
    password getting into log files.


The release version and ``--subcloud/--group`` are mandatory parameters.

This operation has one caveat. After this command is carried out successfully,
both backup_status and ``backup_datetime`` fields will be set to 'unknown' and
'None' respectively even though there might be another set of backup data in
either central storage or local storage.


Delete backup data for a single subcloud
----------------------------------------

.. rubric:: |prereq|

-   The System Controller is healthy and ready to accept dcmanager related
    commands.

-   The release version is valid.

-   The subcloud is managed and online (applicable to backup data removal from
    local storage only).

.. rubric:: |proc|

To delete backup data for |prod| |prod-ver| from central storage:

.. code-block:: none

    ~(keystone_admin)]$ dcmanager subcloud-backup delete 22.12 --subcloud <subcloud>

To delete backup data for |prod| |prod-ver| from local storage:

.. code-block:: none

    ~(keystone_admin)]$ dcmanager subcloud-backup delete 22.12 --local-only --subcloud <subcloud> --sysadmin-password <sysadmin_password>


Delete backup data for a group of subclouds
-------------------------------------------

The above subcloud-backup delete operations can be performed for a group of
subclouds simultaneously by replacing ``--subcloud`` option with ``--group
option``. For instance, to delete backup data for |prod| |prod-ver| for a group
of subclouds from central storage:

.. code-block:: none

    ~(keystone_admin)]$ dcmanager subcloud-backup delete 22.12 -group <group>

