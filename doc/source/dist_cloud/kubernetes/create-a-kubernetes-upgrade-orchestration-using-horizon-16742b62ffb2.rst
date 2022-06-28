.. _create-a-kubernetes-upgrade-orchestration-using-horizon-16742b62ffb2:

=======================================================
Create a Kubernetes Upgrade Orchestration using Horizon
=======================================================

Use the Horizon Web interface as an alternative to the CLI for managing
Kubernetes upgrade strategies.

.. rubric:: |context|

Only one update strategy can exist at a time. The strategy controls how the
subclouds are updated (for example, serially or in parallel).


.. rubric:: |prereq|

Management-affecting alarms cannot be ignored using relaxed alarm rules during
an orchestrated Kubernetes version upgrade operation. For a list of
management-affecting alarms, see |fault-doc|: :ref:`fm-alarm-messages`.

You can use the Horizon Web interface to check the alarm states:

#. Select the **SystemController** region.

#. Select **Admin** > **Fault Management**.

#. Select **Active Alarms**.


.. rubric:: |proc|

#. Select the **SystemController** region.

#. Select **Distributed Cloud Admin** > **Orchestration**.

#. On the **Orchestration** page, select the **Orchestration Strategy** tab.

   .. figure:: figures/update-strategy-1.png

       Orchestration Strategy

#. Create a new strategy.

   On the **Orchestration Strategy** tab, click **Create Strategy**.
   In the **Create Strategy** dialog box, adjust the settings as needed.

   **Strategy Type**
      Kubernetes

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
      Default: Parallel

      Parallel or Serial. Determines whether the subclouds are updated in
      parallel or serially.

   **Maximum Parallel Subclouds**
      Default: 20

      If this is not specified using the CLI, the values for
      ``max_parallel_subclouds`` defined for each subcloud group will be used
      by default.

   **Force**
      Default: False

      Force kube upgrade to a subcloud which is in-sync with system controller.

   **To version**
      Not currently supported.

   .. figure:: figures/create-k8s-strategy.png

   .. figure:: figures/create-k8s-strategy-2.png

       Create a strategy

#. Adjust how Kubernetes is upgraded on RegionOne and on subclouds.

#. Save the new strategy.

   Click **Create Strategy**.


.. rubric:: |result|

Only subclouds in the Managed state and whose patching sync status is
``out-of-sync`` are added to the list. To change the Kubernetes Upgrade
strategy settings, you must delete the current strategy and create a new one.
You must confirm before applying the strategy. If the strategy is older than 60
minutes, a warning message will be display on this popup. You can simply apply
the strategy or verify that it is still valid.
