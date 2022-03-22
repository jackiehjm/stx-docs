.. _replace-osds-on-an-aio-sx-multi-disk-system-b4ddd1c1257c:

===========================================
Replace OSDs on an AIO-SX Multi-Disk System
===========================================

You can replace |OSDs| in an |AIO-SX| system to increase capacity, or replace
faulty disks on the host without reinstalling the host.

.. rubric:: |proc|

**Replication factor > 1**

#.  Make sure there is more than one OSD installed, otherwise there could be
    data loss.

    .. code-block:: none

        ~(keystone_admin)$ ceph osd tree

#.  Verify that all Ceph pools are present.

    .. code-block:: none

        ~(keystone_admin)$ ceph osd lspools

#.  For each pool, make sure its size attribute is larger than 1, otherwise
    there could be data loss.

    .. code-block:: none

        ~(keystone_admin)$ ceph osd pool get <pool-name> size

#.  Disable pool size change during the procedure. This must be run for all
    pools.

    .. code-block:: none

        ~(keystone_admin)$ ceph osd pool set <pool-name> nosizechange true

#.  Verify that the Ceph cluster is healthy. 

    .. code-block:: none

        ~(keystone_admin)$ ceph -s

        cluster:
          id:     50ce952f-bd16-4864-9487-6c7e959be95e
          health: HEALTH_OK

#.  Lock the controller.

    .. code-block:: none

        ~(keystone_admin)$ system host-lock controller-0

#.  Power down the controller.

#.  Replace the disk.

#.  Power on the controller.

#.  Unlock the controller.

    .. code-block:: none

        ~(keystone_admin)$ system host-unlock controller-0

#.  Wait for the recovery process in the Ceph cluster to start and finish.

#.  Ensure that the Ceph cluster is healthy.

    .. code-block:: none

        ~(keystone_admin)]$ ceph -s

        cluster:
          id:     50ce952f-bd16-4864-9487-6c7e959be95e
          health: HEALTH_OK

#.  Enable pool size changes.

    .. code-block:: none

        ~(keystone_admin)]$ ceph osd pool set <pool-name> nosizechange false


**Replication factor 1 with space to backup**

#.  Make sure there is more than one OSD installed, otherwise there could be
    data loss.

    .. code-block:: none

        ~(keystone_admin)$ ceph osd tree

#.  Verify all present ceph pools.

    .. code-block:: none

        ~(keystone_admin)$ ceph osd lspools

#.  For each pool, make sure its size attribute is larger than 1, otherwise
    there could be data loss.

    .. code-block:: none

        ~(keystone_admin)$ ceph osd pool get <pool-name> size

#.  Disable pool size change during the procedure. This must be run for all
    pools.

    .. code-block:: none

        ~(keystone_admin)$ ceph osd pool set <pool-name> nosizechange true

#.  Verify that the Ceph cluster is healthy. 

    .. code-block:: none

        ~(keystone_admin)$ ceph -s

        cluster:
          id:     50ce952f-bd16-4864-9487-6c7e959be95e
          health: HEALTH_OK

#.  Lock the controller.

    .. code-block:: none

        ~(keystone_admin)$ system host-lock controller-0

#.  Power down the controller.

#.  Replace the disk.

#.  Power on the controller.

#.  Unlock the controller.

    .. code-block:: none

        ~(keystone_admin)$ system host-unlock controller-0

#.  Wait for the recovery process in the Ceph cluster to start and finish.

#.  Ensure that the Ceph cluster is healthy.

    .. code-block:: none

        ~(keystone_admin)]$ ceph -s

        cluster:
          id:     50ce952f-bd16-4864-9487-6c7e959be95e
          health: HEALTH_OK

#.  Enable pool size changes.

    .. code-block:: none

        ~(keystone_admin)]$ ceph osd pool set <pool-name> nosizechange false

#.  Set the replication factor to 1 for all pools.

    .. code-block:: none

        ~(keystone_admin)]$ ceph osd pool set <pool-name> size 1


**Replication factor 1 without space to backup**

#.  Lock the controller.

    .. code-block:: none

        ~(keystone_admin)$ system host-lock controller-0

#.  Backup file /etc/pmon.d/ceph.conf, then remove it.

#.  Mark |OSD| as out and down, stop it, and destroy it.

    .. code-block:: none

        ~(keystone_admin)$ ceph osd out osd.<id>
        ~(keystone_admin)$ ceph osd down osd.<id>
        ~(keystone_admin)$ sudo /etc/init.d/ceph stop osd.1
        ~(keystone_admin)$ ceph osd destroy osd.1

#.  Shutdown the machine, replace disk, turn it on, and wait for boot to finish.

#.  Unlock the controller.

    .. code-block:: none

        ~(keystone_admin)$ system host-unlock controller-0

#.  Copy the backup ceph.conf to /etc/pmon.d/.

#.  Verify that the Ceph cluster is healthy.

    .. code-block:: none

        ~(keystone_admin)$ ceph -s