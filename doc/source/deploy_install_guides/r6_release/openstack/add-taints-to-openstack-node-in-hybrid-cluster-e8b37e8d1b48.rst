.. _add-taints-to-openstack-node-in-hybrid-cluster-e8b37e8d1b48-r6:

==============================================
Add Taints to OpenStack Node in Hybrid Cluster
==============================================

.. rubric:: |context|

In a hybrid (Kubernetes and OpenStack) cluster scenario, to prevent end-users'
hosted containerized workloads/pods from being scheduled on
``openstack-compute-nodes`` a taint that only openstack and platform pods are
able to tolerate must be added. Thus, any pod that is not platform or
OpenStack specific can be repelled. To achieve this control, the
``openstack-compute-node`` taint must be added to all
``openstack-compute-nodes``  (i.e. worker nodes or |AIO|-Controller nodes with
the ``openstack-compute-node`` label).

By applying taints, it is possible to separate end users' containerized
workloads/pods from OpenStack in a hybrid (Kubernetes and OpenStack) cluster
scenario.

.. rubric:: |proc|

#.  Apply taints.

    This step is needed to prevent end-users' hosted containerized
    workloads/pods from being scheduled on openstack computes  (i.e. worker
    nodes or |AIO|-Controller nodes with the ``openstack-compute-node`` label).

    Apply this taint on every ``openstack-compute-node`` (i.e. worker nodes
    or |AIO|-Controller nodes with the ``openstack-compute-node`` label):

    .. code-block:: none

        kubectl taint nodes <kubernetes-node-name> openstack-compute-node:NoSchedule

