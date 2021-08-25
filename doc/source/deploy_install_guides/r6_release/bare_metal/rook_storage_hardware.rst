=====================
Hardware Requirements
=====================

This section describes the hardware requirements and server preparation for a
**StarlingX R6.0 bare metal Standard with Rook Storage** deployment
configuration.

.. contents::
   :local:
   :depth: 1

-----------------------------
Minimum hardware requirements
-----------------------------

The recommended minimum hardware requirements for bare metal servers for various
host types are:

+---------------------+---------------------------+-----------------------+-----------------------+
| Minimum Requirement | Controller Node           | Worker Node for rook  | Worker Node for       |
|                     |                           | storage               | application           |
+=====================+===========================+=======================+=======================+
| Number of servers   | 2                         | 2-9                   | 2-100                 |
+---------------------+---------------------------+-----------------------+-----------------------+
| Minimum processor   | Dual-CPU Intel® Xeon® E5 26xx family (SandyBridge) 8 cores/socket         |
| class               |                                                                           |
+---------------------+---------------------------+-----------------------+-----------------------+
| Minimum memory      | 64 GB                     | 64 GB                 | 32 GB                 |
+---------------------+---------------------------+-----------------------+-----------------------+
| Primary disk        | 500 GB SSD or NVMe (see   | 120 GB (min. 10k RPM) | 120 GB (min. 10k RPM) |
|                     | :ref:`nvme_config`)       |                       |                       |
+---------------------+---------------------------+-----------------------+-----------------------+
| Additional disks    | None                      | - 1 or more 500 GB    | - For OpenStack,      |
|                     |                           |   (min. 10K RPM) for  |   recommend 1 or more |
|                     |                           |   Ceph OSD            |   500 GB (min. 10K    |
|                     |                           | - Recommended, but    |   RPM) for VM         |
|                     |                           |   not required: 1 or  |   ephemeral storage   |
|                     |                           |   more SSDs or NVMe   |                       |
|                     |                           |   drives for Ceph     |                       |
|                     |                           |   journals (min. 1024 |                       |
|                     |                           |   MiB per OSD         |                       |
|                     |                           |   journal)            |                       |
+---------------------+---------------------------+-----------------------+-----------------------+
| Minimum network     | - Mgmt/Cluster:           | - Mgmt/Cluster:       | - Mgmt/Cluster:       |
| ports               |   1x10GE                  |   1x10GE              |   1x10GE              |
|                     | - OAM: 1x1GE              |                       | - Data: 1 or more     |
|                     |                           |                       |   x 10GE              |
+---------------------+---------------------------+-----------------------+-----------------------+
| BIOS settings       | - Hyper-Threading technology enabled                                      |
|                     | - Virtualization technology enabled                                       |
|                     | - VT for directed I/O enabled                                             |
|                     | - CPU power and performance policy set to performance                     |
|                     | - CPU C state control disabled                                            |
|                     | - Plug & play BMC detection disabled                                      |
+---------------------+---------------------------+-----------------------+-----------------------+

--------------------------
Prepare bare metal servers
--------------------------

.. include:: prep_servers.txt
