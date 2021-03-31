
.. fak1590002084693
.. _install-a-trusted-ca-certificate:

================================
Install a Trusted CA Certificate
================================

A trusted |CA| certificate can be added to the |prod-os| service containers
such that the containerized OpenStack services can validate certificates of
far-end systems connecting or being connected to over HTTPS. The most common
use case here would be to enable certificate validation of clients connecting
to OpenStack service REST API endpoints.

.. rubric:: |proc|

.. _install-a-trusted-ca-certificate-steps-unordered-am5-xgt-vlb:

#.  Install a trusted |CA| certificate for OpenStack using the following
    command to override all OpenStack Helm Charts.

    .. code-block:: none

        ~(keystone_admin)$ system certificate-install -m openstack_ca <certificate_file>

    where <certificate\_file> contains a single |CA| certificate to be trusted.

    Running the command again with a different |CA| certificate in the file will
    *replace* this openstack trusted |CA| certificate.

#.  Apply the updated Helm chart overrides containing the certificate changes:

    .. code-block:: none

        ~(keystone_admin)$ system application-apply wr-openstack


