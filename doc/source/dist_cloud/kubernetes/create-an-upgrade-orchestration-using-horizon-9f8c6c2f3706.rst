.. _create-an-upgrade-orchestration-using-horizon-9f8c6c2f3706:

=============================================
Create an Upgrade Orchestration using Horizon
=============================================

.. rubric:: |prereq|

You must have completed the procedure in
:ref:`distributed-upgrade-orchestration-process-using-the-cli`.

.. rubric:: |proc|

#.  Review the upgrade status for the subclouds.

    After the System Controller upgrade is completed, wait for 10 minutes for
    the ``load_sync_status`` of all subclouds to be updated. To check the
    subclouds status:

    #. Select the **SystemController** region.

    #. Select **Distributed Cloud Admin** > **Cloud Overview**.

#.  Create the strategy.

    #. Select the **SystemController** region.

    #. Select **Distributed Cloud Admin** > **Orchestration**.

    #. On the **Orchestration** page, select the **Orchestration Strategy** tab.

    #. Create the new strategy.

       On the **Orchestration Strategy** tab, click **Create Strategy**. In the
       **Create Strategy** dialog box, adjust the settings as needed.

       **Strategy Type**
          Upgrade

       **Apply to**
          Subcloud or Subcloud Group

       **Subcloud**
          Enter the subcloud name

       **Subcloud Group**
          Enter the subcloud group name only if you select the **Apply to**:
          **Subcloud Group** option.

       **Stop on Failure**
          Default: True

          Determines whether update orchestration failure for a subcloud
          prevents application to subsequent subclouds.

       **Subcloud Apply Type**
          Default: Parallel

          Parallel or Serial. Determines whether the subclouds are updated in
          parallel or serially.

       **Maximum Parallel Subclouds**
          Default 20

          If this is not specified using the CLI, the values for
          ``max_parallel_subclouds`` defined for each subcloud group will be
          used by default.

       **Force**
          Default: False

          Offline subcloud is not skipped. Applicable only when the strategy is
          created to a single subcloud.

       .. figure:: figures/create-upgrade-strategy.png

       .. figure:: figures/create-upgrade-strategy-2.png

           Create an orchestration strategy

    #. Adjust how the Upgrade on subclouds will be performed.

    #. Save the new strategy.

       Only subclouds in the Managed state and whose patching sync status is
       ``out-of-sync`` are added to the list. To change the Upgrade strategy
       settings, you must delete the current strategy and create a new one.
       Confirmation before applying strategy will be needed. If the created
       strategy is older than 60 minutes, a warning message will be display on
       this popup. The user can apply the strategy or verify if it is still
       valid.


