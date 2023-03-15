
.. zad1611611564761
.. _enabling-mount-bryce-hw-accelerator-for-hosted-vram-containerized-workloads:

==================================================================================
Enable ACC100/ACC200 Hardware Accelerators for Hosted vRAN Containerized Workloads
==================================================================================

You can enable and access ACC100/ACC200 eASIC card from Intel® such
that it can be used as a HW accelerator by hosted vRAN containerized workloads
on |prod-long|.

.. rubric:: |context|

The following procedure shows an example of configuring an |AIO-SX| system such
that it can support hosting a |DPDK| FlexRAN-reference-architecture container
image that uses the ACC100/ACC200 HW accelerator. The procedure enables the
required |SRIOV| drivers, CPU policies and memory of controller-0, and then
enables the ACC100/ACC200 device.

.. rubric:: |prereq|


.. _enabling-mount-bryce-hw-accelerator-for-hosted-vram-containerized-workloads-ul-i3g-gh2-l4b:

-   The system has been provisioned and unlocked.

.. rubric:: |proc|

#.  Source the platform environment.

    .. code-block:: none

        $ source /etc/platform/openrc
        ~(keystone_admin)$

#.  Lock controller-0.

    .. code-block:: none

        ~(keystone_admin)$ system host-lock controller-0

#.  Assign labels to controller-0 to enable |SRIOV| device plugin, static
    Kubernetes CPU manager and restricted Kubernetes topology manager policy.

    .. code-block:: none

        ~(keystone_admin)$ system host-label-assign controller-0 sriovdp=enabled
        ~(keystone_admin)$ system host-label-assign controller-0 kube-cpu-mgr-policy=static
        ~(keystone_admin)$ system host-label-assign controller-0 kube-topology-mgr-policy=restricted

#.  Modify the CPU core assignments for controller-0 to have 12
    application-isolated physical cores (24 virtual cores if hyper-threading
    is supported and enabled on the processor) on processor 0. Your specific
    application(s) may need more or less cores.


    .. code-block:: none

        ~(keystone_admin)$ system host-cpu-modify -f application-isolated -p0 12 controller-0

#.  Modify the memory configuration for controller-0 numa-node 0 to have 12 1G
    Huge Pages. Your specific application(s) may need more or less, or
    different sized Huge Pages.


    .. code-block:: none

        ~(keystone_admin)$ system host-memory-modify controller-0 0 -1G 12

#.  List all devices on controller-0 and identify the name of the Hardware
    Accelerator (i.e. ACC100 device id - 0d5c, ACC200 device id - 57c0). For
    example:

    .. code-block:: none

        ~(keystone_admin)$ system host-device-list -a controller-0
        +------------------+--------------+----------+-----------+..
        | name             | address      | class id | vendor id |
        +------------------+--------------+----------+-----------+
        | pci_0000_00_16_0 | 0000:00:16.0 | 78000    | 8086      |
        | pci_0000_00_16_1 | 0000:00:16.1 | 78000    | 8086      |
        | pci_0000_00_1a_0 | 0000:00:1a.0 | c0300    | 8086      |
        | pci_0000_00_1d_0 | 0000:00:1d.0 | c0300    | 8086      |
        | pci_0000_00_1f_2 | 0000:00:1f.2 | 10600    | 8086      |
        | pci_0000_00_1f_3 | 0000:00:1f.3 | c0500    | 8086      |
        | pci_0000_04_00_0 | 0000:04:00.0 | 10700    | 8086      |
        | pci_0000_04_00_3 | 0000:04:00.3 | c0500    | 8086      |
        | pci_0000_04_00_4 | 0000:04:00.4 | c0500    | 8086      |
        | pci_0000_05_00_0 | 0000:05:00.0 | 30200    | 10de      |
        | pci_0000_0a_00_0 | 0000:0a:00.0 | 30000    | 102b      |
        | pci_0000_85_00_0 | 0000:85:00.0 | 120001   | 8086      |
        | pci_0000_f7_00_0 | 0000:f7:00.0 | 120000   | 8086      |
        +------------------+--------------+----------+-----------+..
        +-----------+---------------------------------+---------------------+..
        | device id | class name                      | vendor name         |
        +-----------+-----------+---------------------+---------------------+
        | 1d3a      | Communication controller        | Intel Corporation   |
        | 1d3b      | Communication controller        | Intel Corporation   |
        | 1d2d      | USB controller                  | Intel Corporation   |
        | 1d26      | USB controller                  | Intel Corporation   |
        | 1d02      | SATA controller                 | Intel Corporation   |
        | 1d22      | SMBus                           | Intel Corporation   |
        | 1d68      | Serial Attached SCSI controller | Intel Corporation   |
        | 1d70      | SMBus                           | Intel Corporation   |
        | 1d71      | SMBus                           | Intel Corporation   |
        | 1eb8      | 3D controller                   | NVIDIA Corporation  |
        | 0522      | VGA compatible controller       | Matrox Electronics..|
        | 0d5c      | Processing accelerators         | Intel Corporation   |
        | 57c0      | Processing accelerators         | Intel Corporation   |
        +-----------+---------------------------------+---------------------+..
        +----------------------------------------------------------+-----------+---------+
        | device name                                              | numa_node | enabled |
        +----------------------------------------------------------+-----------+---------+
        | C600/X79 series chipset MEI Controller #1                | 0         | False   |
        | C600/X79 series chipset MEI Controller #2                | 0         | False   |
        | C600/X79 series chipset USB2 Enhanced Host Controller #2 | 0         | False   |
        | C600/X79 series chipset USB2 Enhanced Host Controller #1 | 0         | False   |
        | C600/X79 series chipset 6-Port SATA AHCI Controller      | 0         | False   |
        | C600/X79 series chipset SMBus Host Controller            | 0         | False   |
        | C606 chipset Dual 4-Port  SATA/SAS Storage Control uni.. | 0         | False   |
        | C600/X79 series chipset SMBus Controller 0               | 0         | False   |
        | C608/C606/X79 series chipset SMBus Controller 1          | 0         | False   |
        | Device 1eb8                                              | 0         | False   |
        | MGA G200e [Pilot] ServerEngines (SEP1)                   | 0         | False   |
        | Device 0d5c                                              | 1         | True    |
        | Device 57c0                                              | 1         | True    |
        +----------------------------------------------------------+-----------+---------+

#.  Modify the device to enable it, specify the base driver and vf driver and
    configure it for 16 VFs.

    .. code-block:: none

        For ACC100:

        ~(keystone_admin)$ system host-device-modify controller-0 pci_0000_85_00_0 --driver igb_uio --vf-driver vfio -N 16

    #.  To modify the ACC200 device to enable it, specify the base driver and
        vf driver and configure it for 16 VFs.

        .. code-block:: none

            ~(keystone_admin)$ system host-device-modify controller-0 pci_0000_f7_00_0 --driver vfio-pci --vf-driver vfio -N 16

#.  Unlock the host.

    .. code-block:: none

        ~(keystone_admin)$ system host-unlock controller-0


.. note::
    For ACC100/ACC200 device, the number of |VF| bundles (``num_vf_bundles``)
    field is automatically changed in ``/usr/share/pf-bb-config/acc100/acc100_config_1vf_4g5g.cfg``
    or ``/usr/share/pf-bb-config/acc200/acc200_config_16vf.cfg`` configuration
    file by updating the value of the ``-N`` parameter via the
    :command:`system host-device-modify` command.

    In addition to the automatic mode, if additional configuration is needed in
    other parts of the configuration file, it is necessary to handle it manually
    by the operator without any validation. This new configuration will not take
    place on the device until a new :command:`system host-device-modify` command
    for that device is run, or host is locked/unlocked.


.. rubric:: |result|

To set up pods using |SRIOV|, see :ref:`Set Up Pods to Use SRIOV to Access ACC100/ACC200 HW Accelerators <set-up-pods-to-use-sriov>`.

