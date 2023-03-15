
.. vca1590088383576
.. _enable-pod-security-policy-checking:

===================================
Enable Pod Security Policy Checking
===================================

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


