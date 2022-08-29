
.. jow1442253584837
.. _accessing-pxe-boot-server-files-for-a-custom-configuration-r7:

=======================================================
Access PXE Boot Server Files for a Custom Configuration
=======================================================

If you prefer, you can create a custom |PXE| boot configuration using the
installation files provided with |prod|.

.. rubric:: |context|

You can use the setup script included with the ISO image to copy the boot
configuration files and distribution content to a working directory. You can
use the contents of the working directory to construct a |PXE| boot environment
according to your own requirements or preferences.

For more information about using a |PXE| boot server, see :ref:`Configure a
PXE Boot Server <configuring-a-pxe-boot-server-r7>`.

.. rubric:: |proc|

.. _accessing-pxe-boot-server-files-for-a-custom-configuration-steps-www-gcz-3t-r7:

#.  Copy the ISO image from the source \(product DVD, USB device, or
    |dnload-loc|\) to a temporary location on the |PXE| boot server.

    This example assumes that the copied image file is
    tmp/TS-host-installer-1.0.iso.

#.  Mount the ISO image and make it executable.

    .. code-block:: none

        $ mount -o loop /tmp/TS-host-installer-1.0.iso /media/iso
        $ mount -o remount,exec,dev /media/iso

#.  Create and populate a working directory.

    Use a command of the following form:

    .. code-block:: none

        $ /media/iso/pxeboot_setup.sh -u http://<ip-addr>/<symlink> <-w <working directory>>

    where:

    **ip-addr**
        is the Apache listening address.

    **symlink**
        is a name for a symbolic link to be created under the Apache document
        root directory, pointing to the directory specified by <working-dir>.

    **working-dir**
        is the path to the working directory.

#.  Copy the required files from the working directory to your custom |PXE|
    boot server directory.
