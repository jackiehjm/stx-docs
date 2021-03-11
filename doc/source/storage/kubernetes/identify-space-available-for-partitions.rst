
.. euf1590523814334
.. _identify-space-available-for-partitions:

=======================================
Identify Space Available for Partitions
=======================================

Use the :command:`system host-disk-list` command to identify space available for partitions.

For example, run the following command to show space available on compute-1.

.. code-block:: none

    ~(keystone_admin)$ system host-disk-list compute-1
    +--------------------------------------+-------------+------------+-------------+----------+------------------+-----+--------------------+--------------------------------------------+
    | uuid                                 | device_node | device_num | device_type | size_gib | available_gib    | rpm | serial_id          | device_path                                |
    |                                      |             |            |             |          |                  |     |                    |                                            |
    +--------------------------------------+-------------+------------+-------------+----------+------------------+-----+--------------------+--------------------------------------------+
    | 2f71f715-ffc8-40f1-b099-f97b8c00e9cc | /dev/sda    | 2048       | SSD         | 447.     | 357.816          | N/A | PHWA6062001U480FGN | /dev/disk/by-path/pci-0000:00:1f.2-ata-1.0 |
    |                                      |             |            |             | 13       |                  |     |                    |                                            |
    |                                      |             |            |             |          |                  |     |                    |                                            |
    | 5331459b-4eff-4d1a-83ea-555acd198bb6 | /dev/sdb    | 2064       | SSD         | 447.     | 0.0              | N/A | PHWA6282051N480FGN | /dev/disk/by-path/pci-0000:00:1f.2-ata-2.0 |
    |                                      |             |            |             | 13       |                  |     |                    |                                            |
    |                                      |             |            |             |          |                  |     |                    |                                            |
    +--------------------------------------+-------------+------------+-------------+----------+------------------+-----+--------------------+--------------------------------------------+


