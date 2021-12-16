=================
Resource Policies
=================

.. note::

   This guide was replaced by: :ref:`Resource Management <resource-management>`

This guide describes two Kubernetes resource policies, LimitRange and
ResourceQuota, which are enabled by default on StarlingX.

.. contents::
   :local:
   :depth: 1

----------
LimitRange
----------

By default, containers run with unbounded resources on a Kubernetes cluster.
This is not ideal in production environments, as a single pod could monopolize
all available resources on a worker node. LimitRange is a policy to constrain
resource allocations (for pods or containers) in a particular namespace.

Specifically a LimitRange policy provides constraints that can:

*   Enforce minimum and maximum compute resources usage per pod or container in
    a namespace.
*   Enforce minimum and maximum storage request per PersistentVolumeClaim in a
    namespace.
*   Enforce a ratio between request and limit for a resource in a namespace.
*   Set the default request/limit for compute resources in a namespace and
    automatically inject them to containers at runtime.

See https://kubernetes.io/docs/concepts/policy/limit-range/ for more details.

An example of LimitRange policies for the ``billing-dept-ns`` namespace in the
:doc:`k8s_pod_sec_policies` example is shown below:

::

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

-------------
ResourceQuota
-------------

A ResourceQuota policy object provides constraints that limit aggregate resource
consumption per namespace. It can limit the quantity of objects that can be
created in a namespace by type, as well as the total amount of compute resources
that may be consumed by resources in that project. ResourceQuota limits can be
created for CPU, memory, storage, and resource counts for all standard
namespaced resource types such as secrets, configmaps, and others.

See https://kubernetes.io/docs/concepts/policy/resource-quotas/ for more details.

An example of ResourceQuota policies for the ``billing-dept-ns`` namespace of
the :doc:`k8s_pod_sec_policies` example is shown below:

::

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

