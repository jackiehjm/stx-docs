
.. pmb1590001656644
.. _install-rest-api-and-horizon-certificate:

========================================
Install REST API and Horizon Certificate
========================================

.. rubric:: |context|

This certificate must be valid for the domain configured for OpenStack, see the
sections on :ref:`Accessing the System <access-using-the-default-set-up>`.

.. rubric:: |prereq|

Before installing the openstack certificate and key, you must install the ROOT
|CA| for the openstack certificate as a trusted ca, :ref:`Install a Trusted CA
Certificate <install-a-trusted-ca-certificate>`.

.. rubric:: |proc|

#.  Install the certificate for OpenStack as Helm chart overrides.

    .. code-block:: none

        ~(keystone_admin)$ system certificate-install -m openstack <certificate_file>

    where <certificate\_file> is a pem file containing both the certificate and
    private key.

    .. note::
        The OpenStack certificate must be created with wildcard |SAN|.

        For example, to create a certificate for |FQDN|: west2.us.example.com,
        the following entry must be included in the certificate:

        .. code-block:: none

            X509v3 extensions:
            X509v3 Subject Alternative Name:
            DNS:*.west2.us.example.com

#.  Apply the Helm chart overrides containing the certificate changes.

    .. code-block:: none

        ~(keystone_admin)$ system application-apply wr-openstack


