.. _subcloud-deployment-with-local-installation-4982449058d5:

===========================================
Subcloud Deployment with Local Installation
===========================================

.. rubric:: |context|

Subcloud install is enhanced to support a local install option for Redfish
supported servers that are ‘Prestaged’ with a valid Install Bundle. A
prestaging ISO can be built and downloaded outside of the maintenance window,
i.e. to reduce the subcloud install time required during the maintenance
window.

Prestaging can be done manually or it can be automated by building a
self-installing Prestaging ISO image using ``gen-prestaged-iso.sh``.

The ``gen-prestaged-iso.sh`` accepts parameters that include Install Bundle
components and produces a ‘Prestaging ISO’.

.. rubric:: |proc|

#.  Build the prestaging ISO image. See section :ref:`Local Install Bundle
    <local-install-bundle-section>`.

#.  Save the prestaging ISO image to the subcloud's bootable device.

#.  Reset the server and select either serial or graphical installation for the
    device. The prestaging ISO will be installed on the server, and will
    'Prestage' the the pre-packaged Install Bundle.

#.  Run the :command:`dcmanger subcloud add` command against a Prestaged
    subcloud. The ``add`` operation creates and injects a small boot loader ISO
    into the subcloud’s BMC’s Redfish Virtual Media device and powers on the
    server.

    .. note::

        Refer to :ref:`Install a Subcloud Using Redfish Platform Management
        Service
        <installing-a-subcloud-using-redfish-platform-management-service>` for
        more details on :command:`dcmanager`.

    This small bootloader, ``Miniboot``, has been enhanced to detect and
    validate a Prestaged Install Bundle.

    If the Install Bundle checks out then ``Miniboot`` will proceed to install
    the subcloud's first system controller with the locally found Install
    Bundle.

    If there is no prestaging or the prestaged Install Bundle validity checks
    fail, then ``Miniboot`` proceeds to install the subcloud using the existing
    Remote Install.

.. _local-install-bundle-section:

--------------------
Local Install Bundle
--------------------

The ‘Local Install Bundle’ consists of the following files stored in the
``/opt/platform-backup/<sw_version>`` release directory on the subcloud
server.

Install Image: (only one permitted)

.. code-block::

    bootimage.iso - the image to install locally on the subcloud.
    bootimage.md5 - a text file containing output of the following command
                    'md5sum bootimage.iso',
                    e.g.
                    fcaacda02ae4fdf1ead71850321ca89e  bootimage.iso

Container_image sets:

.. code-block::

    container-image1.tar.gz ... a set of container images. 2.5G max file size
    container-image2.tar.gz ... another set of container images. 2.5G max file size
    container-images.tar.gz.md5 ... text file containing the output of the following command
                                  'md5sum container-image1.tar.gz container-image2.tar.gz'
                                  e.g.
                                  cb1b51f019c612178f14df6f03131a18  container-image1.tar.gz
                                  db6c0ded6eb7bc2807edf8c345d4fe97  container-image2.tar.gz

----------------------------------------------------
Creating the Prestaged ISO with gen-prestaged-iso.sh
----------------------------------------------------

You can prepare and manually prestage the Install Bundle or use the
``gen-prestaged-iso.sh`` tool to create a self-installing prestaging ISO image.

``gen-prestaged-iso.sh`` converts a traditional |prod| Installation ISO into a
Prestaged Subcloud Installation ISO (Prestaged ISO). It also accepts archives
of pre-downloaded Docker images to further reduce the need to transfer large
quantities of software over the network.

Prestaging will set up a disk partition with all the needed software in a
pre-downloaded state, such that a |prod| subcloud can be installed without the
need to transfer gigabytes of data over the network.

The ``gen-prestaged-iso.sh`` bash shell script is run on a customer build
system with Linux installed (e.g. RedHat, CentOS or Ubuntu).

This customer build system requires ``stx-iso-utils.sh`` for many utility
functions. You will find it in the same software distribution location as
``gen-prestaged-iso.sh``.

.. rubric:: |prereq|

-   The following tools need to be installed and available in your PATH on the
    customer build machine.

    - awk
    - cp
    - find
    - grep
    - md5sum
    - mktemp
    - rm
    - rmdir
    - rsync
    - sed
    - tar
    - which
    - losetup
    - mount
    - mountpoint
    - umount
    - mkisofs
    - isohybrid
    - implantisomd5
    - rpm2cpio
    - cpio

-   These additional tools are required if you choose to run
    ``gen-prestaged-iso.sh`` as a user other than root.

    - guestmount
    - guestunmount
    - udisksctl

-   For RedHat/CentOS, run the following command on the customer build machine
    to install dependencies:

    .. code-block::

        $ sudo yum install coreutils cpio findutils gawk genisoimage grep \
                 isomd5sum libguestfs-tools-c rpm rsync sed syslinux \
                 tar udisks2 util-linux which

-   On Ubuntu, run the following command on the customer build machine to
    install dependencies:

    .. code-block::

        $ sudo apt-get install coreutils cpio debianutils findutils gawk genisoimage \
                     grep initscripts isomd5sum libguestfs-tools mount \
                     rpm2cpio rsync sed syslinux tar udisks2

-   You will also need approximately 30 GB of disk space on the customer build
    machine.

.. rubric:: |proc|

#.  (Mandatory) Obtain a |prod| installation ISO.

#.  Obtain any other patches applicable to your ISO.

#.  (Optional) Obtain archived Docker images.

    |prod| uses a large number of Docker images. You can embed Docker images
    within your Prestaged ISO.

    You can choose the number of Docker images that are required to be
    embedded. The more images are embedded in the Prestaged ISO, the fewer will
    need to be downloaded when installing |prod|.

    .. only:: starlingx

        For |prod|: http://mirror.starlingx.cengn.ca/mirror/starlingx/

    .. only:: partner

        .. include:: /_includes/subcloud-deployment-with-local-installation-4982449058d5.rest
            :start-after: windshare-link-begin
            :end-before:  windshare-link-end

    Use :command:`docker pull` to download all all the selected images, instead
    of downloading it every time a subcloud is installed.

    Finally, archive all your Docker images using :command:`docker save`.
    The archives should be in ``tar.gz`` format.

    It is recommended that you use a single :command:`docker save` command to
    archive multiple images at a time. The total size of all images per archive
    should not exceed 8G which will yield an archive file under 2.5G in
    compressed format.

    Docker images are built in layers, and often share common base layers. A
    multi-image archive avoids duplication, reducing the size of your archive
    and ISO.

    However, your archives must be less than 4GB in size to be included within
    the ISO. Approximately 3 or 4 archives are required for all the images.

.. rubric:: |eg|

The following example has the commands required for a Prestaging ISO containing
a valid Install Bundle.

.. code-block::

    gen-prestaged-iso.sh \
    --input /path/to/the/bootimage.iso \
    --images /path/to/a/container/image/set/container-image1.tar.gz \
    --images /path/to/another/container/image/set/container-image2.tar.gz \
    --param boot_device=/dev/disk/by-path/pci-0000:c3:00.0-nvme-1 \
    --param rootfs_device=/dev/disk/by-path/pci-0000:c3:00.0-nvme-1 \
    --output /path/to/the/prestaged.iso
    --timeout -1

This tool contains options that allows you to customize prestaging content and
images for a specific subcloud’s hardware configuration.

Use the ``--input`` parameter to specify the path/filename to the ISO image to
be installed on the subcloud.

Use the ``--images`` option to specify the path/filename to a container image
to be installed on the subcloud.

Use the ``--param`` option to specify the rootfs device and boot device to
install the prestaging image. The tool defaults to /dev/sda directory. Use this
option to override the default storage device the prestaging image is to be
installed.

Use the ``--output`` directive to specify the path/filename of the created
‘Prestaging ISO’ image.

.. code-block::

    *_Detailed Tool Help:_*
    {code:java}
     gen-prestaged-iso.sh --help
    Usage:
       gen-prestaged-iso.sh --input <input bootimage.iso>
                            --output <output bootimage.iso>
                          [ --images <images.tar.gz> ]
                          [ --patch <patch-name.patch> ]
                          [ --kickstart-patch <kickstart-enabler.patch> ]
                          [ --addon <ks-addon.cfg> ]
                          [ --param <param>=<value> ]
                          [ --default-boot <default menu option> ]
                          [ --timeout <menu timeout> ]

            --input  <file>: Specify input ISO file
            --output <file>: Specify output ISO file

            --images <images.tar.gz>:
                          Specify a collection of docker images in 'docker save'
                          format.  This option can be specified more than once,
                          or a comma separated list can be used.
                          It is recommended to include all images listed in
                          wind-river-cloud-platform-container-images-list.
                          Multiple images can be captured in a single archive.
                          No single archive may exceed 4 GB.

            --patch <patch-name.patch>:
                          Specify WRCP software patch file(s).
                          Can be specified more than once,
                          or provide a comma separated list.

            --kickstart-patch <kickstart-enabler.patch>:
                          A patch to replace the prestaged installer kickstart.
                          Not to be included in the runtime patches.

            --addon  <file>: Specify ks-addon.cfg file.

            --param  <p=v>:  Specify boot parameter(s).
                             Can be specified more than once, or provide a comma separated list.
                             Examples:
                             --param rootfs_device=nvme0n1,boot_device=nvme0n1

                             --param rootfs_device=/dev/disk/by-path/pci-0000:00:0d.0-ata-1.0
                             --param boot_device=/dev/disk/by-path/pci-0000:00:0d.0-ata-1.0

            --default-boot <default menu option>:
                             Specify default boot menu option:
                             0 - Serial Console
                             1 - Graphical Console (default)
            --timeout <menu timeout>:
                             Specify boot menu timeout, in seconds.  (default 30)
                             A value of -1 will wait forever.

---------------------
Prestage the subcloud
---------------------

.. rubric:: |prereq|

This feature is only supported for subcloud servers that support Redfish
Virtual Media.

.. rubric:: |proc|

Perform the following steps to prestage the subcloud with the generated
Prestaging ISO.

#.  Save the ISO image to a bootable device on the subcloud, so that the
    subcloud boots from the device.

#.  The default is an Auto Graphical Install after 30 seconds.

    You can modify the auto install method by specifying ``timeout <secs``
    and/or ``--default-boot 0`` for serial install.

    You can disable auto install by specifying ``--timeout`` of -1 to manually
    start the install.

#.  The Prestaging Install

    The Prestaging image install automatically Prestages the subcloud with the
    Install Bundle contents based on the :command:`gen-prestaged-iso.sh`
    command.

    A new post_prestaging.cfg kickstart implements the prestaging function. It
    is added to a new `controller` packaging group to create
    ``prestaged_installer_ks.cfg`` kickstart bundle. The packaging group is
    sized to decrease installation time.

    The current version of the Prestaging ISO does not support network login
    but Graphical or Serial console login only.

    You can verify if the Prestaged Install Bundle is present after the
    Prestaging Install is complete by logging in as `sysadmin/sysadmin` and
    listing the contents of the ``/opt/platform-backup/<sw_release>``
    directory.

    .. rubric:: |eg|

    .. code-block::

        controller-0:~# ls -lrt /opt/platform-backup/<sw_release>/
        total 7082736
        -rw-r--r--. 1 root 751 2338324480 Nov  4 23:52 bootimage.iso
        -rw-r--r--. 1 root 751         48 Nov  4 23:52 bootimage.md5
        -rw-r--r--. 1 root 751 2489551974 Nov  4 23:52 container-image1.tar.gz
        -rw-r--r--. 1 root 751 2424822040 Nov  4 23:52 container-image2.tar.gz
        -rw-r--r--. 1 root 751        116 Nov  4 23:52 container-image.tar.gz.md5

#.  Prestaging Algorithm

    The prestaging kickstart implements the following algorithm:

    -   Verifies installation repo contains Prestaging Install Bundle

    -   Creates the Platform Backup partition on the rootfs device if it does
        not already exist.

    -   Mounts the Platform Backup partition.

    -   Creates the ``/opt/platform-backup/<sw_release>`` directory if it does
        not exist.

    -   Wipes the ``/opt/platform-backup/<sw_release>`` directory if it exists.

    -   Copies the Install Bundle from the installer repo to the subcloud’s
        Prestaging directory.

    -   Verifies the integrity of the Install Bundle on the subcloud.

        -   Runs ``md5sum --check`` against all files with the .md5 extension.

        -   Any ``md5sum --check`` failure results in a Prestaging Failure

    .. note::

        Failure to create/mount the Platform Backup Prestaging partition or
        validate the ISO image or any of the container image sets will result
        in a Prestaging Installation Failure at the Anaconda Installer level.

    .. note::

        Use the wipedisk utility to wipe the bootloader and rootfs disk
        partitions. The ``--include-backup`` option will also wipe the
        "platform-backup" partition.

----------------
Subcloud Install
----------------

With a successful subcloud prestage completed, the subcloud is ready to be
added and installed from the System Controller. See :ref:`Install a
Subcloud Using Redfish Platform Management Service
<installing-a-subcloud-using-redfish-platform-management-service>`.

#.  Subcloud ``Miniboot`` Installer

    The Subcloud Local Install feature introduces a new kickstart
    ``post_miniboot_controller.cfg`` in a new controller group’s
    ``miniboot_controller_ks.cfg`` kickstart bundle. This new kickstart
    bundle is passed to ``Miniboot`` on the subcloud during the subcloud
    install.

    If there is a valid Prestaged Install Bundle then ``Miniboot`` will use
    it to perform a Local Install.

    If there is no valid Prestaged Install Bundle then ``Miniboot`` will
    default to the already supported Remote Install.

#.  ``Miniboot`` Algorithm

    ``Miniboot`` install algorithm is as follows:

    -   Mounts the Platform Backup partition.

    -   Navigates to the specified sw_version directory.

    -   Searches for a Prestaged Install Bundle.

    -   Verifies the integrity of the Prestaged Install Bundle.

        -   Runs ``md5sum --check`` against all files with the .md5
            extension.

    -   If Install Bundle is present and valid then perform a Local Install.

    -   If Install Bundle is missing or invalid perform a Remote Install.

-----------------
Local Install Log
-----------------

After install, login as ``sysadmin/sysadmin`` and remove the prestaging logs.

**Example of a successful Local install log stream**

.. code-block::

    localhost:~$ sudo cat /var/log/anaconda/ks*.log | grep Prestaging | sort

    2021-11-05 19:45:56.422 - Prestaging post: applying label to backup partition
    2021-11-05 19:45:57.556 - Prestaging post: cmdLine: rootwait inst.text inst.gpt boot_device=/dev/sda rootfs_device=/dev/sda biosdevname=0 usbcore.autosuspend=-1 security_profile=standard user_namespace.enable=1 inst.stage2=hd:LABEL=oe_prestaged_iso_boot inst.ks=hd:LABEL=oe_prestaged_iso_boot:/prestaged_installer_ks.cfg console=ttyS0,115200 serial initrd=initrd.img BOOT_IMAGE=vmlinuz

    2021-11-05 19:45:57.557 - Prestaging post: install source : /run/install/repo
    2021-11-05 19:45:57.558 - Prestaging post: SW_VERSION           : nn.nn
    2021-11-05 19:45:57.559 - Prestaging post: IMAGE_MOUNT          : /run/install/repo
    2021-11-05 19:45:57.560 - Prestaging post: PRESTAGING_REPO_DIR  : /run/install/repo/opt/platform-backup
    2021-11-05 19:45:57.561 - Prestaging post: PRESTAGING_LOCAL_DIR : /mnt/platform-backup
    2021-11-05 19:45:57.565 - Prestaging post: mounting /mnt/platform-backup
    2021-11-05 19:45:59.598 - Prestaging post: copy prestaging files
    2021-11-05 19:46:37.820 - Prestaging post: prestaging files copy done
    2021-11-05 19:46:37.821 - Prestaging post: prestaged file : bootimage.iso
    2021-11-05 19:46:37.822 - Prestaging post: prestaged file : bootimage.md5
    2021-11-05 19:46:41.800 - Prestaging post: bootimage check passed
    2021-11-05 19:46:41.801 - Prestaging post: prestaged file : container-image.tar.gz.md5
    2021-11-05 19:46:49.876 - Prestaging post: container-image.tar.gz check passed
    2021-11-05 19:46:49.878 - Prestaging post: prestaged file : container-image1.tar.gz
    2021-11-05 19:46:49.879 - Prestaging post: prestaged file : container-image2.tar.gz
    2021-11-05 19:46:49.880 - Prestaging post: prestaging integrity checks passed
    2021-11-05 19:46:49.881 - Prestaging post: prestaging complete

-------------
Debug options
-------------

When a failure occurs an installation failure message is printed to stdio.

There are 2 categories of failure:

-   Installation Failure
-   Prestaging Failure

When the Anaconda installer is running you will see the reverse video banner
at the bottom of the screen:

.. code-block::

    [anaconda] 1:main- 2:shell* 3:log  4:storage-log  5:> Switch: Alt+Tab or Ctrl-o

First ``Ctrl-o`` gets you into Linux console shell as Anaconda root.

Subsequent ``Ctrl-o`` toggles through each of 4 additional less helpful views.

Log files are in ``/tmp``. It is recommended to look at the ``program.log`` for
a failure reason log.

If there are Prestaging logs they will also be in ``/tmp/program.log`` or be in
one of the individual randomly named kickstart logs.

.. code-block::

    cat /tmp/ks*.log | grep Prestaging | sort

**Anaconda reports “Installation Failed” – Reason: Specified boot device is invalid**

Look for 'device is invalid' logs on the console, in the ``/tmp/program.log``
or in the individual kickstart logs (``/tmp/ks*.log``).

Example from the console:

.. code-block::

    There was an error running the kickstart script at line 611. This is a fatal error and installation will be aborted.  The details of this error are:

    2021-11-05 23:03:44.105 - Found rootfs /dev/disk/by-path/pci-0000:c3:00.0-nvme-1 on: ->.

    2021-11-05 23:03:44.119 - Found boot /dev/disk/by-path/pci-0000:c3:00.0-nvme-1 on: ->.


    Installation failed.

    ERROR: Specified installation (/dev/disk/by-path/pci-0000:c3:00.0-nvme-1) or boot (/dev/disk/by-path/pci-0000:c3:00.0-nvme-1) device is invalid.

**Prestaging Failure: Server Install Device Too Small**

Look for 'No space left on device' logs on the console, in the
``/tmp/program.log`` or in the individual kickstart logs (``/tmp/ks*.log``).

**Debugging a Rejected Local Install**

The followimg command is to query Local Install logs:

.. code-block::

    $ sudo cat /var/log/anaconda/ks* | grep Miniboot | sort

**Example of a typically successful Local Install log stream**

.. code-block::

    2021-11-05 05:03:10.044 - Miniboot  pre: local install check

    2021-11-05 05:03:12.059 - Miniboot  pre: prestaged file : bootimage.iso

    2021-11-05 05:03:12.060 - Miniboot  pre: found prestaged iso image /mnt/platform-backup/nn.nn/bootimage.iso

    2021-11-05 05:03:12.060 - Miniboot  pre: prestaged file : bootimage.md5

    2021-11-05 05:03:17.339 - Miniboot  pre: bootimage check passed

    2021-11-05 05:03:17.340 - Miniboot  pre: prestaged file : container-image.tar.gz.md5

    2021-11-05 05:03:28.432 - Miniboot  pre: container-image.tar.gz check passed

    2021-11-05 05:03:28.432 - Miniboot  pre: prestaged file : container-image1.tar.gz

    2021-11-05 05:03:28.433 - Miniboot  pre: prestaged file : container-image2.tar.gz

    2021-11-05 05:03:28.434 - Miniboot  pre: local iso found : /mnt/platform-backup/nn.nn/bootimage.iso

    2021-11-05 05:03:28.438 - Miniboot  pre: local iso mounted for local install

    2021-11-05 05:10:25.372 - Miniboot post: mount for eject

    2021-11-05 05:10:25.382 - Miniboot post: /mnt/sysimage files : total 82

    2021-11-05 05:10:25.384 - Miniboot post: /mnt/sysimage/www/pages/feed/rel-nn.nn files : total 23

    2021-11-05 05:10:25.385 - Miniboot post: /mnt/sysimage/www/pages/updates/rel-nn.nn does not exist

    2021-11-05 05:10:25.386 - Miniboot post: /mnt/sysimage/opt/patching does not exist

    2021-11-05 05:10:25.387 - Miniboot post: copying software repository /mnt/bootimage/Packages

    2021-11-05 05:10:25.387 - Miniboot post: /mnt/sysimage/opt/patching/packages/nn.nn/ does not exist

    2021-11-05 05:10:26.465 - Miniboot post: updating platform.conf with install uuid : e1beb1c8-db83-4d0e-b2c5-8623b322a2a7

    2021-11-05 05:10:26.467 - Miniboot post: Local Install

    2021-11-05 05:10:26.472 - Miniboot post: downloading patch repository http://[2620:10a:a001:a103::167]:8080/iso/nn.nn/nodes/subcloud1/patches

    2021-11-05 05:10:26.474 - Miniboot post: fetch packages

    2021-11-05 05:10:26.478 - Miniboot post: fetch package repodata

    2021-11-05 05:10:27.284 - Miniboot post: fetch patch metadata

    2021-11-05 05:10:27.390 - Miniboot post: save a copy of all patch packages, preserve attributes

Specifically look for the “Local Install” log.

-   ``<date> - Miniboot post: Local Install``

**Rejected Local Install**

A rejected Local Install results in a Remote Install indicated by the following
log:

-   ``<date> - Miniboot post: Remote Install``

The reason for the reject local install should accompanied by one of the
following reason logs:

-   ``<date> - Miniboot  pre: <filename.md5> check failed``

-   ``<date> - Miniboot  pre: No prestaging files``

-   ``<date> - Miniboot  pre: Error /mnt/platform-backup not mounted``

-   ``<date> - Miniboot  pre: Local iso file not found``

-   ``<date> - Miniboot  pre: local install rejected due to validity check error``

-   ``<date> - Miniboot  pre: mount of /dev/disk/by-partlabel/Platform\x20Backup to /mnt/platform-backup failed rc:#``

-   ``<date> - Miniboot  pre: backup device /dev/disk/by-partlabel/Platform\x20Backup does not exist``
