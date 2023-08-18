
.. mmg1558615549438
.. _update-orchestration-of-central-clouds-regionone-and-subclouds:

=================================
Update Orchestration of Subclouds
=================================

You can use update orchestration to automate software updates across all
subclouds in the |prod-dc|.

You can use the Horizon Web interface or the CLI. To use the CLI, see
:ref:`update-orchestration-of-central-clouds-regionone-and-subclouds-using-the-cli`.

.. note::

    Patch orchestration is the recommended method for updating software on a
    |prod-dc| system. Do not update individual subclouds manually.

To use update orchestration, complete the following workflow:


.. _update-orchestration-of-central-clouds-regionone-and-subclouds-ul-ttl-gc3-4db:

#.  Ensure that the required updates are uploaded and applied to the
    SystemController / central update repository.

    For more information, see
    :ref:`uploading-and-applying-updates-to-systemcontroller-using-horizon`.

#.  Update the RegionOne, for more information see
    :ref:`uploading-and-applying-updates-to-systemcontroller-using-horizon-update-the-regionone`.

#.  Create an update strategy for the |prod-dc| update orchestration.

    See :ref:`creating-an-update-strategy-for-distributed-cloud-update-orchestration`.

#.  Optionally, customize the configuration settings used by the update strategy.

    The update strategy is applied to all subclouds using default configuration
    settings. You can change these settings, and you can create custom settings
    for individual subclouds. For more information, see
    :ref:`customizing-the-update-configuration-for-distributed-cloud-update-orchestration`.

#.  Apply the strategy for the |prod-dc| update orchestration.

    See :ref:`applying-the-update-strategy-for-distributed-cloud`.

    As each subcloud is updated, it moves through the following states:

    **initial**
        The update has not started.

    **pre-check**
        Subcloud alarm status is being checked for management-affecting alarms.

    **updating patches**
        Patches are being updated to synchronize with System Controller
        updates.

    **creating strategy**
        The strategy is being created in the subcloud.

    **applying strategy**
        The strategy is being applied in the subcloud.

    **finishing**
        Updates that are no longer required are being deleted.

        Updates that require committing are being committed.

    **complete**
        Updating has been completed successfully.

    During this process, alarms **900.001** and **900.101** are raised
    temporarily.

.. seealso::

    :ref:`creating-an-update-strategy-for-distributed-cloud-update-orchestration`

    :ref:`customizing-the-update-configuration-for-distributed-cloud-update-orchestration`

    :ref:`applying-the-update-strategy-for-distributed-cloud`


