
.. oim1552678636383
.. _add-ssd-backed-journals-using-the-cli:

=====================================
Add SSD-backed Journals Using the CLI
=====================================

You can use the command line to define SSD-backed journals.

.. rubric:: |context|

For more about SSD-backed journals, see :ref:`Storage on Storage Hosts
<storage-hosts-storage-on-storage-hosts>`.

To use the Horizon Web interface, see :ref:`Add SSD-Backed Journals
Using Horizon <add-ssd-backed-journals-using-horizon>`.

.. rubric:: |prereq|

A storage host with a solid-state drive (SSD) or Non-Volatile Memory
Express (NVMe) drive is required.

To create or edit an SSD-backed journal, you must lock the host. The system
must have at least two other unlocked hosts with Ceph monitors. (Ceph
monitors run on **controller-0**, **controller-1**, and **storage-0** only).

.. rubric:: |proc|

#.  List the available physical disks.

    .. code-block:: none

        ~(keystone_admin)$ system host-disk-list storage-3
        +--------------------------------------+-------------+------------+-------------+------------------+
        | uuid                                 | device_node | device_num | device_type | journal_size_gib |
        +--------------------------------------+-------------+------------+-------------+------------------+
        | ba785ad3-8be7-3654-45fd-93892d7182da | /dev/sda    | 2048       | HDD         | 51200            |
        | e8785ad3-98sa-1234-32ss-923433dd82da | /dev/sdb    | 2064       | HDD         | 10240            |
        | ae885ad3-8cc7-4103-84eb-9333ff3482da | /dev/sdc    | 2080       | SSD         | 8192             |
        +--------------------------------------+-------------+------------+-------------+------------------+

#.  Create a journal function.

    Use the :command:`system host-stor-add` command:

    .. code-block:: none

        ~(keystone_admin)]$ system host-stor-add <host_name> journal <device_uuid>

    where <host_name> is the name of the storage host (for example,
    storage-3), and <device_uuid> identifies an SSD.

    For example:

    .. code-block:: none

        ~(keystone_admin)]$ system host-stor-add storage-3 journal ae885ad3-8be7-4103-84eb-93892d7182da

        +------------------+--------------------------------------+
        | Property         | Value                                |
        +------------------+--------------------------------------+
        | osdid            | None                                 |
        | state            | None                                 |
        | function         | journal                              |
        | journal_location | None                                 |
        | journal_size_mib | 0                                    |
        | journal_node     | None                                 |
        | uuid             | e639f1a2-e71a-4f65-8246-5cd0662d966b |
        | ihost_uuid       | 4eb90dc1-2b17-443e-b997-75bdd19e3eeb |
        | idisk_uuid       | ae8b1434-d8fa-42a0-ac3b-110e2e99c68e |
        | created_at       | 2016-06-02T20:12:35.382099+00:00     |
        | updated_at       | None                                 |
        +------------------+--------------------------------------+


#.  Update one or more |OSDs| to use the journal function.

    .. code-block:: none

        ~(keystone_admin)$ system host-stor-update <osd_uuid>
        --journal-location <journal_function_uuid> [--journal-size
        <size_in_gib>]


    For example:

    .. code-block:: none

        ~(keystone_admin)$ system host-stor-update --journal-location dc4c9a99-a525-4c7e-baf2-22e8fad3f274 --journal-size 10 355b35d3-1f96-4423-a106-d27d8051af29
        +------------------+-------------------------------------------------+
        | Property         | Value                                           |
        +------------------+-------------------------------------------------+
        | osdid            | 1                                               |
        | function         | osd                                             |
        | state            | configuring-on-unlock                           |
        | journal_location | dc4c9a99-a525-4c7e-baf2-22e8fad3f274            |
        | journal_size_gib | 10240                                           |
        | journal_path     | /dev/disk/by-path/pci-0000:84:00.0-nvme-1-part1 |
        | journal_node     | /dev/nvme1n1p1                                  |
        | uuid             | 355b35d3-1f96-4423-a106-d27d8051af29            |
        | ihost_uuid       | 61d70ac5-bf10-4533-b65e-53efb8c20973            |
        | idisk_uuid       | b28abe19-fc43-4098-8054-e8bfa2136868            |
        | tier_uuid        | 100d7cf9-51d8-4c15-b7b1-83c082d506a0            |
        | tier_name        | storage                                         |
        | created_at       | 2019-11-12T16:14:01.176137+00:00                |
        | updated_at       | 2019-11-12T19:51:16.034338+00:00                |
        +------------------+-------------------------------------------------+


.. rubric:: |postreq|

Unlock the host to make the changes take effect. Wait for the host to be
reported as unlocked, online, and available in the hosts list.

