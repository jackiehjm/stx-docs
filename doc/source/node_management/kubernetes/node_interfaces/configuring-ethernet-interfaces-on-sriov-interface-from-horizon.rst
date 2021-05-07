
.. bmi1612787317125
.. _configuring-ethernet-interfaces-on-sriov-interface-from-horizon:

===============================================================
Configure Ethernet Interfaces on SR-IOV Interface Using Horizon
===============================================================

You can use the Horizon web interface to configure Ethernet interfaces on
|SRIOV|.

.. rubric:: |prereq|

You must create an |SRIOV| interface before you can provision an Ethernet
interface. For more information, see :ref:`Provisioning SR-IOV Interfaces using
the CLI <provisioning-sr-iov-interfaces-using-the-cli>`.

.. rubric:: |proc|

#.  Open the **Host Inventory** page, available from **Admin** \> **Platform**
    \> **Host Inventory** in the left-hand panel, under **Actions** click on the
    down arrow button on "Edit Host" and select "Lock Host".

    .. image:: ../figures/rst1442611298701.png
       :width: 550

#.  Open the Host Detail page for the host.


    #.  Open the Host Inventory page, available from **Admin** \> **Platform**
        \> **Host Inventory** in the left-hand pane.

    #.  Select the Hosts tab, and then in the **Host Name** column, click the
        name of the host.


#.  Select the **Interfaces** tab.

    .. image:: ../figures/vpw1612788524636.png

#.  Open the **Host Inventory** page, available from **Admin** \> **Platform**
    \> **Host Inventory** in the left-hand panel, under **Actions** click on the
    down arrow button on "Edit Host" and select "Unlock Host".

#.  Click **Create Interface**.

#.  Open the **Interface Class** drop-down menu and select **platform**.

#.  Open the **Interface Type** drop-down menu and select **ethernet**.

#.  Select the |SRIOV| Ethernet interface used to attach this interface to the
    network from the Interfaces\(s\) list.

#.  From the Platform Network\(s\) list, select **pxeboot** to which this interface
    is attached.

#.  Click **Create Interface** to save your changes and close the dialog box.

    .. image:: ../figures/qes1612788640104.png
