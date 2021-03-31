
.. mkh1590590274215
.. _configuration-and-management-storage-on-controller-hosts:

===========================
Storage on Controller Hosts
===========================

The controllers provide storage for the OpenStack Controller Services through a
combination of local container ephemeral disk, Persistent Volume Claims backed
by Ceph and a containerized HA mariadb deployment.

On systems configured for controller storage with a small Ceph cluster on the
master/controller nodes, they also provide persistent block storage for
persistent |VM| volumes \(Cinder\), storage for |VM| images \(Glance\), and
storage for |VM| remote ephemeral volumes \(Nova\). On All-in-One Simplex or
Duplex systems, the controllers also provide nova- local storage for ephemeral
|VM| volumes.

On systems configured for controller storage, the master/controller's root disk
is reserved for system use, and additional disks are required to support the
small Ceph cluster. On a All-in-One Simplex or Duplex system, you have the
option to partition the root disk for the nova-local storage \(to realize a
two-disk controller\) or use a third disk for nova-local storage.


.. _configuration-and-management-storage-on-controller-hosts-section-rvx-vwc-vlb:

--------------------------------------
Underlying Platform Filesystem Storage
--------------------------------------

See the :ref:`platform Planning <overview-of-starlingx-planning>` documentation
for details.

To pass the disk-space checks, any replacement disks must be installed before
the allotments are changed.


.. _configuration-and-management-storage-on-controller-hosts-section-wgm-gxc-vlb:

---------------------------------------
Glance, Cinder, and Remote Nova storage
---------------------------------------

On systems configured for controller storage with a small Ceph cluster on the
master/controller nodes, this small Ceph cluster on the controller provides
Glance image storage, Cinder block storage, Cinder backup storage, and Nova
remote ephemeral block storage. For more information, see :ref:`Block Storage
for Virtual Machines <block-storage-for-virtual-machines>`.


.. _configuration-and-management-storage-on-controller-hosts-section-gpw-kxc-vlb:

------------------
Nova-local Storage
------------------

Controllers on |prod-os| Simplex or Duplex systems incorporate the Compute
function, and therefore provide **nova- local** storage for ephemeral disks. On
other systems, **nova- local** storage is provided by compute hosts. For more
information about this type of storage, see :ref:`Storage on Compute Hosts
<storage-on-compute-hosts>` and :ref:`Block Storage for Virtual Machines
<block-storage-for-virtual-machines>`.

