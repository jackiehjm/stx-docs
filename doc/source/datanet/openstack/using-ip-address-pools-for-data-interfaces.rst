
.. jow1445966231060
.. _using-ip-address-pools-for-data-interfaces:

========================================
Use IP Address Pools for Data Interfaces
========================================

You can create pools of IP addresses for use with data interfaces.

.. rubric:: |context|

As an alternative to manually adding static IP addresses to data interfaces for
use with |VXLANs|, you can define pools of IP addresses and associate them with
one or more data interfaces. Each pool consists of one or more contiguous
ranges of IPv4 or IPv6 addresses. When a data interface is associated with a
pool, its IP address is allocated from the pool. The allocation may be either
random or sequential, depending on the settings for the pool.

You can use the |os-prod-hor| or the |CLI| to create and manage
address pools. For information about using the |CLI|, see :ref:`Managing IP
Address Pools Using the CLI <managing-ip-address-pools-using-the-cli>`.

.. rubric:: |prereq|

To make interface changes, you must lock the compute node first.

.. rubric:: |proc|

#.  Lock the compute node.

#.  In the |prod-os| Web administration interface, open the System
    Configuration page.

    The System Configuration page is available from **Admin** \> **Platform**
    \> **System Configuration** in the left-hand pane.

#.  Select the **Address Pools** tab.

    .. image:: /shared/figures/datanet/jow1445971002260.png

    You can use the controls on the Address Pools page to create, update, or
    delete address pools.

#.  To create an address pool, click **Create Address Pool** and complete the
    dialog box.

    .. image:: /shared/figures/datanet/jow1445971475692.png

    **Name**
        A name used for selecting the pool during data interface setup.

    **Network Address**
        The subnet for the range \(for example, **192.168.1.0/24**\).

    **Allocation Order**
        The order for assigning addresses. You can select **Sequential** or
        **Random** from the drop-down list.

    **Address Range**
        One or more ranges, where the start and end IP address of each range
        is separated by a dash, and the ranges are separated by commas \(for
        example, **192.168.1.10-192.168.1.20, 192.168.1.35-192.168.1.45**\).
        If no range is specified, the full range is used.

.. rubric:: |postreq|

You can select an address pool by name when setting up the **IPv4 Addressing
Mode** or **IPv6 Addressing Mode** for a data interface.

See also :ref:`Managing IP Address Pools Using the CLI
<managing-ip-address-pools-using-the-cli>`