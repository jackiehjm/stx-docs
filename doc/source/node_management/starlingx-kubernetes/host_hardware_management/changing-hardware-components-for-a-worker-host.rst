
.. hti1552676663098
.. _changing-hardware-components-for-a-worker-host:

============================================
Change Hardware Components for a Worker Host
============================================

You can replace worker hosts or their hardware components, adjust worker
host resources, or remove a worker host from the pool of available
resources.

.. note::
    On |prod| Simplex or Duplex systems, worker storage is provided using
    resources on the combined host.

.. xbooklink    For more information,  see |stor-doc|: `Storage on Controller Hosts <controller-hosts-storage-on-controller-hosts>`.

Depending on the type of operation, you may need to delete the host from
the Host Inventory. For more information, see
:ref:`Configuration Changes Requiring Re-installation
<configuration-changes-requiring-re-installation>`. If you are performing an
operation that requires the host to be deleted and re-added, record the current
partitioning and **nova-local** volume group assignments for the secondary
disks so that you can reproduce them later.

If the host is active, you must migrate any instances on it by locking the
host.

.. note::
    Any dynamic pods on a worker node, including an AIO-SX or AIO-DX host,
    will be evicted when the host is locked.

.. rubric:: |prereq|

.. caution::
    Before locking a host, ensure that sufficient resources are available
    on other hosts to migrate any running instances.

.. rubric:: |proc|

#.  Lock the host to make changes.

    #.  On the **Admin** menu of the Horizon Web interface, in the **System**
        section, select **Inventory**.

    #.  Select the **Hosts** tab.

    #.  In the **Actions** column, open the drop-down list for the host, and
        then select **Lock Host**.

    #.  Wait for the host to be reported as **Locked**.

#.  Power down the host manually and make any required hardware changes.

    |prod| does not provide controls for powering down a host. Use
    the |BMC| or other control unit.

#.  For an operation that affects the Host Inventory record, delete the host
    from the inventory.

    The Host Inventory contains database information associated with an
    existing host, such as the |MAC| address of the management interface |NIC|,
    or the presence of |prod| software on the primary disk. To update this
    information, you must delete the host and then re-add it to the system.

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

    Wait for the host to be reported as **Locked**, **Disabled**, and
    **Online**.

#.  Unlock the host to make it available for use.

    On the **Hosts** tab of the Host Inventory page, open the drop-down
    list for the host, and then select **Unlock Host**.

    The host is rebooted, and its **Availability State** is reported as
    **In-Test**. After a few minutes, it is reported as **Unlocked**,
    **Enabled**, and **Available**.

.. From step Reinstall the host.
.. xbooklink    For host installation instructions, refer to
    `Installation Overview <installation-overview>`.

.. From step Power up the host
.. xbooklink For details,
    see the `Installation Overview <installation-overview>` for your
    configuration.
