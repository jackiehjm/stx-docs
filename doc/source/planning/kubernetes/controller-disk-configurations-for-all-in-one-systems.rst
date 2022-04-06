
.. kll1552672476085
.. _controller-disk-configurations-for-all-in-one-systems:

=====================================================
Controller Disk Configurations for All-in-one Systems
=====================================================

For |prod| Simplex and Duplex Systems, the controller disk configuration is
highly flexible to support different system requirements for Cinder and
nova-local storage.

You can also change the disk configuration after installation to increase the
persistent volume claim or container-ephemeral storage.

.. _controller-disk-configurations-for-all-in-one-systems-table-h4n-rmg-3jb:

.. table:: Table 1. Disk Configurations for |prod| Simplex or Duplex systems
    :widths: auto

    +--------------+----------+-----------+-----------+-----------+-----------------------------------------------+-----------------------------+-------------------+-------------------------------------------------------------------------+
    | No. of Disks | Disk     | BIOS Boot | Boot      | Root      | Platform File System Volume Group \(cgts-vg\) | Root Disk Unallocated Space | Ceph OSD \(PVCs\) | Notes                                                                   |
    +==============+==========+===========+===========+===========+===============================================+=============================+===================+=========================================================================+
    | 1            | /dev/sda |           |           |           |                                               |                             |                   | Not supported                                                           |
    +--------------+----------+-----------+-----------+-----------+-----------------------------------------------+-----------------------------+-------------------+-------------------------------------------------------------------------+
    | 2            | /dev/sda | /dev/sda1 | /dev/sda2 | /dev/sda3 | /dev/sda4                                     | Not allocated               | Disk              | Space left unallocated for future application use                       |
    |              |          |           |           |           |                                               |                             |                   |                                                                         |
    |              | /dev/sdb |           |           |           |                                               |                             |                   | AIO-SX [#fntarg1]_ \(replication = 1\); AIO-DX \(replication = 2\)      |
    +--------------+----------+-----------+-----------+-----------+-----------------------------------------------+-----------------------------+-------------------+-------------------------------------------------------------------------+
    | 2            | /dev/sda | /dev/sda1 | /dev/sda2 | /dev/sda3 | /dev/sda4                                     | /dev/sda5 \(cgts-vg\)       | Disk              | Space allocated to cgts-vg to allow filesystem expansion                |
    |              |          |           |           |           |                                               |                             |                   |                                                                         |
    |              | /dev/sdb |           |           |           |                                               |                             |                   | AIO-SX \(replication = 1\); AIO-DX \(replication = 2\)                  |
    +--------------+----------+-----------+-----------+-----------+-----------------------------------------------+-----------------------------+-------------------+-------------------------------------------------------------------------+
    | 3            | /dev/sda | /dev/sda1 | /dev/sda2 | /dev/sda3 | /dev/sda4                                     | Not allocated               | Disk              | Space left unallocated for future application use                       |
    |              |          |           |           |           |                                               |                             |                   |                                                                         |
    |              | /dev/sdb |           |           |           |                                               |                             | Disk              | AIO-SX:superscript:`1:` \(replication = 2\); AIO-DX \(replication = 2\) |
    |              |          |           |           |           |                                               |                             |                   |                                                                         |
    |              | /dev/sdc |           |           |           |                                               |                             |                   | AIO-SX:superscript:`1:` \(replication = 2\); AIO-DX \(replication = 2\) |
    +--------------+----------+-----------+-----------+-----------+-----------------------------------------------+-----------------------------+-------------------+-------------------------------------------------------------------------+
    | 3            | /dev/sda | /dev/sda1 | /dev/sda2 | /dev/sda3 | /dev/sda4                                     | /dev/sda5 \(cgts-vg\)       | Disk              | Space allocated to cgts-vg to allow filesystem expansion                |
    |              |          |           |           |           |                                               |                             |                   |                                                                         |
    |              | /dev/sdb |           |           |           |                                               |                             | Disk              | AIO-SX:superscript:`1:` \(replication = 2\); AIO-DX \(replication = 2\) |
    |              |          |           |           |           |                                               |                             |                   |                                                                         |
    |              | /dev/sdc |           |           |           |                                               |                             |                   | AIO-SX:superscript:`1:` \(replication = 2\); AIO-DX \(replication = 2\) |
    +--------------+----------+-----------+-----------+-----------+-----------------------------------------------+-----------------------------+-------------------+-------------------------------------------------------------------------+


.. [#fntarg1]  |AIO|-Simplex Ceph replication is disk-based.
