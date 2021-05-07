
.. jow1440534908675
.. _configuring-a-pxe-boot-server:

===========================
Configure a PXE Boot Server
===========================

You can optionally set up a |PXE| Boot Server to support **controller-0**
initialization.

.. rubric:: |context|

|prod| includes a setup script to simplify configuring a |PXE| boot server. If
you prefer, you can manually apply a custom configuration; for more
information, see :ref:`Access PXE Boot Server Files for a Custom Configuration
<accessing-pxe-boot-server-files-for-a-custom-configuration>`.

The |prod| setup script accepts a path to the root TFTP directory as a
parameter, and copies all required files for BIOS and |UEFI| clients into this
directory.

The |PXE| boot server serves a boot loader file to the requesting client from a
specified path on the server. The path depends on whether the client uses BIOS
or |UEFI|. The appropriate path is selected by conditional logic in the |DHCP|
configuration file.

The boot loader runs on the client, and reads boot parameters, including the
location of the kernel and initial ramdisk image files, from a boot file
contained on the server. To find the boot file, the boot loader searches a
known directory on the server. This search directory can contain more than one
entry, supporting the use of separate boot files for different clients.

The file names and locations depend on the BIOS or |UEFI| implementation.

.. _configuring-a-pxe-boot-server-table-mgq-xlh-2cb:

.. table:: Table 1. |PXE| boot server file locations for BIOS and |UEFI| implementations
    :widths: auto

    +------------------------------------------+------------------------+-------------------------------+
    | Resource                                 | BIOS                   | UEFI                          |
    +==========================================+========================+===============================+
    | **boot loader**                          | ./pxelinux.0           | ./EFI/grubx64.efi             |
    +------------------------------------------+------------------------+-------------------------------+
    | **boot file search directory**           | ./pxelinux.cfg         | ./ or ./EFI                   |
    |                                          |                        |                               |
    |                                          |                        | \(system-dependent\)          |
    +------------------------------------------+------------------------+-------------------------------+
    | **boot file** and path                   | ./pxelinux.cfg/default | ./grub.cfg and ./EFI/grub.cfg |
    +------------------------------------------+------------------------+-------------------------------+
    | \(./ indicates the root TFTP directory\)                                                          |
    +------------------------------------------+------------------------+-------------------------------+

.. rubric:: |prereq|

Use a Linux workstation as the |PXE| Boot server.


.. _configuring-a-pxe-boot-server-ul-mrz-jlj-dt:

-   On the workstation, install the packages required to support |DHCP|, TFTP,
    and Apache.

-   Configure |DHCP|, TFTP, and Apache according to your system requirements.
    For details, refer to the documentation included with the packages.

-   Additionally, configure |DHCP| to support both BIOS and |UEFI| client
    architectures. For example:

    .. code-block:: none

        option arch code 93 unsigned integer 16;  #  ref RFC4578
        # ...
        subnet 192.168.1.0 netmask 255.255.255.0 {
          if option arch = 00:07 {
            filename "EFI/grubx64.efi";
            # NOTE: substitute the full tftp-boot-dir specified in the setup script
          }
          else {
            filename "pxelinux.0";
          }
        # ...
        }


-   Start the |DHCP|, TFTP, and Apache services.

-   Connect the |PXE| boot server to the |prod| management or |PXE| boot
    network.


.. rubric:: |proc|


.. _configuring-a-pxe-boot-server-steps-qfb-kyh-2cb:

#.  Copy the ISO image from the source \(product DVD, USB device, or WindShare
    `http://windshare.windriver.com <http://windshare.windriver.com>`__\) to a
    temporary location on the PXE boot server.

    This example assumes that the copied image file is tmp/TS-host-installer-1.0.iso.

#.  Mount the ISO image and make it executable.

    .. code-block:: none

        $ mount -o loop /tmp/TS-host-installer-1.0.iso /media/iso
        $ mount -o remount,exec,dev /media/iso

#.  Set up the |PXE| boot configuration.

    The ISO image includes a setup script, which you can run to complete the
    configuration.

    .. code-block:: none

        $ /media/iso/pxeboot_setup.sh -u http://<ip-addr>/<symlink> \
        -t <tftp-boot-dir>

    where

    ``ip-addr``
        is the Apache listening address.

    ``symlink``
        is the name of a user-created symbolic link under the Apache document
        root directory, pointing to the directory specified by <tftp-boot-dir>.

    ``tftp-boot-dir``
        is the path from which the boot loader is served \(the TFTP root
        directory\).

    The script creates the directory specified by <tftp-boot-dir>.

    For example:

    .. code-block:: none

        $ /media/iso/pxeboot_setup.sh -u http://192.168.100.100/BIOS-client -t /export/pxeboot

#.  To serve a specific boot file to a specific controller, assign a special
    name to the file.

    The boot loader searches for a file name that uses a string based on the
    client interface |MAC| address. The string uses lower case, substitutes
    dashes for colons, and includes the prefix "01-".


    -   For a BIOS client, use the |MAC| address string as the file name:

        .. code-block:: none

            $ cd <tftp-boot-dir>/pxelinux.cfg/
            $ cp pxeboot.cfg <mac-address-string>

        where:

        ``<tftp-boot-dir>``
            is the path from which the boot loader is served.

        ``<mac-address-string>``
            is a lower-case string formed from the |MAC| address of the client
            |PXE| boot interface, using dashes instead of colons, and prefixed
            by "01-".

            For example, to represent the |MAC| address ``08:00:27:dl:63:c9``,
            use the string ``01-08-00-27-d1-63-c9`` in the file name.

        For example:

        .. code-block:: none

            $ cd /export/pxeboot/pxelinux.cfg/
            $ cp pxeboot.cfg 01-08-00-27-d1-63-c9

        If the boot loader does not find a file named using this convention, it
        looks for a file with the name default.

    -   For a |UEFI| client, use the |MAC| address string prefixed by
        "grub.cfg-". To ensure the file is found, copy it to both search
        directories used by the |UEFI| convention.

        .. code-block:: none

            $ cd <tftp-boot-dir>
            $ cp grub.cfg grub.cfg-<mac-address-string>
            $ cp grub.cfg ./EFI/grub.cfg-<mac-address-string>

        For example:

        .. code-block:: none

            $ cd /export/pxeboot
            $ cp grub.cfg grub.cfg-01-08-00-27-d1-63-c9
            $ cp grub.cfg ./EFI/grub.cfg-01-08-00-27-d1-63-c9

        .. note::
            Alternatively, you can use symlinks in the search directories to
            ensure the file is found.
