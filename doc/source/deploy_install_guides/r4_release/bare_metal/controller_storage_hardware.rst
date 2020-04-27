=====================
Hardware Requirements
=====================

This section describes the hardware requirements and server preparation for a
**StarlingX R4.0 bare metal Standard with Controller Storage** deployment
configuration.

.. contents::
   :local:
   :depth: 1

-----------------------------
Minimum hardware requirements
-----------------------------

The recommended minimum hardware requirements for bare metal servers for various
host types are:

+-------------------------+-----------------------------+-----------------------------+
| Minimum Requirement     | Controller Node             | Worker Node                 |
+=========================+=============================+=============================+
| Number of servers       | 2                           | 2-10                        |
+-------------------------+-----------------------------+-----------------------------+
| Minimum processor class | - Dual-CPU Intel® Xeon® E5 26xx family (SandyBridge)      |
|                         |   8 cores/socket                                          |
+-------------------------+-----------------------------+-----------------------------+
| Minimum memory          | 64 GB                       | 32 GB                       |
+-------------------------+-----------------------------+-----------------------------+
| Primary disk            | 500 GB SSD or NVMe (see     | 120 GB (Minimum 10k RPM)    |
|                         | :doc:`../../nvme_config`)   |                             |
+-------------------------+-----------------------------+-----------------------------+
| Additional disks        | - 1 or more 500 GB (min.    | - For OpenStack, recommend  |
|                         |   10K RPM) for Ceph OSD     |   1 or more 500 GB (min.    |
|                         | - Recommended, but not      |   10K RPM) for VM local     |
|                         |   required: 1 or more SSDs  |   ephemeral storage         |
|                         |   or NVMe drives for Ceph   |                             |
|                         |   journals (min. 1024 MiB   |                             |
|                         |   per OSD journal)          |                             |
+-------------------------+-----------------------------+-----------------------------+
| Minimum network ports   | - Mgmt/Cluster: 1x10GE      | - Mgmt/Cluster: 1x10GE      |
|                         | - OAM: 1x1GE                | - Data: 1 or more x 10GE    |
+-------------------------+-----------------------------+-----------------------------+
| BIOS settings           | - Hyper-Threading technology enabled                      |
|                         | - Virtualization technology enabled                       |
|                         | - VT for directed I/O enabled                             |
|                         | - CPU power and performance policy set to performance     |
|                         | - CPU C state control disabled                            |
|                         | - Plug & play BMC detection disabled                      |
+-------------------------+-----------------------------+-----------------------------+

--------------------------
Prepare bare metal servers
--------------------------

.. include:: prep_servers.txt