
.. mid1588344357117
.. _enable-use-of-cert-manager-acmesolver-image-in-a-particular-namespace:

=====================================================================
Enable Use of cert-manager-acmesolver Image in a Particular Namespace
=====================================================================

When an arbitrary user creates a certificate with an external |CA|,
cert-manager dynamically creates the cert-manager-acmesolver pod and an
ingress in the user-specified namespace in order to handle the http01
challenge from the external CA.

.. rubric:: |context|

In order to pull the
registry.local:9001:/public/cert-manager-acmesolver:|v_jetstack-cert-manager-acmesolver| image from the
local registry, the credentials for the public repository must be in a
secret and referenced in an ImagePullSecret in the **default**
serviceAccount of that user-specified namespace.

.. rubric:: |proc|

#.  Execute the following commands, substituting your deployment-specific
    value for <USERNAMESPACE>.

    .. code-block:: none

        % kubectl get secret registry-local-public-key -n kube-system -o yaml | grep -v '^\s*namespace:\s'  | kubectl apply --namespace=<USERNAMESPACE> -f -

        % kubectl patch serviceaccount default  -p "{\"imagePullSecrets\": [{\"name\": \"registry-local-public-key\"}]}" -n <USERNAMESPACE>



