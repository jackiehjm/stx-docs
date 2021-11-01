
.. iac1588347002880
.. _kubernetes-user-tutorials-cert-manager:

======================
Certificate Management
======================

|prod| integrates the open source project cert-manager
(http://cert-manager.io), in order to provide certificate management support
for end-users’ containerized applications.

------------------
Cert Manager Modes
------------------

Cert-manager is a native Kubernetes certificate management controller, that
supports the following general modes of operation:

-   Interacting with External Certificate Authorities (|CAs|)

    In this mode, a cert-manager ISSUER is configured to interact with an
    External |CA| of a particular type.  External |CA| types supported by
    cert-manager are ACME, Vault or Venafi (note that |prod| has only
    tested and validated cert-manager with ACME |CAs|).

    When a cert-manager CERTIFICATE is created using this External |CA| ISSUER,
    cert-manager

    -   creates the private key and public certificate,

    -   sends the Certificate Signing Request to the External |CA| using the
        appropriate protocol for the type of External |CA|, and

    -   responds to any challenges (as specified in the CERTIFICATE specs) from
        the |CA|

    The signed certificate is made available in a Kubernetes SECRET specified
    in the CERTIFICATE spec.

    Cert-Manager will also automatically monitor CERTIFICATE expiry dates and
    automatically send an updated Certificate Signing Request messages to the
    External |CA|, prior to expiry of the CERTIFICATE (as specified in the
    CERTIFICATE specs), in order to renew the CERTIFICATE and update the
    Kubernetes SECRET holding the certificate.

    .. figure:: /usertasks/kubernetes/figures/figure_1_cert_manager.png

-   Providing an Internal Certificate Authority

    In this mode, a cert-manager ``selfsigned`` type ISSUER and ``ca`` type
    ISSUER provides a non-challenging Root |CA| for signing certificates local to
    the Kubernetes cluster.

    A ``selfsigned`` type ISSUER is created to automatically create a private key
    and certificate pair for the internal Root |CA|.

    Then a ``ca`` type ISSUER is created with this generated Root |CA|’s
    private-key/certificate pair for signing.

    When a cert-manager CERTIFICATE is created using this Internal ``ca``
    ISSUER, cert-manager

    -   creates the private key and public certificate, and

    -   simply signs the certificate with the ``ca`` ISSUER’s
        private-key/certificate pair.

    The signed certificate is made available in a Kubernetes SECRET specified
    in the CERTIFICATE spec.

    Again, cert-Manager will automatically monitor CERTIFICATE expiry dates and
    automatically request the internal ``ca`` ISSUER to sign an updated
    certificate, prior to expiry of the CERTIFICATE (as specified in the
    CERTIFICATE specs), in order to renew the CERTIFICATE and update the
    Kubernetes SECRET holding the certificate.

    .. figure:: /usertasks/kubernetes/figures/figure_2_cert_manager.png

-   Combination of the above two modes

    For example in a particular RootCA  - IntermediateCA  - Server certificate
    chain,

    -   The RootCA ISSUER in cert-manager could be of type ``acme`` for
        requesting the IntermediateCAs certificate from an external ACME |CA|,

    -   While the IntermediateCA ISSUER in cert-manager could be of type ``ca``
        for signing the server certificates based on the intermediateCA
        certificate (from the external ACME |CA|).

---------------------------------------------------
Using Cert Manager CERTIFICATES in your Application
---------------------------------------------------

How CERTIFICATEs (and their |TLS| type SECRETs) are created and integrated into
an end-user’s application depends on how the end-user has chosen to expose its
service externally.  There are typically two options:

-   The end-user’s application uses ingress controller to expose its service
    (the most common approach)

    In this scenario, the end-user’s application uses |prod|’s
    integrated nginx ingress-controller to both originate/terminate the HTTPS
    connection as well as deal with cert-manager for requesting the required
    CERTIFICATE.

    Specifically, in this scenario, the end-user’s application’s helm chart or
    yaml file must

    -   create an INGRESS object that

        -   specifies the details on ingress forwarding based on the URL
            (hostname, port and path), and

        -   specifies ``|TLS|`` mode along with cert-manager -specific
            annotations for details on creating the CERTIFICATE for this
            ingress connection with cert-manager; minimally the cert-manager
            ISSUER to use must be specified.

    Nginx Ingress Controller will automatically detect when cert-manager renews
    the server certificate and update its HTTPS connection to use the new
    certificate.

    The end-user’s application does not deal with HTTPS or certificates at all.

-   The end-user’s application exposes its service with a NodePort and
    originates/terminates HTTPS itself

    In this scenario, the end-user’s application is originating/terminating
    HTTPS on its own, so it needs access to the Kubernetes SECRET holding the
    |TLS| certificate, in order to establish the HTTPS connection.

    In this scenario, the end-user’s application’s helm chart or yaml file must

    -   create the CERTIFICATE (referencing the desired ISSUER to use, and
        indicating the SECRET to store the certificate in),

    -   include the SECRET as a mounted volume in the pod spec

        -   such that the application’s container can access the |TLS|
            certificate as a |PEM| file for use in establishing the HTTPS
            connection.

    Note that in this scenario, the application’s container must detect when
    the mounted SECRET file changes due to cert-manager auto-renewing the
    CERTIFICATE (and the associated SECRET), and update its HTTPS connection to
    use the updated certificate.

.. seealso::

    See :ref:`External CA and Ingress Controller Example <letsencrypt-example>`
    section for an example of how to configure an application to use Ingress
    Controller to both expose its TLS-based service and to use an External |CA|
    for signing CERTIFICATEs.

    See :ref:`Internal CA and NodePort Example
    <internal-ca-and-nodeport-example-2afa2a84603a>` section for an example of
    how to configure an application to use NodePort to expose its self-managed
    |TLS|-based service and to use an Internal |CA| for signing CERTIFICATEs.
