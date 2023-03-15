
.. iym1475074530218
.. _https-access-planning:

=====================
HTTPS Access Planning
=====================

You can enable secure HTTPS access for |prod-os|'s REST API endpoints or
OpenStack Horizon Web interface users.

.. note::
    To enable HTTPS access for |prod-os|, you must enable HTTPS in the
    underlying |prod-long| platform.

By default, |prod-os| provides HTTP access for remote connections. For improved
security, you can enable HTTPS access. When HTTPS access is enabled, HTTP
access is disabled.

When HTTPS is enabled for the first time on a |prod-os| system, a self-signed
certificate is automatically installed. In order to connect, remote clients
must be configured to accept the self-signed certificate without verifying it
\("insecure" mode).

For secure-mode connections, a |CA|-signed certificate is required. The use of
a |CA|-signed certificate is strongly recommended.

You can update the certificate used by |prod-os| at any time after
installation.
