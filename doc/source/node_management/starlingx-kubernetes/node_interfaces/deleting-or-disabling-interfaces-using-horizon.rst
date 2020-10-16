
.. qbd1552675675426
.. _deleting-or-disabling-interfaces-using-horizon:

==========================================
Delete or Disable Interfaces using Horizon
==========================================

You can delete an interface using the Horizon Web interface.

.. note::
    You cannot delete an interface of type **Ethernet**. You can only
    designate it as unused by setting its **Interface Class** to **none**.

.. rubric:: |proc|

.. _deleting-or-disabling-interfaces-using-horizon-steps-pz5-vjh-lkb:

#.  Navigate to the **Interface** tab of the Host Inventory page.

#.  Do one of the following:

    .. table::
        :widths: auto

        +-------------------------------------------+--------------------------------------------------------------------------------------------+
        | **To delete a non-Ethernet Interface**    | Select **Delete Interface** from the **Actions** menu for the interface.                   |
        |                                           |                                                                                            |
        |                                           | .. figure:: ../figures/wuq1538163902474.png                                                |
        |                                           |    :scale: 60%                                                                             |
        +-------------------------------------------+--------------------------------------------------------------------------------------------+
        | **To disable an Ethernet Interface**      | #.  Select **Edit Interface** from the **Actions** menu for the interface.                 |
        |                                           |                                                                                            |
        |                                           | #.  In the Edit Interface pop-up, set **Interface Class** to None and select **Save**.     |
        |                                           |                                                                                            |
        |                                           | .. figure:: ../figures/juc1579524423575.png                                                |
        +-------------------------------------------+--------------------------------------------------------------------------------------------+
