
.. teh1552676677847
.. _changing-hardware-components-for-a-storage-host:

=============================================
Change Hardware Components for a Storage Host
=============================================

You can add or replace storage disks or swap a storage node while the system
is running, even if the storage resources are in active use.

.. rubric:: |context|

You can add disks to a storage node to increase capacity, and you can replace
a faulty host.

.. note::
    The storage nodes in a |prod| system are grouped to provide redundancy
    for High Availability. |org| recommends a balanced storage capacity in
    which each host has sufficient independent resources to meet the
    operational requirements of the system.

Depending on the type of operation, you may need to delete the host from
the Host Inventory. For more information,
see :ref:`Configuration Changes Requiring Re-installation <configuration-changes-requiring-re-installation>`.
If you are performing an operation that requires the host to be deleted and
re-added, record the current |OSD| and journal disk assignments so that you
can reproduce them later.

.. note::
    Due to a limitation in **udev**, the device path of a disk connected
    through a SAS controller changes when the disk is replaced. You must
    lock, delete, and re-install the node. Once this is done, avoid using
    storage profiles containing information about the replaced disk as
    it is no longer accurate.

.. rubric:: |proc|

#.  Lock the host to make changes.

    #.  In the left-hand pane, select **Admin** \> **Platform** \>
        **Host Inventory**.

    #.  Select the **Hosts** tab.

    #.  Open the drop-down list for the host, and then select **Lock Host**.

    #.  Wait for the host to be reported as **Locked**.

#.  Power down the host and make any required hardware changes.

    |prod| does not provide controls for powering down a host. Use the |BMC|
    or other control unit.

    This can involve replacing or adding disks, or replacing the host
    completely.

#.  For an operation that affects the Host Inventory record, delete the host
    from the inventory.

    The Host Inventory contains database information associated with an
    existing host, such as the |MAC| address of the management interface
    |NIC|, or the presence of |prod| software on the primary disk. To update
    this information, you must delete the host and then re-add it to the
    system.

    .. note::
        Ensure that the host is **Online**, so that its disk is erased when
        it is deleted from the inventory. This ensures that the host boots
        from the network when it is powered up again. If the host is not
        online when it is deleted from the inventory, then you may need to
        force a network boot when it is powered up.

#.  Reinstall the host.

#.  Power up the host.

    If the host has been deleted from the Host Inventory, the host software
    is reinstalled. 

.. From Power up the host
.. xbookref For details, see :ref:`|inst-doc| <platform-installation-overview>`.

    Wait for the host to be reported as **Locked**, **Disabled**, and
    **Online**.

#.  If required, allocate the |OSD| and journal disk storage.

    If you have deleted and re-added the host, you must re-create the storage
    disk allocations.

#.  Unlock the host to make it available for use.

    Open the drop-down list for the host, and then select **Unlock Host**.

    The host is rebooted, and the progress of the unlock operation is
    reported in the **Status** field.

    When the unlock is complete, the host is shown as **Unlocked**,
    **Enabled**, and **Available**.

.. From Reinstall the host step
.. xbooklink    For host installation instructions, refer to `|inst-doc| <installation-overview>`.

.. From Power up the host step
.. xbooklink For details, k see `|inst-doc| <installation-overview>`.

.. From If required, allocate the |OSD| and journal disk storage.
.. xbooklinkFor more information, see |stor-doc|: `Provision Storage on a Storage Host <provisioning-storage-on-a-controller-or-storage-host-using-horizon>`.


