
.. pmb1590001656644
.. _install-rest-api-and-horizon-certificate:

========================================
Install REST API and Horizon Certificate
========================================

.. rubric:: |context|

This certificate must be valid for the domain configured for OpenStack, see the
sections on :ref:`Accessing the System <access-using-the-default-set-up>`.

.. rubric:: |prereq|

Obtain an Intermediate or Root CA-signed certificate and key from a trusted
Intermediate or Root CA. The OpenStack certificate should be created with a
wildcard SAN, for example:

.. code-block:: none

    X509v3 extensions:
    X509v3 Subject Alternative Name:
    DNS:*.west2.us.example.com


.. rubric:: |proc|

#.  Put the |PEM| encoded versions of the OpenStack certificate and key in a
    single file (e.g. **openstack-cert-key.pem**), and put the certificate of
    the Root CA in a separate file (e.g. **openstack-ca-cert.pem**), and copy
    the files to the controller host.

#.  Install the certificate as the OpenStack REST API / Horizon Certificate.

    .. code-block:: none

        ~(keystone_admin)]$ system certificate-install -m ssl_ca openstack-ca-cert.pem
        ~(keystone_admin)]$ system certificate-install -m openstack_ca openstack-ca-cert.pem
        ~(keystone_admin)$ system certificate-install -m openstack openstack-cert-key.pem

#.  Apply the Helm chart overrides containing the certificate changes.

    .. parsed-literal::

        ~(keystone_admin)$ system application-apply |prefix|-openstack

