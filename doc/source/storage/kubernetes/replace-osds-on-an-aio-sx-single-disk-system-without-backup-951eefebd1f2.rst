.. _replace-osds-on-an-aio-sx-single-disk-system-without-backup-951eefebd1f2:

===========================================================
Replace OSDs on an AIO-SX Single Disk System without Backup
===========================================================

.. rubric:: |proc|

#.  Get a list of all pools and their settings (size, min_size, pg_num, pgp_num).

    .. code-block:: none

        ~(keystone_admin)$ ceph osd lspools # list all pools
        ~(keystone_admin)$ ceph osd pool get $POOLNAME $SETTING

    Keep the pool names and settings as they will be used in step 12.

#.  Lock the controller.

    .. code-block:: none

        ~(keystone_admin)$ system host-lock controller-0

#.  Remove all applications that use ceph pools.

    .. code-block:: none

        ~(keystone_admin)$ system application-list # list the applications
        ~(keystone_admin)$ system application-remove $APPLICATION_NAME # remove
        application

    Keep the names of the removed applications as they will be used in step 11.

#.  Make a backup of /etc/pmon.d/ceph.conf to a safe location and remove the 
    ceph.conf file from the /etc/pmon.d folder.

#.  Stop ``ceph-mds``.

    .. code-block:: none

        ~(keystone_admin)$ /etc/init.d/ceph stop mds

#.  Declare ``ceph fs`` as failed and delete it.

    .. code-block:: none

        ~(keystone_admin)$ ceph mds fail 0
        ~(keystone_admin)$ ceph fs rm <ceph fs filename> --yes-i-really-mean-it

#.  Allow Ceph pools to be deleted.

    .. code-block:: none

        ~(keystone_admin)$ ceph tell mon.\* injectargs 
        '--mon-allow-pool-delete=true'

#.  Remove all the pools.

    .. code-block:: none

        ~(keystone_admin)$ ceph osd pool ls | xargs -i ceph osd pool delete {} 
        {} --yes-i-really-really-mean-it

#.  Shutdown machine, replace disk, turn it on and wait for boot to finish.

#.  Move the backed up ceph.conf from step 4 to /etc/pmon.d and unlock the 
    controller.

#.  Add the applications that were removed in step 3.

#.  Verify that all pools and settings listed in step 1 are recreated.
