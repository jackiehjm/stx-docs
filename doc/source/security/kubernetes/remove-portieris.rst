
.. kqa1596551916697
.. _remove-portieris:

================
Remove Portieris
================

You can remove the Portieris admission controller completely from a |prod|
system.

.. rubric:: |proc|

#.  Remove the application.

    .. code-block:: none

        ~(keystone_admin)$ system application-remove portieris

#.  Delete kubernetes resources not automatically removed in the previous step.

    This is required if you plan to reapply the application.

    .. code-block:: none

        ~(keystone_admin)$ kubectl delete clusterroles.rbac.authorization.k8s.io portieris
        ~(keystone_admin)$ kubectl delete clusterrolebindings.rbac.authorization.k8s.io admission-portieris-webhook
        ~(keystone_admin)$ kubectl delete -n portieris secret/portieris-certs
        ~(keystone_admin)$ kubectl delete -n portieris cm/image-policy-crds
        ~(keystone_admin)$ kubectl delete -n portieris serviceaccounts/portieris

    .. note::
        If this step is done before removing the application in step 1, the
        removal will fail, leaving the application in the **remove-failed**
        state. In such cases you will need to issue the following commands
        to recover:

        .. code-block:: none

            ~(keystone_admin)$ kubectl delete MutatingWebhookConfiguration image-admission-config --ignore-not-found=true
            ~(keystone_admin)$ kubectl delete ValidatingWebhookConfiguration image-admission-config --ignore-not-found=true
            ~(keystone_admin)$ kubectl delete crd clusterimagepolicies.securityenforcement.admission.cloud.ibm.com imagepolicies.securityenforcement.admission.cloud.ibm.com --ignore-not-found=true
            ~(keystone_admin)$ kubectl delete clusterroles.rbac.authorization.k8s.io portieris --ignore-not-found=true
            ~(keystone_admin)$ kubectl delete clusterrolebindings.rbac.authorization.k8s.io admission-portieris-webhook   --ignore-not-found=true
            ~(keystone_admin)$ kubectl delete ns/portieris --ignore-not-found=true
            ~(keystone_admin)$ helm delete portieris-portieris --purge --no-hooks
            ~(keystone_admin)$ system application-remove portieris

#.  Delete the application.

    .. code-block:: none

        ~(keystone_admin)$ system application-delete portieris


