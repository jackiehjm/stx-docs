
.. akw1596720643112
.. _expose-a-generic-pci-device-for-use-by-vms:

==========================================
Expose a Generic PCI Device for Use by VMs
==========================================

You can configure generic |PCI|-passthrough or |SRIOV| devices (i.e. not network
interface devices/cards) so that they are accessible to |VMs|.

.. rubric:: |context|

.. note::

    For network cards, you must use the network interface settings to configure
    VM access. You can do this from either the |os-prod-hor| interface or
    the |CLI|. For more information, see :ref:`Configuring PCI Passthrough
    Ethernet Interfaces <configure-pci-passthrough-ethernet-interfaces>`.

For generic |PCI|-passthrough or SR-IOV devices, you must


.. _expose-a-generic-pci-device-for-use-by-vms-ul-zgb-zpc-fcb:

-   on each host where an instance of the device is installed, enable the
    device For this, you can use the |os-prod-hor| interface or the |CLI|.

-   assign a system-wide |PCI| alias to the device. For this, you must use the
    |CLI|.


To enable devices and assign a |PCI| alias using the |CLI|, see :ref:`Exposing a
Generic PCI Device Using the CLI
<exposing-a-generic-pci-device-using-the-cli>`.

.. rubric:: |prereq|

To edit a device, you must first lock the host.

.. rubric:: |proc|

#.  Select the **Devices** tab on the Host Detail page for the host.

#.  Click **Edit Device**.

    .. image:: /node_management/figures/jow1452530556357.png


#.  Update the information as required.

    **Name**
        Sets the system inventory name for the device.

    **Enabled**
        Controls whether the device is exposed for use by |VMs|.

#.  Repeat the above steps for other hosts where the same type of device is
    installed.

#.  Assign a |PCI| alias.

    The |PCI| alias is a system-wide setting. It is used for all devices of the
    same type across multiple hosts.

    For more information, see :ref:`Configuring a PCI Alias in Nova
    <configuring-a-pci-alias-in-nova>`.

.. rubric:: |postreq|

After completing the steps above, unlock the host.

To access a device from a |VM|, you must configure a flavor with a reference to
the |PCI| alias. For more information, see :ref:`Configuring a Flavor to Use a
Generic PCI Device <configuring-a-flavor-to-use-a-generic-pci-device>`.

