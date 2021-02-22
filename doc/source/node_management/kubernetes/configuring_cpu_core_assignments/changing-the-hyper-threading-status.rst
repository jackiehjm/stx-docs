
.. nvr1552677362983
.. _changing-the-hyper-threading-status:

=================================
Change the Hyper-threading Status
=================================

The hyper-threading status is controlled by the BIOS settings of the host.

.. rubric:: |proc|

.. _changing-the-hyper-threading-status-steps-v2v-cv3-dt:

#.  Lock the host to prepare it for configuration changes.

    In the **Hosts** list, click **More** for the host, and then select
    **Lock Host**.

    The host is locked and reported as **Locked**, **Disabled**, and
    **Online**.

#.  Edit the host BIOS settings to enable or disable hyper-threading.

    For more about editing the BIOS, refer to the documentation provided by
    the maker of the host computer.

    .. note::
        Changes to the host's BIOS must be made while it is locked and it
        must not be subsequently unlocked until it comes back online
        \(locked-disabled-online\) and the updated Hyperthreading settings
        are available in the inventory.

    #.  Boot the host in BIOS mode.

    #.  Update the host BIOS settings to enable or disable hyper-threading.

    #.  To apply the changes, allow the host to boot to a locked state with
        the updated hyper-threading settings.

#.  Unlock the host to make it available for use.

    In the **Hosts** list, on the row associated with the node, open the
    drop-down menu and select **Unlock Host**.

    The host is rebooted, and its **Availability State** is reported as
    **In-Test**. After a few minutes, it is reported as **Unlocked**,
    **Enabled**, and **Available**.

#.  Confirm the hyper-threading status in |prod|.

    The hyper-threading status is reported on the **Processor** tab for
    the host. For more information, see :ref:`Processor Tab <processor-tab>`.
