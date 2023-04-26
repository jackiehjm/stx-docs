.. _about-apparmor-ebdab8f1ed87:

==============
About AppArmor
==============

AppArmor is a Mandatory Access Control (MAC) system built on Linux's LSM (Linux
Security Modules) interface. In practice, the kernel queries AppArmor before
each system call to know whether the process is authorized to do the given
operation. Through this mechanism, AppArmor confines programs to a limited set
of resources.

AppArmor helps administrators in running a more secure kubernetes deployment by
restricting what containers/pods are allowed to do, and/or provide better
auditing through system logs. The access needed by a container/pod is
configured through profiles tuned to allow access such as Linux capabilities,
network access, file permissions, etc.

AppArmor applies a set of rules (known as a “profile”) on each program. The
profile applied by the kernel depends on the installation path of the program
being executed, the rules applied do not depend on the user. All users face the
same set of rules when they are executing the same program, but traditional
user permissions still apply and might result in different behavior.

AppArmor profiles contain a list of access control rules on resources that each
program can make use of. Each profile can be loaded either in enforcing or
complaining mode. The former enforces the policy and reports violation
attempts, while the latter does not enforce the policy but still logs the
system calls that would have been denied.

In order to apply a profile to a particular pod, the profile needs to be
available to the host machine where the pod is launched. Security Profile
Operator (SPO, https://github.com/kubernetes-sigs/security-profiles-operator)
provides AppArmor profile management (i.e. loading/unloading) across
Kubernetes nodes. |SPO| defines an AppArmor Profile |CRD|, such that end users
can define AppArmor profiles for |SPO| to manage. Once an AppArmor profile is
loaded to the Kubernetes nodes, it can be applied to a particular pod using
annotations on the pod specification.

For example:

.. code-block:: none

    container.apparmor.security.beta.kubernetes.io/<pod_name>:localhost/<profile_ref>

For more information, refer to `Restrict a Container's Access to Resources with
AppArmor: Example
<https://kubernetes.io/docs/tutorials/security/apparmor/#example>`__.




