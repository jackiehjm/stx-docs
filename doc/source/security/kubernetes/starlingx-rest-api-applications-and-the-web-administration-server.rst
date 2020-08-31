
.. xlb1552573425956
.. _starlingx-rest-api-applications-and-the-web-administration-server:

=================================================================
StarlingX REST API Applications and the Web Administration Server
=================================================================

|prod| provides support for secure HTTPS external connections used for
StarlingX REST API application endpoints \(Keystone, Barbican and
StarlingX\) and the |prod| web administration server.

By default HTTPS access to StarlingX REST and Web Server's endpoints are
disabled; i.e. accessible via HTTP only.

For secure HTTPS access, an x509 certificate and key is required.

.. note::
    The default HTTPS X.509 certificates that are used by |prod-long| for
    authentication are not signed by a known authority. For increased
    security, obtain, install, and use certificates that have been signed
    by a Root certificate authority. Refer to the documentation for the
    external Root |CA| that you are using, on how to create public
    certificate and private key pairs, signed by a Root |CA|, for HTTPS.

By default a self-signed certificate and key is generated and installed by
|prod| for the StarlingX REST and Web Server endpoints for evaluation
purposes. This certificate and key is installed by default when HTTPS
access is first enabled for these services. In order to connect, remote
clients must be configured to accept the self-signed certificate without
verifying it \("insecure" mode\).

For secure remote access, a Root |CA|-signed certificate and key are
required. The use of a Root |CA|-signed certificate is strongly recommended.

You can update the certificate used for HTTPS access at any time.

