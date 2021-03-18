
.. ugv1564682723675
.. _nova-ephemeral-storage:

======================
Nova Ephemeral Storage
======================

.. contents::
    :local:
    :depth: 1

This is the default OpenStack storage option used for creating VMs. Virtual
machine instances are typically created with at least one ephemeral disk which
is used to run the VM guest operating system and boot partition.

Ephemeral storage for VMs, which includes swap disk storage, ephemeral disk
storage, and root disk storage if the VM is configured for boot-from-image, is
implemented by the **nova** service. For flexibility and scalability, this
storage is defined using a **nova-local** local volume group created on the
compute hosts.

The nova-local group can be backed locally by one or more disks or partitions
on the compute host, or remotely by resources on the internal Ceph cluster \(on
controller or storage hosts\). If it is backed locally on the compute host,
then it uses CoW-image storage backing. For more information about
**nova-local** backing options, see Cloud Platform Storage Configuration:
:ref:`Block Storage for Virtual Machines <block-storage-for-virtual-machines>`.

Compute hosts are grouped into host aggregates based on whether they offer CoW
or remote Ceph-backed local storage. The host aggregates are used for
instantiation scheduling.


.. _nova-ephemeral-storage-section-N10149-N1001F-N10001:

------------
Instances LV
------------

For storage on compute hosts, CoW-image backing uses an instances logical
volume, or **Instances LV**. This contains the /etc/nova/instances file system,
and is used for the following:


.. _nova-ephemeral-storage-ul-mrd-bxv-q5:

-   the nova image cache, containing images downloaded from Glance

-   various small nova control and log files, such as the libvirt.xml file,
    which is used to pass parameters to **libvirt** at launch, and the console.log
    file


For CoW-image-backed local storage, **Instances LV** is also used to hold
CoW-image disk files for use as VM disk storage. It is the only volume in
**nova-local**.

By default, no size is specified for the **Instances LV**. For non-root disks,
the minimum required space is 2 GB for a **nova-local** volume group with a
total size less that 80 GB, and 5 GB for a **nova-local** volume group larger
or equal than 80 GB; you must specify at least this amount. You can allocate
more **Instances LV** space to support the anticipated number of
boot-from-image VMs, up to 50% of the maximum available storage of the local
volume group. At least 50% free space in the volume group is required to
provide space for allocating logical volume disks for launched instances. The
value provided for the **Instance LV Size** is limited by this maximum.

Instructions for allocating the **Instances LV Size** using the Web
administration interface or the CLI are included in as part of configuring the
compute nodes. Suggested sizes are indicated in the Web administration
interface.

.. caution::

    If less than the minimum required space is available, the compute host
    cannot be unlocked.

