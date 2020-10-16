
.. hsw1552337724849
.. _configuring-vlan-interfaces-using-horizon:

=======================================
Configure VLAN Interfaces Using Horizon
=======================================

You can attach an interface to multiple networks using |VLAN| tagging.

If the cluster is configured with |VLAN|-tagged networks, you can share an
Ethernet interface by attaching it to one or more |VLAN|-tagged networks. You
can do this using the Horizon Web interface or the CLI.

.. note::
    When attaching a |prod-os| application to a data network using
    a |VLAN| interface, you cannot select a |VLAN| data network \(stacked VLANs
    are not supported\).

.. xbooklinkFor more information about shared interfaces,
   see |planning-doc|: `Shared (VLAN) Ethernet Interfaces <shared-vlan-or-multi-netted-ethernet-interfaces>`.

.. rubric:: |proc|

#.  Open the **Host Detail** page for the host.

    #.  Open the Host Inventory page, available from **Admin** \>
        **Platform** \> **Host Inventory** in the left-hand pane.

    #.  Select the **Hosts** tab, and then in the **Host Name** column,
        click the name of the host.

#.  Select the **Interfaces** tab.

    .. figure:: ../figures/zbl1538147657952.png
        :scale: 100%

#.  Click **Create Interface**.

    .. figure:: ../figures/bpw1538149046903.png
        :scale: 100%

#.  Select the type of network for the interface.

#.  Open the **Interface Type** drop-down menu, and select **vlan**.

#.  In the **Vlan ID** field, type a unique |VLAN| identifier for the network.

#.  From the **Interfaces\(s\)** list, select the Ethernet interfaces used to
    attach this interface to the network.

#.  Complete any other settings required for the **Interface Class**.

    .. note::
        For a |prod-os| application data interface attached to a
        data network, the |MTU| must be equal to or larger than the |MTU| of
        the provider data network to which the interface is attached.

    .. caution::
        To avoid potential internal inconsistencies, do not use upper case
        characters when creating interface names. Some components normalize
        all interface names to lower case.

#.  To save your changes and close the dialog box, click **Create Interface**.

.. rubric:: |result|

The interface is created and attached to the network.
