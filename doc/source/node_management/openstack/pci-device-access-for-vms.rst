
.. sip1596720928269
.. _pci-device-access-for-vms:

=========================
PCI Device Access for VMs
=========================

You can provide |VMs| with |PCI| passthrough or |SRIOV| access to network interface
cards and other |PCI| devices.

.. note::

    To use |PCI| passthrough or |SRIOV| devices, you must have Intel-VTx and
    Intel VT-d features enabled in the BIOS.

.. note::

    When starting a |VM| where interfaces have **binding\_vif\_type**, the
    following parameter is required for the |VM| flavor, hw:mem\_page\_size=large
    enabled

    where, page size is one of the following:


.. _pci-device-access-for-vms-ul-cz3-mtd-z4b:

-   small: Requests the smallest available size on the compute node, which
    is always 4KiB of regular memory.

-   large: Requests the largest available huge page size, 1GiB or 2MiB.

-   any: Requests any available size, including small pages. |prod|
    uses the largest available size, 1GiB, then 2MiB, and then 4KiB.


For a network interface card, you can provide |VM| access by configuring the
network interface. For more information, see :ref:`Configuring PCI Passthrough
Ethernet Interfaces <configure-pci-passthrough-ethernet-interfaces>`.

For other types of device, you can provide |VM| access by assigning a |PCI|
alias to the device, and then referencing the |PCI| alias in a flavor extra
specification. For more information, see :ref:`Expose a Generic PCI Device for
Use by VMs <expose-a-generic-pci-device-for-use-by-vms>` and :ref:`Configuring
a Flavor to Use a Generic PCI Device
<configuring-a-flavor-to-use-a-generic-pci-device>`.

-   :ref:`PCI Passthrough Ethernet Interface Devices <pci-passthrough-ethernet-interface-devices>`

-   :ref:`Configuring PCI Passthrough Ethernet Interfaces <configure-pci-passthrough-ethernet-interfaces>`

-   :ref:`PCI SR-IOV Ethernet Interface Devices <pci-sr-iov-ethernet-interface-devices>`

-   :ref:`Generic PCI Passthrough <generic-pci-passthrough>`

-   :ref:`SR-IOV Encryption Acceleration <sr-iov-encryption-acceleration>`

-   :ref:`Expose a Generic PCI Device for Use by VMs <expose-a-generic-pci-device-for-use-by-vms>`

-   :ref:`Exposing a Generic PCI Device Using the CLI <exposing-a-generic-pci-device-using-the-cli>`

-   :ref:`Configure a Flavor to Use a Generic PCI Device <configuring-a-flavor-to-use-a-generic-pci-device>`


