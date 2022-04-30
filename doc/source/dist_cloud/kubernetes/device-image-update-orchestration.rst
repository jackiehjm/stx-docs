
.. cxh1597317861150
.. _device-image-update-orchestration:

=================================
Device Image Update Orchestration
=================================

In a |prod-dc| environment, you can use orchestration strategies to manage
device image updates, including |FPGA| updates.

.. rubric:: |context|

.. note::
    Due to limitations with the existing device image update mechanisms for the
    N3000 |FPGA| hardware, applying more than one image at a time to a given
    hardware device is currently not supported. If multiple device images are
    to be written to a single device, such as a root-key image and a functional
    image, the first device image should be applied, then dcmanager should be
    used to create and apply an update strategy. Once the update strategy has
    completed then the second device image should be applied and dcmanager
    should be used to create and apply a second update strategy for the second
    device image.

.. note::

    For |BMC| images on N3000 |FPGA| hardware, it is recommended that the
    admin user uses the **md5sum** of the device image file as the bitstream
    ID. This will ensure that different files get unique IDs, and the same
    file gets the same ID.

.. rubric:: |prereq|


.. _device-image-update-orchestration-ul-mwd-pfb-smb:

-   Only one type of dcmanager strategy can exist at a time. Run
    :command:`dcmanager fw-update-strategy delete` to delete any existing
    strategies before creating a new update (patch) strategy. Similarly, after
    using an update (patch) strategy you will need to delete it before
    creating a fw-update strategy.

-   Before applying a new functional device image for the same |PCI|
    vendor/device and label as a functional image that has already been applied,
    you need to remove the previous device image from that label using the
    following command:

    .. code-block:: none

        system --os-region-name SystemController device-image-remove image_uuid <name>=<value>

.. rubric:: |proc|

#.  Assign labels to |PCI| devices in each subcloud.

    #.  List known devices on a host.

        To list devices from a subcloud, run:

        .. code-block:: none

            ~(keystone_admin)]$ system host-device-list <hostname_or_id>

        To list devices from the Central cloud, run:

        .. code-block:: none

            ~(keystone_admin)]$ system  --os-region-name <region> --os-auth-url <subcloud_keystone_url> host-device-list <hostname_or_id>

    #.  Assign labels.

        .. code-block:: none

            ~(keystone_admin)]$ system host-device-label-assign [--overwrite] <hostname_or_id> <pci_name_or_address> <name>=<value> [<name>=<value> ...]

        .. warning::

            It is recommended not to apply a **functional** device image for a
            given hardware device with a specific label, and a different
            **functional** device image for the same hardware device with a
            different label. This can cause **dcmanager** to toggle between the
            two device images every time :command:`device-image-apply` is run.

            Either use single label for each hardware device, or use caution to
            avoid this scenario if using multiple device labels per device.

#.  From the Central cloud, upload one or more device images in the System
    Controller region.

    -   To upload a root-key device image:

        .. code-block:: none

            ~(keystone_admin)]$ system --os-region-name SystemController device-image-upload <imagefile> root-key <pci_vendor> <pci_device> --key-signature <key_signature> --name <imagename> --description <description> --image-version <version>

    -   To upload a revocation key device image:

        .. code-block:: none

            ~(keystone_admin)]$ system --os-region-name SystemController device-image-upload <imagefile> key-revocation <pci_vendor> <pci_device> --revoke-key-id <revoke_key_id> --name <imagename> --description <description> --image-version <version>

    -   To upload a functional device image:

        .. code-block:: none

            ~(keystone_admin)]$ system --os-region-name SystemController device-image-upload <imagefile> functional <pci_vendor> <pci_device> --bitstream-id <bitstream_id> --name <imagename> --description <description> --image-version <version>


    For more information about uploading images, see |node-doc|:
    :ref:`Uploading a Device Image <uploading-a-device-image>`.

#.  Apply one or more device images in the System Controller region.

    You can apply multiple device images in the System Controller region
    provided they are for different devices or different labels.

    .. note::

        If you have applied multiple device labels per device, use caution to
        avoid toggling between the two device images due to both labels being
        applied to the same device.

    .. code-block:: none

        ~(keystone_admin)]$ system --os-region-name SystemController device-image-apply <image_uuid>

    For more information about applying images, see |node-doc|: :ref:`Updating
    an Intel N3000 FPGA Image <updating-an-intel-n3000-fpga-image>`.

#.  Create an update strategy using the :command:`fw-update-strategy create`
    command.

    The update strategy controls how |FPGA| updates are applied to hosts on
    subclouds.

    .. code-block:: none

        ~(keystone_admin)]$ dcmanager fw-update-strategy create \
        [--subcloud-apply-type <type>] \
        [–-max-parallel-subclouds <i>] \
        [–-stop-on-failure true|false ] \
        [--group group] \
        [<subcloud>]

    where:

    **subcloud-apply-type**
        parallel or serial — determines whether the subclouds are updated in
        parallel, or serially.

        If this is not specified using the |CLI|, the values for
        :command:`subcloud_update_type` defined for each subcloud group will
        be used by default.

    **max-parallel-subclouds**
        Sets the maximum number of subclouds that can be updated in parallel
        \(default 20\).

        If this is not specified using the |CLI|, the values for
        :command:`max_parallel_subclouds` defined for each subcloud group
        will be used by default.

    **stop-on-failure**
        true or false \(default\) — determines whether update orchestration
        failure for a subcloud prevents application to subsequent subclouds.

    **group**
        Optionally pass the name or ID of a subcloud group to the
        :command:`fw-update-strategy create` command. This results in a
        strategy that is only applied to all subclouds in the specified group.
        The subcloud group values are used for subcloud apply type and max
        parallel subclouds parameters.

    For example:

    .. code-block:: none

        ~(keystone_admin)]$ dcmanager fw-update-strategy create
        +------------------------+----------------------------+
        | Field                  | Value                      |
        +------------------------+----------------------------+
        | strategy type          | firmware                   |
        | subcloud apply type    | None                       |
        | max parallel subclouds | None                       |
        | stop on failure        | False                      |
        | state                  | initial                    |
        | created_at             | 2020-08-11T18:13:40.576659 |
        | updated_at             | None                       |
        +------------------------+----------------------------+

#.  Apply the firmware update strategy.

    .. code-block:: none

        ~(keystone_admin)]$ dcmanager fw-update-strategy apply
        +------------------------+----------------------------+
        | Field                  | Value                      |
        +------------------------+----------------------------+
        | strategy type          | firmware                   |
        | subcloud apply type    | None                       |
        | max parallel subclouds | None                       |
        | stop on failure        | False                      |
        | state                  | applying                   |
        | created_at             | 2020-08-11T18:13:40.576659 |
        | updated_at             | 2020-08-11T18:13:56.525459 |
        +------------------------+----------------------------+


#.  Monitor progress as the strategy is applied.


    -   To monitor the step currently being performed on all subclouds, do the
        following:

        .. code-block:: none

            ~(keystone_admin)]$ dcmanager strategy-step list
            +-----------+-------+----------+------------------------------+----------------------------+----------------------------+
            | cloud     | stage | state    | details                      | started_at                 | finished_at                |
            +-----------+-------+----------+------------------------------+----------------------------+----------------------------+
            | subcloud1 |     2 | complete |                              | 2020-08-13 14:12:11.223001 | 2020-08-13 14:15:52.450908 |
            +-----------+-------+----------+------------------------------+----------------------------+----------------------------+
            | subcloud2 |     2 | applying | apply phase is 66% complete  | 2020-08-13 14:12:12.262001 | None                       |
            +-----------+-------+----------+------------------------------+----------------------------+----------------------------+
            | subcloud3 |     2 | applying | apply phase is 18% complete  | 2020-08-13 14:12:13.457588 | None                       |
            +-----------+-------+----------+------------------------------+----------------------------+----------------------------+


    -   To monitor the step currently being performed on a specific subcloud,
        do the following:

        .. code-block:: none

            ~(keystone_admin)]$ dcmanager strategy-step show <subcloud_name>
            +-------------+----------------------------+
            | Field       | Value                      |
            +-------------+----------------------------+
            | cloud       | subcloud1                  |
            | stage       | 2                          |
            | state       | complete                   |
            | details     |                            |
            | started_at  | 2020-08-11 18:53:52.738079 |
            | finished_at | 2020-08-11 18:54:04.886140 |
            | created_at  | 2020-08-11 18:53:31.962478 |
            | updated_at  | 2020-08-11 18:54:04.907063 |
            +-------------+----------------------------+

#.  If, for any reason, you need to cancel a strategy during application, use
    the :command:`fw-update-strategy abort` command.

    .. note::

        This command completes the current updating stage before aborting, to
        prevent hosts from being left in a locked state requiring manual
        intervention. It has no effect on strategies in the completed state.

    .. code-block:: none

        ~(keystone_admin)]$ dcmanager fw-update-strategy abort
        +------------------------+----------------------------+
        | Field                  | Value                      |
        +------------------------+----------------------------+
        | strategy type          | firmware                   |
        | subcloud apply type    | None                       |
        | max parallel subclouds | None                       |
        | stop on failure        | False                      |
        | state                  | abort requested            |
        | created_at             | 2020-08-11T19:13:41.153044 |
        | updated_at             | 2020-08-11T19:13:54.121796 |
        +------------------------+----------------------------+

.. rubric:: |postreq|

When done, delete the strategy:

.. code-block:: none

    ~(keystone_admin)]$ dcmanager fw-update-strategy delete
    +------------------------+----------------------------+
    | Field                  | Value                      |
    +------------------------+----------------------------+
    | strategy type          | firmware                   |
    | subcloud apply type    | None                       |
    | max parallel subclouds | None                       |
    | stop on failure        | False                      |
    | state                  | deleting                   |
    | created_at             | 2020-08-11T18:53:31.929881 |
    | updated_at             | 2020-08-11T19:13:03.820865 |
    +------------------------+----------------------------+

