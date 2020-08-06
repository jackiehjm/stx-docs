=========================
Certificate Configuration
=========================

This guide describes how to enable secure HTTPS access and manage certificates
using StarlingX.

.. contents::
   :local:
   :depth: 1

----------------------
Configure HTTPS access
----------------------

StarlingX allows you to enable secure HTTPS access and/or manage certificates
for various external interfaces and services. You can also add trusted
:abbr:`CAs (Certificate Authority(s))` for the StarlingX platform and the
OpenStack application.

.. note::

    The default HTTPS X.509 certificates used by StarlingX, Kubernetes, and
    OpenStack for authentication are not signed by a known authority. For
    increased security, we recommend you obtain, install, and use certificates
    that have been signed by a certificate authority.

----------------------------------------------------------------------
StarlingX platform REST API applications and the StarlingX Horizon GUI
----------------------------------------------------------------------

By default, StarlingX platform provides HTTP access for REST API application
endpoints (Keystone, Barbican, and StarlingX) and the StarlingX platform Horizon
GUI. For improved security, you can enable HTTPS access for these service
endpoints. When HTTPS access is enabled, HTTP access is disabled.


*   To enable HTTPS:
    ::

    ~(keystone_admin)]$ system modify --https_enabled true

*   To disable HTTPS:
    ::

    ~(keystone_admin)]$ system modify --https_enabled false

*   To display HTTPS settings:
    ::

    [sysadmin@controller-0 ~(keystone_admin)]$ system show


When HTTPS is enabled for the first time on a StarlingX platform system, a
self-signed certificate is automatically installed. In order to connect, remote
clients must be configured to accept the self-signed certificate without
verifying it. This is called *insecure mode*.

For secure-mode connections, a CA-signed certificate, or an ICA (intermediate
CA) signed certificate is required. Using a CA or ICA signed certificate is
strongly recommended.

*   To install (or update) the certificate used by StarlingX REST API
    applications and the StarlingX Horizon GUI:
    ::

    ~(keystone_admin)]$ system certificate-install -m ssl <keyAndCert.pem>

    where ``<keyAndCert.pem>`` == a PEM file containing both the private key
    and the signed public certificate. In the case of an ICA signed certificate,
    the PEM file also contains the intermediate CA certificates. The certificates
    in the file should be ordered such that each of the certificates is signed
    by the succeeding one, with the public certificate as the very first in the
    list.

    You can update the certificate used by StarlingX platform at any time after
    installation.

For additional security, StarlingX platform supports secure storage of the SSL
private key (for the StarlingX REST APIs and the StarlingX Horizon GUI,
discussed above) using :abbr:`TPM (Trusted Platform Module)`. You can optionally
use TPM to protect HTTPS SSL private keys for use by the REST API, remote CLI,
and Horizon web interface. TPM 2.0-compliant hardware must be available on the
controller hosts before the hosts are provisioned.

*   To install (or update) the certificate used by StarlingX REST API
    applications and the StarlingX Horizon GUI and store the private key
    securely in a TPM 2.0 hardware device on the controller:
    ::

    ~(keystone_admin)]$ system certificate-install -m tpm <keyAndCert.pem>

    where ``<keyAndCert.pem>`` == a PEM file containing both the private key and
    the signed public certificate.

    Note that TPM must be enabled in the UEFI on both
    controllers, and both controllers must be provisioned and unlocked before
    you can install the certificate in TPM.

----------
Kubernetes
----------

For the Kubernetes API server, HTTPS is always enabled. Similarly, a self-signed
certificate is used for the Kubernetes root CA certificate by default. We
recommend that you update this certificate with a certificate signed by a
Certificate Authority.

Currently the Kubernetes root CA certificate and key can only be updated at
Ansible bootstrap time. For details, see
:ref:`Kubernetes root CA certificate and key <k8s-root-ca-cert-key-r4>`.

---------------------
Local Docker registry
---------------------

HTTPS is always enabled for the local Docker registry. Similarly, a self-signed
certificate is used by default, however, we recommend that you update the
certificate with a certificate signed by a Certificate Authority or an
intermediate Certificate Authority after installation.

*   To install (or update) the certificate used by the local Docker registry:
    ::

    ~(keystone_admin)]$ system certificate-install -m docker_registry <keyAndCert.pem>

    where ``<keyAndCert.pem>`` == a PEM file containing both the private key and
    the signed public certificate. In the case of an ICA signed certificate, the
    PEM file also contains the intermediate CA certificates. The certificates in
    the file should be ordered such that each of the certificates is signed by
    the succeeding one, with the public certificate as the very first in the list.

    Note that the CA-signed certificate for the registry must have at least the
    following :abbr:`SANs (Subject Alternative Names)`:

    *   DNS:registry.local
    *   DNS:registry.central
    *   IP Address:oam-floating-ip-address
    *   IP Address:mgmt-floating-ip-address

    Use the ``system addrpool-list`` command to get the oam floating IP Address
    and management floating IP Address for your system. You can add any
    additional DNS entry(s) that you have set up for your oam floating IP
    Address.

---------------------------------------------------------------------
OpenStack REST API applications and OpenStack application Horizon GUI
---------------------------------------------------------------------

By default, the OpenStack application provides HTTP access for REST API
application endpoints and the OpenStack application Horizon GUI. For improved
security, you can enable HTTPS access. When HTTPS access is enabled, HTTP access
is disabled.

To enable HTTPS for OpenStack:

#.  Optionally, but recommended, configure the public endpoint FQDN:

    ::

    $ system service-parameter-add openstack helm endpoint_fqdn=domain_name

    where ``domain_name`` is a fully qualified domain name such as example.com.

#.  Open port 443 for ingress connections. Port 443 is not open for ingress
    connections by default, and must be explicitly added to the
    GlobalNetworkPolicy. This can be done by applying a yaml file using kubectl.

    a.  Create a yaml file containing the rule to be applied. For example:

    ::

        # This rule opens up default HTTPS port 443
        # It is required to access openstack Horizon via FQDN
        apiVersion: crd.projectcalico.org/v1
        kind: GlobalNetworkPolicy
        metadata:
          name: gnp-openstack-oam
        spec:
          ingress:
          - action: Allow
            destination:
              ports:
              - 443
            protocol: TCP
          order: 500
          selector: has(iftype) && iftype == 'oam'
          types:
          - Ingress

    b.  Apply this file using kubectl apply -f fileName.yaml. For example:

    ::

            $ kubectl apply -f gnp-openstack-oam.yaml

#.  If not already done, enable HTTPS.

    ::

    $ system modify --https_enabled=True

#.  If not already done, install the certificate for the StarlingX platform:

    ::

    $ system certificate-install -m ssl <keyAndCert.pem>

    where ``<keyAndCert.pem>`` == a PEM file containing both the private key and
    the signed public certificate.

#.  Install the certificate for OpenStack:

    ::

    $ system certificate-install -m openstack <keyAndCert.pem>

    where ``<keyAndCert.pem>`` == a PEM file containing both the private key and
    the signed public certificate.

    This certificate must be valid for the domain specified in step 1.

#.  If not already done, upload the OpenStack application manifest and Helm
    charts:

    ::

    $ system application-upload stx-openstack <stx-openstack-armada-tar-ball>

#.  Update the OpenStack Helm charts and apply them to OpenStack services.

    ::

    $ system application-apply stx-openstack

-----------
Trusted CAs
-----------

StarlingX platform and the OpenStack application also support the ability to
update the trusted CA bundle on all nodes in the system. For example, for the
StarlingX platform, this is required when container images are being pulled from
an external Docker registry with a certificate signed by a non-standard CA.

*   To install (or update) the list of trusted CAs for the StarlingX platform:

    ::

    ~(keystone_admin)]$ system certificate-install -m ssl_ca <ca-certs.pem>

    where ``<ca-certs.pem>`` == a PEM file containing one or more CA
    certificates to add to the list of trusted CAs.

*   To list the trusted CAs for the StarlingX platform:

    ::

        system certificate-list

    where all entries with ``certtype = ssl_ca`` are trusted CA Certificates.

*   To remove a CA from the list of trusted CAs for the StarlingX platform:

    ::

        system certificate-uninstall -m ssl_ca <UUID>

    where ``<UUID>`` is the UUID of the ``ssl_ca`` certtype to be removed.
    Use the ``system certificate-list`` command to determine the UUID.

*   To install (or update) the list of trusted CAs for the OpenStack
    application:

    ::

    ~(keystone_admin)]$ system certificate-install -m openstack_ca <ca-certs.pem>

    where ``<ca-certs.pem>`` == a PEM file containing one or more CA
    certificates.

    .. note::

        Only a single *trusted CA* PEM file is managed, with each invocation of
        the above command overwriting the previous file. If multiple additional
        trusted CA certificates are required, there must be multiple CA
        certificates in the PEM file.

*   To update the OpenStack Helm charts and apply them:

    ::

    ~(keystone_admin)]$ system application-apply stx-openstack
