
.. nst1588348086813
.. _letsencrypt-example:

===================
LetsEncrypt Example
===================

The LetsEncrypt example illustrates cert-manager usage.

.. rubric:: |prereq|

This example requires that:

.. _letsencrypt-example-ul-h3j-f2w-nlb:

-   the LetsEncrypt CA in the public internet can send an http01 challenge to
    the FQDN of your |prod|'s floating OAM IP Address.

-   your |prod| has access to the kuard demo application at
    gcr.io/kuar-demo/kuard-amd64:blue

.. rubric:: |proc|

#.  Create a LetsEncrypt Issuer in the default namespace by applying the
    following manifest file.

    .. code-block:: none

        apiVersion: cert-manager.io/v1alpha2
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
    <https://github.com/kubernetes-up-and-running/kuard>`__\) with an ingress
    using cert-manager by applying the following manifest file:

    Substitute values in the example as required for your environment.

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
        apiVersion: extensions/v1beta1
        kind: Ingress
        metadata:
          annotations:
            kubernetes.io/ingress.class: nginx
            cert-manager.io/issuer: "letsencrypt-prod"
          name: kuard
        spec:
          tls:
          - hosts:
            - kuard.my-fqdn-for-|prefix|.company.com
            secretName: kuard-ingress-tls
          rules:
            - host: kuard.my-fqdn-for-|prefix|.company.com
              http:
                paths:
                  - backend:
                      serviceName: kuard
                      servicePort: 80
                    path: /

#.  Access the kuard demo from your browser to inspect and verify that the
    certificate is signed by LetsEncrypt CA. For this example, the URL
    would be https://kuard.my-fqdn-for-|prefix|.company.com.
