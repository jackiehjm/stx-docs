.. _replace-osds-on-an-aio-sx-single-disk-system-with-backup-770c9324f372:

========================================================
Replace OSDs on an AIO-SX Single Disk System with Backup
========================================================

When replacing |OSDs| on an AIO-SX system with replication factor 1, it is possible to make a backup.

.. rubric:: |prereq|

Verify if there is an available disk to create a new |OSD| in order to backup
data from an existing |OSD|. Make sure the disk is at least the same size as
the disk to be replaced.

.. code-block:: none

    ~(keystone_admin)$ system host-disk-list controller-0

.. rubric:: |proc|

#.  Add the new OSD with the previously displayed disk UUID of the available
    disk identified in the prerequisites.

    .. code-block:: none

        ~(keystone_admin)$ system host-stor-add controller-0 <disk uuid>

#.  Wait for the new OSD to get configured. Run :command:`ceph -s` to verify
    that the output shows two |OSDs| and that the cluster has finished recovery.
    Make sure the Ceph cluster is healthy (``HEALTH_OK``) before proceeding.

#.  Change replication factor of the pools to 2.

    .. code-block:: none

        ~(keystone_admin)$ ceph osd lspools # will list all ceph pools
        ~(keystone_admin)$ ceph osd pool set <pool-name> size 2
        ~(keystone_admin)$ ceph osd pool set <pool-name> nosizechange true

    This will make the cluster enter a recovery state:

    .. code-block:: none

        [sysadmin@controller-0 ~(keystone_admin)]$ ceph -s
          cluster:
            id:     38563514-4726-4664-9155-5efd5701de86
            health: HEALTH_WARN
                    Degraded data redundancy: 3/57 objects degraded (5.263%), 3 pgs degraded
 
          services:
            mon: 1 daemons, quorum controller-0 (age 28m)
            mgr: controller-0(active, since 27m)
            mds: kube-cephfs:1 {0=controller-0=up:active}
            osd: 2 osds: 2 up (since 6m), 2 in (since 6m)
 
          data:
            pools:   3 pools, 192 pgs
            objects: 32 objects, 1000 MiB
            usage:   1.2 GiB used, 16 GiB / 18 GiB avail
            pgs:     2.604% pgs not active
                     3/57 objects degraded (5.263%)
                     184 active+clean
                     5   activating
                     2   active+recovery_wait+degraded
                     1   active+recovering+degraded
 
          io:
            recovery: 323 B/s, 1 keys/s, 3 objects/s
 

#.  Wait for recovery to end and the Ceph cluster to become healthy.

    .. code-block:: none

        ~(keystone_admin)$ ceph -s

          cluster:
            id:     38563514-4726-4664-9155-5efd5701de86
            health: HEALTH_OK

          services:
            mon: 1 daemons, quorum controller-0 (age 28m)
            mgr: controller-0(active, since 28m)
            mds: kube-cephfs:1 {0=controller-0=up:active}
            osd: 2 osds: 2 up (since 7m), 2 in (since 7m)

          data:
            pools:   3 pools, 192 pgs
            objects: 32 objects, 1000 MiB
            usage:   2.2 GiB used, 15 GiB / 18 GiB avail
            pgs:     192 active+clean
 
#.  Lock the system.

    .. code-block:: none

        ~(keystone_admin)$ system host-lock controller-0

#.  Mark the |OSD| out.

    .. code-block:: none

        ~(keystone_admin)$ ceph osd out osd.<id>

#.  Wait for the rebalance to finish.

    .. code-block:: none

        [sysadmin@controller-0 ~(keystone_admin)]$ ceph -s
          cluster:
            id:     38563514-4726-4664-9155-5efd5701de86
            health: HEALTH_OK

          services:
            mon: 1 daemons, quorum controller-0 (age 37m)
            mgr: controller-0(active, since 36m)
            mds: kube-cephfs:1 {0=controller-0=up:active}
            osd: 2 osds: 2 up (since 15m), 1 in (since 2s)

          data:
            pools:   3 pools, 192 pgs
            objects: 32 objects, 1000 MiB
            usage:   808 MiB used, 8.0 GiB / 8.8 GiB avail
            pgs:     192 active+clean

          progress:
            Rebalancing after osd.0 marked out
              [..............................]

#.  Stop the |OSD| and purge it from the Ceph cluster.

    .. code-block:: none

        ~(keystone_admin)$ sudo mv /etc/pmon.d/ceph.conf ~/
        ~(keystone_admin)$ sudo /etc/init.d/ceph stop osd.<id>

#.  Obtain the stor UUID and delete it from the platform.

    .. code-block:: none

        ~(keystone_admin)$ system host-stor-list controller-0 # list all stors
        ~(keystone_admin)$ system host-stor-delete <stor uuid> # delete stor

#.  Purge the disk from the Ceph cluster.

    .. code-block:: none

        ~(keystone_admin)$ ceph osd purge osd.<id> --yes-i-really-mean-it

#.  Remove the |OSD| entry in /etc/ceph/ceph.conf.

#.  Unmount and remove any remaining folders. 

    .. code-block:: none

        ~(keystone_admin)$ sudo umount /var/lib/ceph/osd/ceph-<id>
        ~(keystone_admin)$ sudo rm -rf /var/lib/ceph/osd/ceph-<id>/

#.  Set the pool to allow size changes.

    .. code-block:: none

        ~(keystone_admin)$ ceph osd pool set <pool-name> nosizechange false

#.  Unlock machine.

    .. code-block:: none

        ~(keystone_admin)$ system host-unlock controller-0

#.  Verify that the Ceph cluster is healthy.

    .. code-block:: none

        ~(keystone_admin)$ ceph -s

    If you see a ``HEALTH_ERR`` message like the following:

    .. code-block:: none

        controller-0:~$ ceph -s
          cluster:
            id:     38563514-4726-4664-9155-5efd5701de86
            health: HEALTH_ERR
                    1 filesystem is degraded
                    1 filesystem has a failed mds daemon
                    1 filesystem is offline
                    no active mgr

          services:
            mon: 1 daemons, quorum controller-0 (age 38s)
            mgr: no daemons active (since 3s)
            mds: kube-cephfs:0/1, 1 failed
            osd: 1 osds: 1 up (since 14m), 1 in (since 15m)

          data:
            pools:   3 pools, 192 pgs
            objects: 32 objects, 1000 MiB
            usage:   1.1 GiB used, 7.7 GiB / 8.8 GiB avail
            pgs:     192 active+clean

    Wait a few minutes until the Ceph cluster shows ``HEALTH_OK``.

    .. code-block:: none

        controller-0:~$ ceph -s
          cluster:
            id:     38563514-4726-4664-9155-5efd5701de86
            health: HEALTH_OK
 
          services:
            mon: 1 daemons, quorum controller-0 (age 2m)
            mgr: controller-0(active, since 96s)
            mds: kube-cephfs:1 {0=controller-0=up:active}
            osd: 1 osds: 1 up (since 46s), 1 in (since 17m)
 
          task status:
 
          data:
            pools:   3 pools, 192 pgs
            objects: 32 objects, 1000 MiB
            usage:   1.1 GiB used, 7.7 GiB / 8.8 GiB avail
            pgs:     192 active+clean


#.  The |OSD| tree should display the new |OSD| and not the previous one.

    .. code-block:: none

        controller-0:~$ ceph osd tree
        ID CLASS WEIGHT  TYPE NAME                 STATUS REWEIGHT PRI-AFF 
        -1       0.00850 root storage-tier                                 
        -2       0.00850     chassis group-0                               
        -3       0.00850         host controller-0                         
         1   hdd 0.00850             osd.1             up  1.00000 1.00000 

