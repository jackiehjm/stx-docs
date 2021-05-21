
.. rbp1590431075472
.. _firmware-update-operations-requiring-manual-migration:

=====================================================
Firmware Update Operations Requiring Manual Migration
=====================================================

On systems with the |prefix|-openstack application there may be some instances
that cannot be migrated automatically by orchestration. In these cases the
instance migration must be managed manually.

Do the following to manage the instance re-location manually:


.. _rbp1590431075472-ul-mgr-kvs-tlb:

-   Manually firmware update at least one openstack-compute worker host. This
    assumes that at least one openstack-compute worker host does not have any
    instances, or has instances that can be migrated. For more information on
    manually updating a host, see the :ref:`Display Worker Host Information
    <displaying-worker-host-information>`.

-   If the migration is prevented by limitations in the VNF or virtual
    application, perform the following:


    -   Create new instances on an already updated openstack-compute worker host.

    -   Manually migrate the data from the old instances to the new instances.

        .. note::
            This is specific to your environment and depends on the virtual
            application running in the instance.

    -   Terminate the old instances.

-   If the migration is prevented by the size of the instances local disks:

    -   For each openstack-compute worker host that has instances that cannot
        be migrated, manually move the instances using the CLI. For more
        information, see :ref:`Firmware Update Orchestration Using the CLI
        <firmware-update-orchestration-using-the-cli>`.

Once all openstack-compute worker hosts containing instances that cannot be
migrated have been firmware updated, firmware update orchestration can then be
used to update the remaining worker hosts.

