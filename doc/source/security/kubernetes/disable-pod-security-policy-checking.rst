
.. ecz1590154334366
.. _disable-pod-security-policy-checking:

====================================
Disable Pod Security Policy Checking
====================================

.. note::

   PodSecurityPolicy (PSP) ONLY applies if running on K8S v1.24 or earlier.
   PodSecurityPolicy (PSP) is deprecated as of Kubernetes v1.21 and removed from K8S v1.25.
   Instead of using PodSecurityPolicy, you can enforce similar restrictions on Pods using
   :ref:`Pod Security Admission Controller <pod-security-admission-controller-8e9e6994100f>`

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


