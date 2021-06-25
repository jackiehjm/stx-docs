
.. xlb1552573425956
.. _starlingx-rest-api-applications-and-the-web-administration-server:

=============================================================================
StarlingX REST API Applications and the Web Administration Server Certificate
=============================================================================

|prod| provides support for secure HTTPS external connections used for
StarlingX REST API application endpoints \(Keystone, Barbican and
StarlingX\) and the |prod| web administration server.

By default HTTPS access to StarlingX REST and Web Server's endpoints are
disabled; i.e. accessible via HTTP only.

For secure HTTPS access, an x509 certificate and key is required. When HTTPS is
enabled for the first time on a |prod| system, a self-signed certificate and
key are automatically generated and installed for the StarlingX REST and Web
Server endpoints.

.. note::
    Refer to the documentation for the external Intermediate or Root |CA| that
    you are using, on how to create public certificate and private key pairs,
    signed by an Intermediate or Root |CA|, for HTTPS.

For secure remote access, an intermediate or Root |CA|-signed certificate and
key are required. The use of a Root |CA|-signed certificate is strongly
recommended.

You can update the certificate used for HTTPS access at any time.

For more details, refer to:

.. toctree::
    :maxdepth: 1

    enable-https-access-for-starlingx-rest-and-web-server-endpoints
    install-update-the-starlingx-rest-and-web-server-certificate
    secure-starlingx-rest-and-web-certificates-private-key-storage-with-tpm
    tpm-configuration-considerations