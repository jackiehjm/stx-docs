
.. ksh1464711502906
.. _vm-storage-settings-for-migration-resize-or-evacuation:

========================================================
VM Storage Settings for Migration, Resize, or Evacuation
========================================================

The migration, resize, or evacuation behavior for an instance depends on the
type of Ephemeral storage used.

.. note::
    Live migration behavior can also be affected by flavor extra
    specifications, image metadata, or instance metadata.

The following table summarizes the boot and local storage configurations needed
to support various behaviors.


.. _vm-storage-settings-for-migration-resize-or-evacuation-table-wmf-qdh-v5:

.. table::
    :widths: auto

    +----------------------------------------------------------------------------+-----------------------+-------------------------------------+------------------------------------+----------------+-------------------+--------------------------+
    | Instance Boot Type and Ephemeral and Swap Disks from flavor                | Local Storage Backing | Live Migration with Block Migration | Live Migration w/o Block Migration | Cold Migration | Local Disk Resize | Evacuation               |
    +============================================================================+=======================+=====================================+====================================+================+===================+==========================+
    | From Cinder Volume \(no local disks\)                                      | N/A                   | N                                   | Y                                  | Y              | N/A               | Y                        |
    +----------------------------------------------------------------------------+-----------------------+-------------------------------------+------------------------------------+----------------+-------------------+--------------------------+
    | From Cinder Volume \(w/ remote Ephemeral and/or Swap\)                     | N/A                   | N                                   | Y                                  | Y              | N/A               | Y                        |
    +----------------------------------------------------------------------------+-----------------------+-------------------------------------+------------------------------------+----------------+-------------------+--------------------------+
    | From Cinder Volume \(w/ local Ephemeral and/or Swap\)                      | CoW                   | Y                                   | Y \(CLI only\)                     | Y              | Y                 | Y                        |
    |                                                                            |                       |                                     |                                    |                |                   |                          |
    |                                                                            |                       |                                     |                                    |                |                   | Ephemeral/Swap data loss |
    +----------------------------------------------------------------------------+-----------------------+-------------------------------------+------------------------------------+----------------+-------------------+--------------------------+
    | From Glance Image \(all flavor disks are local\)                           | CoW                   | Y                                   | Y \(CLI Only\)                     | Y              | Y                 | Y                        |
    |                                                                            |                       |                                     |                                    |                |                   |                          |
    |                                                                            |                       |                                     |                                    |                |                   | Local disk data loss     |
    +----------------------------------------------------------------------------+-----------------------+-------------------------------------+------------------------------------+----------------+-------------------+--------------------------+
    | From Glance Image \(all flavor disks are local + attached Cinder Volumes\) | CoW                   | Y                                   | Y \(CLI only\)                     | Y              | Y                 | Y                        |
    |                                                                            |                       |                                     |                                    |                |                   |                          |
    |                                                                            |                       |                                     |                                    |                |                   | Local disk data loss     |
    +----------------------------------------------------------------------------+-----------------------+-------------------------------------+------------------------------------+----------------+-------------------+--------------------------+

In addition to the behavior summarized in the table, system-initiated cold
migrate \(e.g. when locking a host\) and evacuate restrictions may be applied
if a |VM| with a large root disk size exists on the host. For a Local CoW Image
Backed \(local\_image\) storage type, the VIM can cold migrate or evacuate
|VMs| with disk sizes up to 60 GB

.. note::
    The criteria for live migration are independent of disk size.

.. note::
    The **Local Storage Backing** is a consideration only for instances that
    use local Ephemeral or swap disks.

The boot configuration for an instance is determined by the **Instance Boot
Source** selected at launch.
