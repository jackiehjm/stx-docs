
.. dze1596720804160
.. _generic-pci-passthrough:

=======================
Generic PCI Passthrough
=======================

.. rubric:: |prereq|

Before you can enable a device, you must lock the compute host.

If you want to enable a device that is in the inventory for pci-passthrough,
the device must be enabled and a Nova |PCI| Alias must be configured with
vendor-id, product-id and alias name.

You can use the following command from the |CLI|, to view devices that are
automatically inventoried on a host:

.. code-block:: none

    ~(keystone_admin)$ system host-device-list controller-0 --all


You can use the following command from the |CLI| to list the devices for a
host, for example:

.. code-block:: none

    ~(keystone_admin)$ system host-device-list --all controller-0
    +-------------+----------+------+-------+-------+------+--------+--------+-------------+-------+
    | name        | address  | class| vendor| device| class| vendor | device | numa_node   |enabled|
    |             |          | id   | id    | id    |      | name   | name   |             |       |
    +------------+----------+-------+-------+-------+------+--------+--------+-------------+-------+
    | pci_0000_05.| 0000:05:.| 030. | 10de  | 13f2  | VGA. | NVIDIA.| GM204GL| 0           | True  |
    | pci_0000_06.| 0000:06:.| 030. | 10de  | 13f2  | VGA. | NVIDIA.| GM204GL| 0           | True  |
    +-------------+----------+------+-------+-------+------+--------+--------+-------------+-------+

The ``--alloption`` displays both enabled and disabled devices.

.. note::

    Depending on the system, not all devices in this list can be accessed via
    pci-passthrough, based on hardware/driver limitations.

To enable or disable a device using the |CLI|, do the following:

.. rubric:: |prereq|

To edit a device, you must first lock the host.

.. rubric:: |proc|

#.  Enable the device.

    .. code-block:: none

        ~(keystone_admin)$ system host-device-modify <compute_node>
        <pci_address> --enable=True

#.  Add a |PCI| alias.

    For more information, see :ref:`Configuring a PCI Alias in Nova
    <configuring-a-pci-alias-in-nova>`.

.. rubric:: |postreq|

Refer to :ref:`Configuring a Flavor to Use a Generic PCI Device
<configuring-a-flavor-to-use-a-generic-pci-device>` for details on how to
launch the |VM| with a |PCI| interface to this Generic |PCI| Device.

