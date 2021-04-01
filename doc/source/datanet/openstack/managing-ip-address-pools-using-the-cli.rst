
.. jow1445966287915
.. _managing-ip-address-pools-using-the-cli:

=====================================
Manage IP Address Pools Using the CLI
=====================================

You can create and manage address pools using the |CLI|:

.. contents::
   :local:
   :depth: 1

.. rubric:: |context|

For more information about address pools, see :ref:`Using IP Address Pools for
Data Interfaces <using-ip-address-pools-for-data-interfaces>`.

.. rubric:: |prereq|

To make interface changes, you must lock the compute node first.

.. _managing-ip-address-pools-using-the-cli-section-N1003C-N1001F-N10001:

----------------------
Create an Address pool
----------------------

To create an address pool, use a command of the following form:

.. code-block:: none

    ~(keystone_admin)]$ system addrpool-add <name> <network> <prefix> [-- order <assign_order>] [--ranges <addr_ranges>]

where:

**<name>**
    is a name used to select the pool during data interface setup

**<network>**
    is the subnet and mask for the range \(for example, **192.168.1.0**\)

**<prefix>**
    is the subnet mask, expressed in network prefix length notation \(for
    example, **24**\)

**<assign\_order>**
    is the order in which to assign addresses from the pool \(random or
    sequential\). The default is random.

**<addr\_ranges>**
    is a set of IP address ranges to use for assignment, where the start
    and end IP address of each range is separated by a dash, and the ranges
    are separated by commas \(for example, **192.168.1.10-192.168.1.20,
    192.168.1.35-192.168.1.45**\). If no range is specified, the full range is
    used.

.. _managing-ip-address-pools-using-the-cli-section-N10109-N1001F-N10001:

------------------
List address pools
------------------

To list existing address pools, use a command of the following form:

.. code-block:: none

    ~(keystone_admin)]$ system addrpool-show <uuid>

where **<uuid>** is the universally unique identifier for the pool.

.. _managing-ip-address-pools-using-the-cli-section-N10131-N1001F-N10001:

----------------------
Modify an address pool
----------------------

To modify an address pool, use a command of the following form:

.. code-block:: none

    ~(keystone_admin)]$ system addrpool-modify <uuid> [--name <name>] [-- order <assign_order>] [--ranges <addr_ranges>]

.. _managing-ip-address-pools-using-the-cli-section-N1015F-N1001F-N10001:

----------------------
Delete an address pool
----------------------

To delete an address pool, use a command of the following form:

.. code-block:: none

    ~(keystone_admin)]$ system addrpool-delete <uuid>

.. rubric:: |postreq|

To use address pools with data interfaces, see :ref:`Using IP Address Pools
for Data Interfaces <using-ip-address-pools-for-data-interfaces>`.

.. seealso::
    For more information about address pools, see :ref:`Using IP Address Pools
    for Data Interfaces <using-ip-address-pools-for-data-interfaces>`.