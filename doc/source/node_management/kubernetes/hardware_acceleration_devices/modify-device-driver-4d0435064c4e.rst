.. _modify-device-driver-4d0435064c4e:

====================
Modify Device Driver
====================

The following procedure shows an example how to modify the device driver from
``igb_uio`` to ``vfio-pci``.

.. rubric:: |prereq|

The system has been provisioned and unlocked.

.. rubric:: |proc|

#.  Source the platform environment.

    .. code-block:: none

        $ source /etc/platform/openrc
        ~(keystone_admin)]$

#.  Lock controller-0.

    .. code-block:: none

        ~(keystone_admin)$ system host-lock controller-0

#.  Show the existing device.

    .. code-block:: none

        ~(keystone_admin)$ system host-device-list controller-0
        ~(keystone_admin)$ system host-device-show controller-0 0000:18:00.0
        +-----------------------+---------------------------------------------------------------------------------------+
        | Property              | Value                                                                                 |
        +-----------------------+---------------------------------------------------------------------------------------+
        | name                  | pci_0000_18_00_0                                                                      |
        | address               | 0000:18:00.0                                                                          |
        | class id              | 120001                                                                                |
        | vendor id             | 8086                                                                                  |
        | device id             | 0d5c                                                                                  |
        | class name            | Processing accelerators                                                               |
        | vendor name           | Intel Corporation                                                                     |
        | device name           | Device 0d5c                                                                           |
        | numa_node             | 0                                                                                     |
        | enabled               | True                                                                                  |
        | sriov_totalvfs        | 16                                                                                    |
        | sriov_numvfs          | 1                                                                                     |
        | sriov_vfs_pci_address | 0000:19:00.0                                                                          |
        | sriov_vf_pdevice_id   | 0d5d                                                                                  |
        | extra_info            | {'expected_numvfs': 1, 'expected_driver': 'igb_uio', 'expected_vf_driver': 'igb_uio'} |
        | created_at            | 2023-03-28T15:39:33.083178+00:00                                                      |
        | updated_at            | 2023-03-28T18:27:23.950595+00:00                                                      |
        | root_key              | None                                                                                  |
        | revoked_key_ids       | None                                                                                  |
        | boot_page             | None                                                                                  |
        | bitstream_id          | None                                                                                  |
        | bmc_build_version     | None                                                                                  |
        | bmc_fw_version        | None                                                                                  |
        | retimer_a_version     | None                                                                                  |
        | retimer_b_version     | None                                                                                  |
        | driver                | igb_uio                                                                               |
        | sriov_vf_driver       | igb_uio                                                                               |
        +-----------------------+---------------------------------------------------------------------------------------+

#.  Remove the |VF| configuration for the device.

    .. code-block:: none

        ~(keystone_admin)$ system host-device-modify controller-0 0000:18:00.0 --vf-driver none -N 0

#.  Set the |VF| driver to ``vfio-pci``.

    .. code-block:: none

        ~(keystone_admin)$ system host-device-modify controller-0 0000:18:00.0 --driver vfio-pci --vf-driver vfio -N 1
        +-----------------------+-------------------------------------------------------------------------------------+
        | Property              | Value                                                                               |
        +-----------------------+-------------------------------------------------------------------------------------+
        | name                  | pci_0000_18_00_0                                                                    |
        | address               | 0000:18:00.0                                                                        |
        | class id              | 120001                                                                              |
        | vendor id             | 8086                                                                                |
        | device id             | 0d5c                                                                                |
        | class name            | Processing accelerators                                                             |
        | vendor name           | Intel Corporation                                                                   |
        | device name           | Device 0d5c                                                                         |
        | numa_node             | 0                                                                                   |
        | enabled               | True                                                                                |
        | sriov_totalvfs        | 16                                                                                  |
        | sriov_numvfs          | 1                                                                                   |
        | sriov_vfs_pci_address | 0000:19:00.0                                                                        |
        | sriov_vf_pdevice_id   | 0d5d                                                                                |
        | extra_info            | {'expected_numvfs': 1, 'expected_driver': 'vfio-pci', 'expected_vf_driver': 'vfio'} |
        | created_at            | 2023-03-28T15:39:33.083178+00:00                                                    |
        | updated_at            | 2023-03-28T18:14:25.920137+00:00                                                    |
        | root_key              | None                                                                                |
        | revoked_key_ids       | None                                                                                |
        | boot_page             | None                                                                                |
        | bitstream_id          | None                                                                                |
        | bmc_build_version     | None                                                                                |
        | bmc_fw_version        | None                                                                                |
        | retimer_a_version     | None                                                                                |
        | retimer_b_version     | None                                                                                |
        | driver                | vfio-pci                                                                            |
        | sriov_vf_driver       | vfio                                                                                |
        +-----------------------+-------------------------------------------------------------------------------------+

#.  Unlock the host.

    .. code-block:: none

        $ system host-unlock controller-0
