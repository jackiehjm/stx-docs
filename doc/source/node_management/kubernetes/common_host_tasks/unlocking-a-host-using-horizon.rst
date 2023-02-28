
.. amf1579715633550
.. _unlocking-a-host-using-horizon:

===========================
Unlock a Host Using Horizon
===========================

Unlocking a host brings a locked host into service.

.. rubric:: |context|

Unlocking first resets the target host to ensure that it starts from a
well-known state. The host is then automatically configured, and any required
software patches are applied.

The state transition only succeeds if all the necessary configuration
components for the host are already in place.

During the unlock operation, the host is rebooted. If the boot process fails,
a second reboot is attempted. For some types of boot failure, the number of
successive reboot attempts is limited; for more information,
see :ref:`reboot-limits-for-host-unlock-d9a26854590a`.

.. note::
    On a |prod| Simplex system, any containers (hosted applications) that
    were stopped by the preceding **Lock Host** operation are started
    automatically.

.. rubric:: |proc|

#.  From **Admin** \> **Platform** \> **Host Inventory**, select the
    **Hosts** tab.

#.  From the **Edit** menu for the host, select **Unlock Host**.

    .. figure:: /node_management/kubernetes/figures/mwl1579716430090.png
        :scale: 100%
