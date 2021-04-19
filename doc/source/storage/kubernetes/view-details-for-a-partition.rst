
.. ujn1590525049608
.. _view-details-for-a-partition:

============================
View Details for a Partition
============================

You can view details for a partition, use the **system host-disk-partition-show**
command.

.. rubric:: |context|

The syntax of the command is:

.. code-block:: none

    system host-disk-partition-show <host> <partition>

Make the following substitutions:

**<host>**
    The host name or ID

**<partition>**
    The partition device path or UUID.

#.  This example displays details for a particular partition on compute-1.

    .. code-block:: none

        ~(keystone_admin)]$ system host-disk-partition-show compute-1 a4aa3f66-ff3c-49a0-a43f-bc30012f8361
        +-------------+--------------------------------------------------+
        | Property    | Value                                            |
        +-------------+--------------------------------------------------+
        | device_path | /dev/disk/by-path/pci-0000:00:0d.0-ata-2.0-part3 |
        | device_node | /dev/sdb3                                        |
        | type_guid   | ba5eba11-0000-1111-2222-000000000001             |
        | type_name   | LVM Physical Volume                              |
        | start_mib   | 10240                                            |
        | end_mib     | 21505                                            |
        | size_mib    | 10240                                            |
        | uuid        | a4aa3f66-ff3c-49a0-a43f-bc30012f8361             |
        | ihost_uuid  | 3b315241-d54f-499b-8566-a6ed7d2d6b39             |
        | idisk_uuid  | fcd2f59d-c9ee-4423-9f57-e2c55d5b97dc             |
        | ipv_uuid    | c571653b-1d91-4299-adea-1b24f86cb898             |
        | status      | In-Use                                           |
        | created_at  | 2017-09-07T19:53:23.743734+00:00                 |
        | updated_at  | 2017-09-07T20:06:06.914404+00:00                 |
        +-------------+--------------------------------------------------+


