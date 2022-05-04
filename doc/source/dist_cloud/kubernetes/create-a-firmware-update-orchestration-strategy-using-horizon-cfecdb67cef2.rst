.. _create-a-firmware-update-orchestration-strategy-using-horizon-cfecdb67cef2:

=============================================================
Create a Firmware Update Orchestration Strategy using Horizon
=============================================================

Use the Horizon Web interface as an alternative to the CLI for managing device
/firmware image update strategies (Firmware update).

To use the CLI, see :ref:`device-image-update-orchestration`.

To update device/firmware image Central Cloud’s RegionOne and the subclouds,
you must create an update strategy for Distributed Cloud fw-update-strategy
Orchestration.


.. rubric:: |context|

Only one type of dcmanager strategy can exist at a time. The strategy controls
how the subclouds are updated (for example, serially or in parallel).


.. rubric:: |prereq|

You must be in the SystemController region. To change the mode, see
:ref:`regionone-and-systemcontroller-modes`.

.. rubric:: |proc|

#. Select the **SystemController** region.

#. Select **Distributed Cloud Admin** > **Orchestration**.

#. Select the **Orchestration Strategy** tab on the **Orchestration** page.

   .. figure:: figures/update-strategy-1.png

       Orchestration Strategy

#. Create a new strategy.

   Click **Create Strategy**. In the **Create Strategy** dialog box, adjust the
   settings as needed.

   **Strategy Type**
      Firmware

   **Apply to**
      Subcloud or Subcloud Group

   **Subcloud**
      Enter the subcloud name

   **Subcloud Group**
      Enter the subcloud group name only if you select the **Apply to**:
      **Subcloud Group** option.

   **Stop on Failure**
      Default: True

      Determines whether update orchestration failure for a subcloud prevents
      application to subsequent subclouds.

   **Subcloud Apply Type**
      Parallel or Serial, default Parallel.
      Determines whether the subclouds are updated in parallel or serially.

   **Maximum Parallel Subclouds**
      Default: 20

      If this is not specified using the CLI, the values for
      ``max_parallel_subclouds`` defined for each subcloud group will be used
      by default.

   **Force**
      Default: False

   .. figure:: figures/create-strategy.png

   .. figure:: figures/create-strategy-2.png

       Create a strategy

#. Adjust how device image nodes are updated on RegionOne and the subclouds.

#. Save the new strategy.

   Click **Create Strategy**.


.. rubric:: |result|

Only subclouds in the Managed state and whose patching sync status is
``out-of-sync`` are added to the list. To change the firmware upgrade strategy
settings, you must delete the current strategy and create a new one. You must
confirm before applying the strategy. If the created strategy is older than 60
minutes, a warning message will be displayed. You can simply apply
the strategy or first verify that it is still valid.

