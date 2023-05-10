
.. lqo1552672461538
.. _hard-drive-options:

==================
Hard Drive Options
==================

.. only:: starlingx

    For hard drive storage, |prod| supports high-performance |SSD| and |NVMe|
    drives as well as rotational disks.

.. only:: partner

    .. include:: /_includes/hard-drive-options.rest
      :start-after: hpe-begin
      :end-before: hpe-end

To increase system performance, you can use a |SSD| or a |NVMe| drive on |prod|
hosts in place of any rotational drive. |SSD| provides faster read-write access
than mechanical drives. |NVMe| supports the full performance potential of |SSD|
by providing a faster communications bus compared to the |SATA| or |SAS|
technology used with standard |SSDs|.

On storage hosts, |SSD| or |NVMe| drives are required for journals or Ceph
caching.

.. xrefbook For more information about these features, see |stor-doc|: :ref:`Storage on Storage Hosts <storage-hosts-storage-on-storage-hosts>`.

For |NVMe| drives, a host with an |NVMe|-ready BIOS and |NVMe| connectors or
adapters is required.

To use an |NVMe| drive as a root drive, you must enable |UEFI| support in the
host BIOS. In addition, when installing the host, you must perform extra steps
to assign the drive as the boot device.

.. only:: partner

    .. include:: /_includes/hard-drive-options.rest
      :start-after: hard-drive-begin
      :end-before: hard-drive-end

