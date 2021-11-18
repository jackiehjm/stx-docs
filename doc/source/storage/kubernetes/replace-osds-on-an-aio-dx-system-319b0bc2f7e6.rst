.. _replace-osds-on-an-aio-dx-system-319b0bc2f7e6:

================================
Replace OSDs on an AIO-DX System
================================

On systems that use a Ceph backend for persistent storage, you can replace
storage disks or swap an |AIO-DX| node while the system is running, even if the
storage resources are in active use.

.. note::
    All storage alarms need to be cleared before starting this procedure.

.. rubric:: |context|

You can replace |OSDs| in an |AIO-DX| system to increase capacity, or replace
faulty disks on the host without reinstalling the host.

.. rubric:: |proc|

#.  Ensure that the controller with the |OSD| to be replaced is the standby
    controller.

    For example, if the disk replacement has to be done on controller-1
    and it is the active controller, use the following command to swact the
    controller to controller-0:

    .. code-block:: none

        ~(keystone_admin)$ system host-show controller-1 | fgrep capabilities
        ~(keystone_admin)$ system host-swact controller-1

    After controller swact, you will have to connect via ssh again to the
    <oam-floating-ip> to connect to the newly active controller-0.

#.  Determine the **osdid** of the disk that is to be replaced.

    .. code-block:: none

        ~(keystone_admin)$ system host-stor-list controller-1

#.  Lock the standby controller-1 to make the changes.

    .. code-block:: none

        ~(keystone_admin)$ system host-lock controller-1

#.  Run the :command:`ceph osd destroy osd.<ID> --yes-i-really-mean-it` command.

    .. code-block:: none

        ~(keystone_admin)$ ceph osd destroy osd.<id> --yes-i-really-mean-it

#.  Power down controller-1.

#.  Replace the storage disk.

#.  Power on controller-1.

#.  Unlock controller-1.

    .. code-block:: none

        ~(keystone_admin)]$ system host-unlock controller-1

#.  Wait for the recovery process in the Ceph cluster to complete.

    .. code-block:: none

        ~(keystone_admin)]$ ceph -s

        cluster:
          id:     50ce952f-bd16-4864-9487-6c7e959be95e
          health: HEALTH_WARN
          Degraded data redundancy: 13/50 objects degraded (26.000%), 10 pgs degraded

        services:
          mon: 1 daemons, quorum controller (age 68m)
          mgr: controller-0(active, since 66m)
          mds: kube-cephfs:1 {0=controller-0=up:active} 1 up:standby
          osd: 2 osds: 2 up (since 9s), 2 in (since 9s)

        data:
          pools:   3 pools, 192 pgs
          objects: 25 objects, 300 MiB
          usage:   655 MiB used, 15 GiB / 16 GiB avail
          pgs:     13/50 objects degraded (26.000%)
                   182 active+clean
                   8   active+recovery_wait+degraded
                   2   active+recovering+degraded

        io:
          recovery: 24 B/s, 1 keys/s, 1 objects/s

#.  Ensure that the Ceph cluster is healthy.

    .. code-block:: none

        ~(keystone_admin)]$ ceph -s

        cluster:
          id:     50ce952f-bd16-4864-9487-6c7e959be95e
          health: HEALTH_OK

        services:
          mon: 1 daemons, quorum controller (age 68m)
          mgr: controller-0(active, since 66m), standbys: controller-1
          mds: kube-cephfs:1 {0=controller-0=up:active} 1 up:standby
          osd: 2 osds: 2 up (since 36s), 2 in (since 36s)

        data:
          pools:   3 pools, 192 pgs
          objects: 25 objects, 300 MiB
          usage:   815 MiB used, 15 GiB / 16 GiB avail
          pgs:     192 active+clean


