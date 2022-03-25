.. _configure-a-live-migration-parameters-in-nova-6154238dfc6d:

===========================================
Configure Live Migration Parameters in Nova
===========================================

.. rubric:: |context|

You can configure a maximum time for a live migration to complete and/or the
maximum downtime target for live migration switchover.

----------
Parameters
----------

-   ``live_migration_completion_timeout``

    Time to wait, in seconds, for live migration to successfully complete
    transferring data before aborting the operation.

    Value is per GiB of guest RAM + disk to be transferred, with a lower
    boundary of 2 GiB. Set to 0 to disable timeouts.

-   ``live_migration_downtime``

    The target maximum period of time that Nova will require the |VM| to be
    paused in order to complete the |VM| memory copy. If the transfer rate
    slows down after the |VM| has been paused, this value can be exceeded by a
    small amount of time, it will be rounded up to a minimum of 100ms.

    You may increase this value if you want to allow live-migrations to
    complete faster, or avoid ``live-migration`` timeout errors by allowing the
    guest to be paused longer during the ``live-migration`` switch over.

    Two additional ``live_migration_downtime_scope`` parameters can be
    modified:

    -   ``live_migration_downtime_steps``

        Sets the total number of adjustment steps until
        ``live_migration_downtime`` is reached. This will let nova increase
        ``live_migration_downtime`` gradually until either the switchover has
        been completed or the maximum value has been reached. The default is 10
        steps.

    -   ``live_migration_downtime_delay``

        Sets the time interval between two adjustment steps in seconds. The
        default is 75.

.. rubric:: |proc|

All the parameters can be modified using the Helm overrides for the |prod-os|
application.

#.  Create a yaml file containing the configuration update.

    For example ``nova_override.yaml``:

    .. code-block:: none

        conf:
            nova:
                libvirt:
                    live_migration_completion_timeout: 300
                    live_migration_downtime: 600
                    live_migration_downtime_steps: 12
                    live_migration_downtime_delay: 50

#.  Update the Helm overrides using the new configuration file.

    .. code-block:: none

        ~(keystone_admin)]$ system helm-override-update --values ./nova_override.yaml wr-openstack nova openstack --reuse-values

#.  Confirm that the user override lists the correct live migration parameters.

    .. code-block:: none

        ~(keystone_admin)]$ system helm-override-show wr-openstack nova openstack

#.  Apply the changes.

    .. code-block:: none

        ~(keystone_admin)]$ system application-apply wr-openstack

.. rubric:: |result|

If the live migration aborts because ``live_migration_completion_timeout`` has
been exceeded, then the following message appears on the ``nova_compute`` logs:

.. code-block:: none

    WARNING nova.virt.libvirt.migration [-] [instance: 07b5842b-6324-4de0-973e-6d0ff18ef574] Live migration not completed after 300 seconds

The default behavior is to abort the operation. You can change this action by
configuring ``live_migration_timeout_action`` in your yaml file.

For example:

.. code-block:: none

    live_migration_timeout_action: force_complete

If it is set to ``force_complete``, the compute service will either pause the
|VM| or trigger post-copy if post copy is enabled and available
(``live_migration_permit_post_copy`` is set to True).
