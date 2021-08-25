
.. gpz1552674513169
.. _storage-tab:

===========
Storage Tab
===========

The **Storage** tab on the Host Detail page presents storage details for a
host.

The information is presented in one or more lists, as determined by the
host type.

.. _storage-tab-section-N10043-N1002D-N10001:

-----
Disks
-----

This list is presented for all host types. It lists all available hardware
devices used for storage.

.. figure:: /node_management/kubernetes/figures/bsa1464962126609.png
    :scale: 100%

For each device, the following information is included:

**UUID**
    The unique identifier for the device.

**Disk Info**
    The Linux device path.

**Type**
    The type of storage device \(HDD or SSD\).

**Size**
    The capacity of the device in MiB.

**Available Size**
    The space available for partitioning.

**RPM**
    The rotational speed of the device.

**Serial ID**
    The device's serial ID number.

**Model**
    The manufacturer's model for the device.

.. _storage-tab-section-N10109-N1002E-N10001:

----------
Partitions
----------

For all host types, this list shows user-created disk partitions.

.. figure:: /node_management/kubernetes/figures/lci1515513441685.png
    :scale: 100%

**UUID**
    The unique identifier for the device.

**Partition Device Path**
    The Linux device path.

**Size**
    The capacity of the partition in MiB.

**Partition Type**
    The storage backing and the partition type, such as physical or logical.

**Status**
    The usage status, such as Creating, Ready, Deleting, or In-use.

**Actions**
    Controls for editing or deleting a partition, if it is not currently in use.

.. _storage-tab-section-N1028D-N1002E-N10001:

----------------
Physical Volumes
----------------

On controller and worker hosts, this list shows physical volumes
\(disk or partitions\) assigned to local volume groups.

.. figure:: /node_management/kubernetes/figures/fph1515514594885.png
    :scale: 100%

**Name**
    The Linux device name associated with the physical volume.

**State**
    The availability of the physical volume.

**Type**
    The device type used for the physical volume.

**Disk or Partition UUID**
    The unique identifier for the disk or partition used to implement the
    physical volume.

**Disk or Partition Device Path**
    The device used to implement the physical volume, identified by path.

**LVM Volume Group name**
    The name of the local volume group to which the physical volume belongs.

**Actions**
    Available actions that can be performed on the physical volume.


.. _storage-tab-section-N100CC-N1002D-N10001:

-----------------
Storage Functions
-----------------

This list is presented for storage hosts. It shows a list of logical storage
functions \(OSDs and Ceph journal functions\) defined on available disks.

.. figure:: /shared/figures/storage/caf1464886132887.png
    :scale: 100%

For each volume, the following information is included:

**UUID**
    The unique identifier for the storage volume.

**Function**
    The type of function \(**osd** for object storage, or **journal** for
    Ceph journal storage\).

**OSD ID**
    For an |OSD| function, the identity of the associated Ceph object
    storage daemon.

**Disk UUID**
    The unique identifier for the disk associated with the storage volume.

**Journal Path**
    For an |OSD| function, the path to the device where the associated Ceph
    journal is maintained.

**Journal GiB**
    For an |OSD| function, the size of the associated Ceph journal.

**Journal Location**
    For an |OSD| function, the unique identifier for the associated journal
    function, if applicable.

.. xbooklink For information about creating storage volumes,
   |stor-doc|: `Provisioning Storage on a Controller or
   Storage Host Using Horizon
   <provisioning-storage-on-a-controller-or-storage-host-using-horizon>`.
