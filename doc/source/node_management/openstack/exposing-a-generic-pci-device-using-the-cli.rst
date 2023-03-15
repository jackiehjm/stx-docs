
.. dxo1596720611892
.. _exposing-a-generic-pci-device-using-the-cli:

=========================================
Expose a Generic PCI Device Using the CLI
=========================================

For generic PCI-passthrough or |SRIOV| devices (i.e not network interface
devices or cards), you can configure |VM| access using the |CLI|.

.. rubric:: |context|

To expose a device for |VM| access, you must


.. _exposing-a-generic-pci-device-using-the-cli-ul-zgb-zpc-fcb:

-   enable the device on each host where it is installed

-   assign a system-wide |PCI| alias to the device. For more information, see
    :ref:`Configuring a PCI Alias in Nova <configuring-a-pci-alias-in-nova>`.

.. rubric:: |prereq|

To edit a device, you must first lock the host.

.. rubric:: |proc|

#.  List the non-|NIC| devices on the host for which |VM| access is supported. Use
    ``-a`` to list disabled devices.

    .. code-block:: none

        ~(keystone_admin)$ system host-device-list compute-0 -a
        +------------+----------+------+-------+-------+------+--------+--------+-----------+---------+
        | name       | address  | class| vendor| device| class| vendor | device | numa_node | enabled |
        |            |          | id   | id    | id    |      |  name  | name   |           |         |
        +------------+----------+------+-------+-------+------+--------+--------+-----------+---------+
        |pci_0000_05.| 0000:05:.| 030. | 10de  | 13f2  | VGA. | NVIDIA.| GM204GL| 0         | True    |
        |pci_0000_06.| 0000:06:.| 030. | 10de  | 13f2  | VGA. | NVIDIA.| GM204GL| 0         | True    |
        |pci_0000_00.| 0000:00:.| 0c0. | 8086  | 8d2d  | USB  | Intel  | C610/x9| 0         | False   |
        +------------+----------+------+-------+-------+------+--------+--------+-----------+---------+

    This list shows the |PCI| address needed to enable a device, and the device
    ID and vendor ID needed to add a |PCI| Alias.

#.  On each host where the device is installed, enable the device.

    .. code-block:: none

        ~(keystone_admin)$system host-device-modify <hostname> <pci_address>
        --enable=True [--name="<devicename>"]

    where

    **<hostname>**
        is the name of the host where the device is installed

    **<pci_address>**
        is the address shown in the device list

    **<devicename>**
        is an optional descriptive name for display purposes

    For example:

    .. code-block:: none

        ~(keystone_admin)$ system host-device-modify --name="Encryption1" --enable=True compute-0 0000:09:00.0

#.  Assign a |PCI| alias.

    The |PCI| alias is a system-wide setting. It is used for all devices of the
    same type across multiple hosts. For more information, see
    :ref:`Configuring a PCI Alias in Nova <configuring-a-pci-alias-in-nova>`.

    As the change is applied, **Config-out-of-date** alarms are raised. The
    alarms are automatically cleared when the change is complete.

.. rubric:: |result|

The device is added to the list of available devices.

.. rubric:: |postreq|

To access a device from a |VM|, you must configure a flavor with a reference to
the |PCI| alias. For more information, see :ref:`Configuring a Flavor to Use a
Generic PCI Device <configuring-a-flavor-to-use-a-generic-pci-device>`.

