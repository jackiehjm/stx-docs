
.. qtr1594910639395
.. _create-certificates-locally-using-cert-manager-on-the-controller:

================================================================
Create Certificates Locally using cert-manager on the Controller
================================================================

You can use :command:`cert-manager` to locally create certificates suitable
for use in a lab environment.

.. note::
    
    Ensure the certificates have RSA key length >= 2048 bits. The
    |prod-long| Release |this-ver| provides a new version of ``openssl`` which
    requires a minimum of 2048-bit keys for RSA for better security / encryption
    strength.
    
    You can check the key length by running ``openssl x509 -in <the-certificate-file>
    -noout -text`` and looking for the "Public-Key" in the output. For more
    information see :ref:`Create Certificates Locally using openssl <create-certificates-locally-using-openssl>`.

.. rubric:: |proc|

#.  Create a Root |CA| Certificate and Key.

    #.  Create a self-signing issuer.

        .. code-block:: none

            $ echo "
            apiVersion: cert-manager.io/v1
            kind: Issuer
            metadata:
              name: my-selfsigning-issuer
            spec:
              selfSigned: {}
            " | kubectl apply -f -


    #.  Create a Root CA certificate and key.

        .. code-block:: none

            $ echo "
            apiVersion: cert-manager.io/v1
            kind: Certificate
            metadata:
              name: my-rootca-certificate
            spec:
              secretName: my-rootca-certificate
              commonName: "my-rootca"
              isCA: true
              issuerRef:
                name: my-selfsigning-issuer
                kind: Issuer
            " | kubectl apply -f -

    #.  Create a Root CA Issuer.

        .. code-block:: none

            $ echo "
            apiVersion: cert-manager.io/v1
            kind: Issuer
            metadata:
              name: my-rootca-issuer
            spec:
              ca:
                secretName: my-rootca-certificate
            " | kubectl apply -f -

    #.  Create files for the Root CA certificate and key.

        .. code-block:: none

            $ kubectl get secret my-rootca-certificate -o yaml | egrep "^  tls.crt:" | awk '{print $2}' | base64 --decode > my-rootca-cert.pem
            $ kubectl get secret my-rootca-certificate -o yaml | egrep "^  tls.key:" | awk '{print $2}' | base64 --decode > my-rootca-key.pem

#.  Create and sign a Server Certificate and Key.

    #.  Create the Server certificate and key.

        .. code-block:: none

            $ echo "
            apiVersion: cert-manager.io/v1
            kind: Certificate
            metadata:
              name: my-server-certificate
            spec:
              secretName: my-server-certificate
              duration: 2160h # 90d
              renewBefore: 360h # 15d
              commonName: 1.1.1.1
              dnsNames:
              - myserver.wrs.com
              ipAddresses:
              - 1.1.1.1
              issuerRef:
                name: my-rootca-issuer
                kind: Issuer
            " | kubectl apply -f -

        .. include:: /shared/_includes/recommended-renewbefore-value-for-certificates-c929cf42b03b.rest

    #.  Create the |PEM| files for Server certificate and key.

        .. code-block:: none

            $ kubectl get secret my-server-certificate -o yaml | egrep "^  tls.crt:" | awk '{print $2}' | base64 --decode > my-server-cert.pem
            $ kubectl get secret my-server-certificate -o yaml | egrep "^  tls.key:" | awk '{print $2}' | base64 --decode > my-server-key.pem

    #.  Combine the server certificate and key into a single file.

        .. code-block:: none

            $ cat my-server-cert.pem my-server-key.pem > my-server.pem
