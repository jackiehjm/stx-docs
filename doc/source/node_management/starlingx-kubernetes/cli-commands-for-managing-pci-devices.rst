
.. pdy1579552315732
.. _cli-commands-for-managing-pci-devices:

=====================================
CLI Commands for Managing PCI Devices
=====================================

Several commands are available for managing |PCI| devices from the CLI.

The following commands are available for managing |PCI| devices on a host:

:command:`system host-device-list` <hostname>
    Lists the devices for a host.

:command:`system host-device-show` <hostname> <pciaddress>
    Lists the device at a specific |PCI| address on a host.

:command:`system host-device-modify` \[options\] <hostname> <pciaddress>
    Exposes a device to applications.

For example:

.. code-block:: none

    ~(keystone_admin)$ system host-device-list worker-0
    +-------+----------+--------+--------+--------+------------+-------------+----------------------+-----------+---------+
    | name  | address  | class  | vendor | device | class name | vendor name | device name          | numa_node | enabled |
    |       |          | id     | id     | id     |            |             |                      |           |         |
    +-------+----------+--------+--------+--------+------------+-------------+----------------------+-----------+---------+
    | pci_0 | 0000:0c: | 030000 | 102b   | 0522   | VGA        | Matrox      | MGA G200e [Pilot]    | 0         | True    |
    | 000_0 | 00.0     |        |        |        | compatible | Electronics | ServerEngines (SEP1) |           |         |
    | c_00_ |          |        |        |        | controller | Systems Ltd |                      |           |         |
    | 0     |          |        |        |        |            |             |                      |           |         |
    |       |          |        |        |        |            |             |                      |           |         |
    |pci_0  | 0000:b7: | 120000 | 8086   | 0d8f   | Processing |Intel        | Device 0d8f          | 1         | True    |
    |000_b7 | 00.0     |        |        |        |accelerators|Corporation  |                      |           |         |
    |_00_0  |          |        |        |        |            |             |                      |           |         |
    |       |          |        |        |        |            |             |                      |           |         |
    +-------+----------+--------+--------+--------+------------+-------------+----------------------+-----------+---------+

    ~(keystone_admin)$ system host-device-show worker-0 0000:0c::00.0
    +-----------------------+----------------------------------------+
    | Property              | Value                                  |
    +-----------------------+----------------------------------------+
    | name                  | pci_0000_0c_00_0                       |
    | address               | 0000:0c:00.0                           |
    | class id              | 030000                                 |
    | vendor id             | 102b                                   |
    | device id             | 0522                                   |
    | class name            | VGA compatible controller              |
    | vendor name           | Matrox Electronics Systems Ltd.        |
    | device name           | MGA G200e [Pilot] ServerEngines (SEP1) |
    | numa_node             | 0                                      |
    | enabled               | True                                   |
    | sriov_totalvfs        | None                                   |
    | sriov_numvfs          | 0                                      |
    | sriov_vfs_pci_address |                                        |
    | extra_info            |                                        |
    | created_at            | 2020-01-02T15:47:00.900816+00:00       |
    | updated_at            | None                                   |
    +-----------------------+----------------------------------------+

    ~(keystone_admin)$ system host-device-modify --name="Encryption1" --enable=True worker-0 0000:09:00.0
