.. _pxe-boot-controller-0-d5da025c2524:

=====================
PXE Boot Controller-0
=====================

You can optionally set up a |PXE| Boot Server to support **controller-0**
software installation.

.. contents:: |minitoc|
   :local:
   :depth: 1


.. rubric:: |context|

|prod| includes a setup script to simplify configuring a |PXE| boot server. The
|prod| setup script accepts a path to the root TFTP directory as a parameter,
and copies all required files for BIOS and |UEFI| clients into this directory.

The |PXE| boot server serves a boot loader file to the requesting client from a
specified path on the server. The path depends on whether the client uses BIOS
or |UEFI|. The appropriate path is selected by conditional logic in the |DHCP|
configuration file.

The file names and locations depend on the BIOS or |UEFI| implementation.

.. rubric:: |prereq|

Use a Linux workstation as the |PXE| Boot server.


.. _configuring-a-pxe-boot-server-ul-mrz-jlj-dt-r7:

-   On the workstation, install the packages required to support |DHCP|, TFTP,
    and Apache.

-   Configure |DHCP|, TFTP, and Apache according to your system requirements.
    For details, refer to the documentation included with the packages.

-   Additionally, configure |DHCP| to support both BIOS and |UEFI| client
    architectures. For example:

    .. code-block:: none

        option arch code 93 = unsigned integer 16;  #  ref RFC4578
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


.. begin-pxeboot-grub-setup

There is a single install menu |deb-install-step-change| to choose between a
*Standard*, an *AIO-Controller with the Standard Kernel* installation, and an
*AIO-Controller with the Low-Latency Kernel* installation. .

.. _deb-grub-deltas:

The Debian-based installation requires configuration of the new pxeboot grub
menus; one for servers with Legacy BIOS support and another for servers with
|UEFI| firmware.

.. rubric:: |proc|

Install controller-0 from a PXEboot install feed.

* The 'feed' directory on the remote PXEboot server is a directory containing
  the mounted contents of the Debian ISO.

* The 'feed' can be populated with either a **direct ISO mount**
  or a **copy of the ISO content**.

Direct ISO mount method
=======================

#. Mount the ISO at the feed directory location on the pxeboot server.

#. Copy the ISO to the 'feed' directory location pxeboot server.

   .. note::

      This can be a common location for installing many servers or a
      unique location for a specific server.

#. Mount the ISO as the 'feed' directory.

   .. note:: The mount requires root access. If you don't have root
      access on the PXEboot server then use the **ISO copy** method.

   .. code-block:: none

      $ IMAGENAME=<debian_image>
      $ sudo mount -o loop ${IMAGENAME}.iso ${IMAGENAME}_feed

Copy ISO contents method
========================

#. Create a tarball containing the mounted ISO content.

#. Copy the Debian ISO to a location where the ISO can be mounted.

#. Mount the ISO, tar it up and copy the feed tarball to the PXEboot
   server.

#. Untar the feed tarball at the feed directory location on your
   PXEboot server.

   An example of the above commands:

   .. code-block:: none

      $ IMAGENAME=<debian_image>

      $ sudo mount -o loop ${IMAGENAME}.iso ${IMAGENAME}_feed
      $ tar -czf ${IMAGENAME}_feed.tgz ${IMAGENAME}_feed
      $ scp ${IMAGENAME}_feed.tgz <username>@<pxeboot_server>:<feed directory>

      $ ssh <username>@<pxeboot_server>

      $ cd <feed directory>
      $ tar -xzf ${IMAGENAME}_feed.tgz
      $ rm ${IMAGENAME}_feed.tgz

#. Optionally, link your new feed directory to the name the pxeboot
   server translates the incoming MAC based |DHCP| request to.

   .. code-block:: none

      $ ln -s ${IMAGENAME}_feed feed

   Your 'feed' directory or link should now list similarly to the
   following example:

   .. code-block:: none

      drwxr-xr-x  7 someuser users       4096 Jun 13 10:33          starlingx-20220612220558_feed
      lrwxrwxrwx  1 someuser users         58 Jun 13 10:35  feed -> starlingx-20220612220558_feed

      .. The 'feed' directory structure should be as follows:

      .. .. code-block:: none

      ..    feed
      ..    ├── bzImage-rt                      ... Lowlatency kernel
      ..    ├── bzImage-std                     ... Standard kernel
      ..    ├── initrd                          ... Installer initramfs image
      ..    ├── kickstart
      ..    │   └── kickstart.cfg               ... Unified kickstart
      ..    │
      ..    ├── ostree_repo                     ... OSTree Archive Repo
      ..    │   ├── config
      ..    │   ├── extensions
      ..    │   └── objects
      ..    │
      ..    ├── pxeboot
      ..         └── samples
      ..            ├── efi-pxeboot.cfg.debian  ... controller-0 UEFI install menu sample
      ..            ├── pxeboot.cfg.debian      ... controller-0 BIOS install menu sample
      ..            ├── pxeboot_setup.sh        ... script used to tailor the above samples
      ..            └── README                  ... info file

      .. Note that many files and directories have been omitted for clarity.

#. Set up the PXEboot grub menus.

   The ISO contains a ``pxeboot/sample`` directory with controller-0
   install grub menus.

   * For BIOS: ``feed/pxeboot/samples/pxeboot.cfg.debian``

   * For UEFI: ``feed/pxeboot/samples/efi-pxeboot.cfg.debian``

   You must customize these grub menus for a specific server
   install by modifying the following variable replacement strings
   with path and other information that is specific to your pxeboot
   server.

   ``xxxFEEDxxx``
       The path between http server base and feed directory. For
       example: ``/var/www/html/xxxFEED_xxx/<ISO content>``

   ``xxxPXEBOOTxxx``
       The offset path between /pxeboot and the feed to find
       ``bzImage/initrd``. For example:
       ``/var/pxeboot/xxxPXEBOOTxxx/<ISO content>``

   ``xxxBASE_URLxxx``
       The pxeboot server URL: ``http://###.###.###.###``

   ``xxxINSTDEVxxx``
       The install device name. Default: ``/dev/sda`` Example:
       ``/dev/nvme01``

   ``xxxSYSTEMxxx``
       The system install type index. Default: aio>aio-serial
       (All-in-one Install - Serial; Console)

       menu32               = no default system install type ; requires manual select

       disk                 = Disk Boot

       standard>serial      = Controller Install - Serial Console

       standard>graphical   = Controller Install - Graphical Console

       aio>serial           = All-in-one Install - Serial Console

       aio>graphical        = All-in-one Install - Graphical Console

       aio-lowlat>serial    = All-in-one (lowlatency) Install - Serial Console

       aio-lowlat>graphical = All-in-one (lowlatency) Install - Graphical Console

   The ISO also contains the ``pxeboot/samples/pxeboot_setup.sh`` script that
   can be used to automatically setup both the BIOS and |UEFI| grub files for a
   specific install.

   .. code-block:: none

      ./feed/pxeboot/samples/pxeboot_setup.sh --help

      Usage: ./pxeboot_setup.sh [Arguments Options]

      Arguments:

      -i | --input   <input path>     : Path to pxeboot.cfg.debian and efi-pxeboot.cfg.debian grub template files
      -o | --output  <output path>    : Path to created pxeboot.cfg.debian and efi-pxeboot.cfg.debian grub files
      -p | --pxeboot <pxeboot path>   : Offset path between /pxeboot and bzImage/initrd
      -f | --feed    <feed path>      : Offset path between http server base and mounted iso
      -u | --url     <pxe server url> : The pxeboot server's URL

      Options:

      -h | --help                     : Print this help info
      -b | --backup                   : Create backup of updated grub files as .named files
      -d | --device <install device>  : Install device path ; default: /dev/sda
      -s | --system <system install>  : System install type ; default: 3

      0 = Disk Boot
      1 = Controller Install - Serial Console
      2 = Controller Install - Graphical Console
      3 = All-in-one Install - Serial Console       (default)
      4 = All-in-one Install - Graphical Console
      5 = All-in-one (lowlatency) Install - Serial Console
      6 = All-in-one (lowlatency) Install - Graphical Console

      Example:

      pxeboot_setup.sh -i /path/to/grub/template/dir
                       -o /path/to/target/iso/mount
                       -p pxeboot/offset/to/bzImage_initrd
                       -f pxeboot/offset/to/target_feed
                       -u http://###.###.###.###
                       -d /dev/sde
                       -s 5


