
.. pui1590088143541
.. _pod-security-policies:

=====================
Pod Security Policies
=====================

.. note::

   PodSecurityPolicy (PSP) ONLY applies if running on K8S v1.24 or earlier.
   PodSecurityPolicy (PSP) is deprecated as of Kubernetes v1.21 and removed from K8S v1.25.
   Instead of using PodSecurityPolicy, you can enforce similar restrictions on Pods using
   :ref:`Pod Security Admission Controller <pod-security-admission-controller-8e9e6994100f>`

|PSPs| enable fine-grained authorization of pod creation and updates.

|PSPs| control access to security sensitive aspects of Pod specifications
such as running of privileged containers, use of host filesystem, running as
root, etc. |PSPs| define a set of conditions that a pod must run with, in
order to be accepted into the system, as well as defaults for the related
fields. |PSPs| are assigned to users through Kubernetes |RBAC| RoleBindings.
See `https://kubernetes.io/docs/concepts/policy/pod-security-policy/
<https://kubernetes.io/docs/concepts/policy/pod-security-policy/>`__ for
details.

When enabled, Pod security policy checking will authorize all Kubernetes
API commands against the |PSPs| which the issuer of the command has access
to. If there are no |PSPs| defined in the system or the issuer does not have
access to any |PSPs|, the Pod security policy checking will fail to authorize
the command.

|prod-long| provides a system service-parameter to enable Pod security
policy checking. Setting this parameter also creates:

-	Two |PSPs| (privileged and restricted) such that users with cluster-admin
 	role (which has access to all resources) has |PSPs| to authorize against.

-	Two corresponding roles for specifying access to these |PSPs|
 	(privileged-psp-user and restricted-psp-user), for binding to other
 	non-admin type subjects.

-	A RoleBinding for the kube-system namespace of the privileged-psp-user Role
 	to serviceAccounts in kubesystem, such that privileged
 	Deployments/ReplicaSets/etc. can be created by any user with access to
 	Deployments/ReplicaSets/etc. in the kube-system namespace (e.g. user with
 	cluster-admin role).

-   A ClusterRoleBinding of the restricted-psp-user Role to any authenticated
    user, such that at least restricted Pods can be created by any
    authenticated user in any namespaces that user has access to based on other
    [Cluster]RoleBindings.

-	A ClusterRoleBinding of the restricted-psp-user Role to serviceAccounts in
 	kube-system, such that at least restricted Deployments/ReplicaSets/etc. can
 	be created by any authenticated user in any namespaces that user has access
 	to based on other [Cluster]RoleBindings.

PodSecurityPolicy (PSP) is deprecated as of Kubernetes v1.21 and will be
removed in v1.25. PSP will continue to be fully functional until being removed
in v1.25.

Since first introduced PSP has shown some serious usability problems.

The way PSPs are applied to Pods has proven confusing especially when trying to
use them. It is easy to accidentally grant broader permissions than intended,
and difficult to inspect which PSPs apply in a certain situation.

As a beta feature, Kubernetes offers a built-in Pod Security Admission (PSA)
controller, the successor to PSP. See :ref:`Technology Preview - Pod Security
Admission Controller <pod-security-admission-controller-8e9e6994100f>`.
