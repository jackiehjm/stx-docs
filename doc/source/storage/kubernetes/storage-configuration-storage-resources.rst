
.. jeg1583353455217
.. _storage-configuration-storage-resources:

=================
Storage Resources
=================

|prod| uses storage resources on the controller and worker hosts, and on
storage hosts if they are present.

.. contents::
   :local:
   :depth: 1

The |prod| storage configuration is highly flexible. The specific
configuration depends on the type of system installed, and the requirements
of the system.


.. _storage-configuration-storage-resources-d153e38:

--------------------
Uses of Disk Storage
--------------------

**StarlingX System**

The |prod| system uses root disk storage for the operating system and
related files, and for internal databases. On controller nodes, the
database storage and selected root file-systems are synchronized
between the controller nodes using DRBD.

**Local Docker Registry**

An HA local docker registry is deployed on controller nodes to provide
local centralized storage of container images. Its image store is a
DRBD synchronized file system.

**Docker Container Images**

Container images are pulled from either a remote or local Docker
Registry, and cached locally by docker on the host worker or controller
node when a container is launched.

**Container Ephemeral Local Disk**

Containers have local filesystems for ephemeral storage of data. This
data is lost when the container is terminated.

Kubernetes Docker ephemeral storage is allocated as part of the
docker-lv and kubelet-lv file systems from the cgts-vg volume group on
the root disk. These filesystems are resizable.

**Container Persistent Volume Claims \(PVCs\)**

Containers can mount remote HA replicated volumes backed by the Ceph
Storage Cluster for managing persistent data. This data survives
restarts of the container.

.. note::
    Ceph is not configured by default. For more information, see
    |stor-doc|: :ref:`Configure the Internal Ceph Storage Backend
    <configure-the-internal-ceph-storage-backend>`.


.. _storage-configuration-storage-resources-d153e134:

-----------------
Storage Locations
-----------------

In addition to the root disks present on each host for system storage, the
following storage may be used only for:

.. _storage-configuration-storage-resources-d153e143:

-   Controller hosts: Container Persistent Volume Claims on dedicated
    storage hosts when using that setup or on controller hosts. Additional
    Ceph OSD disk\(s\) are present on controllers in configurations
    without dedicated storage hosts. These OSD\(s\) provide storage to fill
    Persistent Volume Claims made by Kubernetes pods or containers.

-   Worker hosts: This is storage is derived from docker-lv/kubelet-lv as
    defined on the cgts-vg \(root disk\). You can add a disk to cgts-vg and
    increase the size of the docker-lv/kubelet-lv.


**Combined Controller-Worker Hosts**

One or more disks can be used on combined hosts in Simplex or Duplex
systems to provide local ephemeral storage for containers, and a Ceph
cluster for backing Persistent Volume Claims.

Container/Pod ephemeral storage is implemented on the root disk on all
controllers/workers regardless of labeling.

**Storage Hosts**

One or more disks are used on storage hosts to realize a large scale
Ceph cluster providing backing for Persistent Volume Claims for
containers. Storage hosts are used only on |prod| with Dedicated
Storage systems.


.. _storage-configuration-storage-resources-section-N1015E-N10031-N1000F-N10001:

-----------------------
External Netapp Trident
-----------------------

|prod| can be configured to connect to and use an external Netapp Trident
deployment as its storage backend.

Netapp Trident supports:


.. _storage-configuration-storage-resources-d201e23:

-   AWS Cloud Volumes

-   E and EF-Series SANtricity

-   ONTAP AFF, FAS, Select, and Cloud

-   Element HCI and SolidFire

-   Azure NetApp Files service



.. _storage-configuration-storage-resources-d201e56:

For more information about Trident, see
`https://netapp-trident.readthedocs.io
<https://netapp-trident.readthedocs.io>`__.

