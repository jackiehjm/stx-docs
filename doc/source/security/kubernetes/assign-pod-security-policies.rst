
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
directly create pods as they have access to the **privileged** |PSP|.
However, when creating pods through deployments/ReplicaSets/etc., the pods
are validated against the |PSP| policies of the corresponding controller
serviceAccount in kube-system namespace.

Therefore, for any user \(including cluster-admin\) to create
deployment/ReplicaSet/etc. in a particular namespace:


.. _assign-pod-security-policies-ul-hsr-1vp-bmb:

-   the user must have |RBAC| permissions to create the
    deployment/ReplicaSet/etc. in this namespace, and

-   the **system:serviceaccounts:kube-system** must be bound to a role with
    access to |PSPs| \(for example, one of the system created
    **privileged-psp-user** or **restricted-psp-user** roles\) in this
    namespace


**cluster-admin users** have |RBAC| permissions for everything. So it is only
the role binding of a |PSP| role to **system:serviceaccounts:kube-system**
for the target namespace, that is needed to create a deployment in a
particular namespace. The following example describes the required
RoleBinding for a **cluster-admin user** to create a deployment \(with
restricted |PSP| capabilities\) in the 'default' namespace.

.. code-block:: none

    apiVersion: rbac.authorization.k8s.io/v1
    kind: RoleBinding
    metadata:
      name: kube-system-restricted-psp-users
      namespace: default
    roleRef:
       apiGroup: rbac.authorization.k8s.io
       kind: ClusterRole
       name: restricted-psp-user
    subjects:
    - kind: Group
      name: system:serviceaccounts:kube-system
      apiGroup: rbac.authorization.k8s.io



.. _assign-pod-security-policies-section-bm5-vxp-bmb:

-----------------------
non-cluster-admin users
-----------------------

They have restricted |RBAC| capabilities, and may not have access to |PSP|
policies. They require a new RoleBinding to either the
**privileged-psp-user** role, or the **restricted-psp-user** role to create
pods directly. For creating pods through deployments/ReplicaSets/etc., the
target namespace being used will also require a RoleBinding for the
corresponding controller serviceAccounts in kube-system \(or generally
**system:serviceaccounts:kube-system**\).

.. rubric:: |proc|

#.  Define the required RoleBinding for the user in the target namespace.

    For example, the following RoleBinding assigns the 'restricted' |PSP|
    role to dave-user in the billing-dept-ns namespace, from the examples
    in :ref:`Enable Pod Security Policy Checking
    <enable-pod-security-policy-checking>`.

    .. code-block:: none

        apiVersion: rbac.authorization.k8s.io/v1
        kind: RoleBinding
        metadata:
          name: dave-restricted-psp-users
          namespace: billing-dept-ns
        subjects:
        - kind: ServiceAccount
          name: dave-user
          namespace: kube-system
        roleRef:
           apiGroup: rbac.authorization.k8s.io
           kind: ClusterRole
           name: restricted-psp-user

    This will enable dave-user to create Pods in billing-dept-ns namespace
    subject to the restricted |PSP| policy.

#.  Define the required RoleBinding for system:serviceaccounts:kube-system
    in the target namespace.

    For example, the following RoleBinding assigns the 'restricted' |PSP| to
    all kube-system ServiceAccounts operating in billing-dept-ns namespace.

    .. code-block:: none

        apiVersion: rbac.authorization.k8s.io/v1
        kind: RoleBinding
        metadata:
          name: kube-system-restricted-psp-users
          namespace: billing-dept-ns
        roleRef:
           apiGroup: rbac.authorization.k8s.io
           kind: ClusterRole
           name: restricted-psp-user
        subjects:
        - kind: Group
          name: system:serviceaccounts:kube-system
          apiGroup: rbac.authorization.k8s.io


