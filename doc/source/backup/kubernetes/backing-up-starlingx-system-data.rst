
.. hgq1552923986183
.. _backing-up-starlingx-system-data:

===================
Back Up System Data
===================

A system data backup of a |prod-long| system captures core system
information needed to restore a fully operational |prod-long| cluster.

.. contents:: In this section:
   :local:
   :depth: 1

.. _backing-up-starlingx-system-data-section-N1002E-N1002B-N10001:

System Data Backups include:

.. _backing-up-starlingx-system-data-ul-enh-3dl-lp:

-   platform configuration details

-   system databases

-   patching and package repositories

-   home directory for the **sysadmin** user and all |LDAP| user accounts.

.. xreflink See |sec-doc|: :ref:`Local LDAP Linux User Accounts
    <local-ldap-linux-user-accounts>` for additional information.

    .. note::
        If there is any change in hardware configuration, for example, new
        NICs, a system backup is required to ensure that there is no
        configuration mismatch after system restore.

.. _backing-up-starlingx-system-data-section-N10089-N1002B-N10001:

------------------------------------
Detailed contents of a system backup
------------------------------------

The backup contains details as listed below:

.. _backing-up-starlingx-system-data-ul-s3t-bz4-kjb:

-   Platform Configuration Data.

    All platform configuration data and files required to fully restore the
    system to a working state following the platform restore procedure.

-   \(Optional\) Any end user container images in **registry.local**; that
    is, any images other than |org| system and application images.
    |prod| system and application images are repulled from their
    original source, external registries during the restore procedure.

-   Home directory 'sysadmin' user, and all |LDAP| user accounts
    \(item=/etc\)

-   Patching and package repositories:

    -   item=/opt/patching

    -   item=/var/www/pages/updates


.. _backing-up-starlingx-system-data-section-N1021A-N1002B-N10001:

-----------------------------------
Data not included in system backups
-----------------------------------

.. _backing-up-starlingx-system-data-ul-im2-b2y-lp:

-   Application |PVCs| on Ceph clusters.

-   StarlingX application data. Use the command :command:`system
    application-list` to display a list of installed applications.

-   Modifications manually made to the file systems, such as configuration
    changes on the /etc directory. After a restore operation has been completed,
    these modifications have to be reapplied.

-   Home directories and passwords of local user accounts. They must be
    backed up manually by the system administrator.

-   The /root directory. Use the **sysadmin** account instead when root
    access is needed.

.. note::
    The system data backup can only be used to restore the cluster from
    which the backup was made. You cannot use the system data backup to
    restore the system to different hardware. Perform a system data backup
    for each cluster and label the backup accordingly.

    To ensure recovery from the backup file during a restore procedure,
    containers must be in the active state when performing the backup.
    Containers that are in a shutdown or paused state at the time of the
    backup will not be recovered after a subsequent restore procedure.

When the system data backup is complete, the backup file must be kept in a
secured location, probably holding multiple copies of them for redundancy
purposes.

.. seealso::
   :ref:`Run Ansible Backup Playbook Locally on the Controller
   <running-ansible-backup-playbook-locally-on-the-controller>`

   :ref:`Run Ansible Backup Playbook Remotely
   <running-ansible-backup-playbook-remotely>`
