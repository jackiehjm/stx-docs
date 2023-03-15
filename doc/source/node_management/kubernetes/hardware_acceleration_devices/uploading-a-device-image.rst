
.. gxj1590080636728
.. _uploading-a-device-image:

=====================
Upload a Device Image
=====================

.. rubric:: |prereq|

The device image must exist where the system command is executed, such as a
remote CLI, before proceeding.

.. note::
    For |BMC| images on N3000 |FPGA| hardware, it is recommended that the
    admin user uses the **md5sum** of the device image file as the bitstream
    ID. This will ensure that different files get unique IDs, and the same
    file gets the same ID.

.. rubric:: |proc|

-   Upload the device image.

    -   To upload a root-key device image:

        .. code-block:: none

            ~(keystone_admin)$ system device-image-upload <imagefile> root-key <pci_vendor> <pci_device> --key-signature <key_signature> --name <imagename> --description <description> --image-version <version>

    -   To upload a revocation key device image:

        .. code-block:: none

            ~(keystone_admin)$ system device-image-upload <imagefile> key-revocation <pci_vendor> <pci_device> --revoke-key-id <revoke_key_id> --name <imagename> --description <description> --image-version <version>

    -   To upload a functional device image:

        .. code-block:: none

            ~(keystone_admin)$ system device-image-upload <imagefile> functional <pci_vendor> <pci_device> --functional <bitstream_id> --name <imagename> --description <description> --image-version <version>

    In the above :command:`device-image-upload` commands, the following
    substitutions apply:

    **<imagefile>**
        The filepath of the binary device image file.

    **<pci_vendor>**
        The hexadecimal string identifying the |PCI| vendor ID of the device
        this image applies to.

    **<pci_device>**
        The hexadecimal string identifying the |PCI| device ID of the device
        this image applies to.

    **<key_signature>**
        A hexadecimal string identifying the root key device image.

    **<revoke_key_id>**
        A decimal key ID for the key revocation device image.

    **<bitstream_id>**
        A hexadecimal string of the functional device image.

    **<name>**
        The name of the device image (optional).

    **<description>**
        Is the description of the device image (optional).

    **<image-version>**
        The version of the device image (optional).
