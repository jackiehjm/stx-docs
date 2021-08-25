
.. jow1426951671346
.. _configuring-aggregated-ethernet-interfaces-using-horizon:

======================================================
Configure Aggregated Ethernet Interfaces Using Horizon
======================================================

You can increase throughput by adding interfaces to
a |LAG| on a host using the Horizon
web interface.

|prod| supports up to four ports in a |LAG|.

For general information about interface provisioning, see :ref:`Interface
Provisioning <interface-provisioning>`. For more about the available settings
for different types of interface, see :ref:`Interface Settings
<interface-settings>`.

.. rubric:: |proc|

#.  Open the **Host Detail** page for the host.

    #.  Open the Host Inventory page, available from **Admin** \>
        **Platform** \> **Host Inventory** in the left-hand pane.

    #.  Select the **Hosts** tab, and then in the **Host Name** column,
        click the name of the host.

#.  Select the **Interfaces** tab.

    .. figure:: /node_management/kubernetes/figures/zbl1538147657952.png
        :scale: 100%

#.  Click **Create Interface**.

    .. figure:: /node_management/kubernetes/figures/bpw1538149046903.png
        :scale: 100%

#.  Select the class of the interface, from the **Interface Class** drop-down
    menu.

#.  If required, open the **Interface Type** drop-down menu, and select
    **aggregated ethernet**.

#.  Set the **Aggregated Ethernet - Mode**.

#.  From the **Interfaces** list, select the Ethernet interfaces used to
    attach this interface to the network.

#.  Complete any other settings required for the Interface Class.

    .. note::
        For a |prod-os| application data interface attached to a
        data network, the |MTU| must be
        equal to or larger than the |MTU|
        of the data network to which the interface is attached.

    .. caution::
        To avoid potential internal inconsistencies, do not use upper case
        characters when creating interface names. Some components normalize
        all interface names to lower case.

#.  To save your changes and close the dialog box, click **Create Interface**.

.. rubric:: |result|

The interface is created and attached to the network.

.. only:: partner

   .. include:: /_includes/configuring-aggregated-ethernet-interfaces-using-horizon.rest
