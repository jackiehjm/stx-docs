
.. uyj1582118375814
.. _storage-planning-storage-on-controller-hosts:

===========================
Storage on Controller Hosts
===========================

The controller's root disk provides storage for the |prod| system databases,
system configuration files, local Docker images, container's ephemeral
filesystems, the local Docker registry container image store, platform backup,
and the system backup operations.

.. contents:: |minitoc|
   :local:
   :depth: 1

Container local storage is derived from the cgts-vg volume group on the root
disk. You can add additional storage to the cgts-vg volume by assigning a
partition or disk to make it larger. This will allow you to increase the size
of the container local storage for the host, however, you cannot assign it
specifically to a non-root disk.

On All-in-one Simplex, All-in-one Duplex, and Standard with controller storage
systems, at least one additional disk for each controller host is required for
backing container |PVCs|.

Two disks are required with one being a Ceph |OSD|.

.. _storage-planning-storage-on-controller-hosts-d103e57:

-----------------------
Root Filesystem Storage
-----------------------

Space on the root disk is allocated to provide filesystem storage.

You can increase the allotments for the following filesystems using the Horizon
Web interface or the CLI. The following commands are available to increase
various filesystem sizes: :command:`system controllerfs`, and :command:`system
host-fs`.

.. _storage-planning-storage-on-controller-hosts-d103e93:

------------------------
Synchronized Filesystems
------------------------

Synchronized filesystems ensure that files stored in several different physical
locations are up to date. The following commands can be used to resize an
|DRBD|-synced filesystem \(Database, Docker-distribution, Etcd, Extension,
Platform\) on controllers.

:command:`controllerfs-list`, :command:`controllerfs-modify`, and
:command:`controllerfs-show`.

.. xbooklink For more information, see *Increasing Controller Filesystem Storage Allotments Using Horizon*.

**Platform Storage**
    This is the storage allotment for a variety of platform items including the
    local helm repository, the StarlingX application repository, and internal
    platform configuration data files.

**Database storage**
    The storage allotment for the platform's postgres database is used by
    StarlingX, System Inventory, Keystone and Barbican.

    Internal database storage is provided using |DRBD|-synchronized partitions
    on the controller primary disks. The size of the database grows with the
    number of system resources created by the system administrator. This
    includes objects of all kinds such as hosts, interfaces, and service
    parameters.

    If you add a database filesystem or increase its size, you must also
    increase the size of the backup filesystem.

**Docker-distribution storage \(local Docker registry storage\)**
    The storage allotment for container images stored in the local Docker
    registry. This storage is provided using a |DRBD|-synchronized partition on
    the controller primary disk.

**Etcd Storage**
    The storage allotment for the Kubernetes etcd database.

    Internal database storage is provided using a |DRBD|-synchronized partition
    on the controller primary disk. The size of the database grows with the
    number of system resources created by the system administrator and the
    users. This includes objects of all kinds such as pods, services, and
    secrets.

**Ceph-mon**
    Ceph-mon is the cluster monitor daemon for the Ceph distributed file system
    that is used for Ceph monitors to synchronize.

**Extension Storage**
    This filesystem is reserved for future use. This storage is implemented on
    a |DRBD|-synchronized partition on the controller primary disk.

.. _storage-planning-storage-on-controller-hosts-d103e219:

----------------
Host Filesystems
----------------

The following host filesystem commands can be used to resize non-|DRBD|
filesystems \(Backup, Docker, Kubelet, Scratch, and Log\) and do not
apply to all hosts of a given personality type:

:command:`host-fs-list`, :command:`host-fs-modify`, and :command:`host-fs-show`

The :command:`host-fs-modify` command increases the storage configuration for
the filesystem specified on a per-host basis. For example, the following
command increases the scratch filesystem size to 10 GB:

.. code-block:: none

    ~(keystone_admin)]$ system host-fs-modify controller-1 scratch=10

**Backup storage**
    This is the storage allotment for backup operations. This is a backup area,
    where:

    backup=2\*database+platform size

**Docker Storage**
    This storage allotment is for ephemeral filesystems for containers on the
    host, and for Docker image cache.

**Kubelet Storage**
    This storage allotment is for ephemeral storage size related to Kubernetes
    pods on this host.

**Scratch Storage**
    This storage allotment is used by the host as a temporary area for a
    variety of miscellaneous transient host operations.

**Logs Storage**
    This is the storage allotment for log data. This filesystem is not
    resizable. Logs are rotated within the fixed space allocated.

Replacement root disks for a reinstalled controller should be the same size or
larger to ensure that existing allocation sizes for filesystems will fit on the
replacement disk.

.. _storage-planning-storage-on-controller-hosts-d103e334:

-------------------------------------------------
Persistent Volume Claims storage \(Ceph Cluster\)
-------------------------------------------------

For controller-storage systems, additional disks on the controller, configured
as Ceph |OSDs|, provide a small Ceph cluster for backing |PVCs| storage for
containers.

.. _storage-planning-storage-on-controller-hosts-d103e345:

-----------
Replication
-----------

On |AIO|-Simplex systems, replication is done between |OSDs| within the host.

The following three replication factors are supported:

**1**
    This is the default, and requires one or more |OSD| disks.

**2**
    This requires two or more |OSD| disks.

**3**
    This requires three or more |OSD| disks.

On |AIO|-Duplex systems replication is between the two controllers. Only one
replication group is supported and additional controllers cannot be added.

The following replication factor is supported:

**2**
    There can be any number of |OSDs| on each controller, with a minimum of one
    each. It is recommended that you use the same number and same size |OSD|
    disks on the controllers.
