.. _oidc-client-dex-server-certificates-dc174462d51a:

===================================
OIDC Client Dex Server Certificates
===================================

The oidc-auth-apps application installs a proxy |OIDC| identity provider (dex
server) that can be configured to proxy authentication requests to an |LDAP|
(s) identity provider, such as Windows Active Directory.

The oidc-auth-apps application also provides an |OIDC| client for accessing the
username and password |OIDC| login page for user authentication and retrieval
of tokens.

.. note::

    For details on how installing, configuring, and using oidc-auth-apps,
    refer to :ref:`User Authentication Using Windows Active Directory
    <user-authentication-using-windows-active-directory-security-index>`.

    This section is specifically about |OIDC| certificates management.

Oidc-auth-apps needs three certificates to work:

-   |OIDC| client and identity provider server certificate (secret
    ``local-dex.tls``)

-   |OIDC| trusted |CA| certificate (secret ``dex-client-secret``)

-   Windows Active Directory |CA| certificate (secret wadcert)

**OIDC client and identity provider server certificate**

|OIDC| client and Identity provider server certificate is used to secure the
connection between |OIDC| client and identity provider by HTTPS.

This certificate is stored in Kubernetes TLS secret ``local-dex.tls``.

**OIDC client and identity provider trusted CA certificate**

The |OIDC| trusted |CA| certificate is the |CA| certificate that signs the
|OIDC| client and identity server certificate.

It has to be installed for |OIDC| client to verify identity server’s
certificate for HTTPS connection.

|OIDC| trusted |CA| certificate is stored in Kubernetes secret
``dex-client-secret``.

**Windows Active Directory CA certificate (WAD CA certificate)**

|WAD| certificate is the |CA| certificate that signed the Windows Active
Directory that |OIDC| is configured to proxy authentication requests to.

In order for |OIDC| identity provider (as the authentication proxy) to securely
connect and authenticate users to the Windows Active Directory by HTTPS, the
|WAD|’s |CA| certificate needs to installed and configured for |OIDC| to trust
the Windows Active Directory.

-------------------------
Install OIDC certificates
-------------------------

|OIDC| certificates are not auto generated.

They need to be installed as Kubernetes secrets as part of the |OIDC| app
configuration.

Refer to :ref:`Configure OIDC Auth Applications
<configure-oidc-auth-applications>`, on how to install |OIDC| certificates into
Kubernetes secrets.

------------------------------
Update/Renew OIDC certificates
------------------------------

.. warning::

    |OIDC| certificates are not auto renewed. They have to be updated manually
    by updating the secrets from the new certificate files and restart the
    ``oidc-auth`` application.

.. rubric:: |proc|

#.  Update/renew |OIDC| client and identity provider server certificate:

    .. code-block:: none

        ~(keystone_admin)]$ kubectl create secret tls local-dex.tls --cert=/home/sysadmin/new_ssl/dex-cert.pem --key=/home/sysadmin/new_ssl/dex-key.pem --save-config --dry-run=client -n kube-system -o yaml | kubectl apply -f -

#.  Update/renew |OIDC| trusted |CA| certificate:

    .. code-block:: none

        ~(keystone_admin)]$ kubectl create secret generic dex-client-secret --from-file=/home/sysadmin/new_ssl/dex-ca.pem --save-config --dry-run=client -n kube-system -o yaml | kubectl apply -f -

#.  Update/renew |WAD| |CA| certificate:

    .. code-block:: none

        ~(keystone_admin)]$ kubectl create secret generic wadcert --from-file=/home/sysadmin/new_ssl/AD_CA.cer –save-config –dry-run=client -n kube-system -o yaml | kubectl apply -f -

#.  Restart |OIDC| client and identity provider proxy (dex-server):

    .. code-block:: none

        ~(keystone_admin)]$ kubectl rollout restart deployment oidc-dex -n kube-system
        ~(keystone_admin)]$ kubectl rollout restart deployment stx-oidc-client -n kube-system

