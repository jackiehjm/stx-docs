
.. fyl1552681364538
.. _use-uefi-secure-boot:

====================
Use UEFI Secure Boot
====================

Secure Boot is supported in |UEFI| installations only. It is not used when
booting |prod| as a legacy boot target.

.. contents:: |minitoc|
   :local:
   :depth: 1

|prod| currently does not support switching from legacy to |UEFI| mode after a
system has been installed. Doing so requires a reinstallation of the system.
This also means that upgrading from a legacy install to a secure boot install
(|UEFI|) is not supported.

When upgrading a |prod| system from a version which does not support secure
boot to a version that does, do not enable secure boot in UEFI firmware until
the upgrade is complete.

For each node that is going to use secure boot, you must populate the |prod|
public certificate/key in the |UEFI| Secure Boot authorized database in
accordance with the board manufacturer's process. This must be done for each
node before starting installation.

You may need to work with your hardware vendor to have the certificate
installed.

There is often an option in the |UEFI| setup utility which allows a user to
browse to a file containing a certificate to be loaded in the authorized
database. This option may be hidden in the |UEFI| setup utility unless |UEFI|
mode is enabled, and secure boot is enabled.

The UEFI implementation may or may not require a |TPM| device to be
present and enabled before providing for secure boot functionality. Refer to
you server board's manufacturer's documentation.

Many motherboards ship with Microsoft secure boot certificates
pre-programmed in the |UEFI| certificate database. These certificates may be
required to boot |UEFI| drivers for video cards, RAID controllers, or NICs
(for example, the |PXE| boot software for a NIC may have been signed by a
Microsoft certificate). While certificates can usually be removed from the
certificate database (again, this is |UEFI| implementation specific) it
may be required that you keep the Microsoft certificates to allow for
complete system operation.

Mixed combinations of secure boot and non-secure boot nodes are supported.
For example, a controller node may secure boot, while a worker node may not.
Secure boot must be enabled in the UEFI firmware of each node for that node
to be protected by secure boot.

.. only:: starlingx

    --------------------------------------------------------------
    Build considerations for signing packages for UEFI Secure Boot
    --------------------------------------------------------------

    The |prod| build environment has provisions for calling out to a signing
    server for purposes of creating a secure boot load.  At this time |prod|
    does not include an implementation of the signing server.  The following
    describes how the signing process is intended to work in the context of a
    CentOS build. You may find it helpful in implementing your own signing
    server.

    The following environmental variables should be defined before attempting
    to request a secure boot signing:

    .. code-block:: bash

        export SIGNING_SERVER=<signing-host>
        export SIGNING_USER=<signing-user>
        export SIGNING_SERVER_SCRIPT=<path-to-signing-script>

    ``build-pkgs`` further requires that ``$USER`` be set to "jenkins", and
    :command:`export FORMAL_BUILD=1``.

    If the above criteria is met, it calls into ``sign-secure-boot``.

    This is an example of the call sequence:

    .. code-block:: bash

        # 1. Set up the server side directory for files transfers.
        UPLOAD_PATH=`ssh $SIGNING_USER@$SIGNING_SERVER sudo $SIGNING_SCRIPT -r`

        # 2. upload the original package
        scp -q $FILE $SIGNING_USER@$SIGNING_SERVER:$UPLOAD_PATH

        # 3. Request that the package be signed
        ssh $SIGNING_USER@$SIGNING_SERVER sudo $SIGNING_SCRIPT -v -i $UPLOAD_PATH/$(basename $FILE) $UNSIGNED_OPTION -t $TYPE > $TMPFILE

        # 4. Download the file from the signing server
        DOWNLOAD_FILENAME=$(basename $OUTPUT_FILE)
        scp -q $SIGNING_USER@$SIGNING_SERVER:$OUTPUT_FILE $(dirname $FILE)


    Within the signing server there are two keys used for signing, known as the
    `boot` key and the `shim` key. The public `boot` key file must be manually
    added to the secure boot keychain in the firmware. The `boot` key signs the
    first executable loaded, contained in the `shim` package. The first
    executable must then install the public `shim` key file (automatically)
    before passing control to the grub, and ultimately the kernel, both of
    which are signed by the private `shim` key.

    Three packages need to be passed to the signing server. The RPMs need to be
    unpacked, the relevant binaries signed with the correct keys, and the RPMs
    reassembled.

    .. table::
       :widths: auto

       +---------+------+------------------------------------+
       | Package | Key  | Files to sign                      |
       +=========+======+====================================+
       | shim    | boot | BOOTX64, shim, shimx64             |
       |         | shim | MokManager, fallback, mmx64, fbx64 |
       +---------+------+------------------------------------+
       | grub    | shim | grubx64.efi, gcdx64.efi            |
       +---------+------+------------------------------------+
       | kernel  | shim |                                    |
       +---------+------+------------------------------------+

    .. note::

        `shim` files that are required to be signed might might include a
        ``.efi`` or ``.EFI`` suffix.

        Some files may be absent in newer packages.

    Example:

    .. code-block:: none

        sbsign --key $KEYPATH/$KEYNAME.key --cert $KEYPATH/$KEYNAME.crt  --output $SIGNEDFILE $UNSIGNEDFILE

    .. rubric:: Keys and certificates:

    * ``boot.crt`` - Certificate to boot (to be programmed in firmware)

    * ``boot.key`` - Private key with which to sign shim

    * ``shim.crt`` - Certificated embedded within shim used to validate kernel, grub

    * ``shim.key`` - Private key with which to sign kernel/grub

    .. rubric:: Key generation:

    .. code-block:: none

        openssl req -new -x509 -newkey rsa:2048 -keyout $KEY.key -out $KEY.pem -days 3650
        openssl x509 -in $KEY.pem -out $KEY.crt -outform DER

    .. note::

        ``boot.crt`` should be copied to
        ``cgcs-root/build-tools/certificates/TiBoot.crt`` for inclusion during the
        ``build-iso`` step.
