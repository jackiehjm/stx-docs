
.. dnn1552678684527
.. _storage-functions-osds-and-ssd-backed-journals:

===============================================
Storage Functions: OSDs and SSD-backed Journals
===============================================

Disks on storage hosts are assigned storage functions in |prod| to provide
either OSD storage or Ceph journal storage.

Rotational disks on storage hosts are always assigned as object storage
devices \(OSDs\) to provide storage for Application disks. Solid-state disks
\(SSDs\) can be assigned as OSDs, or as journal functions to provide space for
Ceph transaction journals associated with OSDs. NVMe-compatible SSDs are also
supported.

To assign storage-host disks as OSDs, see :ref:`Provision Storage on a
Controller or Storage Host Using Horizon
<provision-storage-on-a-controller-or-storage-host-using-horizon>`.

To create SSD-backed journals, see :ref:`Add SSD-Backed Journals Using
Horizon <add-ssd-backed-journals-using-horizon>`.

