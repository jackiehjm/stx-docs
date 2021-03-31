
.. psa1596720683716
.. _sr-iov-encryption-acceleration:

==============================
SR-IOV Encryption Acceleration
==============================

|prod-os| supports |PCI| |SRIOV| access for encryption acceleration.

|prod-os| supports |SRIOV| access for acceleration devices based on
Intel QuickAssist™ technology, specifically Coleto Creek 8925/8950, and C62X
chipset. Other QuickAssist™ devices are currently not supported.

If acceleration devices have to be used, the devices have to be present as
virtual devices \(qat-dh895xcc-vfor qat-c62x-vf\) on the |PCI| bus. Physical
devices \(qat-pf\) are currently not supported.

If hardware is present \(for example, Intel AV-ICE02 VPN Acceleration Card\) on
an available host, you can provide |VMs| with |PCI| passthrough access to one or
more of the supported virtual |SRIOV| acceleration devices to improve
performance for encrypted communications.

.. caution::
    Live migration is not supported for instances using |SRIOV| devices.

To expose the device to |VMs|, see :ref:`Exposing a Generic PCI Device for Use
by VMs <expose-a-generic-pci-device-for-use-by-vms>`.

.. note::
    To use |PCI| passthrough or |SRIOV| devices, you must have Intel VT-x and
    Intel VT-d features enabled in the BIOS.

