
.. zjx1464641246986
.. _specifying-the-storage-type-for-vm-ephemeral-disks:

==================================================
Specify the Storage Type for VM Ephemeral Disks
==================================================

You can specify the ephemeral storage type for virtual machines \(|VMs|\) by
using a flavor with the appropriate extra specification.

.. rubric:: |context|

.. note::
    On a system with one or more single-disk compute hosts, do not use
    ephemeral disks for *any* |VMs| unless *all* single-disk compute hosts are
    configured to use remote Ceph backing. For more information, see
    |os-intro-doc|:

.. xbooklink:ref:`Storage on Storage Hosts <storage-configuration-storage-on-storage-hosts>`.

Each new flavor is automatically assigned a Storage Type extra spec that
specifies, as the default, instantiation on compute hosts configured for
image-backed local storage \(Local |CoW| Image Backed\). You can change the extra
spec to specify instantiation on compute hosts configured for Ceph-backed
remote storage, if this is available \(Remote Storage Backed\). Ceph-backed
remote storage is available only on systems configured with a Ceph storage
backend.

The designated storage type is used for ephemeral disk and swap disk space, and
for the root disk if the virtual machine is launched using boot-from-image.
Local storage is allocated from the Local Volume Group on the host, and does
not persist when the instance is terminated. Remote storage is allocated from a
Ceph storage pool configured on the storage host resources, and persists until
the pool resources are reallocated for other purposes. The choice of storage
type affects migration behavior; for more information, see |stor-doc|: :ref:`VM
Storage Settings for Migration, Resize, or Evacuation
<vm-storage-settings-for-migration-resize-or-evacuation>`.

If the instance is configured to boot from volume, the root disk is implemented
using persistent Cinder-based storage allocated from the controller \(for a
system using LVM\) or from storage hosts \(for a system using Ceph\) by
default. On a system that offers both LVM and Ceph storage backends for Cinder
storage, you can specify to use the LVM backend when you launch an instance.

To specify the type of storage offered by a compute host, see |stor-doc|:
:ref:`Work with Local Volume Groups <work-with-local-volume-groups>`.

.. rubric:: |context|

.. caution::
    Unlike Cinder-based storage, ephemeral storage does not persist if the
    instance is terminated or the compute node fails.


.. _specifying-the-storage-type-for-vm-ephemeral-disks-d29e17:

In addition, for local ephemeral storage, migration and resizing support
depends on the storage backing type specified for the instance, as well as the
boot source selected at launch.

To change the storage type using the Web administration interface, click
**Edit** for the existing **Storage Type** extra specification, and select from
the **Storage** drop-down menu.

