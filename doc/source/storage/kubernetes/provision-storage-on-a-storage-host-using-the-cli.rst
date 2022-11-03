
.. ytc1552678540385
.. _provision-storage-on-a-storage-host-using-the-cli:

=================================================
Provision Storage on a Storage Host Using the CLI
=================================================

You can use the command line to configure the ceph disks \(|OSDs| disk\)
on storage hosts.

.. rubric:: |context|

For more about |OSDs|, see |stor-doc|: :ref:`Storage on Storage Hosts
<storage-hosts-storage-on-storage-hosts>`.

.. xbooklink

   To use the Horizon Web interface, see the :ref:`Installation Overview
   <installation-overview>` for your system.

.. rubric:: |prereq|

To create or edit an |OSD|, you must lock the storage host. The system must
have at least two other unlocked hosts with Ceph monitors. \(Ceph monitors
run on **controller-0**, **controller-1**, and **storage-0** only\).

To use a custom storage tier, you must create the tier first.

.. rubric:: |proc|

#.  List the available physical disks.

    .. code-block:: none

        ~(keystone_admin)]$ system host-disk-list storage-3
        +--------------------------------------+-------------+------------+-------------+----------+---------------+--------------------------------------------+
        | uuid                                 | device_node | device_num | device_type | size_gib | available_gib | device_path                                |
        +--------------------------------------+-------------+------------+-------------+----------+---------------+--------------------------------------------+
        | ba751efe-33sd-as34-7u78-df3416875896 | /dev/sda    | 2048       |   HDD       | 51.2     | 0             | /dev/disk/by-path/pci-0000:00:0d.0-ata-2.0 |
        | e8751efe-6101-4d1c-a9d3-7b1a16871791 | /dev/sdb    | 2064       |   HDD       | 10.2     | 10.1          | /dev/disk/by-path/pci-0000:00:0d.0-ata-3.0 |
        | ae851efe-87hg-67gv-9ouj-sd3s16877658 | /dev/sdc    | 2080       |   SSD       | 8.1      | 8.0           | /dev/disk/by-path/pci-0000:00:0d.0-ata-4.0 |
        +--------------------------------------+-------------+------------+-------------+----------+---------------+--------------------------------------------+

#.  List the available storage tiers.

    .. code-block:: none

        ~(keystone_admin)]$ system storage-tier-list ceph_cluster
        +--------------------------------------+---------+--------+----------------+
        | uuid                                 | name    | status | backend_using  |
        +--------------------------------------+---------+--------+----------------+
        | 220f17e2-8564-4f4d-8665-681f73d13dfb | gold    | in-use | 283e5997-ea... |
        | e9ddc040-7d5e-4e28-86be-f8c80f5c0c42 | storage | in-use | f1151da5-bd... |
        +--------------------------------------+---------+--------+----------------+

#.  Create a storage function \(an |OSD|\).

    .. note::
        You cannot add a storage function to the root disk \(/dev/sda in this
        example\).

    .. code-block:: none

        ~(keystone_admin)]$ system host-stor-add
        usage: system host-stor-add [--journal-location [<journal_location>]]
                                     [--journal-size[<size of the journal MiB>]]
                                     [--tier-uuid[<storage tier uuid>]]
                                     <hostname or id> [<function>] <idisk_uuid>

    where <idisk\_uuid> identifies an |OSD|. For example:

    .. code-block:: none

        ~(keystone_admin)]$ system host-stor-add storage-3 e8751efe-6101-4d1c-a9d3-7b1a16871791

        +------------------+--------------------------------------------------+
        | Property         | Value                                            |
        +------------------+--------------------------------------------------+
        | osdid            | 3                                                |
        | function         | osd                                              |
        | journal_location | e639f1a2-e71a-4f65-8246-5cd0662d966b             |
        | journal_size_gib | 1                                                |
        | journal_path     | /dev/disk/by-path/pci-0000:00:0d.0-ata-3.0-part2 |
        | journal_node     | /dev/sdc1                                        |
        | uuid             | fc7b2d29-11bf-49a9-b4a9-3bc9a973077d             |
        | ihost_uuid       | 4eb90dc1-2b17-443e-b997-75bdd19e3eeb             |
        | idisk_uuid       | e8751efe-6101-4d1c-a9d3-7b1a16871791             |
        | tier_uuid        | e9ddc040-7d5e-4e28-86be-f8c80f5c0c42             |
        | tier_name        | storage                                          |
        | created_at       | 2018-01-30T22:57:11.561447+00:00                 |
        | updated_at       | 2018-01-30T22:57:27.169874+00:00                 |
        +------------------+--------------------------------------------------+

    In this example, an SSD-backed journal function is available. For
    more about SSD-backed journals, see :ref:`Storage Functions: OSDs and
    SSD-backed Journals
    <storage-functions-osds-and-ssd-backed-journals>`. The Ceph journal for
    the OSD is automatically created on the journal function using a
    default size of 1 GiB. You can use the ``--journal-size`` option to
    specify a different size in GiB.

    If multiple journal functions exist \(corresponding to multiple
    dedicated |SSDs|\), then you must include the ``--journal-location``
    option and specify the journal function to use for the |OSD|. You can
    obtain the UUIDs for journal functions using the :command:`system
    host-stor-list` command:

    .. code-block:: none

        ~(keystone_admin)]$ system host-stor-list storage-3

        +--------------------------------------+----------+-------+--------------+---------------+--------------------------+------------------+-----------+
        | uuid                                 | function | osdid | capabilities | idisk_uuid    | journal_path             | journal_size_gib | tier_name |
        +--------------------------------------+----------+-------+--------------+---------------+--------------------------+------------------+-----------|
        | e6391e2-8564-4f4d-8665-681f73d13dfb  | journal  | None  | {}           | ae8b1434-d... | None                     | 0                |           |
        | fc7bdc40-7d5e-4e28-86be-f8c80f5c0c42 | osd      | 3     | {}           | e8751efe-6... | /dev/disk/by-path/pci... | 1.0              | storage   |
        +--------------------------------------+----------+-------+--------------+---------------+--------------------------+------------------+-----------+

    If no journal function exists when the storage function is created, the
    Ceph journal for the |OSD| is collocated on the |OSD|.

    If an |SSD| or |NVMe| drive is available on the host, you can add a
    journal function. For more information, see :ref:`Add SSD-Backed
    Journals Using the CLI <add-ssd-backed-journals-using-the-cli>`. You
    can update the |OSD| to use a journal on the |SSD| by referencing the
    journal function |UUID|, as follows:

    .. code-block:: none

        ~(keystone_admin)]$ system host-stor-update <osd_uuid> --journal-location <journal_function_uuid> [--journal-size <size>]

.. rubric:: |postreq|

Unlock the host to make the changes take effect. Wait for the host to be
reported as unlocked, online, and available in the hosts list.

You can re-use the same settings with other storage nodes by creating and
applying a storage profile. For more information, see the `StarlingX
Containers Installation Guide
<https://docs.starlingx.io/deploy_install_guides/index.html>`__.

