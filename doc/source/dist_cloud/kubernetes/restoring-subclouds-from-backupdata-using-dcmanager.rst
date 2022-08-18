
.. _restoring-subclouds-from-backupdata-using-dcmanager:

=========================================================
Restoring a Subcloud From Backup Data Using DCManager CLI
=========================================================

For subclouds with servers that support Redfish Virtual Media Service
(version 1.2 or higher), you can use the Central Cloud's CLI to restore the
subcloud from data that was backed up previously.

.. rubric:: |context|

The CLI command :command:`dcmanager subcloud restore` can be used to restore a
subcloud from available system data and bring it back to the operational state
it was in when the backup procedure took place. The subcloud restore has three
phases:

-   Re-install the controller-0 of the subcloud with the current active load
    running in the SystemController. For subcloud servers that support
    Redfish Virtual Media Service, this phase can be carried out remotely
    as part of the CLI.

-   Run Ansible Platform Restore to restore |prod|, from a previous backup on
    the controller-0 of the subcloud. This phase is also carried out as part
    of the CLI.

-   Unlock the controller-0 of the subcloud and continue with the steps to
    restore the remaining nodes of the subcloud where applicable. This phase
    is carried out by the system administrator, see :ref:`Restoring Platform System Data and Storage <restoring-starlingx-system-data-and-storage>`.

.. rubric:: |prereq|

-   The SystemController is healthy, and ready to accept **dcmanager** related
    commands.

-   The subcloud is unmanaged, and not in the process of installation,
    bootstrap or deployment.

-   The platform backup tar file is already on the subcloud in
    ``/opt/platform-backup`` directory or has been transferred to the
    SystemController.

-   The subcloud install values have been saved in the **dcmanager** database
    i.e. the subcloud has been installed remotely as part of :command:`dcmanager subcloud add`.

.. rubric:: |proc|

#.  Create the ``restore_values.yaml`` file which will be passed to the
    :command:`dcmanager subcloud restore` command using the ``--restore-values``
    option. This file contains parameters that will be used during the platform
    restore phase. Minimally, the **backup_filename** parameter, indicating the
    file containing a previous backup of the subcloud, must be specified in the
    yaml file, see :ref:`Run Ansible Restore Playbook Remotely <system-backup-running-ansible-restore-playbook-remotely>`,
    and, :ref:`Run Restore Playbook Locally on the Controller <running-restore-playbook-locally-on-the-controller>`,
    for supported restore parameters.

#.  Restore the subcloud, using the dcmanager CLI command, :command:`subcloud restore`
    and specify the restore values, with the ``--with-install`` option and the
    subcloud's sysadmin password.

    .. code-block:: none

        ~(keystone_admin) $ dcmanager subcloud restore --restore-values /home/sysadmin/subcloud1-restore.yaml --with-install --sysadmin-password <sysadmin_password> subcloud-name-or-id

    Where:

    -  ``--restore-values`` must reference the restore values yaml file
       mentioned in Step 1 of this procedure.

    -  ``--with-install`` indicates that a re-install of controller-0 of the
       subcloud should be done remotely using Redfish Virtual Media Service.

    If the ``--sysadmin-password`` option is not specified, the system
    administrator will be prompted for the password. The password is masked
    when it is entered. Enter the sysadmin password for the subcloud.
    The **dcmanager subcloud restore** can take up to 30 minutes to reinstall
    and restore the platform on controller-0 of the subcloud.

#.  On the Central Cloud (SystemController), monitor the progress of the
    subcloud reinstall and restore via the deploy status field of the
    :command:`dcmanager subcloud list` command.

    .. code-block:: none

        ~(keystone_admin)]$ dcmanager subcloud list

        +----+-----------+------------+--------------+---------------+---------+
        | id | name      | management | availability | deploy status | sync    |
        +----+-----------+------------+--------------+---------------+---------+
        |  1 | subcloud1 | unmanaged  | online       | installing    | unknown |
        +----+-----------+------------+--------------+---------------+---------+

#.  In case of a failure, check the Ansible log for the corresponding subcloud
    under ``/var/log/dcmanager/ansible`` directory.

#.  When the subcloud deploy status changes to "complete", the controller-0
    is ready to be unlocked. Log into the controller-0 of the subcloud using
    its bootstrap IP and unlock the host using the following command.

    .. code-block:: none

        ~(keystone_admin)]$ system host-unlock controller-0

#.  For |AIO|-DX and Standard subclouds, follow the procedure,
    see :ref:`Restoring Platform System Data and Storage <restoring-starlingx-system-data-and-storage>`
    to restore the rest of the subcloud nodes.

#.  To resume subcloud audit, use the following command.

    .. code-block:: none

        ~(keystone_admin)]$ dcmanager subcloud manage
