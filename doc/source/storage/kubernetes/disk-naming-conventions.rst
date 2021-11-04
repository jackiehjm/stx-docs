
.. sgc1552679032825
.. _disk-naming-conventions:

=======================
Disk Naming Conventions
=======================

|prod| uses persistent disk names to simplify hardware management.

In addition to the device node identification commonly used in Linux
systems \(for example, **/dev/sda**\), |prod| identifies hardware storage
devices by physical location \(device path\). This ensures that the system
can always identify a given disk based on its location, even if its device
node enumeration changes because of a hardware reconfiguration. This helps
to avoid the need for a system re-installation after a change to the disk
complement on a host.

In the Horizon Web interface and in |CLI| output, both identifications are
shown. For example, the output of the :command:`system host-disk-show`
command includes both the **device_node** and the **device_path**.

.. code-block:: none

    ~(keystone_admin)]$ system host-disk-show controller-0
    1722b081-8421-4475-a6e8-a26808cae031

    +-------------+--------------------------------------------+
    | Property    | Value                                      |
    +-------------+--------------------------------------------+
    | device_node | /dev/sda                                   |
    | device_num  | 2048                                       |
    | device_type | HDD                                        |
    | device_path | /dev/disk/by-path/pci-0000:00:0d.0-ata-2.0 |
    | size_gib    | 120                                        |
    | rpm         | Undetermined                               |
    | serial_id   | VB77269fb1-ae169607                        |
    | uuid        | 1722b081-8421-4475-a6e8-a26808cae031       |
    | ihost_uuid  | 78c46728-4108-4b35-8081-bed1bd4cba35       |
    | istor_uuid  | None                                       |
    | ipv_uuid    | 2a7e7aad-6da5-4a2d-957c-058d37eace1c       |
    | created_at  | 2017-05-05T07:56:02.969888+00:00           |
    | updated_at  | 2017-05-08T12:27:04.437818+00:00           |
    +-------------+--------------------------------------------+

