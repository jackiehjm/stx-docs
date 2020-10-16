
.. jow1426949897008
.. _configuring-ethernet-interfaces-using-horizon:

===========================================
Configure Ethernet Interfaces Using Horizon
===========================================

You can attach an Ethernet interface to a network by editing the interface.

When a worker or storage node is added to |prod| and initialized, Ethernet
interfaces are created automatically for each physical port detected. To
support installation using |PXE| booting, one interface is attached
automatically to the internal management network. You must attach additional
interfaces manually before you can unlock the node.

For a network that uses Ethernet interfaces, you can edit an existing
Ethernet interface on the node to attach it, as described in this topic.
You can also do this from the CLI. For more
information, see :ref:`Attach Ethernet Interfaces to Networks Using the CLI
<attaching-ethernet-interfaces-to-networks-using-the-cli>`.

For a network that uses aggregated Ethernet or |VLAN| interfaces, you must
create an interface in order to attach it,
see :ref:`Configure Aggregated Ethernet Interfaces Using Horizon
<configuring-aggregated-ethernet-interfaces-using-horizon>`
or :ref:`Configure VLAN Interfaces Using Horizon
<configuring-vlan-interfaces-using-horizon>`.

For general information about interface provisioning,
see :ref:`Interface Provisioning <interface-provisioning>`.
For more about the available settings for different types of interface,
see :ref:`Interface Settings <interface-settings>`.

.. rubric:: |proc|

.. _configuring-ethernet-interfaces-using-horizon-steps-tzh-52j-vbb:

#.  Open the **Host Detail** page for the host.

    #.  Open the Host Inventory page, available from **Admin** \>
        **Platform** \> **Host Inventory** in the left-hand pane.

    #.  Select the **Hosts** tab, and then in the **Host Name** column,
        click the name of the host.

#.  Select the **Interfaces** tab.

    .. figure:: ../figures/zbl1538147657952.png
        :scale: 100%

#.  Click **Edit Interface** for the interface you want to attach to a
    network.

    .. figure:: ../figures/bvb1538146331222.png
        :scale: 100%

    For an Ethernet interface, the **Port** is already selected.

#.  Select the interface class for the interface.

#.  Complete the required information for the type of interface.

    .. note::
        For a |prod-os| OpenStack application data interface attached
        to a data network, the |MTU| must be equal to or larger than the |MTU|
        of the data network to which the interface is attached.

#.  Click **Save** to save your changes and close the dialog box.

.. rubric:: |result|

The interface is attached to the network.
