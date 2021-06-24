
.. law1570030645265
.. _install-update-the-starlingx-rest-and-web-server-certificate:

=================================================================
Install/Update the StarlingX Rest and Web Server Certificate
=================================================================

Use the following procedure to install or update the certificate for the REST
API application endpoints \(Keystone, Barbican and StarlingX\) and the web
administration server.

.. rubric:: |prereq|

Obtain an intermediate or Root |CA|-signed certificate and key from a trusted
intermediate or Root |CA|. Refer to the documentation for the external
Intermediate or Root |CA| that you are using, on how to create public
certificate and private key pairs, signed by intermediate or a Root |CA|, for
HTTPS.

.. xbooklink

   For lab purposes, see :ref:`Locally Creating Certificates
   <creating-certificates-locally-using-openssl>` for how to create a test
   intermediate or Root |CA| certificate and key, and use it to sign test
   certificates.

Put the |PEM| encoded versions of the certificate and key in a single file,
and copy the file to the controller host.

.. note::
    If you plan to use the container-based remote CLIs, due to a limitation
    in the Python2 SSL certificate validation, the certificate used for the
    'ssl' certificate must either have:

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
    |CA|-signed certificate and private key to install.


