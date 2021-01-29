
.. paa1552672791171
.. _changing-the-mtu-of-an-oam-interface-using-horizon:

================================================
Change the MTU of an OAM Interface Using Horizon
================================================

You can change the |MTU| value of an |OAM| interface from the Horizon Web
interface.

If you prefer, you can use the CLI. See :ref:`Change the MTU of an OAM Interface Using the CLI <changing-the-mtu-of-an-oam-interface-using-the-cli>`.

Controller configuration changes require each controller to be
locked. This requires a swact during the procedure.

.. rubric:: |proc|

#.  Lock the standby controller.

    #.  From **Admin** \> **Platform** \> **Host Inventory**, select
        the **Hosts** tab.

    #.  From the **Edit** menu for the standby controller, select **Lock Host**.

        .. figure:: ../figures/rst1442611298701.png
            :scale: 100%

#.  Edit the |OAM| interface to change the |MTU| value.

    #.  Click the name of the standby controller, then select
        the **Interfaces** tab and click **Edit** for the |OAM| interface.

    #.  In the Edit Interface dialog, edit the **MTU** field, and then
        click **Save**.

#.  Unlock the standby controller.

    From the **Edit** menu for the standby controller, select **Unlock Host**.

#.  Swact the hosts.

    From the **Edit** menu for the active controller, select **Swact Host**.

    .. figure:: ../figures/psa1420751608971.png
        :scale: 100%

#.  Lock the new standby controller.

#.  Modify the |MTU| of the |OAM| interface on the new standby controller.

#.  Unlock the standby controller.