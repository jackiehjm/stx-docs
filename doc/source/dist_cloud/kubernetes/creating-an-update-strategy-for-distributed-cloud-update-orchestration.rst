
.. rmf1558615469496
.. _creating-an-update-strategy-for-distributed-cloud-update-orchestration:

====================================================================
Create an Update Strategy for Distributed Cloud Update Orchestration
====================================================================

To update Central Cloud's RegionOne and the subclouds with updates in the
**Partial-Apply** state, you must create an update strategy for |prod-dc|
Update Orchestration.

After a patch (update) has been **applied/removed/committed** on the
Central Cloud's RegionOne, the subclouds are audited and their patching sync
status is updated. This can take up to 15 minutes.

If the Subclouds are in a **Managed** state and if the patching sync status is
"out-of-sync", it can be orchestrated.

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

#.  On the Software Management page, select the **Cloud Strategy Orchestration**
    tab.

    .. image:: figures/update-strategy-1.png


#.  On the Cloud Strategy Orchestration tab, click **Create Strategy**.

    In the Create Strategy dialog box, adjust the settings as needed.

    **Strategy Type**
        Patch, Upgrade, Kubernetes, or Firmware.

    **Apply to**
        Subcloud or Subcloud Group.

    **Subcloud**
        Write the subcloud name.

    **Subcloud Group**
        Write the subcloud group name, only if you select the **Apply to: Subcloud Group** option.

    **Stop on Failure**
        default true — determines whether update orchestration failure for a
        subcloud prevents application to subsequent subclouds.

    **Subcloud Apply Type**
        Parallel or Serial, default Parallel — determines whether the subclouds
        are updated in parallel or serially.

    **Maximum Parallel Subclouds**
        default 20 — If this is not specified using the |CLI|, the values for
        max_parallel_subclouds defined for each subcloud group will be used by
        default.

    **Force**
        default False.

    .. image:: figures/update-strategy-2.png

    .. image:: figures/update-strategy-3.png

#.  Adjust how nodes are updated on RegionOne and the subclouds.

    See :ref:`Customizing the Update Configuration for Distributed Cloud Update
    Orchestration
    <customizing-the-update-configuration-for-distributed-cloud-update-orchestration>`.

#.  Click **Create Strategy**.

    Only subclouds in the **Managed** state and whose patching sync status is
    out-of-sync are added to the list. To change the update strategy settings,
    you must delete the update strategy and create a new one. Confirmation
    before applying strategy will be needed. If the created strategy is older
    than 60 minutes, a warning message will be displayed. The user can apply
    the strategy or verify if it is still valid.

    .. image:: figures/update-strategy-4.png

    .. note::

        To change the update strategy settings, you must delete the update
        strategy and create a new one.

.. seealso::

    :ref:`Customizing the Update Configuration for Distributed Cloud Update
    Orchestration <customizing-the-update-configuration-for-distributed-cloud-update-orchestration>`

    :ref:`Applying the Update Strategy for Distributed Cloud
    <applying-the-update-strategy-for-distributed-cloud>`

