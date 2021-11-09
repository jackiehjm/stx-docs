
.. vri1561486014514
.. _security-install-update-the-docker-registry-certificate:

==================================
Local Registry Server Certificates
==================================

.. note::
    This procedure is deprecated. For up-to-date information, refer to:
    :ref:`configure-docker-registry-certificate-after-installation-c519edbfe90a`.

For the Local Docker Registry, HTTPS is always enabled. By default, a
self-signed server certificate and key is generated and installed for this
endpoint. However, it is strongly recommended that you update the server
certificate used after installation with an Intermediate or Root |CA|-signed
server certificate and key. Refer to the documentation for the external
Intermediate or Root |CA| that you are using, on how to create public
certificate and private key pairs, signed by a Root |CA|, for HTTPS.

The local Docker registry provides Docker image service that can be accessed
using the registry API by secure HTTPS. Standalone system, central cloud and
every subcloud of |DC| system has their own Docker registry called
`registry.local`.

The Docker registry on the central cloud of |DC| system has an
alias of `registry.central`, which is used by subcloud to remotely login or
pull images from this central Docker registry.

.. rubric:: |context|

By default a self-signed certificate is generated at installation time for the
registry API. For more secure access, an Intermediate or Root |CA|-signed
certificate is strongly recommended.

The Intermediate or Root |CA|-signed certificate for the registry must have at
least the following |SANs|: ``DNS:registry.local``, ``DNS:registry.central``, IP
Address:<oam-floating-ip-address>, IP Address:<mgmt-floating-ip-address>. Use
the :command:`system addrpool-list` command to get the |OAM| floating IP
Address and management floating IP Address for your system. You can add any
additional DNS entry\(s\) that you have set up for your |OAM| floating IP
Address.

Use the following procedure to install an intermediate or Root |CA|-signed
certificate to either replace the default self-signed certificate or to replace
an expired or soon to expire certificate.

.. rubric:: |prereq|

Obtain an intermediate or Root |CA|-signed certificate and key from a trusted
Intermediate or Root |CA|. Refer to the documentation for the external Root
|CA| that you are using, on how to create public certificate and private key
pairs, signed by an Intermediate or Root |CA|, for HTTPS.

For lab purposes, see :ref:`Create Certificates Locally using openssl
<create-certificates-locally-using-openssl>` for how to create a test
Intermediate or Root |CA| certificate and key, and use it to sign test
certificates.

Put the |PEM| encoded versions of the certificate and key in a single file,
and copy the file to the controller host.

Also, obtain the certificate of the Intermediate or Root |CA| that signed the
above certificate.

.. rubric:: |proc|


.. _security-install-update-the-docker-registry-certificate-d527e71:

#.  In order to enable internal use of the Docker registry certificate,
    update the trusted |CA| list for this system with the Root |CA| associated
    with the Docker registry certificate.

    .. code-block:: none

        ~(keystone_admin)]$ system certificate-install --mode ssl_ca
        <pathTocertificate>

    where:

    ``<pathTocertificate>``
        is the path to the intermediate or Root |CA| certificate associated
        with the Docker registry's Intermediate or Root |CA|-signed
        certificate.

#.  Update the Docker registry certificate using the
    :command:`certificate-install` command.

    Set the ``mode (-m or --mode)`` parameter to ``docker_registry``.

    .. code-block:: none

        ~(keystone_admin)]$ system certificate-install --mode docker_registry
        <pathTocertificateAndKey>

    where:

    ``<pathTocertificateAndKey>``
        is the path to the file containing both the Docker registry's
        Intermediate or Root CA-signed certificate and private key to install.

Refer to :ref:`Install/Update Local Registry Certificates
<installing-updating-the-docker-registry-certificate>` on how to install/update
and renew local registry certificates.
