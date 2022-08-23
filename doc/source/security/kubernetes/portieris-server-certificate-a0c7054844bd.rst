.. _portieris-server-certificate-a0c7054844bd:

============================
Portieris Server Certificate
============================

Portieris allows you to configure trust policies for an individual namespace or
cluster-wide, and checks the image against a signed image list on a specified
notary server to enforce the configured image policies.

Refer to :ref:`Portieris Admission Controller
<portieris-admission-controller-security-index>` for details about Portieris
installation and configuration.

The |prod| implementation of Portieris is integrated with cert-manager.

Once Portieris application is applied, the server certificate is created in
cert-manager and stored in a secret in the Portieris namespace.

The server certificate has default 3 month validity.

-   Certificate in cert-manager:  portieris-certs

-   Certificate secret: portieris-certs

This server certificate is used by Portieris webhook for secure communication
with ``kube-apiserver``.

In order for Portieris on the |prod| to securely access registries or notary
servers with certificates signed by a custom |CA| certificate, the caCert:
CERTIFICATE override must be added to the portieris-certs Helm chart so that
Portieris trusts the custom |CA| certificate.

This must be passed as the base-64 encoded (b64enc) format of the |CA|
certificate and may contain one or more |CA| certificates.

------------------------------
Install Portieris certificates
------------------------------

The Portieris server certificate is automatically created and managed by
cert-manager once Portieris application is applied.

One or more |CA| certificates can be installed for Portieris to trust
registries and notary servers.

Refer to :ref:`Install Portieris <install-portieris>` for |CA|
certificates installation.

-----------------------------------
Update/Renew Portieris certificates
-----------------------------------

Portieris server certificate is managed by cert-manager.

.. note::

    Currently notification of the renewal is not supported.

It is recommended to re-configure the automatically configured Portieris
Certificate to have a long duration since certificate renewal is not fully
supported for Portieris.

|CA| certificates can be updated the same way as installation.

Once |CA| certificates are updated, you must restart Portieris using the command:

.. code-block::

    ~(keystone_admin)]$ kubectl rollout restart deployment portieris-portieris -n portieris
