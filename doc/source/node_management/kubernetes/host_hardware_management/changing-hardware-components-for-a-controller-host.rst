
.. boz1552676693053
.. _changing-hardware-components-for-a-controller-host:

================================================
Change Hardware Components for a Controller Host
================================================

You can replace controller hosts or hardware components while the system
is running, in a two controller (|AIO-DX|) system.

.. xbooklink .. note::
    If you are replacing disks in order to increase the controller storage
    capacity, follow the instructions for |stor-doc|: `Increasing Controller Filesystem Storage Allotments Using Horizon <increasing-controller-filesystem-storage-allotments-using-horizon>`.

With the exception of |prod| Simplex, all |prod| systems require two
controllers. You can lock and remove one controller temporarily to replace
or upgrade hardware, including primary or secondary disks.

Depending on the type of operation, you may need to delete the host from the
Host Inventory. For more information, see :ref:`Configuration Changes Requiring
Re-installation <configuration-changes-requiring-re-installation>`.
If you are performing an operation that requires the host to be deleted and
re-added, record the current partitioning and volume group assignments for
all disks so that you can reproduce them later.

.. note::

    All your data should be preserved across this procedure.

.. include:: /_includes/changing-hardware-components-for-a-worker-host.rest

.. rubric:: |proc|

#.  Lock the standby controller.

    #.  On the **Admin** menu of the Horizon Web interface, in the **System**
        section, select **Inventory**.

    #.  Select the **Hosts** tab.

    #.  In the **Actions** column, open the drop-down list for the host, and
        then select **Lock Host**.

    #.  Wait for the host to be reported as **Locked**.

    The standby controller is shown as **Locked**, **Disabled**,
    and **Online**.

#.  Power down the host manually and make any required hardware changes.

    |prod| does not provide controls for powering down a host. Use
    the |BMC| or other control unit.

#.  For an operation that affects the Host Inventory record, delete the host
    from the inventory.

    The Host Inventory contains database information associated with an
    existing host, such as the |MAC| address of the management
    interface |NIC|, or the presence of |prod| software on the primary disk. To
    update this information, you must delete the host using
    :command:`host-delete` and then reconfigure and re-add it to the system.

    You must delete the host and then re-add it to the system if a |NIC| is
    replaced or moved on a host.

    .. note::
        Ensure that the host is **Online** so that its disk is erased when
        it is deleted from the inventory. This ensures that the host boots
        from the network when it is powered up for re-installation. If the
        host is not online when it is deleted from the inventory, you may
        need to force a network boot during re-installation.

    In the **Actions** column, open the drop-down list for the host, and
    select **Delete Host**.

    The standby controller is removed from the **Hosts** list, and the |prod|
    software is removed from its hard drive.

#.  Reinstall the host.

#.  Power up the host.

    If the host has been deleted from the Host Inventory, the host software
    is reinstalled.

    Wait for the host to be reported as **Locked**, **Disabled**, and
    **Online**.

#.  If required, configure the Ceph monitor location.

    Before attempting to unlock the controller, be sure to specify the
    correct disk for the Ceph monitor, if required.

    .. caution::
        You must do this before unlocking the reinstalled controller for the
        first time. Otherwise, the controller reboots continuously on unlock,
        and must be installed again.

    To specify the correct disk, use a command of the following form:

    .. code-block:: none

        ~(keystone_admin)$ system ceph-mon-modify <controller_name> device_node=<diskUUID>

    For example:

    .. code-block:: none

        ~(keystone_admin)$ system ceph-mon-show controller-1
        +--------------+--------------------------------------+
        | Property     |                                Value |
        +--------------+--------------------------------------+
        | uuid         | ce4a1913-ce1f-4fda-90c0-c49f313d0adc |
        | device_path  | None                                 |
        | device_node  | None                                 |
        | ceph_mon_gib | 30                                   |
        | created_at   | 2016-10-15T00:16:56.423442+00:00     |
        | updated_at   | None                                 |
        +--------------+--------------------------------------+
        ~(keystone_admin)$ system ceph-mon-modify controller-1 device_node=cbc483ad-d7cb-47a8-8622-8846d9444f27
        +--------------+--------------------------------------------+
        | Property     | Value                                      |
        +--------------+--------------------------------------------+
        | uuid         | ce4a1913-ce1f-4fda-90c0-c49f313d0adc       |
        | device_path  | /dev/disk/by-path/pci-0000:00:0d.0-ata-3.0 |
        | device_node  | /dev/sdc                                   |
        | ceph_mon_gib | 30                                         |
        | created_at   | 2016-10-15T00:16:56.423442+00:00           |
        | updated_at   | None                                       |
        +--------------+--------------------------------------------+

        System configuration has changed.
        please follow the administrator guide to complete configuring system.
        ~(keystone_admin)$ system ceph-mon-show controller-1

        +--------------+--------------------------------------------+
        | Property     | Value                                      |
        +--------------+--------------------------------------------+
        | uuid         | ce4a1913-ce1f-4fda-90c0-c49f313d0adc       |
        | device_path  | /dev/disk/by-path/pci-0000:00:0d.0-ata-3.0 |
        | device_node  | /dev/sdc                                   |
        | ceph_mon_gib | 30                                         |
        | created_at   | 2016-10-15T00:16:56.423442+00:00           |
        | updated_at   | 2016-10-15T00:35:44.181413+00:00           |
        +--------------+--------------------------------------------+

#.  Unlock the host to make it available for use.

    On the **Hosts** tab of the Host Inventory page, open the drop-down list
    for the host, and then select **Unlock Host**.

    The host is rebooted, and its **Availability State** is reported as
    **In-Test**. After a few minutes, it is reported as **Unlocked**,
    **Enabled**, and **Available**.

#.  If the same hardware change is required on both controllers, make the
    change to the other controller.

    #.  Open the drop-down menu for the active controller and then select
        **Swact Host**.

        Up to 20 minutes can be required to complete the swact.

        .. note::
            During the swact, access to Horizon is temporarily interrupted,
            and the login screen is displayed. Wait for a few minutes, and
            then log in. The new active controller is shown as Degraded,
            and then changed to **Available**.

        The **Controller-Active** and **Controller-Standby** personalities
        are updated in the Hosts List.

    #.  Return to Step 1 and repeat the procedure for the new standby
        controller.

.. rubric:: |result|

The updated controllers are now in service.

.. From Reinstall the host step
.. xbooklink     For host installation instructions, refer to `|inst-doc| <installation-overview>`: `Installing Software on controller-0 <installing-software-on-controller-0>`.

.. From Power up the host step
.. xbooklink For details, see `|inst-doc| <installation-overview>`: `Installing Software on controller-0 <installing-software-on-controller-0>`.
