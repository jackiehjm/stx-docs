
.. yui1591714746999
.. _updating-an-intel-n3000-fpga-image:

==========================
Update an N3000 FPGA Image
==========================

The N3000 |FPGA| as shipped from the factory is expected to have production
|BMC| and factory images. The following procedure describes how to update the
N3000 |FPGA| user image on a |prod| host.

.. note::
    |prod| does not support the |FPGA| prestart CRI-O hook. |FPGA|
    programming must be performed manually.

.. _updating-an-intel-n3000-fpga-image-section-obd-kky-1mb:

------------------
Device Image Types
------------------

There are three types of device images, root-key, functional, and
key-revocation.

**root-key**
    The root-key image sets the main authentication key on the hardware.

**functional**
    The functional device image performs the desired work on behalf of the
    application. If a root-key device image has been written to the hardware,
    then the functional image will only be accepted if it has been signed by
    a |CSK| generated from the root key which has not
    been revoked.

**key-revocation**
    The key-revocation device image will revoke a |CSK|. If a root-key device
    image has been written to the hardware, then the key-revocation device
    image will only be accepted if it has been signed by the root key.

Specifically for the N3000, the root-key image can only be set
once, |CSKs| are revoked by specifying an integer |CSK| ID, and there are 128
|CSK| ID cancellation slots. In the Intel literature the root-key device image
is known as the "root entry hash bitstream", the functional device image is
known as the "user image", and the key-revocation device image is known as the
"|CSK| ID cancellation bitstream". For the N3000, a |CSK| is revoked by
specifying an integer ID, and all |CSKs| with that ID will be revoked. Writing
the root-key device image or a key-revocation device image is essentially
permanent. Reverting to factory status requires physical access to the card and
specialized equipment.

.. rubric:: |prereq|

.. _updating-an-intel-n3000-fpga-image-ul-p45-zzv-nkb:

-   Before adding or updating |FPGA| support, read

    `<https://www.intel.com/content/dam/www/programmable/us/en/pdfs/literature/ug/ug-ias-n3000.pdf>`_

    and particularly Chapter 8, *Configuring Ethernet Interfaces*, to
    understand how to properly configure the N3000 |NICs|.

-   If you are using your own load, you must have it compiled for the N3000
    |FPGA|.

-   Familiarize yourself with setting the |MTU| on a |NIC|.

    See |datanet-doc|: :ref:`Add Data Networks Using the CLI
    <adding-data-networks-using-the-cli>` and
    :ref:`Attach Ethernet Interfaces to Networks Using the CLI
    <attaching-ethernet-interfaces-to-networks-using-the-cli>`.

-   The host should be unlocked.

.. rubric:: |proc|

#.  Upload the device image.

    -   To upload a root-key device image:

        .. code-block:: none

            ~(keystone_admin)$ system device-image-upload <imagefile> root-key <pci_vendor> <pci_device> --key-signature <key_signature> --name <imagename> --description <description> --image-version <version>

    -   To upload a revocation key device image:

        .. code-block:: none

            ~(keystone_admin)$ system device-image-upload <imagefile> key-revocation <pci_vendor> <pci_device> --revoke-key-id <revoke_key_id> --name <imagename> --description <description> --image-version <version>

    -   To upload a functional device image:

        .. code-block:: none

            ~(keystone_admin)$ system device-image-upload <imagefile> functional <pci_vendor> <pci_device> --bitstream-id <bitstream_id> --name <imagename> --description <description> --image-version <version> --retimer-included <true/false>

    In the above :command:`device-image-upload` commands, the following
    substitutions apply:

    ``<imagefile>``
        The filepath of the binary device image file.

    ``<pci_vendor>``
        The hexadecimal string identifying the |PCI| vendor ID of the device
        this image applies to.

    ``<pci_device>``
        The hexadecimal string identifying the |PCI| device ID of the device
        this image applies to.

    ``<key_signature>``
        A hexidecimal string identifying the root key device image.

    ``<revoke_key_id>``
        A decimal key ID for the key revocation device image.

    ``<bitstream_id>``
        A hexidecimal string of the functional device image.

    ``<name>``
        The name of the device image \(optional\).

    ``<description>``
        Is the description of the device image \(optional\).

    ``<image-version>``
        The version of the device image \(optional\).

    ``--retimer-included <true/false>``
        A boolean indicates whether the |BMC| firmware includes a retimer
        firmware (optional).

#.  Assign a device label to the device.

    Labels are key-value pairs that are assigned to host |PCI| devices and are
    used to specify attributes of the devices. Labels can be used to identify
    certain properties of the |PCI| devices where the same device image can be
    used.

    The command syntax is:

    .. code-block:: none

        system host-device-label-assign [--overwrite] <hostname_or_id> <pci_name_or_address> <name>=<value> [<name>=<value> ...]

    For example:

    .. code-block:: none

        ~(keystone_admin)$ system host-device-label-assign controller-0 0000:b3:00.0 key1=value1
        +-------------+--------------------------------------+
        | Property    | Value                                |
        +-------------+--------------------------------------+
        | uuid        | 789be75d-7ac3-472e-bbbc-6d62878aad4a |
        | label_key   | key1                                 |
        | label_value | value1                               |
        +-------------+--------------------------------------+


    The label can be overwritten using the ``--overwrite`` option. This option
    is not allowed while the image update is in progress after running
    :command:`host-device-image-update`.

    Once assigned, a device label can be referenced by multiple
    :command:`device-image-apply` commands.

#.  Apply the device image on one or all supported devices.

    .. note::
        A **device firmware update in progress** alarm is raised once the
        first device image is applied.

        The :command:`system device-image-state-list` will show the status
        of the device as **pending**.

    -   Apply a device image to all supported devices:

        .. code-block:: none

            ~(keystone_admin)$ system device-image-apply <image_uuid>

    -   Alternatively, apply a device image to devices with a specified label:

        .. code-block:: none

            ~(keystone_admin)$ system device-image-apply image_uuid <key1>=<value1>

    When applying functional device images :command:`device-image-apply` will
    remove any existing **pending** or **completed** functional device image
    state entries for that device. Additionally, any in-progress device image
    updates will block the **apply** operation.

    For root-key device images, :command:`device-image-apply` will be blocked
    if a root-key device image has already been applied.

#.  Write pending device images on the host to hardware.

    .. code-block:: none

        ~(keystone)admin)$ system host-device-image-update <hostname>

    .. note::
        This operation currently supports one pending device image at a time.

    Any previously-attempted device image writes for this host that are in a
    **failed** state will be reset to **pending** and retried.

    Root and revocation key updates can be expected to take 1-2 minutes.
    Functional image updates can take approximately 40 minutes for the
    N3000 |FPGA|.

    -   Once a device update is complete,
        :command:`system device-image-state-list` will show the status as
        **completed** for that device/image.

    -   Once all pending device updates for the host are complete,
        :command:`system host-show` <hostname> will again display an empty
        string for **device_image_update**.

#.  Lock and unlock the host.

    For example:

    .. code-block:: none

        ~(keystone_admin)$ system host-lock controller-0
        ~(keystone_admin)$ system host-unlock controller-0

#.  Upload, apply, and update any additional key-revocation device images
    or functional device images as needed.

    New device images can be uploaded as needed, and already-uploaded images
    can be applied with new labels. Devices can also have new labels applied
    to them and any device images with matching labels will be automatically
    applied.

    .. note::
        The N3000 supports a maximum of 128 code-signing key IDs.
