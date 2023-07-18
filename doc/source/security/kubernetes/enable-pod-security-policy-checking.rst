
.. vca1590088383576
.. _enable-pod-security-policy-checking:

===================================
Enable Pod Security Policy Checking
===================================

.. note::

   PodSecurityPolicy (PSP) ONLY applies if running on K8S v1.24 or earlier.
   PodSecurityPolicy (PSP) is deprecated as of Kubernetes v1.21 and removed from K8S v1.25.
   Instead of using PodSecurityPolicy, you can enforce similar restrictions on Pods using
   :ref:`Pod Security Admission Controller <pod-security-admission-controller-8e9e6994100f>`

.. rubric:: |proc|

#.  Set the kubernetes kube_apiserver admission_plugins system parameter to
    include PodSecurityPolicy.

    .. code-block:: none

        ~(keystone_admin)]$ system service-parameter-add kubernetes kube_apiserver admission_plugins=PodSecurityPolicy

#.  Apply the Kubernetes system parameters.

    .. code-block:: none

        ~(keystone_admin)]$ system service-parameter-apply kubernetes

#.  View the automatically added pod security policies.

    .. code-block:: none

        $ kubectl get psp
        $ kubectl describe <psp> privileged
        $ kubectl describe <psp> restricted


