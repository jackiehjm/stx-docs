
.. euf1590523814334
.. _identify-space-available-for-partitions:

=======================================
Identify Space Available for Partitions
=======================================

For example, run the following command to show space available on compute-1.

.. code-block:: none

    ~(keystone_admin)$ system host-disk-list compute-1

    +--------------------------------------+------------+...+---------------+...
    | uuid                                 |device_node |   | available_gib |...
    +--------------------------------------+------------+...+---------------+...
    | 6a0cadea-58ae-406f-bedf-b25ba82f0488 | /dev/sda   |...| 32698         |...
    | fcd2f59d-c9ee-4423-9f57-e2c55d5b97dc | /dev/sdb   |...| 9215          |...
    +--------------------------------------+------------+...+---------------+...


