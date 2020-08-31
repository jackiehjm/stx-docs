
.. gqn1595963439839
.. _secure-https-external-connectivity:

==================================
Secure HTTPS External Connectivity
==================================

|prod| provides support for secure HTTPS external connections for REST API
and webserver access.

For secure remote access, a ROOT-CA-signed certificate is required. The use
of a ROOT-CA-signed certificate is strongly recommended.

Operational complexity:

.. _secure-https-external-connectivity-ul-ct1-pzf-mmb:

-   HTTPS is enabled using the platform system commands.

-   Obtain a certificate signed by a ROOT certificate authority and install
    it with the platform system command.

For more information, see :ref:`Secure HTTPS Connectivity
<https-access-overview>`.

