
.. ddq1552672412979
.. _https-access-overview:

==========================================
HTTPS and Certificates Management Overview
==========================================

Certificates are heavily used for secure HTTPS access and authentication on
|prod| platform. This table lists the major certificates being used in the
system, and indicates which certificates are automatically created/renewed by
the system versus which certificates must be manually created/renewed by the
system administrator. Details on manual management of certificates can be found
in the following sections.

.. table::
    :widths: auto

    +-----------------------------------------------------------+-----------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------+
    | Certificate                                               | Auto Created                                                                | Renewal Status                                                                                         |
    +===========================================================+=============================================================================+========================================================================================================+
    | Kubernetes Root CA Certificate                            | Yes                                                                         | NOT AUTO-RENEWED; Default expiry is set at 10 years; MUST be renewed via CLI.                          |
    +-----------------------------------------------------------+-----------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------+
    | Cluster Admin client certificate used by kubectl          | Yes                                                                         | auto-renewed by cron job                                                                               |
    +-----------------------------------------------------------+-----------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------+
    | kube-controller-manager client certificate                | Yes                                                                         | auto-renewed by cron job                                                                               |
    +-----------------------------------------------------------+-----------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------+
    | kube-scheduler client certificate                         | Yes                                                                         | auto-renewed by cron job                                                                               |
    +-----------------------------------------------------------+-----------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------+
    | kube-apiserver server certificate                         | Yes                                                                         | auto-renewed by cron job                                                                               |
    +-----------------------------------------------------------+-----------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------+
    | kube-apiserver's kubelet client certificate               | Yes                                                                         | auto-renewed by cron job                                                                               |
    +-----------------------------------------------------------+-----------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------+
    | kubelet client certificate                                | Yes                                                                         | auto-renewed by kubelet feature enabled by default                                                     |
    +-----------------------------------------------------------+-----------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------+
    |                                                                                                                                                                                                                                                  |
    +-----------------------------------------------------------+-----------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------+
    | etcd Root CA certificate                                  | Yes                                                                         | NOT AUTO-RENEWED; Default expiry is set at 10 years                                                    |
    +-----------------------------------------------------------+-----------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------+
    | etcd server certificate                                   | Yes                                                                         | auto-renewed by cron job                                                                               |
    +-----------------------------------------------------------+-----------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------+
    | etcd client certificate                                   | Yes                                                                         | auto-renewed by cron job                                                                               |
    +-----------------------------------------------------------+-----------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------+
    | kube-apiserver's etcd client certificate                  | Yes                                                                         | auto-renewed by cron job                                                                               |
    +-----------------------------------------------------------+-----------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------+
    |                                                                                                                                                                                                                                                  |
    +-----------------------------------------------------------+-----------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------+
    | StarlingX REST API & HORIZON Server Certificate           | Yes (But the auto-created certificate is self-signed and should be changed) | auto-renewed if configured with cert-manager;                                                          |
    |                                                           |                                                                             | NOT AUTO-RENEWED if configured with :command:`system certificate-install ..`, must be renewed via CLI  |
    +-----------------------------------------------------------+-----------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------+
    |                                                                                                                                                                                                                                                  |
    +-----------------------------------------------------------+-----------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------+
    | Local Registry Server Certificate                         | Yes (But the auto-created certificate is self-signed and should be changed) | auto-renewed if configured with cert-manager;                                                          |
    |                                                           |                                                                             | NOT AUTO-RENEWED if configured with :command:`system certificate-install ..`, must be renewed via CLI  |
    +-----------------------------------------------------------+-----------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------+
    |                                                                                                                                                                                                                                                  |
    +-----------------------------------------------------------+-----------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------+
    | OIDC Client and Dex Server Server Certificate             | No                                                                          | auto-renewed if configured with cert-manager;                                                          |
    |                                                           |                                                                             | NOT AUTO-RENEWED if configured with an externally generated certificate, CUSTOMER MUST renew via CLI.  |
    +-----------------------------------------------------------+-----------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------+
    | OIDC Client and Dex Server CA certificate                 | No                                                                          | NOT AUTO-RENEWED. CUSTOMER MUST renew via CLIs                                                         |
    +-----------------------------------------------------------+-----------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------+
    | OIDC Remote WAD CA Certificate                            | No                                                                          | NOT AUTO-RENEWED. CUSTOMER MUST renew via CLIs                                                         |
    +-----------------------------------------------------------+-----------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------+
    |                                                                                                                                                                                                                                                  |
    +-----------------------------------------------------------+-----------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------+
    | Vault Server Certificate                                  | Yes                                                                         | NOT AUTO-RENEWED; CUSTOMER MUST renew via CLIs                                                         |
    +-----------------------------------------------------------+-----------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------+
    | Vault Root CA certificate                                 | Yes                                                                         | NOT AUTO-RENEWED; CUSTOMER MUST renew via CLIs                                                         |
    +-----------------------------------------------------------+-----------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------+
    |                                                                                                                                                                                                                                                  |
    +-----------------------------------------------------------+-----------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------+
    | Portieris Server Certificate                              | Yes                                                                         | Auto renewed by cert-manager; BUT CUSTOMER MUST restart Portieris after the certificate is renewed     |
    +-----------------------------------------------------------+-----------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------+
    | Portieris remote registry and notary server CA Certificate| No                                                                          | NOT AUTO-RENEWED; CUSTOMER MUST renew via CLIs                                                         |
    +-----------------------------------------------------------+-----------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------+
    |                                                                                                                                                                                                                                                  |
    +-----------------------------------------------------------+-----------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------+
    | Root CA DC Admin Endpoint CA Certificate                  | Yes                                                                         | auto-renewed                                                                                           |
    +-----------------------------------------------------------+-----------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------+
    | Intermediate CA DC Admin Endpoint CA Certificate          | Yes                                                                         | auto-renewed                                                                                           |
    +-----------------------------------------------------------+-----------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------+
    | DC Admin Endpoint Server Certificate                      | Yes                                                                         | auto-renewed                                                                                           |
    +-----------------------------------------------------------+-----------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------+
    |                                                                                                                                                                                                                                                  |
    +-----------------------------------------------------------+-----------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------+
    | System trusted CA Certificates                            | No                                                                          | NOT AUTO-RENEWED as these are certificates that are not necessarily owned by the platform              |
    +-----------------------------------------------------------+-----------------------------------------------------------------------------+--------------------------------------------------------------------------------------------------------+

Where:

-   Auto created: the certificate is generated during system deployment or
    triggered by certain operations.

-   Renewal Status: whether the certificate is renewed automatically by the system
    when expiry date approaches.

The following sections provide details on managing these certificates.

-   :ref:`StarlingX REST API Applications and the Web Administration Server Certificate <starlingx-rest-api-applications-and-the-web-administration-server>`

-   :ref:`Kubernetes Certificates <kubernetes-certificates-f4196d7cae9c>`

-   :ref:`Local Registry Server Certificates <security-install-update-the-docker-registry-certificate>`

-   :ref:`System Trusted CA Certificates <add-a-trusted-ca>`

For further information about certificates expiration date or other certificates
information, see :ref:`Display Certificates Installed on a System <utility-script-to-display-certificates>`.
In addition, |prod| monitors the installed certificates on the system by raising
alarms for expire-soon certificates and for expired certificates on the system,
see :ref:`Expiring-Soon and Expired Certificate Alarms
<alarm-expiring-soon-and-expired-certificates-baf5b8f73009>`.

---------------------------------------------------------------------------
Limitations for using IPv6 addresses related to management and OAM networks
---------------------------------------------------------------------------

Cert-manager accepts only short-hand IPv6 addresses. 

**Workaround**: You must use the following rules when defining IPv6 addresses
to be used by Cert-manager. 

-  all letters must be in lower case

-  each group of hexadecimal values must not have any leading 0s
   (use :12: instead of :0012:)

-  the longest sequence of consecutive all-zero fields must be short-handed
   with ``::``
    
-  ``::`` must not be used to short-hand an IPv6 address with 7 groups of hexadecimal
    values, use :0: instead of ``::``

.. note::

    Use the rules above to set the IPv6 address related to the management
    and |OAM| network in the Ansible bootstrap overrides file, ``localhost.yml``.
    
.. code-block:: none

    apiVersion: cert-manager.io/v1alpha2
    kind: Certificate
    metadata:
    name: oidc-auth-apps-certificate
    namespace: pvtest
    spec:
    duration: 1h
    renewBefore: 55m
    secretName: oidc-auth-apps-certificate
    dnsNames:
    - ahost.com
    ipAddresses:
    - 2620:10a:a001:a103::11
    organization:
    - WRCP-System
    issuerRef:
        name: cloudplatform-interca-issuer
        kind: Issuer
    controller-0:~$

