
.. ols1590583073449
.. _delete-a-partition:

==================
Delete a Partition
==================

You can use the :command:`system host-disk-partition-delete` command to
delete a partition.

.. rubric:: |context|

You can delete only the last partition on a disk. You cannot delete a
partition that is in use by a physical volume.

The syntax for the command is:

.. code-block:: none

    system host-disk-partition-delete <host> <partition>

where:

**<host>**
    is the host name or ID.

**<partition>**
    is the partition device path or |UUID|.

For example, to delete a partition with the |UUID|
9f93c549-e26c-4d4c-af71-fb84e3fcae63 from compute-1, do the following.

.. code-block:: none

    ~(keystone_admin)$ system host-disk-partition-delete compute-1 9f93c549-e26c-4d4c-af71-fb84e3fcae63


To view the progress of the deletion, use the :command:`system
host-disk-partition-list` command. The progress is shown in the status
column.