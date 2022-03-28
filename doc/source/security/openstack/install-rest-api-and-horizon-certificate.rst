
.. pmb1590001656644
.. _install-rest-api-and-horizon-certificate:

========================================
Install REST API and Horizon Certificate
========================================

.. rubric:: |context|

For secure communications, HTTPS should be enabled for OpenStack REST API and
Horizon endpoints by configuring a certificate for these endpoints.

.. rubric:: |prereq|

-   Obtain an Intermediate or Root |CA|-signed certificate and key from a trusted
    Intermediate or Root |CA|. The OpenStack certificate should be created with a
    wildcard SAN.

    For example:

    .. code-block:: none

        X509v3 extensions:
        X509v3 Subject Alternative Name:
        DNS:*.west2.us.example.com

    -   To install an openstack certificate, the domain has to be added to the
        service-parameter openstack as prerequisite, for details see
        :ref:`Update the Domain Name <update-the-domain-name>`.

        .. code-block:: none

            ~(keystone_admin)$ system service-parameter-add openstack Helm endpoint_domain=west2.us.example.com

            +-------------+--------------------------------------+
            | Property    | Value                                |
            +-------------+--------------------------------------+
            | uuid        | 0459ede4-85e7-4767-aca9-d29e84f38bd4 |
            | service     | openstack                            |
            | section     | Helm                                 |
            | name        | endpoint_domain                      |
            | value       | west2.us.example.com                 |
            | personality | None                                 |
            | resource    | None                                 |
            +-------------+--------------------------------------+

            ~(keystone_admin)$ system service-parameter-apply openstack
            Applying openstack service parameters

-   HTTPS must be enabled for |prod|, see :ref:`Configure REST API Applications
    and Web Administration Server Certificate
    <configure-rest-api-applications-and-web-administration-server-certificates-after-installation-6816457ab95f>`.

.. rubric:: |proc|

#.  Put the |PEM| encoded versions of the OpenStack certificate and key in a
    single file (e.g. ``openstack-cert-key.pem``), and put the certificate of
    the Root |CA| in a separate file (e.g. ``openstack-ca-cert.pem``), then
    copy the files to the controller host.

#.  Install the certificate as the OpenStack REST API / Horizon Certificate.

    This will automatically update the required openstack Helm charts.

    .. code-block:: none

        ~(keystone_admin)$ system certificate-install -m ssl_ca openstack-ca-cert.pem
        ~(keystone_admin)$ system certificate-install -m openstack_ca openstack-ca-cert.pem
        ~(keystone_admin)$ system certificate-install -m openstack openstack-cert-key.pem

#.  Apply the Helm chart overrides containing the certificate changes.

    .. parsed-literal::

        ~(keystone_admin)$ system application-apply |prefix|-openstack

#.  Ensure port 443 is open in |prod| firewall. For details see :ref:`Modify
    Firewall Options <security-firewall-options>`.
