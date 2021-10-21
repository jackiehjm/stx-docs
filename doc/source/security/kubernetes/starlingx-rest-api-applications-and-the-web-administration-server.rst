
.. xlb1552573425956
.. _starlingx-rest-api-applications-and-the-web-administration-server:

=============================================================================
StarlingX REST API Applications and the Web Administration Server Certificate
=============================================================================

By default, |prod| provides HTTP access to REST API application endpoints
\(Keystone, Barbican and |prod|\) and the web administration server. For
improved security, you can enable HTTPS access. When HTTPS access is
enabled, HTTP access is disabled.

When HTTPS is enabled for the first time on a |prod| system, a self-signed
server certificate and key are automatically generated and installed for REST
and Web Server endpoints. In order to connect, remote clients must be
configured to accept the self-signed server certificate without verifying it.
This is called insecure mode.

For secure-mode connections, an Intermediate or Root |CA|-signed server
certificate and key are required. The use of an Intermediate or Root
|CA|-signed server certificate is strongly recommended. Refer to the
documentation for the external Intermediate or Root |CA| that you are using, on
how to create public certificate and private key pairs, signed by an
Intermediate or Root |CA|, for HTTPS.

.. note::

    Refer to the documentation for the external Intermediate or Root |CA| that
    you are using, on how to create public certificate and private key pairs,
    signed by an Intermediate or Root |CA|, for HTTPS.

You can update the certificate and key used by |prod| for the
REST and Web Server endpoints at any time after installation.

For additional security, |prod| optionally supports storing the private key
of the |prod| REST and Web Server certificate in a |TPM| hardware
device. |TPM| 2.0-compliant hardware must be available on the controller
hosts.

For more details, refer to:

.. toctree::
   :maxdepth: 1

   enable-https-access-for-starlingx-rest-and-web-server-endpoints
   install-update-the-starlingx-rest-and-web-server-certificate
   secure-starlingx-rest-and-web-certificates-private-key-storage-with-tpm
