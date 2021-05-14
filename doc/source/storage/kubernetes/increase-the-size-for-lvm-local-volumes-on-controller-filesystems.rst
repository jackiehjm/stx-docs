
.. dvn1552678726609
.. _increase-the-size-for-lvm-local-volumes-on-controller-filesystems:

=================================================================
Increase the Size for LVM Local Volumes on Controller Filesystems
=================================================================

Controller filesystems are allocated as LVM local volumes inside the
**cgts-vg** volume group. You can increase controller filesystem storage
inside the **cgts-vg** volume group by using the |CLI|, or the Horizon Web
interface.

.. rubric:: |context|

To provision filesystem storage, enough free disk space has to be available
in this volume group. You can increase available space for provisioning by
creating a partition and assigning it to **cgts-vg** volume group. This
partition can be created on the root disk or on a different disk of your
choice. In |prod-long|, Simplex or Duplex systems that use a dedicated disk
for **nova-local**, some root disk space reserved for **nova-local** is
unused. You can recover this space for use by the **cgts-vg** volume group
to allow for controller filesystem expansion.

For convenience, this operation is permitted on an unlocked controller.

.. note::
    Using more than one disk during setup for **cgts-vg**, may increase
    disk failures. In case any of the disks in the **cgts-vg** volume group
    fails, the disk has to be replaced and the node has to be reinstalled.
    It is strongly recommended to limit **cgts-vg** to the root disk.

.. note::
    The partition should be the same size on both controllers, otherwise
    only the smallest common denominator size can be provisioned from
    **cgts-vg**.

.. caution::
    Once the **cgts-vg** partition is added, it cannot be removed.

The following example is used for provisioning **cgts-vg** on a root disk.
The default **rootfs** device is **/dev/sda**.

.. rubric:: |proc|

#.  Check the free space on the **rootfs**, by using the following command:

    .. code-block:: none

        ~(keystone_admin)$ system host-disk-list 1

#.  Create a new partition on **rootfs**, for example:

    .. code-block:: none

        ~(keystone_admin)$ system host-disk-partition-add -t lvm_phys_vol controller-0 /dev/sda 22
         +---------------+------------------------------------------------+
         | Property      |     Value                                      |
         +---------------+------------------------------------------------+
         | device_path   |/dev/disk/by-path/pci-0000:00:0d.0-ata-1.0-part7|
         | device_node   | /dev/sda7                                      |
         | type_guid     | ba5eba11-0000-1111-2222-000000000001           |
         | type_name     | None                                           |
         | start_mib     | None                                           |
         | end_mib       | None                                           |
         | size_mib      | 22528                                          |
         | uuid          | 994d7efb-6ac1-4414-b4ef-ae3335dd73c7           |
         | ihost_uuid    | 75ea78b6-62f0-4821-b713-2618f0d5f834           |
         | idisk_uuid    | 685bee31-45de-4951-a35c-9159bd7d1295           |
         | ipv_uuid      | None                                           |
         | status        | Creating                                       |
         | created_at    | 2020-07-30T21:29:04.014193+00:00               |
         | updated_at    | None                                           |
         +---------------+------------------------------------------------+

#.  Check the disk space on the new partition, once it is created.

    .. code-block:: none

        ~(keystone_admin)$ system host-disk-partition-list 1
        ---------------------------------------------------------------------------------
         uuid	 device_path	     device_node type_guid  type_name	 size_gib status
        ---------------------------------------------------------------------------------
         69b1b.. /dev/disk/by-path/.. /dev/sda6  ba5eba11.. LVM Phy.Vol..  22.0	 Ready
        ---------------------------------------------------------------------------------

#.  Assign the unused partition on **controller-0** as a physical volume to
    **cgts-vg** volume group.

    For example

    .. code-block:: none

        ~(keystone_admin)$ system host-pv-add controller-0 cgts-vg 69b1bb35-7326-4bcc-94d7-bef72f064f46
        +---------------------------+---------------------------------------+
        |    Property	            | Value                                 |
        +---------------------------+---------------------------------------+
        | uuid	                    | 626c450f-4472-485c-bae7-791768630e1e  |
        | pv_state                  | adding                                |
        | pv_type                   | partition                             |
        | disk_or_part_uuid         | 69b1bb35-7326-4bcc-94d7-bef72f064f46  |
        | disk_or_part_device_node  | /dev/sda6                             |
        | disk_or_part_device_path  | /dev/disk/by-path/pci-0000:18:00.     |
        |                           | 0-scsi-0:2:0:0-part6                  |
        | lvm_pv_name	            | /dev/sda6                             |
        | lvm_vg_name	            | cgts-vg                               |
        | lvm_pv_uuid	            | None                                  |
        | lvm_pv_size_gib           | 0.0                                   |
        | lvm_pe_total	            | 0                                     |
        | lvm_pe_alloced            | 0                                     |
        | ihost_uuid	            | e579a4af-108b-4dc9-9975-0aa089d530d7  |
        | created_at	            | 2020-12-09T17:22:19.666250+00:00      |
        | updated_at	            | None                                  |
        +---------------------------+---------------------------------------+

#.  To assign the unused partition on **controller-1** as a physical volume to
    **cgts-vg** volume group, **swact** the hosts and repeat the procedure on
    **controller-1**.

.. rubric:: |proc|

After increasing the **cgts-vg** volume size, you can provision the filesystem
storage. For more information about increasing filesystem allotments using the
|CLI|, or the Horizon Web interface, see:

.. _increase-the-size-for-lvm-local-volumes-on-controller-filesystems-ul-mxm-f1c-nmb:

-   :ref:`Increase Controller Filesystem Storage Allotments Using Horizon
    <increase-controller-filesystem-storage-allotments-using-horizon>`

-   :ref:`Increase Controller Filesystem Storage Allotments Using the CLI
    <increase-controller-filesystem-storage-allotments-using-the-cli>`


