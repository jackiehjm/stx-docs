
.. cwn1581381515361
.. _configure-oidc-auth-applications:

=============================
Set up OIDC Auth Applications
=============================

The **oidc-auth-apps** application is a system application that needs to be
configured to use a remote Windows Active Directory server to authenticate
users of the Kubernetes API. The ``oidc-auth-apps`` is packaged in the ISO
and uploaded by default.


Configure OIDC Auth Applications
================================

.. rubric:: |prereq|

.. _configure-oidc-auth-applications-ul-gpz-x51-llb:

-   You must have configured the Kubernetes ``kube-apiserver`` to use
    the **oidc-auth-apps** |OIDC| identity provider for validation of
    tokens in Kubernetes API requests, which use |OIDC| authentication. For
    more information on configuring the Kubernetes ``kube-apiserver``, see
    :ref:`Configure Kubernetes for OIDC Token Validation while
    Bootstrapping the System
    <configure-kubernetes-for-oidc-token-validation-while-bootstrapping-the-system>`
    or :ref:`Configure Kubernetes for OIDC Token Validation after
    Bootstrapping the System
    <configure-kubernetes-for-oidc-token-validation-after-bootstrapping-the-system>`.


.. rubric:: |proc|

#. Create certificates using one of the following options.

   #. Create certificates using cert-manager (recommended):

      Certificates used by ``oidc-auth-apps`` can be managed by Cert-Manager.
      Doing so will automatically renew the certificates before they expire.
      The ``system-local-ca`` ClusterIssuer (see
      :ref:`starlingx-rest-api-applications-and-the-web-admin-server-cert-9196c5794834`)
      will be used to issue this certificate.

      .. important::
          The namespace for ``oidc-auth-apps`` must be ``kube-system``.

      #. Create the |OIDC| client and identity provider server certificate and
         private key pair.

         .. code-block:: none

            ~(keystone_admin)]$ cat <<EOF > oidc-auth-apps-certificate.yaml
            ---
            apiVersion: cert-manager.io/v1alpha2
            kind: Certificate
            metadata:
              name: oidc-auth-apps-certificate
              namespace: kube-system
            spec:
              secretName: oidc-auth-apps-certificate
              duration: 2160h # 90 days
              renewBefore: 360h # 15 days
              issuerRef:
                name: system-local-ca
                kind: ClusterIssuer
              commonName: <OAM_floating_IP_address>
              organizations:
                - ABC-Company
              organizationalUnits:
                - StarlingX-system-oidc-auth-apps
              ipAddresses:
              - <OAM_floating_IP_address>
            EOF

      #. Apply the configuration.

         .. code-block:: none

             ~(keystone_admin)]$ kubectl apply -f oidc-auth-apps-certificate.yaml

      #. Verify the configuration.

         .. code-block:: none

             ~(keystone_admin)]$ kubectl get certificate oidc-auth-apps-certificate –n kube-system

      #. Configure the |OIDC|-client with both the |OIDC| Client and Identity
         Server Certificate and the |OIDC| Client and Identity Trusted |CA|
         certificate.

         Create a secret with the certificate of the root |CA| that signed the
         |OIDC| client and identity provider's server certificate.  In this
         example, it will be the ``ca.crt`` of the ``system-local-ca``
         ClusterIssuer).

         .. code-block:: none

            ~(keystone_admin)]$ mkdir /home/sysadmin/ssl
            ~(keystone_admin)]$ kubectl get secret system-local-ca -n cert-manager -o=jsonpath='{.data.ca\.crt}' | base64 --decode > /home/sysadmin/ssl/dex-ca-cert.crt

            ~(keystone_admin)]$ kubectl create secret generic dex-ca-cert --from-file=/home/sysadmin/ssl/dex-ca-cert.pem  -n kube-system

            ~(keystone_admin)]$ cat <<EOF > stx-oidc-client.yaml
            tlsName: oidc-auth-apps-certificate
            config:
               # The OIDC-client container mounts the dex-ca-cert secret at /home, therefore
               # issuer_root_ca: /home/<filename-only-of-generic-secret>
               issuer_root_ca: /home/dex-ca-cert.crt
               issuer_root_ca_secret: dex-ca-cert
            EOF

            ~(keystone_admin)]$ system helm-override-update oidc-auth-apps oidc-client kube-system --values stx-oidc-client.yaml


      #. Create a secret with the certificate of the |CA| that signed the
         certificate of the remote Windows Active Directory server that you
         will be using.

         Create the secret ``wad-ca-cert`` with the |CA|'s certificate that
         signed the Active Directory's certificate using the following
         command:

         .. code-block:: none

             ~(keystone_admin)]$ kubectl create secret generic wad-ca-cert.crt --from-file=ssl/wad-ca-cert -n kube-system

         Add the following sections to your dex helm overrides to configure the
         |OIDC| Client and Identity Server Certificate and the Windows Active
         Directory server |CA| Certificate for the |OIDC| Identity Server:

         .. code-block:: none

             certs:
               web:
                 secret:
                   tlsName: oidc-auth-apps-certificate
                   caName: oidc-auth-apps-certificate
               grpc:
                 secret:
                   serverTlsName: oidc-auth-apps-certificate
                   clientTlsName: oidc-auth-apps-certificate
                   caName: oidc-auth-apps-certificate
             extraVolumes:
             - name: certdir
               secret:
                 secretName: wad-ca-cert
             extraVolumeMounts:
             - name: certdir
               mountPath: /etc/ssl/certs/wad-ca-cert.crt


      #. Apply the overrides configuration.

         .. code-block:: none

             ~(keystone_admin)]$ system helm-override-update oidc-auth-apps dex kube-system --values dex-overrides.yaml

      #. Configure the secret observer to track changes.

         Change the cronSchedule according to your needs. The cronSchedule
         controls how often the application checks to see if the certificate
         mounted on the dex and oidc-client pods had changed.

         Create a YAML configuration to modify the cronSchedule according to
         your needs.

         The cronSchedule controls how often the application checks to see
         if the certificate mounted on the dex and oidc-client pods changed.
         The following example sets the schedule to every 15 minutes.

         .. code-block:: none

               ~(keystone_admin)]$ cat <<EOF > secret-observer-overrides.yaml
               cronSchedule: "*/15 * * * *"
               observedSecrets:
                 - secretName: "dex-ca-cert"
                   filename: "dex-ca-cert.crt"
                   deploymentToRestart: "stx-oidc-client"
                 - secretName: "oidc-auth-apps-certificate"
                   filename: "tls.crt"
                   deploymentToRestart: "stx-oidc-client"
                 - secretName: "oidc-auth-apps-certificate"
                   filename: "tls.crt"
                   deploymentToRestart: "oidc-dex"
               EOF

      Execute the following command to update the overrides:

      .. code-block:: none

         ~(keystone_admin)]$ system helm-override-update oidc-auth-apps secret-observer kube-system --values secret-observer-overrides.yaml

   #. Use certificates generated and signed by an external |CA|.

      .. rubric:: |prereq|

      -   You must have a |CA| signed certificate (``dex-cert.pem`` file), and
          private key (``dex-key.pem file``) for the dex |OIDC| Identity
          Provider of **oidc-auth-apps**.

          This certificate *must* have the |prod|'s floating |OAM| IP Address
          in the |SAN| list. If you are planning on defining and using a DNS
          name for the |prod|'s floating |OAM| IP Address, then this DNS name
          *must* also be in the |SAN| list. Refer to the documentation for the
          external |CA| that you are using, in order to create a signed
          certificate and key.

          If you are using an intermediate |CA| to sign the dex certificate,
          include both the dex certificate (signed by the intermediate |CA|),
          and the intermediate |CA|'s certificate (signed by the Root |CA|) in
          that order, in ``dex-cert.pem``.

      -   You must have the certificate of the |CA| (``dex-ca.pem`` file) that
          signed the above certificate for the dex |OIDC| Identity Provider of
          **oidc-auth-apps**.

          If an intermediate |CA| was used to sign the dex certificate and both
          the dex certificate and the intermediate |CA| certificate was
          included in ``dex-cert.pem``, then the ``dex-ca.pem`` file should
          contain the root |CA|'s certificate.

          If the signing |CA| (``dex-ca.pem``) is not a well-known trusted
          |CA|, you must ensure the system trusts the |CA| by specifying it
          either during the bootstrap phase of system installation, by
          specifying ``ssl_ca_cert: dex-ca.pem`` in the ansible bootstrap
          overrides ``localhost.yml`` file, or by using the :command:`system
          certificate-install -m ssl_ca dex-ca.pem` command.


      #.  Create the secret, ``local-dex.tls``, with the certificate and key,
          to be used by the **oidc-auth-apps**, as well as the secret,
          ``dex-client-secret``, with the |CA|'s certificate that signed the
          ``local-dex.tls`` certificate.

          For example, assuming the cert and key pem files for creating these
          secrets are in ``/home/sysadmin/ssl/``, run the following commands to
          create the secrets:

          .. note::
              **oidc-auth-apps** looks specifically for secrets of these names
              in the ``kube-system`` namespace.

              For the generic secret ``dex-client-secret``, the filename must
              be ``dex-ca.pem``.

          .. code-block:: none

              ~(keystone_admin)]$ kubectl create secret tls local-dex.tls --cert=ssl/dex-cert.pem --key=ssl/dex-key.pem -n kube-system

              ~(keystone_admin)]$ kubectl create secret generic dex-client-secret --from-file=/home/sysadmin/ssl/dex-ca.pem -n kube-system

          Create the secret ``wad-ca-cert`` with the |CA|'s certificate that signed
          the Active Directory's certificate using the following command:

          .. code-block:: none

              ~(keystone_admin)]$ kubectl create secret generic wad-ca-cert --from-file=ssl/wad-ca-cert.crt -n kube-system

#.  Specify user overrides for **oidc-auth-apps** application, by using the
    following command:

    .. code-block:: none

        ~(keystone_admin)]$ system helm-override-update oidc-auth-apps dex kube-system --values /home/sysadmin/dex-overrides.yaml --reuse-values

    The dex-overrides.yaml file contains the desired dex helm chart overrides
    (that is, the |LDAP| connector configuration for the Active Directory
    service, optional token expiry, and so on), and volume mounts for
    providing access to the ``wadcert`` secret, described in this section.

    For the complete list of dex helm chart values supported, see `Dex Helm
    Chart Values
    <https://github.com/helm/charts/blob/92b6289ae93816717a8453cfe62bad51cbdb
    8ad0/stable/dex/values.yaml>`__. For the complete list of parameters of the
    dex |LDAP| connector configuration, see `Authentication Through LDAP
    <https://dexidp.io/docs/connectors/ldap/>`__.

    The example below configures a token expiry of ten hours, a single |LDAP|
    connector to an Active Directory service using HTTPS \(LDAPS\) using the
    ``wadcert`` secret configured in this section, the required Active
    Directory service login information \(that is, bindDN, and bindPW\), and
    example :command:`userSearch`, and :command:`groupSearch` clauses.

    (Optional) There is a default secret in the dex configuration for
    ``staticClients``. You can change this using helm overrides. For example,
    to change the secret, first run the following command to see the default
    settings. In this example, ``10.10.10.2`` is the |prod-long| |OAM| floating
    IP address.

    .. code-block:: none

        ~(keystone_admin)]$ system helm-override-show oidc-auth-apps dex kube-system

        config:
          staticClients:
          - id: stx-oidc-client-app
            name: STX OIDC Client app
            redirectURIs: ['https://10.10.10.2:30555/callback']
            secret: St8rlingX

    Change the secret from the output and copy the entire configuration section
    shown above in to your dex overrides file shown in the example below.

    .. warning::
        Do not forget to include the id, name, and redirectURIs parameters.

    .. note::
        There is an internal ``client_secret`` that is used between the
        oidc-client container and the dex container. It is recommended that you
        configure a unique, more secure ``client_secret`` by specifying the
        value in the dex overrides file, as shown in the example below.

    .. begin-connector-config

    .. code-block:: none

        config:
          staticClients:
          - id: stx-oidc-client-app
            name: STX OIDC Client app
            redirectURIs: ['<OAM floating IP address>/callback']
            secret: BetterSecret
          client_secret: BetterSecret
          expiry:
            idTokens: "10h"
          connectors:
          - type: ldap
            name: OpenLDAP
            id: ldap
            config:
              host: pv-windows-acti.windows-activedir.example.com:636
              rootCA: /etc/ssl/certs/adcert/wad-ca-cert.crt
              insecureNoSSL: false
              insecureSkipVerify: false
              bindDN: cn=Administrator,cn=Users,dc=windows-activedir,dc=example,dc=com
              bindPW: [<password>]
              usernamePrompt: Username
              userSearch:
                baseDN: ou=Users,ou=Titanium,dc=windows-activedir,dc=example,dc=com
                filter: "(objectClass=user)"
                username: sAMAccountName
                idAttr: sAMAccountName
                emailAttr: sAMAccountName
                nameAttr: displayName
              groupSearch:
                baseDN: ou=Groups,ou=Titanium,dc=windows-activedir,dc=example,dc=com
                filter: "(objectClass=group)"
                userAttr: DN
                groupAttr: member
                nameAttr: cn
        extraVolumes:
        - name: certdir
          secret:
            secretName: wad-ca-cert
        extraVolumeMounts:
        - name: certdir
          mountPath: /etc/ssl/certs/wad-ca-cert.crt

    .. end-connector-config

    If more than one Windows Active Directory service is required for
    authenticating the different users of the |prod|, multiple ``ldap``
    type connectors can be configured; one for each Windows Active
    Directory service.

    If more than one ``userSearch`` plus ``groupSearch`` clauses are
    required for the same Windows Active Directory service, multiple
    ``ldap`` type connectors, with the same host information but
    different ``userSearch`` plus ``groupSearch`` clauses, should be used.

    Whenever you use multiple ``ldap`` type connectors, ensure you use
    unique ``name:`` and ``id:`` parameters for each connector.

#.  An override in the secrets in the dex helm chart must be accompanied by
    an override in the oidc-client helm chart.

    The following override is sufficient for changing the secret in the
    ``/home/sysadmin/oidc-client-overrides.yaml`` file.

    .. code-block:: none

        config:
          client_secret: BetterSecret

    Apply the oidc-client overrides using the following command:

    .. code-block:: none

        ~(keystone_admin)]$ system helm-override-update oidc-auth-apps oidc-client kube-system --values /home/sysadmin/oidc-client-overrides.yaml --reuse-values

    .. note::

        If you need to manually override the secrets, the client_secret in the
        oidc-client overrides must match the staticClients secret and
        client_secret in the dex overrides, otherwise the oidc-auth |CLI|
        client will not function.

#.  Use the :command:`system application-apply` command to apply the
    configuration:

    .. code-block:: none

        ~(keystone_admin)]$ system application-apply oidc-auth-apps
