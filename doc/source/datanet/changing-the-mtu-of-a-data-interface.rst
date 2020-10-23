
.. rst1448489015877
.. _changing-the-mtu-of-a-data-interface:

==================================
Change the MTU of a Data Interface
==================================

You can change the MTU value for a data interface within limits determined by
the data network to which the interface is attached.

.. rubric:: |context|

The data interface MTU must be equal to or greater than the MTU of the data
network.

.. rubric:: |prereq|

You must lock the host for the interface on which you want to change the MTU.

.. rubric:: |proc|

.. _changing-the-mtu-of-a-data-interface-steps-hfm-5nb-p5:

#.  Lock all hosts attached to the data network.

    #.  From **Admin** \> **Platform** \> **Host Inventory**, select the
        **Hosts** tab.

    #.  From the **Edit** menu for the standby controller, select **Lock Host**.

#.  On all the hosts, edit the interface to change the MTU value.

    #.  Click the name of the host, and then select the **Interfaces** tab and
        click **Edit** for the interface you want to change.

    #.  In the Edit Interface dialog, edit the **MTU** field, and then click
        **Save**.

#.  Unlock all the hosts.

    From the **Edit** menu for the host, select **Unlock Host**.

    The network MTU is updated with the new value.