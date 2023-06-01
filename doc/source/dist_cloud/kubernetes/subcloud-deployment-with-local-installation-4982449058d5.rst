.. _subcloud-deployment-with-local-installation-4982449058d5:

===========================================
Subcloud Deployment with Local Installation
===========================================

.. rubric:: |context|

Subcloud install is enhanced to support a local install option for Redfish
supported servers that are 'Prestaged' with a valid Install Bundle. A
prestaging ISO can be built and downloaded outside of the maintenance window,
i.e. to reduce the subcloud install time required during the maintenance
window.

Where Install Bundle refers to a valid OSTree repo, that will be available at
/opt/platform-backup on the subcloud, and any container images and patches
as required.

Prestaging can be done manually or it can be automated by building a
self-installing Prestaging ISO image using ``gen-prestaged-iso.sh``.

The ``gen-prestaged-iso.sh`` accepts parameters that include Install Bundle
components and produces a 'Prestaging ISO'.

.. rubric:: |proc|

#.  Build the prestaging ISO image. See section :ref:`Local Install Bundle
    <local-install-bundle-section>`.

#.  Save the prestaging ISO image to the subcloud's bootable device.

#.  Reset the server and select either serial or graphical installation for the
    device. The prestaging ISO will be installed on the server, and will
    'Prestage' the the pre-packaged Install Bundle.

#.  Run the :command:`dcmanger subcloud add` command against a Prestaged
    subcloud. The ``add`` operation creates and injects a small boot loader ISO
    into the subcloud's BMC's Redfish Virtual Media device and powers on the
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

.. rubric:: |postreq|

-   Provision the newly installed and bootstrapped subcloud.  For detailed
    |prod| deployment procedures for the desired deployment configuration of
    the subcloud, see the post-bootstrap steps of the |_link-inst-book|.

-   Check and update docker registry credentials on the subcloud:

    .. code-block:: none

        REGISTRY="docker-registry"
        SECRET_UUID='system service-parameter-list | fgrep
        $REGISTRY | fgrep auth-secret | awk '{print $10}''
        SECRET_REF='openstack secret list | fgrep $
        {SECRET_UUID} | awk '{print $2}''
        openstack secret get ${SECRET_REF} --payload -f value

    The secret payload should be :command:`username: sysinv password:<password>`.
    If the secret payload is :command:`username: admin password:<password>`,
    see, :ref:`Updating Docker Registry Credentials on a
    Subcloud <updating-docker-registry-credentials-on-a-subcloud>` for more
    information.

-   For more information on bootstrapping and deploying, see the procedures
    listed under :ref:`install-a-subcloud`.

-   Add static route for nodes in subcloud to access openldap service.

    In DC system, openldap service is running on Central Cloud. In order for the nodes
    in the subclouds to access openldap service, such as ssh to the nodes as openldap
    users, a static route to the System Controller is required to be added in these
    nodes. This applies to controller nodes, worker nodes and storage nodes (nodes
    that have sssd running).

    The static route can be added on each of the nodes in the subcloud using system
    CLI.

    The following examples show how to add the static route in controller node and
    worker node:

    .. code-block:: none

        system host-route-add controller-0 mgmt0 <Central Cloud mgmt subnet> 64 <Gateway IP address>
        system host-route-add compute-0 mgmt0 <Central Cloud mgmt subnet> 64 <Gateway IP address>

    The static route can also be added using Deployment Manager by adding the route
    in its configuration file.

    The following examples show adding the route configuration in controller and
    worker host profiles of the deployment manager's configuration file:

    .. code-block:: none

        Controller node:
        ---
        apiVersion: starlingx.windriver.com/v1
        kind: HostProfile
        metadata:
          labels:
            controller-tools.k8s.io: "1.0"
          name: controller-0-profile
          namespace: deployment
        spec:
          administrativeState: unlocked
          bootDevice: /dev/disk/by-path/pci-0000:c3:00.0-nvme-1
          console: ttyS0,115200n8
          installOutput: text
          ......
          routes:
              - gateway: <Gateway IP address>
            activeinterface: mgmt0
            metric: 1
            prefix: 64
            subnet: <Central Cloud mgmt subnet>

        Worker node:
        ---
        apiVersion: starlingx.windriver.com/v1
        kind: HostProfile
        metadata:
          labels:
            controller-tools.k8s.io: "1.0"
          name: compute-0-profile
          namespace: deployment
        spec:
          administrativeState: unlocked
          boardManagement:
            credentials:
              password:
                secret: bmc-secret
            type: dynamic
          bootDevice: /dev/disk/by-path/pci-0000:00:1f.2-ata-1.0
          clockSynchronization: ntp
          console: ttyS0,115200n8
          installOutput: text
          ......
          routes:
              - gateway: <Gateway IP address>
            interface: mgmt0
            metric: 1
            prefix: 64
            subnet: <Central Cloud mgmt subnet>

.. _local-install-bundle-section:

--------------------
Local Install Bundle
--------------------

The 'Local Install Bundle' consists of the following files stored in the
``/opt/platform-backup/`` directory on the subcloud server.

Install Image: (only one permitted)

.. code-block::

    ostree_repo /opt/platform-backup

Container_image sets are available in the ``/opt/platform-backup/<release_id>``
release directory

.. code-block::

    container-image1.tar.gz ... a set of container images. 2.5G max file size
    container-image2.tar.gz ... another set of container images. 2.5G max file size
    container-images.tar.gz.md5 ... text file containing the output of the following command
                                  'md5sum container-image1.tar.gz container-image2.tar.gz'
                                  e.g.
                                  cb1b51f019c612178f14df6f03131a18  container-image1.tar.gz
                                  db6c0ded6eb7bc2807edf8c345d4fe97  container-image2.tar.gz

--------------------------------------------------
Create the Prestaged ISO with gen-prestaged-iso.sh
--------------------------------------------------

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

        $ sudo apt-get install coreutils cpio debianutils findutils gawk genisoimage grep initscripts isomd5sum libguestfs-tools mount rsync sed syslinux tar udisks2

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
install the prestaging image. The tool defaults to ``/dev/sda directory``. Use this
option to override the default storage device the prestaging image is to be
installed.

Use the ``--output`` directive to specify the path/filename of the created
'Prestaging ISO' image.

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
                          A modified kickstart.cfg to replace the prestaged
                          installer kickstart. This will only be used during
                          installation using the prestaged ISO.

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
    OSTree repo and other contents based on the :command:`gen-prestaged-iso.sh`
    command.

    The kickstart.cfg kickstart implements the prestaging function.

    The current version of the Prestaging ISO does not support network login
    but Graphical or Serial console login only.

    You can verify if the Prestaged OSTree repo and other contents are present
    after the Prestaging install is complete by:

    #. Login using the login credentials; sysadmin/sysadmin. You will be
       prompted to change the password at the first login.

    #. Check the contents of /opt/platform-backup and /opt/platform-backup/<release_id>
       directories.

       -  You will see the directory named ostree-repo. You can use the
          ``fsck`` function of OSTree to validate the OSTree repo.
          You will see another directory named <release_id>. It contains the
          container images and patches, if any.

       -  The contents of /opt/platform-backup/<release-id> will not include
          bootimage.iso or the sig file.

          where <release-id> is the Release number.

    .. rubric:: |eg|

    .. code-block::

        controller-0:~# ls -lrt /opt/platform-backup/<release_id>/
        total 4914374130
        -rw-r--r--. 1 root 751 2489551974 Nov  4 23:52 container-image1.tar.gz
        -rw-r--r--. 1 root 751 2424822040 Nov  4 23:52 container-image2.tar.gz
        -rw-r--r--. 1 root 751        116 Nov  4 23:52 container-image.tar.gz.md5

#.  Prestaging Algorithm

    The prestaging kickstart implements the following algorithm:

    -   Verifies that the installation repo contains the OSTree repo.

    -   Creates the Platform Backup partition on the rootfs device if it does
        not already exist.

    -   Mounts the Platform Backup partition.

    -   Creates the ``/opt/platform-backup/<sw_release>`` directory if it does
        not exist.

    -   Wipes the ``/opt/platform-backup/<sw_release>`` directory if it exists.

    -   Copies the OSTree repo from the installer to the subcloud's
        /opt/platform-backup.

    .. note::

        Failure to create/mount the Platform backup prestaging partition
        will result in a prestaging installation failure at the kickstart level.

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

    The subcloud Local install feature uses a new kickstart ``miniboot.cfg`` .
    This kickstart is passed to ``Miniboot`` on the subcloud during the subcloud
    install via the miniboot iso.

    If there is a valid Prestaged OSTree repo then ``Miniboot`` will use
    it to perform a Local install.

    If there is no valid Prestaged OSTree repo then ``Miniboot`` will
    default to the already supported Remote install.

#.  ``Miniboot`` Algorithm

    ``Miniboot`` install algorithm is as follows:

    -   Mounts the Platform Backup partition.

    -   Navigates to the specified sw_version directory.

    -   Searches for a Prestaged install bundle.

    -   If the OSTree repo is present and valid then perform a Local install.

    -   If OSTree repo is missing or invalid perform a Remote install.

-----------------
Local Install Log
-----------------

After install, login as ``sysadmin/sysadmin``. You will be prompted to change
the password the first time you login. Then remove the prestaging logs.

**Example of a successful Local install log stream**

.. code-block::

    sysadmin@localhost:/var/log/lat$ cat kickstart.log | grep -i prestag
    2022-12-13 21:12:44.448 kickstart ks-early  info: controller /proc/cmdline:net.naming-scheme=vSTX7_0 BOOT_IMAGE=/bzImage-std ini0
    2022-12-13 21:12:44.544 kickstart ks-early  info: controller Prestaging for Local Install
    2022-12-13 21:12:44.614 kickstart ks-early  warn: controller Prestage: Force Installing Prestaged content. All existing installa.
    2022-12-13 21:16:30.756 kickstart post_nochroot  info: controller Prestage operation: copying repo to /opt/platform-backup

-------------
Debug options
-------------

When a failure occurs an installation failure message is printed to stdio.

There are 2 categories of failure:

-   Installation Failure
-   Prestaging Failure

You can monitor the progress and installation failures on the boot screen.

**Debugging a Rejected Local Install**

The logs for a failed prestaging are found in /var/log/lat. ``miniboot.cfg`` is
used for prestaging from the System Controller. You can find the log files
at /var/log/lat/miniboot.log.

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
