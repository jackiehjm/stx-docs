
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
    However, for an |AIO-DX| system, use the following alternative procedure to
    replace |OSDs| without reinstalling the host:
    :ref:`Replace OSDs on an AIO-DX System <replace-osds-on-an-aio-dx-system-319b0bc2f7e6>`.

.. rubric:: |proc|

Follow the procedure located at |node-doc|: :ref:`Change
Hardware Components for a Storage Host <changing-hardware-components-for-a-storage-host>`.

The replacement disk is automatically formatted and updated with data when the
storage host is unlocked.
