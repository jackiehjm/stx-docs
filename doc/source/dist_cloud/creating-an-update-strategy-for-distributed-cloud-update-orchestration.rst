
.. rmf1558615469496
.. _creating-an-update-strategy-for-distributed-cloud-update-orchestration:

====================================================================
Create an Update Strategy for Distributed Cloud Update Orchestration
====================================================================

To update Central Cloud's RegionOne and the subclouds with updates in the
**Partial-Apply** state, you must create an update strategy for |prod-dc|
Update Orchestration.

.. rubric:: |context|

Only one update strategy can exist at a time. The strategy controls how the
subclouds are updated \(for example, serially or in parallel\).

To determine how the nodes on the Central Cloud's RegionOne and each subcloud
are updated, the update strategy refers to separate configuration settings
available on the Cloud Patching Configuration tab.

.. rubric:: |prereq|

You must be in **SystemController** mode. To change the mode, see
:ref:`RegionOne and SystemController Modes
<regionone-and-systemcontroller-modes>`.

.. rubric:: |proc|

#.  Select the **SystemController** region.

#.  Select **Distributed Cloud Admin** \> **Software Management**.

#.  On the Software Management page, select the **Cloud Patching Orchestration**
    tab.

    .. image:: figures/vhy1525122582274.png
    
    

#.  On the Cloud Patching Orchestration tab, click **Create Strategy**.

    In the Create Patch Strategy dialog box, adjust the settings as needed.

    .. image:: figures/jod1525122097274.png

    **subcloud-apply-type**
        parallel or serial — determines whether the subclouds are updated in
        parallel or serially.

        If this is not specified using the |CLI|, the values for
        :command:`subcloud\_update\_type` defined for each subcloud group will
        be used by default.

    **max-parallel-subclouds**
        Sets the maximum number of subclouds that can be updated in parallel
        \(default 20\).

        If this is not specified using the |CLI|, the values for
        :command:`max\_parallel\_subclouds` defined for each subcloud group
        will be used by default.

    **stop-on-failure**
        true or false \(default\) — determines whether update orchestration
        failure for a subcloud prevents application to subsequent subclouds.

#.  Adjust how nodes are updated on RegionOne and the subclouds.

    See :ref:`Customizing the Update Configuration for Distributed Cloud Update
    Orchestration
    <customizing-the-update-configuration-for-distributed-cloud-update-orchestration>`.

#.  Click **Create Patch Strategy**.

    Only subclouds in the Managed state and whose patching sync status is
    out-of-sync are added to the list.

    .. image:: figures/bqu1525123082913.png

    .. note::

        To change the update strategy settings, you must delete the update
        strategy and create a new one.

.. seealso:: 

    :ref:`Customizing the Update Configuration for Distributed Cloud Update
    Orchestration <customizing-the-update-configuration-for-distributed-cloud-update-orchestration>`

    :ref:`Applying the Update Strategy for Distributed Cloud
    <applying-the-update-strategy-for-distributed-cloud>`

