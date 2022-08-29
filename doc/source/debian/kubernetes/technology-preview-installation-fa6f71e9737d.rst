.. _technology-preview-installation-fa6f71e9737d:

===============================
Technology Preview Installation
===============================

In general, the installation of |prod| |deb-eval-release| Debian Technology
Preview on All-in-one Simplex is unchanged.


.. only:: partner

   .. include:: /_includes/deb-tech-preview.rest
       :start-after: begin-dec-and-imp
       :end-before: end-dec-and-imp


There are no changes to:

*  The overall installation workflow

   .. only:: partner

      .. include:: /_includes/deb-tech-preview.rest
          :start-after: begin-install-prereqs
          :end-before: end-install-prereqs


*  The installation prerequisites, i.e. required files, boot mechanism
   (bootable USB or pxeboot server), network connectivity, external DNS Server
   and a Docker Registry:

   .. only:: partner

      .. include:: /_includes/deb-tech-preview.rest
          :start-after: begin-install-prereqs
          :end-before: end-install-prereqs

*  The hardware requirements: :ref:`starlingx-hardware-requirements`,  or

*  The preparation of physical servers, i.e. BIOS setup, etc.

The only minor change in the installation is in the initial install of software
on controller-0. |deb-update-iso|

.. only:: partner

   .. include:: /_includes/deb-tech-preview.rest
       :start-after: begin-prep-servers
       :end-before: end-prep-servers

There is a single install menu |deb-install-step-change| to choose between an
AIO-Controller with the Standard Kernel and an AIO-Controller with the
Low-Latency Kernel. Of course the actual console log output of the software
install will be different due to OSTree and Debian details.

.. _deb-grub-deltas:

The Debian installation requires configuration of the new pxeboot grub menus;
one for servers with Legacy BIOS support and another for servers with |UEFI|
firmware.

During |PXE| boot configuration setup, as described in
:ref:`configuring-a-pxe-boot-server-r7`, additional steps are required to
collect configuration information and create a grub menu to install |prod|
|deb-eval-release| AIO controller-0 function on the target server.

#. Wipe the install device prior to Debian installation.

   .. code-block:: none

      $ sudo wipedisk --force --include-backup
      $ sudo sgdisk -o /dev/sda

   Repeat the :command:`sudo sgdisk -o` command for all disks, such as ``dev/sdb``,
   ``/dev/sdc``, and so-on.

#. **Option 1:** Install controller-0 from a USB device containing the
   Debian ISO image.

   Use this method to install locally from a physical or virtual media USB
   device/ISO.

   #. Add the Debian ISO image to a USB device and make the target server
      boot the ISO image from that USB device.

   #. During installation, select the install type from the presented
      menu. For a |UEFI| installation, the menu options are prefixed with
      "UEFI ".

#. **Option 2:** Install controller-0 from a PXEboot install feed.

   This method uses a network PXEboot install from a remote PXEboot server
   and 'feed' directory.

   * The 'feed' directory is a directory containing the mounted contents
     of the Debian ISO.

   * The 'feed' creation process for the Debian install differs from the
     CentOS method.

   * The 'feed' can be populated with either a **direct ISO mount**
     or a **copy of the ISO content**.

   **Direct ISO mount** method:

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

   **Copy ISO contents** method:


   #. Create a tarball containing the mounted ISO content

   #. Copy the Debian ISO to a location where the ISO can be mounted

   #. Mount the ISO, tar it up and copy the feed tarball to the PXEboot
      server


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

      The 'feed' directory structure should be as follows:

      .. code-block:: none

         feed
         ├── bzImage-rt                      ... Lowlatency kernel
         ├── bzImage-std                     ... Standard kernel
         ├── initrd                          ... Installer initramfs image
         ├── kickstart
         │   └── kickstart.cfg               ... Unified kickstart
         │
         ├── ostree_repo                     ... OSTree Archive Repo
         │   ├── config
         │   ├── extensions
         │   └── objects
         │
         ├── pxeboot
              └── samples
                 ├── efi-pxeboot.cfg.debian  ... controller-0 UEFI install menu sample
                 ├── pxeboot.cfg.debian      ... controller-0 BIOS install menu sample
                 ├── pxeboot_setup.sh        ... script used to tailor the above samples
                 └── README                  ... info file

      Note that many files and directories have been omitted for clarity.

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

      The ISO also contains the ``pxeboot/samples/pxeboot_setup.sh``
      script that can be used to automatically setup both the BIOS and
      |UEFI| grub files for a specific install.

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

The remaining install steps are also completely unchanged:

.. only:: partner

   **Imperative mode**

:ref:`aio_simplex_install_kubernetes_r6`

.. only:: partner

   .. include:: /_includes/deb-tech-preview.rest
       :start-after: begin-declarative
       :end-before: end-declarative

