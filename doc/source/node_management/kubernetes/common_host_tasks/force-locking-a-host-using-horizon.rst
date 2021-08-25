
.. zhb1579712335161
.. _force-locking-a-host-using-horizon:

===============================
Force Lock a Host Using Horizon
===============================

Force locking an unlocked host takes it out of service immediately for
configuration and maintenance purposes.

.. note::
    A force lock operation on a worker host causes an immediate service
    outage on all containers and causes the host to reboot.

.. rubric:: |proc|

#.  Try to lock the host normally using **Lock Host**.

    For more information, see :ref:`Lock a Host Using Horizon
    <locking-a-host-using-horizon>`.

#.  If the **Lock Host** attempt fails for a worker host, manually relocate
    containers running on the host, and then try using **Lock Host** again.

#.  Use a force lock only if the above steps fail to lock the host.

    #.  From **Admin** \> **Platform** \> **Host Inventory**, select the
        **Hosts** tab.

    #.  From the **Edit** menu for the host, select **Force Lock Host**.

        .. figure:: /node_management/kubernetes/figures/xwu1579713699282.png
            :scale: 100%

        The system displays a warning message appropriate to the
        personality of the host.
