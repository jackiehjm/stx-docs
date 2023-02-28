
.. uvy1462906813562
.. _storage-resources:

=================
Storage Resources
=================

|prod-os| uses storage resources on the controller-labelled master hosts, the
compute-labeled worker hosts, and on storage hosts if they are present.

The storage configuration for |prod-os| is very flexible. The specific
configuration depends on the type of system installed, and the requirements of
the system.

.. _storage-resources-section-N1005C-N10029-N10001:

-----------------------------
Storage Services and Backends
-----------------------------

The figure below shows the storage options and backends for |prod-os|.

.. figure:: /shared/figures/storage/zpk1486667625575.png

   |prod-os| Storage Options and Backends

Each service can use different storage backends.

**Ceph**
    This provides storage managed by the internal Ceph cluster. Depending on
    the deployment configuration, the internal Ceph cluster is provided through
    |OSDs| on OpenStack master / controller hosts or storage hosts.

.. _storage-resources-table-ajr-tlf-zbb:

.. table:: Table 1. Available Backends for Storage Services
    :widths: auto

    +---------+---------------------------------------------------------------+---------------------------------------------------------------+
    | Service | Description                                                   | Available Backends                                            |
    +=========+===============================================================+===============================================================+
    | Cinder  | -   persistent block storage                                  | -   Internal Ceph on master/controller hosts or storage hosts |
    |         |                                                               |                                                               |
    |         | -   used for VM boot disk volumes                             |                                                               |
    |         |                                                               |                                                               |
    |         | -   used as additional disk volumes for VMs booted from images|                                                               |
    |         |                                                               |                                                               |
    |         | -   snapshots and persistent backups for volumes              |                                                               |
    +---------+---------------------------------------------------------------+---------------------------------------------------------------+
    | Glance  | -   image file storage                                        | -   Internal Ceph on master/controller hosts or storage hosts |
    |         |                                                               |                                                               |
    |         | -   used for VM boot disk images                              |                                                               |
    +---------+---------------------------------------------------------------+---------------------------------------------------------------+
    | Nova    | -   ephemeral object storage                                  | -   CoW-Image on Compute Nodes                                |
    |         |                                                               |                                                               |
    |         | -   used for VM ephemeral disks                               | -   Internal Ceph on master/controller hosts or storage hosts |
    +---------+---------------------------------------------------------------+---------------------------------------------------------------+


.. _storage-resources-section-N10035-N10028-N10001:

--------------------
Uses of Disk Storage
--------------------

**Containerized OpenStack System**
    The |prod-os| system containers use a combination of local container
    ephemeral disk, |PVCs| backed by Ceph and a containerized HA mariadb
    deployment for configuration and database files.

**VM Ephemeral Boot Disk Volumes (that is, when booting from an image)**
    Virtual machines use local ephemeral disk storage on computes for Nova
    ephemeral local boot disk volumes built from images. These virtual disk
    volumes are created when the |VM| instances are launched. These virtual
    volumes are destroyed when the |VM| instances are terminated.

**VM Persistent Boot Disk Volumes (that is, when booting from Cinder Volumes)**
    Virtual machines can optionally use the Ceph-backed storage cluster for
    backing Cinder boot disk volumes. This provides permanent storage for the
    |VM| root disks, facilitating faster machine startup, but requiring more
    storage resources. For |VMs| booted from images it provides additional
    Cinder disk volumes for persistent storage.

**VM Additional Disks**
    Virtual machines can optionally use local ephemeral disk storage on
    computes for additional virtual disks, such as swap disks. These disks are
    ephemeral; they are created when a |VM| instance is launched, and destroyed
    when the |VM| instance is terminated.

**VM Block Storage backups**
    Cinder volumes can be backed up for long term storage in a separate Ceph
    pool.

.. _storage-resources-section-N100B3-N10028-N10001:

-----------------
Storage Locations
-----------------

In additional to the storage used by |prod-os| system containers, the following
storage locations may be used.

**Controller Hosts**
    In the Standard with Controller Storage deployment option, one or more
    disks can be used on controller hosts to provide a small Ceph-based cluster
    for providing the storage backend for Cinder volumes, Cinder backups,
    Glance images, and remote Nova ephemeral volumes.

**Compute Hosts**
    One or more disks can be used on compute hosts to provide local Nova
    ephemeral storage for virtual machines.

**Combined Controller-Compute Hosts**
    One or more disks can be used on combined hosts in Simplex or Duplex
    systems to provide local Nova Ephemeral Storage for virtual machines and a
    small Ceph-backed storage cluster for backing Cinder, Glance, and Remote
    Nova Ephemeral storage.

**Storage Hosts**
    One or more disks are used on storage hosts to provide a large scale
    Ceph-backed storage cluster for backing Cinder, Glance, and Remote Nova
    Ephemeral storage. Storage hosts are used only on |prod-os| with Dedicated
    Storage systems.
