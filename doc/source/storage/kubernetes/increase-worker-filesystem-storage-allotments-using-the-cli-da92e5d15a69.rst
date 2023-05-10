.. _increase-worker-filesystem-storage-allotments-using-the-cli-da92e5d15a69:

===========================================================
Increase Worker Filesystem Storage Allotments Using the CLI
===========================================================

You can use the |CLI| to list or increase the allotments for worker-based
storage at any time after installation.

.. caution::
    Decreasing the filesystem size is not supported, and can result in
    synchronization failures requiring system re-installation. Do not
    attempt to decrease the size of the filesystem.

.. rubric:: |proc|

#.  To review the existing host filesystems on a worker host, use the
    :command:`system host-fs-list <hostname>` command. For example:

    .. code-block:: none

        ~(keystone_admin)$ system host-fs-list worker-0


#.  To add a filesystem use the :command:`host-fs-add` CLI command.

    .. code-block:: none

        ~(keystone_admin)$ system host-fs-add worker-0 docker=60

    The syntax is:

    .. code-block:: none

        system host-fs-add <hostname or id> <fs-name=size>

    Where:

    *   ``hostname or id`` is the location where the file system will be added.
    *   ``fs-name`` is the filesystem name.
    *   ``size`` is an integer indicating the file system size in Gigabytes.

#.  Modify, for example, the docker host filesystem size on worker-0, use the
    :command:`system host-fs-modify <hostname> docker=60` command.

    .. code-block:: none

        ~(keystone_admin)$ system host-fs-modify worker-0 docker=60

    .. note::

        When you use the :command:`system host-fs-modify` to increase
        the filesystem size, you may not have enough space in the |LVG| due to
        additional services running on the worker host. To increase the size
        from the default size of 30G to 60G for example, the docker filesystem,
        see below:

        .. code-block:: bash

           # check existing size of docker fs
           system host-fs-list worker-0
           # check available space (Avail Size (GiB)) in cgts-vg LVG where docker fs is located
           system host-lvg-list worker-0
           # if existing docker fs size + cgts-vg available space is less than
           # 80G, you will need to add a new disk partition to cgts-vg.
           # There must be at least 20GB of available space after the docker
           # filesystem is increased.
  
              # Assuming you have unused space on ROOT DISK, add partition to ROOT DISK.
              # ( if not use another unused disk )
  
              # Get device path of ROOT DISK
              system host-show worker-0 --nowrap | fgrep rootfs
  
              # Get UUID of ROOT DISK by listing disks
              system host-disk-list worker-0
  
              # Create new PARTITION on ROOT DISK, and take note of new partition's 'uuid' in response
              # Use a partition size such that you'll be able to increase docker fs size from 30G to 60G
              PARTITION_SIZE=30
              system hostdisk-partition-add -t lvm_phys_vol worker-0 <root-disk-uuid> ${PARTITION_SIZE}
  
              # Add new partition to 'cgts-vg' local volume group
              system host-pv-add worker-0 cgts-vg <NEW_PARTITION_UUID>
              sleep 2    # wait for partition to be added
  
              # Increase docker filesystem to 60G
              system host-fs-modify worker-0 docker=60

For more information on Host FileSystems, see :ref:`Host FileSystems <storage-planning-storage-on-controller-hosts>`
