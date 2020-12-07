
.. faf1573057127832
.. _kubernetes-topology-manager-policies:

====================================
Kubernetes Topology Manager Policies
====================================

You can apply the kube-topology-mgr-policy host label from Horizon or the CLI
to set the Kubernetes Topology Manager policy.

The kube-topology-mgr-policy host label has four supported values:

-   none

-   best-effort

    This is the default when the static CPU policy is enabled.

-   restricted

-   single-numa-node


For more information on these settings, see the Kubernetes Topology Manager
policies described at `https://kubernetes.io/docs/tasks/administer-cluster/topology-manager/#how-topology-manager-works <https://kubernetes.io/docs/tasks/administer-cluster/topology-manager/#how-topology-manager-works>`__.

.. xreflink For information about adding labels, see |node-doc|: :ref:`Configuring Node Labels Using Horizon <configuring-node-labels-using-horizon>`

.. xreflink and |node-doc|: :ref:`Configuring Node Labels from the CLI <assigning-node-labels-from-the-cli>`.

-----------
Limitations
-----------

-   The scheduler is not NUMA-aware and can therefore make suboptimal pod
    scheduling decisions when the Topology Manager policy on the destination
    node is taken into account.

-   If a pod fails with *Topology Affinity Error* because it can't satisfy the
    Topology Manager policy on the node where the schedule placed it, it will
    remain in the error state and not be retried. If the pod is part of a
    manager object such as ReplicaSet, Deployment, etc., then a new pod will be
    created. If that new pod is placed on the same node, it can result in a
    series of pods with a status of *Topology Affinity Error*. For more
    information, see `https://github.com/kubernetes/kubernetes/issues/84757 <https://github.com/kubernetes/kubernetes/issues/84757>`__.

In light of these limitations, |org| recommends using the best-effort policy,
which will cause Kubernetes to try to provide NUMA-affined resources without
generating any unexpected errors if the policy cannot be satisfied.

