
.. law1570030645265
.. _install-update-the-starlingx-rest-and-web-server-certificate:

=================================================================
Install/Update the StarlingX Rest and Web Server Certificate
=================================================================

Use the following procedure to install or update the certificate for the REST
API application endpoints \(Keystone, Barbican and StarlingX\) and the web
administration server.

.. rubric:: |prereq|

Obtain a Root |CA|-signed certificate and key from a trusted Root |CA|.
Refer to the documentation for the external Root |CA| that you are using,
on how to create public certificate and private key pairs, signed by a Root
|CA|, for HTTPS.

.. xbooklink

   For lab purposes, see :ref:`Locally Creating Certificates
   <creating-certificates-locally-using-openssl>` for how to create a test
   Root |CA| certificate and key, and use it to sign test certificates.

Put the |PEM| encoded versions of the certificate and key in a single file,
and copy the file to the controller host.

.. rubric:: |proc|

-   Install/update the copied certificate.

    For example:

    .. code-block:: none

        ~(keystone_admin)$ system certificate-install <pathTocertificateAndKey>

    where:

    **<pathTocertificateAndKey>**

    is the path to the file containing both the Root |CA|-signed certificate
    and private key to install.


