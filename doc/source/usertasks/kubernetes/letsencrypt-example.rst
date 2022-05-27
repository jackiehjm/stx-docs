
.. nst1588348086813
.. _letsencrypt-example:

==========================================
External CA and Ingress Controller Example
==========================================

This section describes how to configure an application to use Ingress
Controller to both expose its |TLS|-based service and to use an External |CA|
for signing CERTIFICATEs.

NOTE that alternatively an Internal |CA| could be used with an Ingress
Controller -based solution as well.

.. rubric:: |prereq|

This example requires that:

.. _letsencrypt-example-ul-h3j-f2w-nlb:

-   The LetsEncrypt |CA| in the public internet can send an http01 challenge to
    the |FQDN| of the |prod|'s floating |OAM| IP Address.

-   The |prod| has access to the kuard demo application at
    `gcr.io/kuar-demo/kuard-amd64:blue <gcr.io/kuar-demo/kuard-amd64:blue>`__

-   Ensure that your |prod| administrator has shared the local
    registry’s public repository’s credentials/secret with the namespace where
    you will create certificates. This will allow you to leverage the
    :command:`registry.local:9001/public/cert-manager-acmesolver` image. See
    :ref:`Set up a Public Repository in Local Docker Registry
    <setting-up-a-public-repository>`.

-   Ensure that your |prod| administrator has enabled use of the
    cert-manager apiGroups in your |RBAC| policies.

-   Ensure that your |prod| administrator has opened port 80 and 443 in
    GlobalNetworkPolicy.

.. rubric:: |proc|

#.  Create a LetsEncrypt ISSUER in the default namespace by applying the
    following manifest file.

    .. code-block:: none

        apiVersion: cert-manager.io/v1
        kind: Issuer
        metadata:
          name: letsencrypt-prod
        spec:
          acme:
            # The ACME server URL
            server: https://acme-v02.api.letsencrypt.org/directory
            # Email address used for ACME registration
            email: dave.user@hotmail.com
            # Name of a secret used to store the ACME account private key
            privateKeySecretRef:
              name: letsencrypt-prod
            # Enable the HTTP-01 challenge provider
            solvers:
            - http01:
                ingress:
                  class: nginx

#.  Create a deployment of the kuard demo application
    \(`https://github.com/kubernetes-up-and-running/kuard
    <https://github.com/kubernetes-up-and-running/kuard>`__\) with an INGRESS
    using cert-manager by applying the following manifest file:

    Where both ``starlingx.mycompany.com`` and
    ``kuard.starlingx.mycompany.com`` are |FQDNs| that map to the |OAM|
    Floating IP of |prod|.

    (You should substitute these for |FQDNs| for the |prod| installation.)


    .. parsed-literal::

        apiVersion: apps/v1
        kind: Deployment
        metadata:
          name: kuard
        spec:
          replicas: 1
          selector:
            matchLabels:
              app: kuard
          template:
            metadata:
              labels:
                app: kuard
            spec:
              containers:
              - name: kuard
                image: gcr.io/kuar-demo/kuard-amd64:blue
                imagePullPolicy: Always
                ports:
                - containerPort: 8080
                  protocol: TCP
        ---
        apiVersion: v1
        kind: Service
        metadata:
          name: kuard
          labels:
            app: kuard
        spec:
          ports:
            - port: 80
              targetPort: 8080
              protocol: TCP
          selector:
            app: kuard
        ---
        apiVersion: networking.k8s.io/v1
        kind: Ingress
        metadata:
          annotations:
            cert-manager.io/issuer: "letsencrypt-prod"
          name: kuard
        spec:
          ingressClassName: nginx
          tls:
          - hosts:
            - kuard.starlingx.mycompany.com
            secretName: kuard-ingress-tls
          rules:
            - host: kuard.starlingx.mycompany.com
              http:
                paths:
                - backend:
                    service:
                      name: kuard
                      port:
                        number: 80
                  path: /
                  pathType: Prefix

#.  Access the kuard demo from your browser to inspect and verify that the
    certificate is signed by LetsEncrypt |CA|. For this example, the URL
    would be https://kuard.starlingx.mycompany.com.
