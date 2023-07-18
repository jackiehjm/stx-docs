=====================
Pod Security Policies
=====================

.. note::

   PodSecurityPolicy (PSP) ONLY applies if running on K8S v1.24 or earlier.
   PodSecurityPolicy (PSP) is deprecated as of Kubernetes v1.21 and removed from K8S v1.25.
   Instead of using PodSecurityPolicy, you can enforce similar restrictions on Pods using
   :ref:`Pod Security Admission Controller <pod-security-admission-controller-8e9e6994100f>`

.. note::

   This guide was replaced by: :ref:`Pod Security Policies <pod-security-policies>`

This guide describes how to enable Kubernetes pod security policies.

.. contents::
   :local:
   :depth: 1

--------
Overview
--------

Pod Security Policies (PSPs) enable fine-grained authorization of pod creation
and updates. :abbr:`PSPs (Pod Security Policies)` control access to security
sensitive aspects of pod specifications such as running of privileged
containers, use of host file system, running as root, etc. PSPs define a set of
conditions that a pod must run with in order to be accepted into the system, as
well as defaults for the related fields. PSPs are assigned to users using
Kubernetes RBAC RoleBindings. See
https://kubernetes.io/docs/concepts/policy/pod-security-policy/ for details.

When enabled, pod security policy checking authorizes all Kubernetes API
commands against the PSPs which the issuer of the command has access to. If
there are no PSPs defined in the system or the issuer does not have access to
any PSPs, PSP checking will fail to authorize the command.

StarlingX provides a system service parameter to enable pod security policy
checking. Setting this service parameter also creates two PSPs (privileged and
restricted). Users with the cluster-admin role can access all resources and
therefore have PSPs to authorize against. The parameter also creates two
corresponding roles for specifying access to these PSPs (``privileged-psp-user``
and ``restricted-psp-user``) for binding to other non-admin type subjects.

-------------------
Enable PSP checking
-------------------

Perform the following steps.

#.  Set the Kubernetes ``kube_apiserver admission_plugins`` system parameter to
    include PodSecurityPolicy.

    ::

       system service-parameter-add kubernetes kube_apiserver admission_plugins=PodSecurityPolicy

#.  Apply the Kubernetes system parameters.

    ::

       system service-parameter-apply kubernetes

Use the following commands to view the automatically added PSPs, as well as
privileged and restricted PSPs.

::

    kubectl get psp
    kubectl describe psp privileged
    kubectl describe psp restricted

-------------------------------
Update role for non-admin users
-------------------------------

After enabling Pod security policy checking in StarlingX, all users
with the cluster-admin role are unaffected because they have access to the
privileged PSP. However, other users require a new ``RoleBinding`` to either
the privileged-psp-user role or the restricted-psp-user role.

For example, the following ``RoleBinding`` assigns the restricted PSP to
``basic-user`` in the ``billing-dept-ns`` namespace:

::

    apiVersion: rbac.authorization.k8s.io/v1
    kind: RoleBinding
    metadata:
      name: basic-restricted-psp-users
      namespace: billing-dept-ns
    subjects:
    - kind: ServiceAccount
      name: basic-user
      namespace: kube-system
    roleRef:
       apiGroup: rbac.authorization.k8s.io
       kind: ClusterRole
       name: restricted-psp-user

This enables ``basic-user`` to create pods in the ``billing-dept-ns`` namespace
subject to the restricted PSP policy.

---------------------------------
Bind to the PSP for the namespace
---------------------------------

An unexpected behavior when PSP checking is enabled is that the above
``basic-user`` is able to create pods in ``billing-dept-ns`` (subject to the
restricted PSP), however they are **not** able to create deployments. This is
because the pods of the deployment are created using the replicaSet
controller’s serviceAccount and RBAC bindings, not the ``basic-user``
serviceAccount and RBAC bindings.

The typical approach for addressing this is to bind all the serviceAccounts in
kube-system (which includes replicaSet controller serviceAccounts) to the
appropriate PSP for the specific namespace.

For example, the following RoleBinding assigns the restricted PSP to all
kube-system serviceAccounts operating in the ``billing-dept-ns`` namespace.

::

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
