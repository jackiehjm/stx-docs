
.. ecz1590154334366
.. _disable-pod-security-policy-checking:

====================================
Disable Pod Security Policy Checking
====================================

You can delete the previously added PodSecurityPolicy service parameter to
disable pod security policy checking.

.. rubric:: |proc|

#.  Remove the kubernetes **kube_apiserver admission_plugins** system
    parameter to exclude PodSecurityPolicy.

    .. code-block:: none

        ~(keystone_admin)]$ system service-parameter-delete <uuid>

#.  Apply the Kubernetes system parameters.

    .. code-block:: none

        ~(keystone_admin)]$ system service-parameter-apply kubernetes


