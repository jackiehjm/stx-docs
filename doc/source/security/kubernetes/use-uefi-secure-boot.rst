
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
boot to a version that does, do not enable secure boot in |UEFI| firmware until
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
Secure boot must be enabled in the |UEFI| firmware of each node for that node
to be protected.

.. only:: partner

    .. include:: /_includes/extract-certificate-from-iso-181be684e2e5.rest

.. only:: starlingx

    ------------------------------------------------------------------------------
    Build considerations for signing packages for UEFI Secure Boot -- CentOS build
    ------------------------------------------------------------------------------

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

    ------------------------------------------------------------------------------
    Build considerations for signing packages for UEFI Secure Boot -- Debian build
    ------------------------------------------------------------------------------

    The |prod| build environment has provisions for calling out to a signing
    server for purposes of creating a secure boot load.  At this time |prod|
    does not include an implementation of the signing server.  The following
    describes how the signing process is intended to work in the context of a
    ``Debian`` build. You may find it helpful in implementing your own signing
    server.

    The secure boot verification sequence of StarlingX Debian is:

    #. UEFI firmware verify shim image

    #. shim verify grub image

    #. grub verify kernel image and initramfs image

    The bootloader shim will enroll the public key to verify grub image.

    The bootloader grub-efi will enroll the public key to verify kernel and
    initramfs image.

    The following process should be followed to request a secure boot signing:

    .. code-block:: none

        ......
        stx control keys-add --key-type=signing-server --key=[key file]
        stx shell
        downloader
        build-pkgs
        export SIGNING_SERVER="signing_user@signing_server_ip"
        sign-secure-boot_debian
        build-image

    The "key file" is the private key generated by :command:`ssh-keygen -t rsa`
    and used to setup signing server access without password.

    The signing script ``sign-secure-boot_debian`` does secure boot signing for
    |prod| Debian as follows:


    #. Sign shim / grub images

       The shim/grub efi images are obtained from extracted shim/grub
       packages, and they are sent to signing server and signed there and
       copied back. Then the shim/grub packages are repacked with the
       signed efi images.

    #. Sign kernel images and ``LockDown.efi``

       The file sign_rootfs-post-scripts is inserted to where the hook script
       "rootfs-post-scripts" is defined in the LAT config file
       ``base-bullseye.yaml``. This will sign kernel images and
       ``LockDown.efi`` on signing server in the LAT build process. The
       "rootfs-post-scripts" is the hook in LAT tool running after rootfs is
       created.

    #. Sign initramfs and mini initrd

       The file`` sign_initramfs-sign-script`` is inserted to where the hook
       script ``initramfs-sign-script`` is defined in the LAT config file
       ``base-bullseye.yaml``. This will sign initramfs and mini initrd on
       signing server in the LAT build process. The ``initramfs-sign-script``
       is the hook in LAT tool running after initramfs is created.

    **2** and **3** above prepare the signing codes in the LAT config file.
    After build-image is triggered, the signing codes inserted into the LAT
    config files will run on the LAT container in the correct sequence.

    Here is an example for signing an image file in sign-secure-boot_debian:

    .. code-block:: bash

        # Request upload path from signing server.
        REQUEST=$(ssh ${SSH_OPTION_NOCHECKING} ${SIGNING_SERVER} sudo /opt/signing/sign-debian.sh -r)
        UPLOAD_PATH=${REQUEST#*Upload: }

        # Copy shimx64.efi to signing server
        scp ${SSH_OPTION_NOCHECKING} shimx64.efi ${SIGNING_SERVER}:${UPLOAD_PATH}
        # Sign shimx64.efi
        ssh ${SSH_OPTION_NOCHECKING} ${SIGNING_SERVER} sudo /opt/signing/sign-debian.sh -i ${UPLOAD_PATH}/shimx64.efi -t shim
        # Copy back signed shimx64.efi which is renamed as bootx64.efi
        sudo scp ${SSH_OPTION_NOCHECKING} ${SIGNING_SERVER}:${UPLOAD_PATH}/bootx64.efi ./

    ``sign-debian.sh``, above, is the script running on signing server whose
    interface is defined as below:

    .. code-block:: none

        Usage:
        sign-debian.sh [options]

        [-i <file>] - input unsigned file
        [-t <type>] - type of signing to do
        [-r]        - request an upload path

        Types of signing:
        -t shim     - signs a shim EFI binary with the boot key
        -t grub     - signs a GRUB EFI binary with the shim key
        -t shimtool - signs a shim tool EFI binary with the shim key
        -t grub-gpg - signs a kernel/initrd/grub.cfg with the grub gpg key

    .. _key-management-use-uefi-secure-boot:

    .. rubric:: Keys management:


    Upstream stx public keys repo: https://opendev.org/starlingx/public-keys

    The keys under cgcs-root/public-keys are the public keys used in
    the verification process of secure boot process for StarlingX
    Debian.

    .. rubric:: Keys Introduction:
    
    ``tis-boot.crt``: The public key flashed into |UEFI| to verify
      ``bootx64.efi`` (signed shim image ``shimx64.efi``)

    ``tis-shim.der``: The public key used by shim to verify
      ``grubx64.efi`` (signed grub image) and ``mmx64.efi``
      (signed shim tool image);

    ``boot_pub_key``: it is the public key used by grub to verify signed
      kernel image and initramfs image and efitools image and so on.

    ``TiBoot.crt``: it is the same pub key with ``tis-boot.crt`` (pem) as a
      der format. It is installed as ``/CERTS/TiBoot.crt`` in the ``efi.img``
      which is in the iso image.

    The following methods can be used to create substitute keys:

    #. Example to create ``tis-boot.crt/TiBoot.crt``.

       .. code-block:: bash
    
           openssl req -new -x509 -newkey rsa:2048 -keyout BOOT.priv -outform DER -out BOOT.der -days 36500 -subj "/CN=My Boot/" -nodes
           openssl x509 -inform der -in BOOT.der -out BOOT.pem
           cp BOOT.pem tis-boot.crt
           cp BOOT.priv tis-boot.key
           cp BOOT.der TiBoot.crt


       The ``tis-boot.crt`` and ``tis-boot.key`` are used to sign images
       mentioned above (shim image).

       The ``tis-shim.crt``/``tis-shim.der``/``tis-shim.key`` can be created in
       the same way, and used to sign images mentioned above (grub image and
       shim tool image).

    #. Example to create ``boot_pub_key``.

       .. code-block:: bash

          #!/bin/bash
          key_dir="./"
          priv_key="${key_dir}/BOOT-GPG-PRIVKEY-SecureBootCore"
          pub_key="${key_dir}/BOOT-GPG-KEY-SecureBootCore"
          name_real="SecureBootCore"
          pw="PASSWORD"
          USE_PW="Passphrase: PASSWORD"
          cat >"${key_dir}/gen_keyring" <<EOF
          Key-Type: RSA
          Key-Length: 4096
          Name-Real: ${name_real}
          Name-Comment: EXAMPLE
          Name-Email: a@b.com
          Expire-Date: 0
          ${USE_PW}
          %commit
          %echo keyring ${name_real} created
          EOF
  
          gpg --homedir "${key_dir}" --batch --yes --gen-key "${key_dir}/gen_keyring"
          gpg --homedir "${key_dir}" -k
          gpg --homedir "${key_dir}" --export --armor "${name_real}" > "${pub_key}"
          gpg --homedir "${key_dir}" --export-secret-keys --pinentry-mode=loopback --passphrase "${pw}" --armor "${name_real}" > "${priv_key}"
          gpg --homedir "${key_dir}" --export "${name_real}" > ${key_dir}/boot_pub_key
  
       The ``BOOT-GPG-PRIVKEY-SecureBootCore`` is used to sign images mentioned
       above (kernel image, initramfs image and efitools image and so on).

    #. Signing commands to sign image files:

       * Signing command to sign type shim/grub/shimtool image files:

         .. code-block:: none

            sbsign --key $KEYPATH/$KEYNAME.key \
                   --cert $KEYPATH/$KEYNAME.crt \
                   --output $SIGNEDFILE \
                   $UNSIGNEDFILE

         * for ``-t shim``, the output file name is ``bootx64.efi``
 
         * for ``-t grub``, the output file name is ``grubx64.efi``
 
         * for ``-t shimtool``, the output file name is ${UNSIGNEDFILE}.signed

       * Signing command to sign type grub-gpg files:

         .. code-block::

                gpg2 --batch \
                    --homedir ${GPGHOME} \
                    --passphrase PASSWORD \
                    --import ${KEYPATH}/${BOOT_GPG_PRI_KEY}
                echo 'PASSWORD' | \
                gpg2 --pinentry-mode loopback \
                    --batch \
                    --homedir ${GPGHOME} \
                    -u SecureBootCore \
                    --detach-sign \
                    --passphrase-fd 0 \
                        ${FILEIN}

         Refer to :ref:`Key management <key-management-use-uefi-secure-boot>`
         to determine the keys they should use.
