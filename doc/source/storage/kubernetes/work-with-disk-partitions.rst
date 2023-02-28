
.. rjs1590523169603
.. _work-with-disk-partitions:

=========================
Work with Disk Partitions
=========================

You can use disk partitions to provide space for local volume groups.

You can create, modify, and delete partitions from the Horizon Web interface or
the |CLI|.

To use |prod-os|, select **Admin** \> **Platform** \> **Host Inventory**,
and then click the host name to open the Host Details page. On the Host
Details page, select the Storage tab. For more information, refer to the
host provisioning sections in the OpenStack Installation guide.

The following restrictions apply:


.. _work-with-disk-partitions-ul-mkv-pgx-5lb:

-   Logical volumes are not supported. All user-created partitions are
    implemented as physical volumes.

-   You cannot specify a start location. Each new partition is created
    using the first available location on the disk.

-   You can modify or delete only the last partition on a disk.

-   You can increase the size of a partition, but you cannot decrease the
    size.

-   You cannot delete a partition while it is in use (that is, while its
    physical volume is assigned to a local volume group).

-   User-created partitions are not supported for storage hosts.

-   Partition operations on a host are limited to one operation at a time.

.. seealso::

    -   :ref:`Identify Space Available for Partitions
        <identify-space-available-for-partitions>`

    -   :ref:`List Partitions <list-partitions>`

    -   :ref:`View Details for a Partition <view-details-for-a-partition>`

    -   :ref:`Add a Partition <add-a-partition>`

    -   :ref:`Increase the Size of a Partition
        <increase-the-size-of-a-partition>`

    -   :ref:`Delete a Partition <delete-a-partition>`


