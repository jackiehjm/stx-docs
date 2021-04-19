
.. ler1590089128119
.. _assign-pod-security-policies:

============================
Assign Pod Security Policies
============================

This section describes Pod security policies for **cluster-admin users**,
and **non-cluster-admin users**.

.. contents::
   :local:
   :depth: 1

.. _assign-pod-security-policies-section-xyl-2vp-bmb:

-------------------
cluster-admin users
-------------------

After enabling |PSP| checking, all users with **cluster-admin** roles can
directly create pods since they have access to the **privileged** |PSP|. Also,
based on the ClusterRoleBindings and RoleBindings automatically added by
|prod|, all users with cluster-admin roles can also create privileged
Deployment/ReplicaSets/etc. in the kube-system namespace and restricted
Deployment/ReplicaSets/etc. in any other namespace.


In order to enable privileged Deployment/ReplicaSets/etc. to be created in
another namespace, a role binding of a |PSP| role to
**system:serviceaccounts:kube-system** for the target namespace, is required.
However, this will enable *ANY* user with access to Deployments/ReplicaSets/etc
in this namespace to create privileged Deployments/ReplicaSets. The following
example describes the required RoleBinding to allow "creates" of privileged
Deployments/ReplicaSets/etc in the 'default' namespace for any user with access
to Deployments/ReplicaSets/etc. in the ‘default’ namespace.

.. code-block:: none

    apiVersion: rbac.authorization.k8s.io/v1
    kind: RoleBinding
    metadata:
      name: default-privileged-psp-users
      namespace: default
    roleRef:
       apiGroup: rbac.authorization.k8s.io
       kind: ClusterRole
       name: privileged-psp-user
    subjects:
    - kind: Group
      name: system:serviceaccounts:kube-system
      apiGroup: rbac.authorization.k8s.io



.. _assign-pod-security-policies-section-bm5-vxp-bmb:

-----------------------
non-cluster-admin users
-----------------------

Based on the ClusterRoleBindings and RoleBindings automatically added by
|prod|, non-cluster-admin users have at least restricted |PSP| privileges, for
both Pods and Deployment/ReplicaSets/etc., for any namespaces they have access
to based on other [Cluster]RoleBindings. If a non-cluster-admin user requires
privileged capabilities for the namespaces they have access to, they require a
new RoleBinding to the **privileged-psp-user** role to create pods directly.
For creating privileged pods through deployments/ReplicaSets/etc., the target
namespace being used will also require a RoleBinding for the corresponding
controller serviceAccounts in kube-system \(or generally
**system:serviceaccounts:kube-system**\).

.. rubric:: |proc|

#.  Define the required RoleBinding for the user in the target namespace.

    For example, the following RoleBinding assigns the 'privileged' |PSP|
    role to dave-user in the billing-dept-ns namespace, from the examples
    in :ref:`Enable Pod Security Policy Checking
    <enable-pod-security-policy-checking>`.

    .. code-block:: none

        apiVersion: rbac.authorization.k8s.io/v1
        kind: RoleBinding
        metadata:
          name: dave-privileged-psp-users
          namespace: billing-dept-ns
        subjects:
        - kind: ServiceAccount
          name: dave-user
          namespace: kube-system
        roleRef:
           apiGroup: rbac.authorization.k8s.io
           kind: ClusterRole
           name: privileged-psp-user

    This will enable dave-user to create Pods in billing-dept-ns namespace
    subject to the privileged |PSP| policy.

#.  Define the required RoleBinding for system:serviceaccounts:kube-system
    in the target namespace.

    For example, the following RoleBinding assigns the 'privileged' |PSP| to
    all kube-system ServiceAccounts operating in billing-dept-ns namespace.

    .. code-block:: none

        apiVersion: rbac.authorization.k8s.io/v1
        kind: RoleBinding
        metadata:
          name: billing-dept-ns-privileged-psp-users
          namespace: billing-dept-ns
        roleRef:
           apiGroup: rbac.authorization.k8s.io
           kind: ClusterRole
           name: privileged-psp-user
        subjects:
        - kind: Group
          name: system:serviceaccounts:kube-system
          apiGroup: rbac.authorization.k8s.io

    This will enable dave-user to create Deployments/ReplicaSets/etc. in
    billing-dept-ns namespace subject to the privileged |PSP| policy.


