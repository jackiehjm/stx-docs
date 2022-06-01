
.. _fec-replacement-with-different-vendor-or-device-id-b1ab1440e15f:

==============================================================
Replace N3000 and ACC100 with a different vendor and device-id
==============================================================

.. rubric:: |context|

The following procedure allows the replacement of an N3000 or ACC100 FEC device on
a host, without requiring a host or system (in case of |AIO-SX|) re-install and
re-configuration, in the case of the replaced device having different vendor or
device ID information.

The normal approach to doing such a change would be to do a :command:`system
host-delete`, a :command:`system host-add` (re-install) and a re-configure of
the host. In the case of an |AIO-SX| deployment, with only one host, this
would result in a full system re-install and full system re-configuration.

In this procedure, to allow the system to update the |PCI| device database, you
must remove the current device configuration before replacing the |PCI| card
and adding in configuration for the new device.

.. warning::
    The N3000 card comes with both NIC and |FEC| functionality. If you complete
    this |FEC| procedure without executing the equivalent NIC procedure, the
    resulting network configuration may not match the new card, resulting in
    service interuptions. See
    :ref:`replace-a-nic-with-a-different-vendor-or-device-id-b406c1c190a9`
    for more information.

.. rubric:: |prereq|

Obtain the vendor and device-id of currently installed card with:

.. code-block::

   (keystone_admin)]# system host-port-show <hostname> port-name
   (keystone_admin)]# system host-device-list <hostname>

For information on replacing an N3000 or ACC100 with the same model, see
:ref:`n3000-and-acc100-replacement-with-the-same-vendor-and-device-id-cccabcdc5d43`

.. warning::

   Vendors may issue updated hardware with the same model, but with changed IDs
   and/or capabilities. You must verify that |PCI| ID and capabilities are  the
   same before proceeding or you may be forced to perform a reinstallation.

.. rubric:: |proc|

#.  If the host in question is the single host of an |AIO-SX| subcloud
    deployment, set the subcloud as unmanaged.

    .. code-block::

        ~(keystone_admin)]$ dcmanager subcloud unmanage <subcloud-name>

#.  Lock the host.

    .. code-block::

        ~(keystone_admin)]$ system host-lock <hostname>

#.  Identify the current N3000 or ACC100 module.

    .. code-block::

        ~(keystone_admin)]$ system host-device-list <hostname>

        +------------------+--------------+----------+-----------+-----------+---------------------------+-------------------------+-------------------------------------+-----------+---------+
        | name             | address      | class id | vendor id | device id | class name                | vendor name             | device name                         | numa_node | enabled |
        +------------------+--------------+----------+-----------+-----------+---------------------------+-------------------------+-------------------------------------+-----------+---------+
        | pci_0000_02_00_0 | 0000:02:00.0 | 030000   | 1a03      | 2000      | VGA compatible controller | ASPEED Technology, Inc. | ASPEED Graphics Family              | 0         | True    |
        | pci_0000_3d_00_0 | 0000:3d:00.0 | 0b4000   | 8086      | 37c8      | Co-processor              | Intel Corporation       | C62x Chipset QuickAssist Technology | 0         | True    |
        | pci_0000_3f_00_0 | 0000:3f:00.0 | 0b4000   | 8086      | 37c8      | Co-processor              | Intel Corporation       | C62x Chipset QuickAssist Technology | 0         | True    |
        | pci_0000_b2_00_0 | 0000:b2:00.0 | 120000   | 8086      | 0b30      | Processing accelerators   | Intel Corporation       | Device 0b30                         | 1         | True    |
        | pci_0000_b4_00_0 | 0000:b4:00.0 | 120000   | 8086      | 0d8f      | Processing accelerators   | Intel Corporation       | Device 0d8f                         | 1         | True    |
        | pci_0000_da_00_0 | 0000:da:00.0 | 0b4000   | 8086      | 37c8      | Co-processor              | Intel Corporation       | C62x Chipset QuickAssist Technology | 1         | True    |
        +------------------+--------------+----------+-----------+-----------+---------------------------+-------------------------+-------------------------------------+-----------+---------+

    N3000 has vendor ID 8086 and device IDs 0b30 and 0d8f. ACC100 has vendor ID
    8086 and device ID 0d5c.

#.  Record the current FEC device configuration; as shown below for the
    N3000 scenario with its FEC device 0x0d8f

    .. code-block::

        ~(keystone_admin)]$ system host-device-show <hostname> <device-name>

        +-----------------------+---------------------------------------------------------------------------------------------------------+
        | Property              | Value                                                                                                   |
        +-----------------------+---------------------------------------------------------------------------------------------------------+
        | name                  | pci_0000_b4_00_0                                                                                        |
        | address               | 0000:b4:00.0                                                                                            |
        | class id              | 120000                                                                                                  |
        | vendor id             | 8086                                                                                                    |
        | device id             | 0d8f                                                                                                    |
        ...
        | sriov_totalvfs        | 8                                                                                                       |
        | sriov_numvfs          | 8                                                                                                       |
        | sriov_vfs_pci_address | 0000:b4:00.1,0000:b4:00.2,0000:b4:00.3,0000:b4:00.4,0000:b4:00.5,0000:b4:00.6,0000:b4:00.7,0000:b4:01.0 |
        | sriov_vf_pdevice_id   | 0d90                                                                                                    |
        ...
        | driver                | igb_uio                                                                                                 |
        | sriov_vf_driver       | vfio-pci                                                                                                |
        +-----------------------+---------------------------------------------------------------------------------------------------------+


#.  Remove the |VF| configuration, if any, for device 0d8f (N3000) or 0d5c
    (ACC100).

    .. code-block::

        ~(keystone_admin)]$ system host-device-modify <hostname> <device-name-or-address> --vf-driver none -N 0

#.  Remove the driver configuration, if any, for device 0d8f (N3000) or 0d5c
    (ACC100).

    .. code-block::

       ~(keystone_admin)]$ system host-device-modify <hostname> <device-name-or-address> --driver none --enable false

#.  Power down the host manually and replace the N3000 or ACC100 |PCI| card.

#.  Power up the host.

#.  Check the new device.

    .. code-block::

       ~(keystone_admin)]$ system host-device-list <hostname>

#.  Reconfigure the device 0d8f (N3000) or 0d5c (ACC100).

    The new device's number of |VFs| is limited by the parameter
    ``sriov_totalvfs``.

    .. code-block::

        ~(keystone_admin)]$ system host-device-modify <hostname> <name-or-address> --driver <vf-driver> --vf-driver <vf driver> -N <number-of-vfs> --enable true

#.  If the replaced |PCI| card is an N3000 and its |FPGA| was not
    pre-loaded with an updated image, follow the steps described in
    :ref:`index-intel-n3000-support`.

#.  Unlock the host.

    .. code-block::

        ~(keystone_admin)]$ system host-unlock <hostname>

#.  If the host in question is the single host of an |AIO-SX| subcloud
    deployment, set the subcloud as managed.

    .. code-block::

        ~(keystone_admin)]$ dcmanager subcloud manage <subcloud-name>

