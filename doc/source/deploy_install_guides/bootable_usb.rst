
.. _bootable_usb:

===================
Create Bootable USB
===================

Follow the instructions for your system to create a bootable USB with the
StarlingX ISO:

* :ref:`bootable-usb-linux`
* :ref:`bootable-usb-mac`
* :ref:`bootable-usb-windows`


.. _bootable-usb-linux:

--------------------------------------
Create a bootable USB drive on Linux\*
--------------------------------------

#. Open a terminal and get root privilege:

   ::

      sudo -s

#. Get the StarlingX ISO from the
   `CENGN StarlingX mirror <http://mirror.starlingx.cengn.ca/mirror/starlingx/>`_.
   Alternately, you can use an ISO from a private StarlingX build.

#. Navigate to the directory with the `StarlingX ISO <http://mirror.starlingx.cengn.ca/mirror/starlingx/release/latest_release/centos/flock/outputs/iso/>`_.

#. Plug in the USB drive and get its identifier:

   ::

      lsblk

   This will list available disks and their partitions.

#. Unmount the USB drive before burning an image onto it. (Note that
   some Linux distros automatically mount a USB drive when it is plugged in.)
   For example:

   ::

      umount /dev/sdd2

#. Burn the StarlingX bootimage.iso onto the USB drive:

   ::

      dd if=</path/to/bootimage.iso> of=<your USB device> bs=1M status=progress

.. caution::

   Not fully unmounting the USB drive before burning an image can cause
   file system checksum errors. If this happens, burn the image again,
   ensuring all the USB drive partitions are unmounted first.


.. _bootable-usb-mac:

--------------------------------------
Create a bootable USB drive on macOS\*
--------------------------------------

#. Launch the Terminal app.

#. Get the StarlingX ISO from the
   `CENGN StarlingX mirror <http://mirror.starlingx.cengn.ca/mirror/starlingx/>`_. Alternately, you can use an ISO from a private StarlingX build.

#. Navigate to the directory with the ISO.

#. Plug in a USB drive and get its identifier:

   ::

      diskutil list

   This will list available disks and their partitions.

#. Unmount the USB drive identified in the previous step. For example:

   ::

      diskutil umountDisk /dev/disk2

#. Burn the StarlingX bootimage.iso onto the USB drive.
   The example below burns an ISO onto `<your USB device>`:

   .. code-block:: bash

      sudo dd if=</path/to/bootimage.iso> of=<your USB device> bs=1m

   To speed up the imaging process, add an ‘r’ in front of the disk identifier.
   For example `/dev/rdisk2`.

   Press ``<CTL>-T`` to check imaging progress.

#. Eject the USB drive.

   .. code-block:: bash

      diskutil eject /dev/disk2

.. _bootable-usb-windows:

----------------------------------------
Create a bootable USB drive on Windows\*
----------------------------------------

#. Get the StarlingX ISO from the
   `CENGN StarlingX mirror <http://mirror.starlingx.cengn.ca/mirror/starlingx/>`_. Alternately, you can use an ISO from a private StarlingX build.

#. Download the `Rufus`_ utility to burn the image onto a USB drive.
   **Only use the latest version of Rufus**.

#. Plug in the USB drive and open Rufus.

#. Under `Boot selection`, click the :guilabel:`SELECT` button.

#. Find and select the StarlingX ISO.

#. Click the :guilabel:`START` button.

#. When the dialogue appears, select
   :guilabel:`Write in ISO image mode (Recommended)`.

#. Select the Windows taskbar menu for USB and select eject.

.. _Rufus: https://rufus.ie/

