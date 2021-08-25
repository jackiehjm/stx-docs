
.. eww1579717175946
.. _reinstalling-a-host-using-horizon:

==============================
Reinstall a Host Using Horizon
==============================

Reinstalling forces a full re-installation of the |prod| software on a
locked host.

The host's hard drive is erased, and the installation process is started
afresh.

.. note::
   On a |prod| Simplex system, this function is not available.

.. rubric:: |prereq|

Performing a host reinstall successfully is dependent on your BIOS boot
order. Observe the following tips:

.. _reinstalling-a-host-using-horizon-ul-mtt-vzq-ds:

-   Prior to installation, configure the BIOS to allow booting from disk
    and the network.

-   During the host re-installation, |org| recommends that you have a console
    serial cable attached to the host to observe the boot progress.

-   The BIOS boot order should be:

    #.  The boot partition.

        Typically, this is the disk associated with /dev/sda and is as
        defined in /proc/cmdline when the load is booted.

    #.  The |NIC| on the boot interface \(such as management or |PXE| network\).

-   Set the BIOS boot options to ensure a failsafe boot, if available. For
    example, rotating through available boot interfaces, watchdog timer on
    boot, retry boot interfaces, and so forth.

If the BIOS boot still fails to progress, you may need to force a boot using
the network interfaces through the BIOS boot option.

.. rubric:: |proc|

#.  From **Admin** \> **Platform** \> **Host Inventory**, select the
    **Hosts** tab.

#.  Lock the host as described in
    :ref:`Lock a Host Using Horizon <locking-a-host-using-horizon>`.

#.  From the **Edit** menu for the host, select **Reinstall Host**.

    .. figure:: /node_management/kubernetes/figures/mwl1579716430090.png
        :scale: 100%
