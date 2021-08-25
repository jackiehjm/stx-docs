
.. jow1443038432894
.. _adding-a-static-ip-address-to-a-data-interface:

===========================================
Add a Static IP Address to a Data Interface
===========================================

You can add static IP addresses to a data interface using the web
administration interface or the CLI.

.. rubric:: |context|

For VXLAN connectivity between VMs, you must add appropriate endpoint IP
addresses to the compute node interfaces. You can add individual static
addresses, or you can assign addresses from a pool associated with the
data interface. For more about using address pools, see :ref:`Using IP
Address Pools for Data Interfaces <using-ip-address-pools-for-data-interfaces>`.

To add a static IP address using the |os-prod-hor|, refer to the
following steps. To use the CLI, see :ref:`Managing Data Interface Static IP
Addresses Using the CLI <managing-data-interface-static-ip-addresses-using-the-cli>`.

.. rubric:: |prereq|

To make interface changes, you must lock the compute host first.

.. rubric:: |proc|

.. _adding-a-static-ip-address-to-a-data-interface-steps-zkx-d1h-hr:

#.  Lock the compute host.

#.  Set the interface to support an IPv4 or IPv6 address, or both.

    #.  Select **Admin** \> **Platform** \> **Host Inventory** to open the Host
        Inventory page.

    #.  Select the **Host** tab, and then double-click the compute host to open
        the Host Detail page.

    #.  Select the **Interfaces** tab and click **Edit Interface** for the data
        interface you want to edit.

    #.  In the Edit Interface dialog box, set the **IPv4 Addressing Mode** or
        the **IPv6 Addressing Mode** to **Static**.

        .. image:: /shared/figures/datanet/bju1538154656153.png

#.  Add an IPv4 or IPv6 address to the interface.

    #.  On the Host Detail page, click the **Name** of the interface to open
        the Interface Detail page.

        .. image:: /shared/figures/datanet/jow1443041105867.png

    #.  Click **Create Address** to open the Create Address dialog box.

        .. image:: /shared/figures/datanet/jow1442607685238.png

    #.  Enter the IPv4 or IPv6 address and netmask \(for example,
        192.168.1.3/24\), and then click **Create Address**.

    The new address is added to the **Address List**.

#.  Unlock the compute node and wait for it to become available.

For more information, see :ref:`Managing Data Interface Static IP Addresses
Using the CLI <managing-data-interface-static-ip-addresses-using-the-cli>`