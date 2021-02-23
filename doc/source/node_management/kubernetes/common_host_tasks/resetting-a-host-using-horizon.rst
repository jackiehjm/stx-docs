
.. pdr1579788689781
.. _resetting-a-host-using-horizon:

==========================
Reset a Host Using Horizon
==========================

A host can be reset out-of-band, stopping and restarting the host without
ensuring that all system processes are shut off first.

.. note::
    This function is not available on a |prod| Simplex system.

Use this selection only if **Reboot Host** fails.

.. rubric:: |prereq|

Board management must be configured on the system. For more information,
see :ref:`Provision Board Management Control from Horizon <provisioning-board-management-control-from-horizon>`.

.. rubric:: |proc|

#.  From **Admin** \> **Platform** \> **Host Inventory**, select the
    **Hosts** tab.

#.  From the **Edit** menu for the host, select **Reset Host**.
