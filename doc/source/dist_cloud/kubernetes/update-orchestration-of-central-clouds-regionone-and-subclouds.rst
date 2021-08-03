
.. mmg1558615549438
.. _update-orchestration-of-central-clouds-regionone-and-subclouds:

===============================================================
Update Orchestration of Central Cloud's RegionOne and Subclouds
===============================================================

You can use update orchestration to automate software updates across the
Central Cloud's RegionOne and all subclouds in the |prod-dc|.

You can use the Horizon Web interface or the CLI. To use the CLI, see
:ref:`Update Orchestration of Central Cloud's RegionOne and Subclouds Using the
CLI
<update-orchestration-of-central-clouds-regionone-and-subclouds-using-the-cli>`.

.. note::

    Patch orchestration is the recommended method for updating software on a
    |prod-dc| system. Do not update RegionOne or individual subclouds manually.

To use update orchestration, complete the following workflow:


.. _update-orchestration-of-central-clouds-regionone-and-subclouds-ul-ttl-gc3-4db:

#.  Ensure that the required updates are uploaded and applied to the
    SystemController / central update repository.

    For more information, see :ref:`Uploading and Applying Updates to
    SystemController Using Horizon
    <uploading-and-applying-updates-to-systemcontroller-using-horizon>`.

#.  Create an update strategy for the |prod-dc| update orchestration.

    See :ref:`Creating an Update Strategy for Distributed Cloud Update
    Orchestration
    <creating-an-update-strategy-for-distributed-cloud-update-orchestration>`.

#.  Optionally, customize the configuration settings used by the update strategy.

    The update strategy is applied to the Central Cloud's RegionOne and all
    subclouds using default configuration settings. You can change these
    settings, and you can create custom settings for individual subclouds. For
    more information, see :ref:`Customizing the Update Configuration for
    Distributed Cloud Update Orchestration
    <customizing-the-update-configuration-for-distributed-cloud-update-orchestration>`.

#.  Apply the strategy for the |prod-dc| update orchestration.

    See :ref:`Applying the Update Strategy for Distributed Cloud
    <applying-the-update-strategy-for-distributed-cloud>`.

    As each subcloud is updated, it moves through the following states:

    **initial**
        The update has not started.

    **updating patches**
        Patches are being updated to synchronize with System Controller
        updates.

    **creating strategy**
        The strategy is being created in the subcloud.

    **applying strategy**
        The strategy is being applied in the subcloud.

    **finishing**
        updates that are no longer required are being deleted

        updates that require committing are being committed

    **complete**
        Updating has been completed successfully.

    During this process, alarms **900.001** and **900.101** are raised
    temporarily.

.. seealso::

    :ref:`Creating an Update Strategy for Distributed Cloud Update
    Orchestration <creating-an-update-strategy-for-distributed-cloud-update-orchestration>`  

    :ref:`Customizing the Update Configuration for Distributed Cloud Update
    Orchestration <customizing-the-update-configuration-for-distributed-cloud-update-orchestration>`
    
    :ref:`Applying the Update Strategy for Distributed Cloud
    <applying-the-update-strategy-for-distributed-cloud>`  


