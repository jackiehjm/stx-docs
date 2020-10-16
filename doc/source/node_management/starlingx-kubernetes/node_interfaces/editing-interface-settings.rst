
.. rls1552338670403
.. _editing-interface-settings:

=======================
Edit Interface Settings
=======================

You can change the settings for a host interface.

.. rubric:: |context|

The ability to change the interface settings is especially useful for
updating the management interface. When a worker node is first created, its
internal management interface is automatically set up using the default
**Interface Type** \(**ethernet**\). If you are using |LAG| on the internal
management network, you must update this manually to **aggregated ethernet**.

.. rubric:: |proc|

#.  Lock the host to make changes.

    #.  In the left-hand pane, select **Admin** \> **Platform** \>
        **Host Inventory**.

    #.  Select the **Hosts** tab.

    #.  Open the drop-down list for the host, and then select **Lock Host**.

    #.  Wait for the host to be reported as **Locked**.

#.  Open the **Host Detail** page for the locked host.

    In the **Host Name** column, click the name of the host.

#.  Select the **Interfaces** tab to display the existing interfaces.

    .. figure:: ../figures/zbl1538147657952.png
        :scale: 100%

#.  Click **Edit Interface** for the interface you want to change.

    .. figure:: ../figures/bvb1538146331222.png
        :scale: 100%

#.  Make the required changes and then click **Save**.

#.  Unlock the host.
