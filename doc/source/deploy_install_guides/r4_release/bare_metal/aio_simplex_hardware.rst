=====================
Hardware Requirements
=====================

This section describes the hardware requirements and server preparation for a
**StarlingX R4.0 bare metal All-in-one Simplex** deployment configuration.

.. contents::
   :local:
   :depth: 1

-----------------------------
Minimum hardware requirements
-----------------------------

The recommended minimum hardware requirements for bare metal servers for various
host types are:

+-------------------------+-----------------------------------------------------------+
| Minimum Requirement     | All-in-one Controller Node                                |
+=========================+===========================================================+
| Number of servers       |  1                                                        |
+-------------------------+-----------------------------------------------------------+
| Minimum processor class | - Dual-CPU Intel® Xeon® E5 26xx family (SandyBridge)      |
|                         |   8 cores/socket                                          |
|                         |                                                           |
|                         | or                                                        |
|                         |                                                           |
|                         | - Single-CPU Intel® Xeon® D-15xx family, 8 cores          |
|                         |   (low-power/low-cost option)                             |
+-------------------------+-----------------------------------------------------------+
| Minimum memory          | 64 GB                                                     |
+-------------------------+-----------------------------------------------------------+
| Primary disk            | 500 GB SSD or NVMe (see :doc:`../../nvme_config`)         |
+-------------------------+-----------------------------------------------------------+
| Additional disks        | - 1 or more 500 GB (min. 10K RPM) for Ceph OSD            |
|                         | - Recommended, but not required: 1 or more SSDs or NVMe   |
|                         |   drives for Ceph journals (min. 1024 MiB per OSD         |
|                         |   journal)                                                |
|                         | - For OpenStack, recommend 1 or more 500 GB (min. 10K     |
|                         |   RPM) for VM local ephemeral storage                     |
+-------------------------+-----------------------------------------------------------+
| Minimum network ports   | - OAM: 1x1GE                                              |
|                         | - Data: 1 or more x 10GE                                  |
+-------------------------+-----------------------------------------------------------+
| BIOS settings           | - Hyper-Threading technology enabled                      |
|                         | - Virtualization technology enabled                       |
|                         | - VT for directed I/O enabled                             |
|                         | - CPU power and performance policy set to performance     |
|                         | - CPU C state control disabled                            |
|                         | - Plug & play BMC detection disabled                      |
+-------------------------+-----------------------------------------------------------+

--------------------------
Prepare bare metal servers
--------------------------

.. include:: prep_servers.txt