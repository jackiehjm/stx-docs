
.. ixo1464634136835
.. _block-storage-for-virtual-machines:

==================================
Block Storage for Virtual Machines
==================================

Virtual machines use controller or storage host resources for root and
ephemeral disk storage.

.. _block-storage-for-virtual-machines-section-N10022-N1001F-N10001:

-------------------------
Root Disk Storage for VMs
-------------------------

You can allocate root disk storage for virtual machines using the following:

.. _block-storage-for-virtual-machines-ul-d1c-j5k-s5:

-   Cinder volumes on controller hosts \(backed by small Ceph Cluster\) or
    storage hosts \(backed by large-scale Ceph\).

-   Ephemeral local storage on compute hosts, using image-based instance
    backing.

-   Ephemeral remote storage on controller hosts or storage hosts, backed by
    Ceph.

The use of Cinder volumes or ephemeral storage is determined by the **Instance
Boot Source** setting when an instance is launched. Boot from volume results in
the use of a Cinder volume, while Boot from image results in the use of
ephemeral storage.

.. note::
    On systems with one or more single-disk compute hosts configured with local
    instance backing, the use of Boot from volume for all |VMs| is strongly
    recommended. This helps prevent the use of local ephemeral storage on these
    hosts.

On systems without dedicated storage hosts, Cinder-backed persistent storage
for virtual machines is provided using the small Ceph cluster on controller
disks.

On systems with dedicated hosts, Cinder storage is provided using Ceph-backed
|OSD| disks on high-availability and highly-scalable storage hosts.

.. _block-storage-for-virtual-machines-section-N100A2-N1001F-N10001:

---------------------------------------
Ephemeral and Swap Disk Storage for VMs
---------------------------------------

Storage for |VM| ephemeral and swap disks, and for ephemeral boot disks if the
|VM| is launched from an image rather than a volume, is provided using the
**nova-local** local volume group defined on compute hosts.

The **nova-local** group provides either local ephemeral storage using
|CoW|-image-backed storage resources on compute hosts, or remote ephemeral
storage, using Ceph-backed resources on storage hosts. You must configure the
storage backing type at installation before you can unlock a compute host. The
default type is image-backed local ephemeral storage. You can change the
configuration after installation.

.. xbooklink For more information, see |stor-doc|: :ref:`Working with Local Volume Groups <working-with-local-volume-groups>`.

.. caution::
    On a compute node with a single disk, local ephemeral storage uses the root
    disk. This can adversely affect the disk I/O performance of the host. To
    avoid this, ensure that single-disk compute nodes use remote Ceph-backed
    storage if available. If Ceph storage is not available on the system, or is
    not used for one or more single-disk compute nodes, then you must ensure
    that all VMs on the system are booted from Cinder volumes and do not use
    ephemeral or swap disks.

    On |prod-os| Simplex or Duplex systems that use a single disk, the same
    consideration applies. Since the disk also provides Cinder support, adverse
    effects on I/O performance can also be expected for VMs booted from Cinder
    volumes.

The backing type is set individually for each host using the **Instance
Backing** parameter on the **nova-local** local volume group.

**Local CoW Image backed**
    This provides local ephemeral storage using a |CoW| sparse-image-format
    backend, to optimize launch and delete performance.

**Remote RAW Ceph storage backed**
    This provides remote ephemeral storage using a Ceph backend on a system
    with storage nodes, to optimize migration capabilities. Ceph backing uses a
    Ceph storage pool configured from the storage host resources.

You can control whether a |VM| is instantiated with |CoW| or Ceph-backed
storage by setting a flavor extra specification.

.. xbooklink For more information, see OpenStack Configuration and Management: :ref:`Specifying the Storage Type for VM Ephemeral Disks <specifying-the-storage-type-for-vm-ephemeral-disks>`.

.. _block-storage-for-virtual-machines-d29e17:

.. caution::
    Unlike Cinder-based storage, ephemeral storage does not persist if the
    instance is terminated or the compute node fails.

    In addition, for local ephemeral storage, migration and resizing support
    depends on the storage backing type specified for the instance, as well as
    the boot source selected at launch.

The **nova-local** storage type affects migration behavior. Live migration is
not always supported for |VM| disks using local ephemeral storage.

.. xbooklink For more information, see :ref:`VM Storage Settings for Migration, Resize, or Evacuation <vm-storage-settings-for-migration-resize-or-evacuation>`.
