
.. cwn1581381515361
.. _configure-oidc-auth-applications:

================================
Configure OIDC Auth Applications
================================

The **oidc-auth-apps** application is a system application that needs to be
configured to use a remote Windows Active Directory server to authenticate
users of the Kubernetes API. The **oidc-auth-apps** is packaged in the ISO
and uploaded by default.

.. rubric:: |prereq|


.. _configure-oidc-auth-applications-ul-gpz-x51-llb:

-   You must have configured the Kubernetes **kube-apiserver** to use
    the **oidc-auth-apps** |OIDC| identity provider for validation of
    tokens in Kubernetes API requests, which use |OIDC| authentication. For
    more information on configuring the Kubernetes **kube-apiserver**, see
    :ref:`Configure Kubernetes for OIDC Token Validation while
    Bootstrapping the System
    <configure-kubernetes-for-oidc-token-validation-while-bootstrapping-the-system>`
    or :ref:`Configure Kubernetes for OIDC Token Validation after
    Bootstrapping the System
    <configure-kubernetes-for-oidc-token-validation-after-bootstrapping-the-system>`.

-   You must have a |CA| signed certificate \(dex-cert.pem file\), and private
    key \(dex-key.pem file\) for the dex |OIDC| Identity Provider of
    **oidc-auth-apps**.

    This certificate *must* have the |prod|'s floating OAM IP Address in
    the |SAN| list. If you are planning on defining and using a DNS
    name for the |prod|'s floating OAM IP Address, then this DNS name
    *must* also be in the |SAN| list. Refer to the documentation for
    the external |CA| that you are using, in order to create a signed
    certificate and key.

    If you are using an intermediate |CA| to sign the dex certificate, include
    both the dex certificate \(signed by the intermediate |CA|\), and the
    intermediate |CA|'s certificate \(signed by the Root |CA|\) in that order, in
    **dex-cert.pem**.

-   You must have the certificate of the |CA|\(**dex-ca.pem** file\) that
    signed the above certificate for the dex |OIDC| Identity Provider of
    **oidc-auth-apps**.

    If an intermediate |CA| was used to sign the dex certificate and both the
    dex certificate and the intermediate |CA| certificate was included in
    **dex-cert.pem**, then the **dex-ca.pem** file should contain the root
    |CA|'s certificate.

    If the signing |CA| \(**dex-ca.pem**\) is not a well-known trusted |CA|, you
    must ensure the system trusts the |CA| by specifying it either during the
    bootstrap phase of system installation, by specifying '**ssl\_ca\_cert:
    dex-ca.pem**' in the ansible bootstrap overrides **localhost.yml** file,
    or by using the **system certificate-install -m ssl\_ca dex-ca.pem**
    command.


.. rubric:: |proc|


.. _configure-oidc-auth-applications-steps-kll-nbm-tkb:

#.  Create the secret, **local-dex.tls**, with the certificate and key, to be
    used by the **oidc-auth-apps**, as well as the secret, **dex-client-secret**,
    with the |CA|'s certificate that signed the **local-dex.tls** certificate.

    For example, assuming the cert and key pem files for creating these
    secrets are in /home/sysadmin/ssl/, run the following commands to create
    the secrets:

    .. note::
        **oidc-auth-apps** looks specifically for secrets of these names in
        the **kube-system** namespace.

        For the generic secret **dex-client-secret**, the filename must be
        '**dex-ca.pem**'.

    .. code-block:: none

        ~(keystone_admin)$ kubectl create secret tls local-dex.tls --cert=ssl/dex-cert.pem --key=ssl/dex-key.pem -n kube-system

        ~(keystone_admin)$ kubectl create secret generic dex-client-secret --from-file=/home/sysadmin/ssl/dex-ca.pem -n kube-system

    Create the secret **wadcert** with the |CA|'s certificate that signed
    the Active Directory's certificate using the following command:

    .. code-block:: none

        ~(keystone_admin)$ kubectl create secret generic wadcert --from-file=ssl/AD_CA.cer -n kube-system

#.  Specify user overrides for **oidc-auth-apps** application, by using the following command:

    .. code-block:: none

        ~(keystone_admin)$ system helm-override-update oidc-auth-apps dex kube-system --values /home/sysadmin/dex-overrides.yaml

    The dex-overrides.yaml file contains the desired dex helm chart overrides
    \(that is, the LDAP connector configuration for the Active Directory
    service, optional token expiry, and so on.\), and volume mounts for
    providing access to the **wadcert** secret, described in this section.

    For the complete list of dex helm chart values supported, see `Dex Helm
    Chart Values
    <https://github.com/helm/charts/blob/92b6289ae93816717a8453cfe62bad51cbdb
    8ad0/stable/dex/values.yaml>`__. For the complete list of parameters of
    the dex LDAP connector configuration, see `Dex LDAP Connector
    Configuration
    <https://github.com/dexidp/dex/blob/master/Documentation/connectors/ldap.
    md>`__.

    The example below configures a token expiry of ten hours, a single LDAP
    connector to an Active Directory service using HTTPS \(LDAPS\) using the
    **wadcert** secret configured in this section, the required Active
    Directory service login information \(that is, bindDN, and bindPW\), and
    example :command:`userSearch`, and :command:`groupSearch` clauses.

    .. code-block:: none

        config:
          expiry:
            idTokens: "10h"
          connectors:
          - type: ldap
            name: OpenLDAP
            id: ldap
            config:
              host: pv-windows-acti.cumulus.wrs.com:636
              rootCA: /etc/ssl/certs/adcert/AD_CA.cer
              insecureNoSSL: false
              insecureSkipVerify: false
              bindDN: cn=Administrator,cn=Users,dc=cumulus,dc=wrs,dc=com
              bindPW: Li69nux*
              usernamePrompt: Username
              userSearch:
                baseDN: ou=Users,ou=Titanium,dc=cumulus,dc=wrs,dc=com
                filter: "(objectClass=user)"
                username: sAMAccountName
                idAttr: sAMAccountName
                emailAttr: sAMAccountName
                nameAttr: displayName
              groupSearch:
                baseDN: ou=Groups,ou=Titanium,dc=cumulus,dc=wrs,dc=com
                filter: "(objectClass=group)"
                userAttr: DN
                groupAttr: member
                nameAttr: cn
        extraVolumes:
        - name: certdir
          secret:
            secretName: wadcert
        extraVolumeMounts:
        - name: certdir
          mountPath: /etc/ssl/certs/adcer

    If more than one Windows Active Directory service is required for
    authenticating the different users of the |prod|, multiple '**ldap**'
    type connectors can be configured; one for each Windows Active
    Directory service.

    If more than one **userSearch** plus **groupSearch** clauses are
    required for the same Windows Active Directory service, multiple
    '**ldap**' type connectors, with the same host information but
    different **userSearch** plus **groupSearch** clauses, should be used.

    Whenever you use multiple '**ldap**' type connectors, ensure you use
    unique '**name:**' and '**id:**' parameters for each connector.

#.  Use the :command:`system application-apply` command to apply the
    configuration:

    .. code-block:: none

        ~(keystone_admin)$ system application-apply oidc-auth-apps

