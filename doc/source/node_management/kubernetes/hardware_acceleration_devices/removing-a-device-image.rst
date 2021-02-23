
.. uks1591727490244
.. _removing-a-device-image:

=====================
Remove a Device Image
=====================

You can remove a device image, either from all devices in the system or only
from those matching a specified label.

.. rubric:: |proc|

-   Use one of the following options to remove a device image with a specific
    label or all device images.


    -   The command syntax to remove a device image from all devices is:

        .. code-block:: none

            system device-image-remove <image_uuid>

    -   The command syntax to remove the device image from all devices with a
        matching label is:

        .. code-block:: none

            system device-image-remove <image_uuid> <key1>=<value1>
