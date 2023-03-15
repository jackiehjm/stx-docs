
.. lid1552672445221
.. _starlingx-boot-sequence-considerations:

===================================
System Boot Sequence Considerations
===================================

During |prod| software installation, each host must boot from different devices
at different times. In some cases, you may need to adjust the boot order.

The first controller node must be booted initially from a removable storage
device to install an operating system. The host then reboots from the hard
drive.

Each remaining host must be booted initially from the network using |PXE| to
install an operating system. The host then reboots from the hard drive.

To facilitate this process, ensure that the hard drive does not already contain
a bootable operating system, and set the following boot order in the BIOS.

.. _starlingx-boot-sequence-considerations-ol-htt-5qg-fn:

#.  removable storage device (USB flash drive or DVD drive)

#.  hard drive

#.  network (|PXE|), over an interface connected to the internal management
    network

#.  network (|PXE|), over an interface connected to the |PXE| boot network

For BIOS configuration details, refer to the OEM documentation supplied with
the worker node.

.. note::
    If a host contains a bootable hard drive, either erase the drive
    beforehand, or ensure that the host is set to boot from the correct source
    for initial configuration. If necessary, you can change the boot device at
    boot time by pressing a dedicated key. For more information, refer to the
    OEM documentation for the worker node.
