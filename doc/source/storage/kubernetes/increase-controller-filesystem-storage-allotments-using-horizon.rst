
.. ndt1552678803575
.. _increase-controller-filesystem-storage-allotments-using-horizon:

===============================================================
Increase Controller Filesystem Storage Allotments Using Horizon
===============================================================

Using the Horizon Web interface, you can increase the allotments for
controller-based storage.

.. rubric:: |context|

If you prefer, you can use the |CLI|. See :ref:`Increase Controller
Filesystem Storage Allotments Using the CLI
<increase-controller-filesystem-storage-allotments-using-the-cli>`.

The requested changes are checked against available space on the affected
disks; if there is not enough, the changes are disallowed.

To provide more space for the controller filesystem, you can replace the
primary disk.

With the exception of the Ceph monitor space, you can resize logical
volumes of the filesystem without doing a reboot. Resizing the Ceph monitor
requires a reboot.

.. caution::
    Decreasing the filesystem size is not supported.

For more about controller-based storage, see |stor-doc|: :ref:`Storage on
Controller Hosts <controller-hosts-storage-on-controller-hosts>`.

.. rubric:: |prereq|

Before changing storage allotments, prepare as follows:


.. _increase-controller-filesystem-storage-allotments-using-horizon-ul-p3d-2h5-vp:

-   Record the current configuration settings in case they need to be
    restored (for example, because of an unexpected interruption during
    changes to the system configuration). Consult the configuration plan for
    your system.

-   Ensure that the BIOS boot settings for the host are appropriate for a
    reinstall operation.

-   If necessary, install replacement disks in the controllers.

    If you do not need to replace disks, you can skip this step. Be sure to
    include the headroom required on the primary disk.

    To replace disks in the controllers, see |node-doc|: :ref:`Change
    Hardware Components for a Controller Host
    <changing-hardware-components-for-a-controller-host>`.

-   Add and assign enough disk partition space to accommodate the increased
    filesystem size.


.. rubric:: |proc|

#.  Edit the disk storage allotments.


    #.  In the |prod| Horizon interface, open the System Configuration pane.

        The System Configuration pane is available from **Admin** \>
        **Platform** \> **System Configuration** in the left-hand pane.

    #.  Select the **Controller Filesystem** tab.

        The Controller Filesystem page appears, showing the currently
        defined storage allotments.

        .. image:: /shared/figures/storage/ele1569534467005.jpeg


    #.  Click **Edit Filesystem**.

        The Edit Controller Filesystem dialog box appears.

        .. image:: /shared/figures/storage/ngh1569534630524.jpeg


    #.  Replace the storage allotments as required.

    #.  Click **Save**.

        This raises major alarms against the controllers (**250.001
        Configuration out-of-date**). You can view the alarms on the Fault
        Management page. In addition, the status **Config out-of-date** is
        shown for the controllers in the Hosts list.

#.  Confirm that the **250.001 Configuration out-of-date** alarms are
    cleared for both controllers as the configuration is deployed in the
    background.

.. rubric:: |postreq|

After making these changes, ensure that the configuration plan for your
system is updated with the new storage allotments and disk sizes.

