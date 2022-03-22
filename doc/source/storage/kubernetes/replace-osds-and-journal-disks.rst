
.. xps1552678558589
.. _replace-osds-and-journal-disks:

==============================
Replace OSDs and Journal Disks
==============================

You can replace failed storage devices on storage nodes.

.. rubric:: |context|

For best results, ensure the replacement disk is the same size as others in
the same peer group. Do not substitute a smaller disk than the original.

.. note::
    Due to a limitation in **udev**, the device path of a disk connected through
    a SAS controller changes when the disk is replaced. Therefore, in the
    general procedure below, you must lock, delete, and re-install the node.
    However, for standard, |AIO-SX|, and |AIO-DX| systems, use the following
    alternative procedures to replace |OSDs| without reinstalling the host:

    -   :ref:`Replace OSDs on a Standard System
        <replace-osds-on-a-standard-system-f3b1e376304c>`

    -   :ref:`Replace OSDs on an AIO-DX System
        <replace-osds-on-an-aio-dx-system-319b0bc2f7e6>`

    -   :ref:`Replace OSDs on an AIO-SX Multi-Disk System
        <replace-osds-on-an-aio-sx-multi-disk-system-b4ddd1c1257c>`

    -   :ref:`Replace ODSs on an AIO-SX Single Disk System without Backup
        <replace-osds-on-an-aio-sx-single-disk-system-without-backup-951eefebd1f2>`

    -   :ref:`Replace OSDs on an AIO-SX Single Disk System with Backup
        <replace-osds-on-an-aio-sx-single-disk-system-with-backup-770c9324f372>`

.. rubric:: |proc|

Follow the procedure located at |node-doc|: :ref:`Change
Hardware Components for a Storage Host <changing-hardware-components-for-a-storage-host>`.

The replacement disk is automatically formatted and updated with data when the
storage host is unlocked.
