
.. yhg1552677278157
.. _changing-a-worker-host-performance-profile:

========================================
Change a Worker Host Performance Profile
========================================

Changing the performance profile assigned to a worker host is useful for
adjusting low-latency resources on a |prod| system.

.. rubric:: |proc|

.. _changing-a-worker-host-performance-profile-steps-svz-glx-1z:

#.  Lock the host.

    Open the **Hosts** tab on the Host Inventory page, available from
    **Admin** \> **Platform** \> **Host Inventory** in the left-hand pane.

    Select **Lock Host** from the **Edit Host** drop-down menu in the Actions
    column.

    Wait until the host is reported as locked.

#.  Delete the host from the inventory.

    .. note::
        Ensure that the host is **Online** so that its disk is erased when
        it is deleted from the inventory. This ensures that the host boots
        from the network when it is powered up for re-installation. If the
        host is not online when it is deleted from the inventory, you may
        need to force a network boot during re-installation.

    Select **Delete Host** from the **Edit Host** drop-down menu in the
    Actions column.

#.  Reinstall the host and select the desired performance profile.

#.  Assign a node label to the host to enable host selection during
    Application scheduling.

.. From step 3
..  .. xbooklink    For host installation instructions, refer to
    `Installation Overview <installation-overview>`.