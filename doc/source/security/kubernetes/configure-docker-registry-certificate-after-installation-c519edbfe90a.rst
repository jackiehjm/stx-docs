.. _configure-docker-registry-certificate-after-installation-c519edbfe90a:

=====================================
Configure Docker Registry Certificate
=====================================

The local Docker registry provides secure HTTPS access using the registry API.

.. rubric:: |context|

By default, a self-signed server certificate is generated at installation time
for the registry API. For more secure access, an intermediate or Root CA-signed
server certificate is strongly recommended.

To configure or update the HTTPS certificate for the local Docker registry,
create a certificate named ``system-registry-local-certificate`` in the
``deployment`` namespace.  The ``secretName`` attribute of this certificate's
spec must also be named ``system-registry-local-certificate``.

See the example procedure below for creating the certificate for the local
Docker registry.

Update the following fields:

* The ``duration`` and ``renewBefore`` dates for the expiry and renewal times
  you desire. The system will automatically renew and re-install the
  certificate.

* The ``subject`` fields to identify your particular system.

* The ``ipAddresses`` with the |OAM| Floating IP Address and the MGMT Floating
  IP address for this system which MUST be specified for this certificate. Use
  the :command:`system addrpool-list` command to get the |OAM| floating IP
  Address and MGMT floating IP Address for your system.

* The ``dnsNames`` with ``registry.local``, ``registry.central`` and any |FQDN|
  names configured for this system's |OAM| Floating IP Address in an external
  DNS server.

.. rubric:: |proc|

#. Create the Docker certificate yaml configuration file.

   .. code-block::

      ~(keystone_admin)]$ cat <<EOF > docker-certificate.yaml
      ---
      apiVersion: cert-manager.io/v1
      kind: Certificate
      metadata:
        name: system-registry-local-certificate
        namespace: deployment
      spec:
        secretName: system-registry-local-certificate
        issuerRef:
          name: system-local-ca
          kind: ClusterIssuer
        duration: 2160h    # 90d
        renewBefore: 360h  # 15d
        subject:
          organizationalUnits:
            - StarlingX-system-registry-local
        ipAddresses:
          - <OAM_FLOATING_IP>
          - <MGMT_FLOATING_IP>
        dnsNames:
          - registry.local
          - registry.central
          - <external-FQDN-for-OAM-Floating-IP-Address, if applicable>

#. Apply the configuration.

   .. code-block::

       ~(keystone_admin)]$ kubectl apply -f docker-certificate.yaml

#. Verify the configuration.

   .. code-block::

       ~(keystone_admin)]$ kubectl get certificate system-registry-local-certificate -n deployment

   If configuration was successful, the certificate's Ready status will be
   ``True``.

#. Update the platform's trusted certificates (i.e. ``ssl_ca``) with the Root
   |CA| associated with ``system-registry-local-certificate``.

   See the example below where a Root |CA| ``system-local-ca`` was used to sign
   the ``system-registry-local-certificate``, the ``ca.crt`` of the
   ``system-local-ca`` SECRET is extracted and added as a trusted |CA| for
   |prod| (i.e. ``system certificate-install -m ssl_ca``).

   .. code-block:: none

      ~(keystone_admin)]$ kubectl -n cert-manager get secret system-local-ca -o yaml | fgrep tls.crt | awk '{print $2}' | base64 --decode >> system-local-ca.pem
      ~(keystone_admin)]$ system certificate-install -m ssl_ca system-local-ca.pem

.. rubric:: |result|

The Docker registry certificate installation is now complete, and Cert-Manager
will handle the lifecycle management of the certificate.

---------------------------------------------------------------------------
Limitations for using IPv6 addresses related to management and OAM networks
---------------------------------------------------------------------------

.. include:: /shared/_includes/cert-mgmt-ipv6-address-limitation-1a4504370674.rest
