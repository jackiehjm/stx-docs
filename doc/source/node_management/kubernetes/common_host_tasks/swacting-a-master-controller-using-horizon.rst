
.. fab1579714529266
.. _swacting-a-master-controller-using-horizon:

===============================
Swact Controllers Using Horizon
===============================

Swacting initiates a switch of the active/standby roles between two
controllers.

Swact is an abbreviated form of the term Switch Active (host). When
selected, this option forces the other controller to become the active one in
the HA cluster. This means that all active system services on this controller
move to standby operation, and that the corresponding services on the other
controller become active.

Complete this procedure when you need to lock the currently active
controller, or undertake any kind of maintenance procedures; for example,
when updating hardware or replacing faulty components.

.. rubric:: |proc|

#.  From **Admin** \> **Platform** \> **Host Inventory**, select the
    **Hosts** tab.

#.  From the **Edit** menu for the standby controller, select **Swact Host**.

    .. figure:: /node_management/kubernetes/figures/wwd1579715313055.png
        :scale: 100%
