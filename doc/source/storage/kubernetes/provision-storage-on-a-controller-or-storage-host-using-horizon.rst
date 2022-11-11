
.. nxl1552678669664
.. _provision-storage-on-a-controller-or-storage-host-using-horizon:

===============================================================
Provision Storage on a Controller or Storage Host Using Horizon
===============================================================

You must configure the Ceph disks \(OSD disks\) on controllers or
storage hosts to provide container disk storage.

.. rubric:: |context|

For more about OSDs, see :ref:`Storage on Storage Hosts
<storage-hosts-storage-on-storage-hosts>`.

.. rubric:: |prereq|


.. _provision-storage-on-a-controller-or-storage-host-using-horizon-d388e17:

To create or edit an OSD, you must lock the controller or storage host.


.. _provision-storage-on-a-controller-or-storage-host-using-horizon-d388e19:

-   When adding storage to a storage host or controller on a Standard
    system , you must have at least two other unlocked hosts with Ceph
    monitors. \(Ceph monitors typically run on **controller-0**,
    **controller-1**, and **storage-0** only\).

-   When adding storage to AIO-SX and AIO-DX system, a single Ceph monitor
    is required.

    -   An AIO-SX system can be locked independent of the ceph monitor.

    -   An AIO-DX standby controller can be locked independent of ceph
        monitor status since the ceph monitor runs on the active controller in
        this configuration.

.. _provision-storage-on-a-controller-or-storage-host-using-horizon-d388e42:

If you want to use an SSD-backed journal, you must create the journal
first. For more about SSD-backed Ceph journals, see :ref:`Add SSD-Backed
Journals Using Horizon <add-ssd-backed-journals-using-horizon>`.

.. _provision-storage-on-a-controller-or-storage-host-using-horizon-d388e46:

If you want to assign the OSD to a storage tier other than the default, you
must add the storage tier first. For more about storage tiers, see
:ref:`Add a Storage Tier Using the CLI <add-a-storage-tier-using-the-cli>`.

.. rubric:: |proc|

.. _provision-storage-on-a-controller-or-storage-host-using-horizon-d388e50:

#.  Lock the host to prepare it for configuration changes.

    On the **Hosts** tab of the Host Inventory page, open the drop-down
    list for the host, and then select **Lock Host**.

    The host is locked and reported as **Locked**, **Disabled**, and
    **Online**.

#.  Open the Host Detail page for the host.

    To open the Host Detail page, click the name of the host on the
    **Hosts** tab of the System Inventory page.

#.  Select the **Storage** tab to view the disks and storage functions for
    the node.

    .. image:: /shared/figures/storage/qgh1567533283603.png

    .. note::
        User-defined partitions are not supported on storage hosts.

#.  Add an OSD storage device.

    #.  Click **Assign Storage Function** to open the Assign Storage
        Function dialog box.

        .. image:: /shared/figures/storage/bse1464884816923.png

    #.  In the **Disks** field, select the OSD to use for storage.

        You cannot use the rootfs disk \(**dev/sda**\) for storage functions.

    #.  If applicable, specify the size of the Ceph journal.

        If an SSD-backed Ceph journal is available, the **Journal** for the
        OSD is automatically set to use the SSD or NVMe device assigned for
        journals. You can optionally adjust the **Journal Size**. For
        sizing considerations, refer to the guide.

        If no journal function is configured on the host, then the
        **Journal** is set to **Collocated with OSD**, and the **Journal
        Size** is set to a default value. These settings cannot be changed.

    #.  Select a **Storage Tier**.

        If more than one storage tier is available, select the storage tier
        for this OSD.

    The storage function is added.

    .. image:: /shared/figures/storage/caf1464886132887.png

#.  Unlock the host to make it available for use.

    #.  Select **Admin** \> **Platform** \> **Host Inventory**.

    #.  On the **Hosts** tab of the Host Inventory page, open the drop-down
        list for the host, and then select **Unlock Host**.

    The host is rebooted, and the progress of the unlock operation is
    reported in the **Status** field.

    When the unlock is complete, the host is shown as as **Unlocked**,
    **Enabled**, and **Available**.