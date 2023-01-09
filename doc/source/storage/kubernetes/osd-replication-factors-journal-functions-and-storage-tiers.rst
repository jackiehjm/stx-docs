
.. ldg1564594442097
.. _osd-replication-factors-journal-functions-and-storage-tiers:

============================================================
OSD Replication Factors, Journal Functions and Storage Tiers
============================================================


.. _osd-replication-factors-journal-functions-and-storage-tiers-section-N1003F-N1002B-N10001:

----------------------
OSD Replication Factor
----------------------


.. _osd-replication-factors-journal-functions-and-storage-tiers-d61e23:


.. table::
    :widths: auto

    +--------------------+-----------------------------+--------------------------------------+
    | Replication Factor | Hosts per Replication Group | Maximum Replication Groups Supported |
    +====================+=============================+======================================+
    | 2                  | 2                           | 4                                    |
    +--------------------+-----------------------------+--------------------------------------+
    | 3                  | 3                           | 3                                    |
    +--------------------+-----------------------------+--------------------------------------+

You can add up to 16 Ceph disks \(OSD disks\) per storage host for
data storage.

Space on the storage hosts must be configured at installation before you
can unlock the hosts. You can change the configuration after installation
by adding resources to existing storage hosts or adding more storage hosts.
For more information, see |_link-inst-book|.

Storage hosts can achieve faster data access using SSD-backed transaction
journals \(journal functions\). NVMe-compatible SSDs are supported.

.. _osd-replication-factors-journal-functions-and-storage-tiers-section-N10044-N1002B-N10001:

-----------------
Journal Functions
-----------------

Each OSD on a storage host has an associated Ceph transaction journal,
which tracks changes to be committed to disk for data storage and
replication, and if required, for data recovery. This is a full Ceph
journal, containing both meta-data and data. By default, it is collocated
on the OSD, which typically uses slower but less expensive HDD-backed
storage. For faster commits and improved reliability, you can use a
dedicated solid-state drive \(SSD\) installed on the host and assigned as a
journal function. NVMe-compatible SSDs are also supported. You can dedicate
more than one SSD as a journal function.

.. note::
    You can also assign an SSD for use as an OSD, but you cannot assign the
    same SSD as a journal function.

If a journal function is available, you can configure individual OSDs to
use journals located on the journal function. Each journal is implemented
as a partition. You can adjust the size and location of the journals.

For OSDs implemented on rotational disks, |org| strongly recommends that
you use an SSD-based journal function. For OSDs implemented on SSDs,
collocated journals can be used with no performance cost.

For more information, see |stor-doc|: :ref:`Storage Functions: OSDs and
SSD-backed Journals <storage-functions-osds-and-ssd-backed-journals>`.

.. _osd-replication-factors-journal-functions-and-storage-tiers-section-N10049-N1002B-N10001:

-------------
Storage Tiers
-------------

You can create different tiers of OSDs storage to meet different Container
requirements. For example, to meet the needs of Containers with frequent
disk access, you can create a tier containing only high-performance OSDs.
You can then associate new Persistent Volume Claims with this tier for use
with the Containers.

By default, |prod| is configured with one tier, called the Storage
Tier. This is created as part of adding the Ceph storage back-end. It uses
the first OSD in each peer host of the first replication group.

You can add more tiers as required, limited only by the available hardware.

After adding a tier, you can assign OSDs to it. The OSD assignments must
satisfy the replication requirements for the system. That is, in the
replication group used to implement a tier, each peer host must contribute
the same number of OSDs to the tier.

For more information on storage tiers, see |stor-doc|: :ref:`Add a
Storage Tier Using the CLI <add-a-storage-tier-using-the-cli>`.

