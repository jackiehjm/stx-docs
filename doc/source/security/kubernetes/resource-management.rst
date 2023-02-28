
.. cmy1590090067787
.. _resource-management:

===================
Resource Management
===================

Kubernetes supports two types of resource policies, **LimitRange** and
**ResourceQuota**.

.. contents::
   :local:
   :depth: 1

.. _resource-management-section-z51-d5m-tlb:

----------
LimitRange
----------

By default, containers run with unbounded resources on a Kubernetes cluster.
Obviously this is bad as a single Pod could monopolize all available
resources on a worker node. A **LimitRange** is a policy to constrain
resource allocations (for Pods or Containers) in a particular namespace.

Specifically a **LimitRange** policy provides constraints that can:


.. _resource-management-ul-vz5-g5m-tlb:

-   Enforce minimum and maximum compute resources usage per Pod or Container
    in a namespace.

-   Enforce minimum and maximum storage request per PersistentVolumeClaim in
    a namespace.

-   Enforce a ratio between request and limit for a resource in a namespace.

-   Set default request/limit for compute resources in a namespace and
    automatically inject them to Containers at runtime.


See `https://kubernetes.io/docs/concepts/policy/limit-range/ <https://kubernetes.io/docs/concepts/policy/limit-range/>`__ for more details.

An example of **LimitRange** policies for the billing-dept-ns namespace of
the example in :ref:`Assign Pod Security Policies
<assign-pod-security-policies>` is shown below:

.. code-block:: none

    apiVersion: v1
    kind: LimitRange
    metadata:
      name: mem-cpu-per-container-limit
      namespace: billing-dept-ns
    spec:
      limits:
      - max:
          cpu: "800m"
          memory: "1Gi"
        min:
          cpu: "100m"
          memory: "99Mi"
        default:
          cpu: "700m"
          memory: "700Mi"
        defaultRequest:
          cpu: "110m"
          memory: "111Mi"
        type: Container
    ---
    apiVersion: v1
    kind: LimitRange
    metadata:
      name: mem-cpu-per-pod-limit
      namespace: billing-dept-ns
    spec:
      limits:
      - max:
          cpu: "2"
          memory: "2Gi"
        type: Pod
    ---
    apiVersion: v1
    kind: LimitRange
    metadata:
      name: pvc-limit
      namespace: billing-dept-ns
    spec:
      limits:
      - type: PersistentVolumeClaim
        max:
          storage: 3Gi
        min:
          storage: 1Gi
    ---
    apiVersion: v1
    kind: LimitRange
    metadata:
      name: memory-ratio-pod-limit
      namespace: billing-dept-ns
    spec:
      limits:
      - maxLimitRequestRatio:
          memory: 10
        type: Pod



.. _resource-management-section-ur2-q5m-tlb:

-------------
ResourceQuota
-------------

A **ResourceQuota** policy object provides constraints that limit aggregate
resource consumption per namespace. It can limit the quantity of objects
that can be created in a namespace by type, as well as the total amount of
compute resources that may be consumed by resources in that project.
**ResourceQuota** limits can be created for cpu, memory, storage and
resource counts for all standard namespaced resource types such as secrets,
configmaps, etc.

See `https://kubernetes.io/docs/concepts/policy/resource-quotas/
<https://kubernetes.io/docs/concepts/policy/resource-quotas/>`__ for more
details.

An example of **ResourceQuota** policies for the billing-dept-ns namespace
of :ref:`Assign Pod Security Policies <assign-pod-security-policies>`
is shown below:

.. code-block:: none

    apiVersion: v1
    kind: ResourceQuota
    metadata:
      name: resource-quotas
      namespace: billing-dept-ns
    spec:
      hard:
        persistentvolumeclaims: "1"
        services.loadbalancers: "2"
        services.nodeports: "0"

