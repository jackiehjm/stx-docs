
.. idr1582032622279
.. _installing-updating-the-docker-registry-certificate:

==============================================
Install/Update the Docker Registry Certificate
==============================================

The local Docker registry provides secure HTTPS access using the registry API.

.. rubric:: |context|

By default a self-signed certificate is generated at installation time for the
registry API. For more secure access, an intermediate or Root CA-signed
certificate is strongly recommended.

The intermediate or Root CA-signed certificate for the registry must have at
least the following |SANs|: DNS:registry.local, DNS:registry.central, IP
Address:<oam-floating-ip-address>, IP Address:<mgmt-floating-ip-address>. Use
the :command:`system addrpool-list` command to get the |OAM| floating IP
Address and management floating IP Address for your system. You can add any
additional |DNS| entry\(s\) that you have set up for your |OAM| floating IP
Address.

Use the following procedure to install an intermediate or Root CA-signed
certificate to either replace the default self-signed certificate or to replace
an expired or soon to expire certificate.

.. rubric:: |prereq|

Obtain an intermediate or Root CA-signed certificate and key from a trusted
intermediate or Root Certificate Authority \(CA\). Refer to the documentation
for the external Root CA that you are using, on how to create public
certificate and private key pairs, signed by an intermediate or Root CA, for
HTTPS.

.. xreflink For lab purposes, see |sec-doc|: :ref:`Locally Creating
   Certificates <creating-certificates-locally-using-openssl>` to create a
   Intermediate or test Root CA certificate and key, and use it to sign test
   certificates.

Put the Privacy Enhanced Mail \(PEM\) encoded versions of the certificate and
key in a single file, and copy the file to the controller host.

Also obtain the certificate of the intermediate or Root CA that signed the
above certificate.

.. rubric:: |proc|

.. _installing-updating-the-docker-registry-certificate-d271e71:

#.  In order to enable internal use of the Docker registry certificate, update
    the trusted CA list for this system with the Root CA associated with the
    Docker registry certificate.

    .. code-block:: none

       ~(keystone_admin)]$ system certificate-install --mode ssl_ca <pathTocertificate>

    where:

    **<pathTocertificate>**

    is the path to the intermediate or Root CA certificate associated with the
    Docker registry's intermediate or Root CA-signed certificate.

#.  Update the Docker registry certificate using the
    :command:`certificate-install` command.

    Set the mode (``-m`` or ``--mode``) parameter to docker\_registry.

    .. code-block:: none

       ~(keystone_admin)]$ system certificate-install --mode docker_registry <pathTocertificateAndKey>

    where:

    **<pathTocertificateAndKey>**

    is the path to the file containing both the Docker registry's Intermediate
    or Root CA-signed certificate and private key to install.
