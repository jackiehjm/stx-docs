
.. uvy1591726512485
.. _removing-a-device-label:

=====================
Remove a Device Label
=====================

Device labels can be removed from a device by specifying the label key.

The command format is:

.. code-block:: none

    system host-device-label-remove <hostname_or_id> <pci_name_or_address> <name> [<name> ...]

.. rubric:: |eg|

-   Remove key1 associated with a |PCI| device from controller-0.

    .. code-block:: none

        ~(keystone_user)$ system host-device-label-remove controller-0 0000:b3:00.0 key1
