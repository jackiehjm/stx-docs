.. _apply-a-kubernetes-upgrade-strategy-using-horizon-2bb24c72e947:

=================================================
Apply a Kubernetes Upgrade Strategy using Horizon
=================================================

You can use the Horizon Web interface to upgrade Kubernetes across the
Distributed Cloud system by applying the Kubernetes upgrade strategy for 
Distributed Cloud Orchestration.

.. rubric:: |prereq|

Before you can apply the Kubernetes Upgrade strategy, you must upload and apply
one or more updates to the SystemController / central update repository, create
the Kubernetes strategy for subclouds, and optionally adjust the configuration
settings for updating nodes.

.. rubric:: |proc|

#. Select the SystemController region.

#. Select **Distributed Cloud Admin** > **Orchestration**.

#. On the **Orchestration** page, select the **Orchestration Strategy** tab.

   .. figure:: figures/bqu1525123082913.png

       Orchestration Strategy

#. Click Apply Strategy.

   *  To monitor the progress of the overall Kubernetes Upgrade orchestration,
      use the **Orchestration Strategy** tab.

   *  To monitor the progress of host Kubernetes Upgrade on RegionOne or a
      subcloud, use the **Host Inventory** page on the subcloud.




