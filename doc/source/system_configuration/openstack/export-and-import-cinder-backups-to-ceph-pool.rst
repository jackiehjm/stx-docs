
.. _export-and-import-cinder-backups-to-ceph-pool:

=============================================
Export and Import Cinder Backups to Ceph Pool
=============================================

This document describes how to export and import Cinder backups stored in Ceph
pool, along with their respective metadata.

.. rubric:: |prereq|

#.  |prefix|-openstack application is applied, up and running.

#.  The user has OpenStack admin credentials.

---------------------------------
Create and Export a Volume Backup
---------------------------------

Cinder doesn't guarantee the data consistency during a backup operation, so if
the volume to be backed up is attached to a running VM and the application in the
VM is not crash consistent, the recommended approach is to stop the VM for the
backup procedure. Check the OpenStack documentation
`Back up and restore volumes and snapshots
<https://docs.openstack.org/cinder/ussuri/admin/blockstorage-volume-backups.html>`__
for more details.

.. rubric:: |proc|

#.  Create a volume backup:

    If the volume to be backed up is attached to a running VM, stop the VM first:

    .. code-block:: none

        $ openstack server stop <vm>

    Then, create the backup:

    .. code-block:: none

        $ openstack volume backup create --force [--name <backup_name>] <volume_id>

    where:

    ``--name`` is optional.

    ``--force`` allows you to back up an "in-use" volume.

    .. only:: partner

        .. include:: /_includes/export-and-import-cinder-backups-to-ceph-pool.rest
            :start-after: location-ceph-begin
            :end-before: location-ceph-end

#.  Export the backup image from Ceph pool:

    .. code-block:: none

        $ rbd list -p cinder.backups
        $ rbd export -p cinder.backups <backup_image> <path_to_backup_image_file>

    where ``<backup_image>`` uses the format
    ``volume-<volume_id>.backup.<backup_id>``.

#.  Export the backup metadata from Cinder database:

    .. code-block:: none

        $ cinder backup-export <backup_id> > <path_to_backup_metadata_file>

----------------------------------
Import and Restore a Volume Backup
----------------------------------

.. rubric:: |proc|

#.  Import the backup metadata to Cinder database:

    .. code-block:: none

        $ backup_service=`grep "backup_service" <path_to_backup_metadata_file> | awk '{ print $4 }'`
        $ backup_url=`grep "backup_url" <path_to_backup_metadata_file> | awk '{ print $4 }'`
        $ cinder backup-import $backup_service $backup_url

#.  Import the backup image to Ceph pool.

    Check the ID of volume from which the backup was created:

    .. code-block:: none

        $ openstack volume backup show <backup_id>

    Import the backup image to Ceph pool:

    .. code-block:: none

        $ rbd import <path_to_backup_image_file> cinder.backups/volume-<volume_id>.backup.base

#.  Restore the backup to a new volume.

    If the volume in which the backup will be restored is attached to a VM,
    stop the VM and set the volume status to ``available``:

    .. code-block:: none

        $ openstack server stop <vm>
        $ openstack volume set --state "available" <new_volume_id>

    Then, restore the backup:

    .. code-block:: none

        $ openstack volume backup restore <backup_id> <new_volume_id>

    If the volume was attached to a VM before the restore operation, set the
    volume status to ``in-use`` before starting the VM:

    .. code-block:: none

        $ openstack volume set --state "in-use" <new_volume_id>
        $ openstack server start <vm>