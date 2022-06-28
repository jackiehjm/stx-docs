
.. sku1558615443333
.. _customizing-the-update-configuration-for-distributed-cloud-update-orchestration:

=============================================================================
Customize the Update Configuration for Distributed Cloud Update Orchestration
=============================================================================

You can adjust how the nodes in each system \(Central Cloud's RegionOne and/or
Subclouds\) are updated.

.. rubric:: |context|

The update strategy for |prod-dc| Update Orchestration uses separate
configuration settings to control how the nodes on a given system are updated.
You can adjust the settings used by default for Central Cloud's RegionOne and
all subclouds, and you can create custom settings for individual subclouds.

You can change the configuration settings before or after creating a update
strategy for |prod-dc| update orchestration. The settings are maintained
independently.

.. rubric:: |proc|

#.  Select the **SystemController** region.

#.  Select **Distributed Cloud Admin** \> **Orchestration**.

#.  On the **Orchestration** page, select the **Cloud Patching Configuration**
    tab.

    .. image:: figures/qfq1525194569886.png
        :width: 1000px

    Take one of the following actions:


    -   To edit the settings applicable to RegionOne and all subclouds by
        default, click **Edit Configuration** in the **all clouds default** row.

        .. image:: figures/brk1525194697928.png

        To save your changes, click **Edit Cloud Patching Configuration**.

    -   To create custom settings for an individual subcloud, click **Create
        New Cloud Patching Configuration**.

        .. image:: figures/vzc1525194338519.png

        In the **Subcloud** field, select the subcloud for the custom settings.

        To save your configuration changes, click **Create Cloud Patching
        Configuration**. The new configuration is added to the list.

        .. image:: figures/vwa1525194889921.png

    The following settings are available:

    **Subcloud**
        This specifies the subcloud affected by the configuration. For the
        **all clouds default** configuration, this setting cannot be changed.

    **Storage Apply Type**
        Parallel or Serial — determines whether storage nodes are patched in
        parallel or serially

    **Worker Apply Type**
        Parallel or Serial — determines whether worker nodes are patched in
        parallel or serially

    **Maximum Parallel Worker Hosts**
        This sets the maximum number of worker nodes that can be patched in
        parallel.

    **Default Instance Action**
        .. note::

            This parameter is only applicable to hosted application VMs with
            the |prefix|-openstack application.

        migrate or stop-start — determines whether hosted application VMs are
        migrated or stopped and restarted when a worker host is upgraded

    **Alarm Restrictions**
        Relaxed or Strict — determines whether the orchestration is aborted for
        alarms that are not management-affecting.


.. rubric:: |postreq|

For information about creating and applying a patch strategy, see :ref:`Update
Management for Distributed Cloud <update-management-for-distributed-cloud>`.

**Related information**

.. seealso::

    :ref:`Creating an Update Strategy for Distributed Cloud Update
    Orchestration <creating-an-update-strategy-for-distributed-cloud-update-orchestration>`

    :ref:`Applying the Update Strategy for Distributed Cloud
    <applying-the-update-strategy-for-distributed-cloud>`

