.. _configure-rest-api-applications-and-web-administration-server-certificates-after-installation-6816457ab95f:

=========================================================================
Configure REST API Applications and Web Administration Server certificate
=========================================================================

.. rubric:: |context|

|prod| provides support for secure HTTPS external connections used for
StarlingX REST API application endpoints (Keystone, Barbican and StarlingX) and
the |prod| web administration server. By default, HTTPS access to StarlingX
REST and Web Server endpoints is disabled. They are accessible via HTTP only.
To enable secure HTTPS access, an x509 certificate and key must be configured.

You can update the certificate used for HTTPS access at any time.

To configure or update the HTTPS certificate for the StarlingX REST API and Web
Server endpoints, create a certificate named ``system-restapi-gui-certificate``
in the ``deployment`` namespace.  The ``secretName`` attribute of this
certificate's spec must also be named ``system-restapi-gui-certificate``.

See the example procedure below for creating the certificate for the StarlingX
REST API and Web Server endpoints.

Update the following fields:

* The ``duration`` and ``renewBefore`` dates for the expiry and renewal times
  you desire. The system will automatically renew and re-install the
  certificate.

* The ``subject`` fields to identify your particular system.

* The ``ipAddresses`` with the |OAM| Floating IP Address for this system.

* The ``dnsNames`` with any |FQDN| names configured for this system in an
  external DNS server.

.. note::

   If you plan to use the container-based remote CLIs, due to a limitation in
   the Python2 SSL certificate validation, the certificate used for the
   'system-restapi-gui-certificate' certificate must either have:

   1. CN=IPADDRESS and SANs=IPADDRESS

   or

   1. CN=FQDN and SANs=FQDN

   where IPADDRESS and FQDN are for the |OAM| Floating IP Address.

.. rubric:: |proc|

#. Create the REST API certificate yaml configuration file.

   .. code-block::

      ~(keystone_admin)]$ cat <<EOF > restapi-certificate.yaml
      ---
      apiVersion: cert-manager.io/v1
      kind: Certificate
      metadata:
        name: system-restapi-gui-certificate
        namespace: deployment
      spec:
        secretName: system-restapi-gui-certificate
        issuerRef:
          name: system-local-ca
          kind: ClusterIssuer
        duration: 2160h    # 90 days
        renewBefore: 360h  # 15 days
        commonName:  < oam floating IP Address or FQDN >
        subject:
          organizations:
            - ABC-Company
          organizationalUnits:
            - StarlingX-system-restapi-gui
        ipAddresses:
          -  < oam floating IP address >
        dnsNames:
          - < oam floating FQDN >
      EOF


#. Apply the configuration.

   .. code-block::

       ~(keystone_admin)]$ kubectl apply -f restapi-certificate.yaml


#. Verify the configuration.

   .. code-block::

       ~(keystone_admin)]$ kubectl get certificate system-restapi-gui-certificate –n deployment

   If configuration was successful, the certificate’s Ready status will be
   ``True``.

.. rubric:: |result|

The REST and Web Server certificate installation is now complete, and
Cert-Manager will handle the lifecycle management of the certificate.
