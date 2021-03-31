
.. bfh1466190844731
.. _storage-configuration-storage-by-host-type:

======================
Storage Configurations
======================

.. contents:: |minitoc|
   :local:
   :depth: 1

---------------------------
Storage on controller hosts
---------------------------

.. _storage-configuration-storage-on-controller-hosts:

The controllers provide storage for the |prod-os|'s OpenStack Controller
Services through a combination of local container Ephemeral disk, |PVCs| backed
by Ceph and a containerized HA mariadb deployment.

On systems configured for controller storage with a small Ceph cluster on the
master/controller nodes, they also provide persistent block storage for
persistent |VM| volumes \(Cinder\), storage for |VM| images \(Glance\), and
storage for |VM| remote Ephemeral volumes \(Nova\). On All-in-One Simplex or
Duplex systems, the controllers also provide nova-local storage for Ephemeral
|VM| volumes.

On systems configured for controller storage, the master/controller's root disk
is reserved for system use, and additional disks are required to support the
small Ceph cluster. On a All-in-One Simplex or Duplex system, you have the
option to partition the root disk for the nova-local storage \(to realize a
two-disk controller\) or use a third disk for nova-local storage.

.. _storage-configuration-storage-on-controller-hosts-section-N10031-N10024-N10001:

**************************************
Underlying platform filesystem storage
**************************************

To pass the disk-space checks, any replacement disks must be installed before
the allotments are changed.

.. _storage-configuration-storage-on-controller-hosts-section-N1010F-N1001F-N10001:

***************************************
Glance, Cinder, and remote Nova storage
***************************************

On systems configured for controller storage with a small Ceph cluster on the
master/controller nodes, this small Ceph cluster on the controller provides
Glance image storage, Cinder block storage, Cinder backup storage, and Nova
remote Ephemeral block storage. For more information, see :ref:`Block Storage
for Virtual Machines <block-storage-for-virtual-machines>`.

.. _storage-configuration-storage-on-controller-hosts-section-N101BB-N10029-N10001:

******************
Nova-local storage
******************

Controllers on |prod-os| Simplex or Duplex systems incorporate the Compute
function, and therefore provide **nova-local** storage for Ephemeral disks. On
other systems, **nova-local** storage is provided by compute hosts. For more
information about this type of storage, see :ref:`Storage on Compute Hosts
<storage-on-compute-hosts>` and :ref:`Block Storage for Virtual Machines
<block-storage-for-virtual-machines>`.

You can add a physical volume using the system :command:`host-pv-add` command.

.. xbooklink For more information, see Cloud Platform Storage Configuration: :ref:`Adding a Physical Volume <adding-a-physical-volume>`.

.. _storage-on-storage-hosts:

------------------------
Storage on storage hosts
------------------------

|prod-os| creates default Ceph storage pools for Glance images, Cinder volumes,
Cinder backups, and Nova Ephemeral data. For more information, see the
:ref:`Platform Storage Configuration <storage-configuration-storage-resources>`
guide for details on configuring the internal Ceph cluster on either controller
or storage hosts.

------------------------
Storage on compute hosts
------------------------

Compute-labelled worker hosts can provide Ephemeral storage for |VM| disks.

.. note::
    On All-in-One Simplex or Duplex systems, compute storage is provided using
    resources on the combined host.
