..
.. _configure-the-nfs-backend-on-cinder-backup:

==========================================
Configure the NFS Backend on Cinder-Backup
==========================================

You can configure the cinder-backup service to use a remote external |NFS| server as backend.

.. rubric:: |prereq|

Ensure you have the following:

* the openstack application already applied or uploaded to |prod-os|
* the remote |NFS| server is up and running
* the remote |NFS| server IP address or domain are known
* the remote |NFS| server can be reached from inside the OpenStack cluster where |prod-os| is running

Follow these steps to perform the configuration.

.. rubric:: |proc|

#.  Create a Helm user override configuration file for Cinder.

    The following is a sample configuration for |NFS| backend:

    .. code-block:: none

        conf:
          cinder:
            DEFAULT:
              backup_driver: cinder.backup.drivers.nfs.NFSBackupDriver
              backup_mount_point_base: /backup/             # NFS volume mount point
              backup_share: 10.10.20.2:/exports/backup/     # NFS server IP address and exported directory
        pod:
         mounts:
            cinder_backup:
              cinder_backup:
                volumeMounts:
                - mountPath: /backup
                  name: nfs-backup
                volumes:
                - emptyDir: {}
                  name: nfs-backup
          security_context:
            cinder_backup:
              container:
                cinder_backup:
                  readOnlyRootFilesystem: false
                  runAsGroup: 65534                                                  # nogroup GID (from NFS server)
                  runAsUser: 42424                                                   # cinder UID

    For other options for configuring |NFS| backend on cinder-backup, see:
    `NFS Backup Driver <https://docs.openstack.org/cinder/wallaby/configuration/block-storage/backup/nfs-backup-driver.html>`__.

#.  The following commands are used for updating the Cinder Helm Chart overrides for |prod-os|:

    #. Update the Helm Chart overrides for Cinder:

       .. parsed-literal::

           ~(keystone_admin)]$ system helm-override-update |prefix|-openstack cinder openstack --values=\<path/to/override/file\>

    #. Shows the updated Helm Chart overrides for Cinder:

       .. parsed-literal::

           ~(keystone_admin)$ system helm-override-show |prefix|-openstack cinder openstack

#.  The following commands are used to apply the updated Helm Chart overrides:

    #. Applies updated Helm Chart overrides:

       .. parsed-literal::

           ~(keystone_admin)$ system application-apply |prefix|-openstack

    #. Wait for the application apply to complete:

       .. parsed-literal::

           ~(keystone_admin)$ watch system application-show |prefix|-openstack

#.  Verify that the Cinder services are up and running:

    #. Set the |CLI| context to the |prod-os| Cloud Application and set up
       OpenStack admin credentials:

       .. code-block:: none

           sed '/export OS_AUTH_URL/c\export OS_AUTH_URL=http://keystone.openstack.svc.cluster.local/v3' /etc/platform/openrc > ~/openrc.os source ./openrc.os

    #. Shows the OpenStack volume service:

       .. code-block:: none

           ~(keystone_admin)]$ openstack volume service list

    For more information on how to access the OpenStack CLI, see documentation at:
    `Access StarlingX Openstack <https://docs.starlingx.io/deploy_install_guides/r5_release/openstack/access.html>`__.

.. note::

    During startup, if the group ID of the mount point is not the same as the
    group ID of the exported directory of the |NFS| server, then cinder-backup
    will try to update the ownership of the |NFS| share mount point directory.
    If the cinder-backup operation is not successful, the deployment will fail
    and cinder-backup will stay down.

    Run cinder-backup as a privileged user in order to change the ownership
    of the |NFS| share mount point directory.




