
.. xuj1552678789246
.. _increase-controller-filesystem-storage-allotments-using-the-cli:

===============================================================
Increase Controller Filesystem Storage Allotments Using the CLI
===============================================================

You can use the |CLI| to list or increase the allotments for controller-based
storage at any time after installation.

.. rubric:: |context|

For more information about increasing filesystem allotments, or to use the
Horizon Web interface, see :ref:`Increase Controller Filesystem Storage
Allotments Using Horizon
<increase-controller-filesystem-storage-allotments-using-horizon>`.

.. caution::
    Decreasing the filesystem size is not supported, and can result in
    synchronization failures requiring system re-installation. Do not
    attempt to decrease the size of the filesystem.

.. rubric:: |prereq|

Before proceeding, review the prerequisites given for :ref:`Increase
Controller Filesystem Storage Allotments Using Horizon
<increase-controller-filesystem-storage-allotments-using-horizon>`.

.. rubric:: |proc|


#.  To review the existing host filesystems on a controller, use the
    :command:`system host-fs-list <hostname>` command. For example:

    .. code-block:: none

        ~(keystone_admin)$ system host-fs-list controller-0
        +--------------------------------------+---------+-------------+----------------+
        | UUID                                 | FS Name | Size in GiB | Logical Volume |
        +--------------------------------------+---------+-------------+----------------+
        | 1875cd0e-aee2-4646-b397-298348acf424 | backup  | 25          | backup-lv      |
        | cee6df98-9222-4594-b25f-469c625c5975 | docker  | 60          | docker-lv      |
        | c53be87c-bbcf-4d11-8cf5-93f350f8d027 | kubelet | 10          | kubelet-lv     |
        | efdddf39-7a0d-48f1-a14d-fc734e5b8675 | scratch | 16          | scratch-lv     |
        +--------------------------------------+---------+-------------+----------------+

#.  To review the existing controller filesystems that are synchronized between
    controllers on two controller (|AIO-DX| and standard) systems, use the
    :command:`system controllerfs-list` command.

    .. code-block:: none

        ~(keystone_admin)$ system controllerfs-list
        +-------------+-------------+------+--------------+------------+-----------+
        | UUID        | FS Name     | Size | Logical      | Replicated | State     |
        |             |             | in   | Volume       |            |           |
        |             |             | GiB  |              |            |           |
        |             |             |      |              |            |           |
        +-------------+-------------+------+--------------+------------+-----------+
        | aa9c7eab... | database    | 10   | pgsql-lv     | True       | available |
        |             |             |      |              |            |           |
        | 173cbb02... | docker-     | 16   | docker       |            |           |
        |             | distribution|      | distribution | True       | available |
        |             |             |      |-lv           |            |           |
        |             |             |      |              |            |           |
        | 448f77b9... | etcd        | 5    | etcd-lv      | True       | available |
        |             |             |      |              |            |           |
        | 9eadf06a... | extension   | 1    | extension-lv | True       | available |
        |             |             |      |              |            |           |
        | afcb9f0e... | platform    | 10   | platform-lv  | True       | available |
        +-------------+-------------+------+--------------+------------+-----------+

    .. note::
        The values shown by :command:`system controllerfs-list` are not
        adjusted for space used by the filesystem, and therefore may not
        agree with the output of the Linux :command:`df` command. Also,
        they are rounded compared to the :command:`df` output.

#.  Modify, for example, the docker host filesystem size on controller-0.

    .. code-block:: none

        ~(keystone_admin)$ system host-fs-modify controller-0 docker=60
        +--------------------------------------+---------+-------------+----------------+
        | UUID                                 | FS Name | Size in GiB | Logical Volume |
        +--------------------------------------+---------+-------------+----------------+
        | 910844e9-f763-4426-8b92-9b44693ee8a7 | backup  | 35          | backup-lv      |
        | 3bb38311-00b3-49c7-8b53-9178aeef2233 | docker  | 60          | docker-lv      |
        | 44dd07e8-b4bf-4751-b76b-dd96b5bea9cc | kubelet | 10          | kubelet-lv     |
        | b2ab5c8e-a26a-4460-b960-552c636cfe43 | scratch | 16          | scratch-lv     |
        +--------------------------------------+---------+-------------+----------------+

    .. note::

        When you use the :command:`system host-fs-modify` to increase
        the filesystem size, you may not have enough space in the |LVG| due to
        additional services running on the controller host. To increase the size
        from the default size of 30G to 60G for example, the docker filesystem,
        see below:

        .. code-block:: bash

         # check existing size of docker fs
         system host-fs-list controller-0
         # check available space (Avail Size (GiB)) in cgts-vg LVG where docker fs is located
         system host-lvg-list controller-0
         # if existing docker fs size + cgts-vg available space is less than
         # 80G, you will need to add a new disk partition to cgts-vg.
         # There must be at least 20GB of available space after the docker
         # filesystem is increased.

            # Assuming you have unused space on ROOT DISK, add partition to ROOT DISK.
            # ( if not use another unused disk )

            # Get device path of ROOT DISK
            system host-show controller-0 --nowrap | fgrep rootfs

            # Get UUID of ROOT DISK by listing disks
            system host-disk-list controller-0

            # Create new PARTITION on ROOT DISK, and take note of new partition's 'uuid' in response
            # Use a partition size such that you'll be able to increase docker fs size from 30G to 60G
            PARTITION_SIZE=30
            system hostdisk-partition-add -t lvm_phys_vol controller-0 <root-disk-uuid> ${PARTITION_SIZE}

            # Add new partition to 'cgts-vg' local volume group
            system host-pv-add controller-0 cgts-vg <NEW_PARTITION_UUID>
            sleep 2    # wait for partition to be added

            # Increase docker filesystem to 60G
            system host-fs-modify controller-0 docker=60

#.  Modify, for example, the extensions controller filesystem on the
    controller(s).

    .. code-block:: none

        ~(keystone_admin)]$ system controllerfs-modify extension=2
        +--------------------------------------+---------------------+---------+-----------------------+------------+------------------------------+
        | UUID                                 | FS Name             | Size in | Logical Volume        | Replicated | State                        |
        |                                      |                     | GiB     |                       |            |                              |
        +--------------------------------------+---------------------+---------+-----------------------+------------+------------------------------+
        | 176b8e7b-e38c-4829-b16f-023465360e52 | extension           | 2       | extension-lv          | True       | drbd_fs_resizing_in_progress |
        | 6efb7069-6eef-49d1-aaca-771164e129f3 | docker-distribution | 16      | dockerdistribution-lv | True       | available                    |
        | a0b10f6d-21f6-4e3c-a0f7-166f96672d93 | database            | 10      | pgsql-lv              | True       | available                    |
        | db43909e-8389-4372-8914-4018166f5eca | etcd                | 5       | etcd-lv               | True       | available                    |
        | f9b55e7c-468e-46bd-8ae7-5ca817e3e250 | platform            | 10      | platform-lv           | True       | available                    |
        +--------------------------------------+---------------------+---------+-----------------------+------------+------------------------------+

