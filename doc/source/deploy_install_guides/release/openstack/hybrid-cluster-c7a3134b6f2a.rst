.. _hybrid-cluster-c7a3134b6f2a:

==============
Hybrid Cluster
==============

A Hybrid Cluster occurs when the hosts with a worker function (|AIO|
controllers and worker nodes) are split between two groups, one running
|prod-os| for hosting |VM| payloads and the other for hosting containerized
payloads.

The host labels are used to define each worker function on the Hybrid Cluster
setup. For example, a standard configuration (2 controllers and 2 computes) can
be split into (2 controllers, 1 openstack-compute and 1 kubernetes-worker).

.. only:: partner

   .. include:: /_includes/hybrid-cluster.rest
       :start-after: begin-prepare-cloud-platform
       :end-before: end-prepare-cloud-platform

-----------
Limitations
-----------

-   Worker function on |AIO| controllers MUST both be either
    Kubernetes or OpenStack.

    -   Hybrid Cluster does not apply to |AIO-SX| or |AIO-DX| setups.

-   A worker must have only one function, either it is OpenStack compute or
    k8s-only worker, never both at the same time.

    -   The ``sriov`` and ``sriovdp`` labels cannot coexist on the same host,
        in order to prevent the |SRIOV| device plugin from conflicting with the
        OpenStack |SRIOV| driver.

    -   No host will assign |VMs| and application containers to application cores
        at the same time.

-   Standard Controllers cannot have ``openstack-compute-node`` label;
    only |AIO| Controllers can have ``openstack-compute-node`` label.

-   Taints must be added to OpenStack compute hosts (i.e. worker nodes or
    |AIO|-Controller nodes with the ``openstack-compute-node`` label) to
    prevent end users' hosted containerized workloads/pods from being scheduled on
    OpenStack compute hosts.


