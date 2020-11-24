
.. iac1588347002880
.. _kubernetes-user-tutorials-cert-manager:

============
Cert Manager
============

|prod| integrates the open source project cert-manager.

Cert-manager is a native Kubernetes certificate management controller, that
supports certificate management with external certificate authorities \(CAs\).
nginx-ingress-controller is also integrated with |prod| in support of http-01
challenges from CAs as part of cert-manager certificate requests.

For more information about Cert Manager, see `cert-manager.io
<http://cert-manager.io>`__.

.. _kubernetes-user-tutorials-cert-manager-section-lz5-gcw-nlb:

------------------------------------
Prerequisites for using Cert Manager
------------------------------------

.. _kubernetes-user-tutorials-cert-manager-ul-rd3-3cw-nlb:

-   Ensure that your |prod| administrator has shared the local registry's
    public repository's credentials/secret with the namespace where you will
    create certificates,. This will allow you to leverage the
    ``registry.local:9001/public/cert-manager-acmesolver`` image.

-   Ensure that your |prod| administrator has enabled use of the
    cert-manager apiGroups in your RBAC policies.

.. _kubernetes-user-tutorials-cert-manager-section-y5r-qcw-nlb:

----------------------------------------------
Resources on Creating Issuers and Certificates
----------------------------------------------

.. _kubernetes-user-tutorials-cert-manager-ul-uts-5cw-nlb:

-   Configuration documentation:

    -   `https://cert-manager.io/docs/configuration
        <https://cert-manager.io/docs/configuration/>`__/

        This link provides details on creating different types of certificate
        issuers or CAs.

-   Usage documentation:

    -   `https://cert-manager.io/docs/usage/certificate/
        <https://cert-manager.io/docs/usage/certificate/>`__

        This link provides details on creating a standalone certificate.

    -   `https://cert-manager.io/docs/usage/ingress/
        <https://cert-manager.io/docs/usage/ingress/>`__

        This link provides details on adding a cert-manager annotation to an
        Ingress in order to specify the certificate issuer for the ingress to
        use to request the certificate for its https connection.

-   :ref:`LetsEncrypt Example <letsencrypt-example>`
