
.. fez1617811988954
.. _the-kubernetes-distributed-cloud-update-orchestration-process:

===================================================================
Kubernetes Version Upgrade Distributed Cloud Orchestration Overview
===================================================================

Before you create a *Kubernetes Version Upgrade Distributed Cloud Orchestration
Strategy*, ensure that the Kubernetes version on the System Controller has been upgraded
using the procedure documented in :ref:`Manual Kubernetes Version Upgrade <manual-kubernetes-components-upgrade>`.

For an orchestrated Kubernetes version upgrade across a |prod-dc|, you need to
first create a *Kubernetes Version Upgrade Distributed Cloud Orchestration
Strategy*, or plan, for the automated Kubernetes version upgrade procedure
orchestrated across all subclouds of the Distributed Cloud system.

You must use the :command:`dcmanager` CLI tool to **create**, and then
**apply** the upgrade strategy. A created strategy can be monitored with the
**show** command. For more information, see :ref:`Create Kubernetes Version
Upgrade Cloud Orchestration Strategy <configuring-kubernetes-update-orchestration-on-distributed-cloud>`.

Kubernetes upgrade orchestration automatically iterates through all managed
online subclouds if you do not specify a group of subclouds to be upgraded.

The specific steps involved in a Kubernetes Version Upgrade Distributed Cloud
Orchestration for a single or group of hosts in each subcloud includes:

.. _fez1617811988954-ol-a1b-v5s-tlb:

#. Creating the subcloud kube upgrade strategy based on the new version installed
   as part of the platform.

#. Applying the subcloud kube upgrade strategy.
