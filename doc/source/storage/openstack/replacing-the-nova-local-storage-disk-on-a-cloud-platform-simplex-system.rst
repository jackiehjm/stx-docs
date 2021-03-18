
.. syu1590591059068
.. _replacing-the-nova-local-storage-disk-on-a-cloud-platform-simplex-system:

========================================================================
Replace Nova-local Storage Disk on a Cloud Platform Simplex System
========================================================================

On a |prod-long| Simplex system, a special procedure is
recommended for replacing or upgrading the nova-local storage device, to allow
for the fact that |VMs| cannot be migrated.

.. rubric:: |context|

For this procedure, you must use the |CLI|.

.. note::
    The volume group will be rebuilt as part of the disk replacement procedure.
    You can select a replacement disk of any size provided that the ephemeral
    storage requirements for all |VMs| are met.

.. rubric:: |proc|

#.  Delete all |VMs|.

#.  Lock the controller.

    .. code-block:: none

        ~(keystone_admin)$ system host-lock controller-0

#.  Delete the nova-local volume group.

    .. code-block:: none

        ~(keystone_admin)$ system host-lvg-delete controller-0 nova-local

#.  Shut down the controller.

    .. code-block:: none

        ~(keystone_admin)$ sudo shutdown -h now

#.  Replace the physical device.


    #.  Power down the physical device.

    #.  Replace the drive with an equivalent or larger drive.

    #.  Power up the device.

        Wait for the node to boot to the command prompt.


#.  Source the environment.

#.  Unlock the node.

    .. code-block:: none

        ~(keystone_admin)$ system host-unlock controller-0

#.  Relaunch the deleted |VMs|.


