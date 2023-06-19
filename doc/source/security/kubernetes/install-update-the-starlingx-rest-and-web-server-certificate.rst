
.. law1570030645265
.. _install-update-the-starlingx-rest-and-web-server-certificate:

============================================================
Install/Update the StarlingX Rest and Web Server Certificate
============================================================

Use the following procedure to install or update the certificate for the |prod|
REST API application endpoints (Keystone, Barbican and |prod|) and the
|prod| web administration server.

.. rubric:: |prereq|

Obtain an intermediate or Root |CA|-signed server certificate and key from a
trusted Intermediate or Root |CA|. Refer to the documentation for the external
Intermediate or Root |CA| that you are using, on how to create public
certificate and private key pairs, signed by intermediate or a Root |CA|, for
HTTPS.

For lab purposes, see :ref:`Create Certificates Locally using openssl
<create-certificates-locally-using-openssl>` for how to create a test
Intermediate or Root |CA| certificate and key, and use it to sign test
server certificates.

Put the |PEM| encoded versions of the server certificate and key in a single
file, and copy the file to the controller host.

.. note::

    If you plan to use the container-based remote CLIs, due to a limitation in
    the Python2 SSL certificate validation, the certificate used for the |prod|
    REST API application endpoints and |prod| Web Administration Server ('ssl')
    certificate must either have:

    #.  CN=IPADDRESS and SANs=IPADDRESS

        or

    #.  CN=FQDN and SANs=FQDN

        where IPADDRESS and FQDN are for the OAM Floating IP Address.


.. rubric:: |proc|

-   Install/update the copied certificate.

    For example:

    .. code-block:: none

        ~(keystone_admin)]$ system certificate-install -m ssl <pathTocertificateAndKey>

    where:

    **<pathTocertificateAndKey>**

    is the path to the file containing both the intermediate or Root
    |CA|-signed server certificate and private key to install.

.. warning::

    The REST and Web Server certificate are not automatically renewed, user
    MUST renew the certificate prior to expiry, otherwise a variety of system
    operations will fail.

.. note::
    
    Ensure the certificates have RSA key length >= 2048 bits. The
    |prod-long| Release |this-ver| provides a new version of ``openssl`` which
    requires a minimum of 2048-bit keys for RSA for better security / encryption
    strength.
    
    You can check the key length by running ``openssl x509 -in <the certificate file> -noout -text``
    and looking for the "Public-Key" in the output. For more information see
    :ref:`Create Certificates Locally using openssl <create-certificates-locally-using-openssl>`.

