
.. _increase-the-size-of-raw-image-uploads-in-openstack-2170f501d2e7:

===================================================
Increase the Size of Raw Image Uploads in OpenStack
===================================================


You can increase the size of raw image uploads for both **Kubelet** and/or
**Docker's Filesystem** in OpenStack, using the procedure below.

.. rubric:: |prereq|

-  Ensure you have configured the Docker filesystem with at least 60 GB.
   If not, use the following commands:

   .. code-block:: none

       # check existing size of docker fs
       system host-fs-list controller-0

       # check available space (Avail Size (GiB)) in cgts-vg LVG where docker fs is located
       system host-lvg-list controller-0
       # if existing docker fs size + cgts-vg available space is less than
       # 80G, you will need to add a new disk partition to cgts-vg.
       # There must be at least 20GB of available space after the docker
       # filesystem is increased.

          # Assuming you have unused space on ROOT DISK, add partition to ROOT DISK
          # ( if not use another unused disk )

          # Get device path of ROOT DISK
          system host-show controller-0 --nowrap | fgrep rootfs

          # Get UUID of ROOT DISK by listing disks
          system host-disk-list controller-0

          # Create new PARTITION on ROOT DISK, and take note of new partition’s ‘uuid’ in response
          # Use a partition size such that you’ll be able to increase docker fs size from 30G to 60G
          PARTITION_SIZE=30
          system hostdisk-partition-add -t lvm_phys_vol controller-0 <root-disk-uuid> ${PARTITION_SIZE}

          # Add new partition to ‘cgts-vg’ local volume group
          system host-pv-add controller-0 cgts-vg <NEW_PARTITION_UUID>
          sleep 2    # wait for partition to be added

       # Increase docker filesystem to 60G
       system host-fs-modify controller-0 docker=60

-  Ensure you have configured the **Kubelet** filesystem with sufficient disk
   space for the size of images you want to upload.

   The **Kubelet** filesystem available size is at least 25% larger than the
   largest image you need to upload. For example, to upload a 100 GB image,
   increase it to 125 GB. This applies to systems with HTTPS disabled.
   If you are using HTTPS enabled with |prod-long| earlier releases, you should
   increase the **Docker** filesystem using the instructions below.

   .. note::
       For future releases of |prod-long|, you will need to use the **Kubelet**
       filesystem.

   .. code-block:: none

       # check existing size of kubelet fs
       system host-fs-list controller-0

       # check available space (Avail Size (GiB)) in cgts-vg LVG where kubelet fs is located
       system host-lvg-list controller-0

       # if existing kubelet fs size + cgts-vg available space is less than
       # 125GB (or what you determined you need from above),
       # you will need to add a new disk partition to cgts-vg.

              # Assuming you have unused space on ROOT DISK, add partition to ROOT DISK.
              # ( if not use another unused disk )

              # Get device path of ROOT DISK
              system host-show controller-0 --nowrap | fgrep rootfs

              # Get UUID of ROOT DISK by listing disks
              system host-disk-list controller-0

              # Create new PARTITION on ROOT DISK, and take note of new partition’s ‘uuid’ in response

              # Use a partition size such that you’ll be able to increase kubelet fs size from 10G to 125G (example)
              PARTITION_SIZE=115
              system hostdisk-partition-add -t lvm_phys_vol controller-0 <root-disk-uuid> ${PARTITION_SIZE}

              # Add new partition to ‘cgts-vg’ local volume group
              system host-pv-add controller-0 cgts-vg <NEW_PARTITION_UUID>
              sleep 2    # wait for partition to be added

       # Increase kubelet filesystem to 125G (example)
       system host-fs-modify controller-0 kubelet=125


.. rubric:: |proc|

#.  When uploading an image file to OpenStack, Glance's API sets a default
    timeout of 600 seconds for the upload to be completed. You cannot change
    the timeout using the OpenStack :command:`image create` command. If the raw
    image requires more than 10 minutes to be uploaded, for example, for a file
    larger than 50 GB, use the :command:`glance image-create` command to set
    the timeout. For example:

    .. code-block:: none

        ~(keystone_admin)$ glance --timeout <value> image-create --name <image_name> --file <image_file> --progress --visibility <option> --disk-format raw --container-format bare

    .. note::
        It is mandatory that the ``--timeout`` parameter is before the
        :command:`image create` command.

    It is strongly recommended to use high timeout values when uploading
    large images. For example:

    .. table::
        :widths: auto

        +------------------+-------------------------+
        | Image Size (GB)  | Time to Upload (seconds)|
        +==================+=========================+
        |     50           |       900               |
        +------------------+-------------------------+
        |     100          |       1800              |
        +------------------+-------------------------+
        |     150          |       2700              |
        +------------------+-------------------------+
        |     200          |       3600              |
        +------------------+-------------------------+

    If the timeout set is not enough to upload the image, an error will be
    displayed. For example:

    .. code-block:: none

        Error finding address for http://glance.openstack.svc.cluster.local/v2/images/7209bd4d-d085-4fa7-930b-3a061b49271b/file: timed out

For more information on Glance commands and ``--timeout`` errors, see
`Image service (Glance) command-line client <https://docs.openstack.org/python-glanceclient/latest/cli/details.html#glance-usage>`__.

