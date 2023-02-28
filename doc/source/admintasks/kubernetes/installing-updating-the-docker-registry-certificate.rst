
.. idr1582032622279
.. _installing-updating-the-docker-registry-certificate:

==========================================
Install/Update Local Registry Certificates
==========================================

.. warning::

   By default a self-signed certificate is generated at installation time for
   the registry API. This applies to standalone system, central cloud and
   subclouds of |DC| system. For more secure access, it is strongly recommended
   to update the default self-signed certificate with an intermediate or Root
   |CA|-signed certificate.


The local Docker registry provides secure HTTPS access using the registry API.

.. rubric:: |context|

The intermediate or Root |CA|-signed certificate for the registry must have at
least the following |SANs|: ``DNS:registry.local``, ``DNS:registry.central``,
IP Address:<oam-floating-ip-address>, IP Address:<mgmt-floating-ip-address>.
Use the :command:`system addrpool-list` command to get the |OAM| floating IP
Address and management floating IP Address for your system. You can add any
additional |DNS| entry\(s) that you have set up for your |OAM| floating IP
Address.

.. note::

   The ``DNS:registry.central`` can be omitted from |SANs| for
   standalone system and subcloud of |DC| system.

The update procedure for any type of system (standalone, central cloud and
subcloud of |DC| system) is the same.

Use the following procedure to install an intermediate or Root |CA|-signed
certificate to either replace the default self-signed certificate or to replace
an expired or soon to expire certificate.

.. rubric:: |prereq|

Obtain an intermediate or Root |CA|-signed certificate and key from a trusted
intermediate or Root Certificate Authority (|CA|). Refer to the documentation
for the external Root |CA| that you are using, on how to create public
certificate and private key pairs, signed by an intermediate or Root |CA|, for
HTTPS.

.. xreflink

For lab purposes, see |sec-doc|: :ref:`Create Certificates Locally
using openssl <create-certificates-locally-using-openssl>` to create an
Intermediate or test Root |CA| certificate and key, and use it to sign test
certificates.

Put the Privacy Enhanced Mail (PEM) encoded versions of the certificate and
key in a single file, and copy the file to the controller host.

Also obtain the certificate of the intermediate or Root CA that signed the
above certificate.

Ensure all certificates are valid before starting an upgrade. Run the
:command:`show-certs.sh` script to display an overview of the various
certificates that exist in the system along with their expiry date. For more
information, see, :ref:`Display Certificates Installed on a System <utility-script-to-display-certificates>`.

.. rubric:: |proc|

.. _installing-updating-the-docker-registry-certificate-d271e71:

#.  In order to enable internal use of the Docker registry certificate, update
    the trusted |CA| list for this system with the Root |CA| associated with the
    Docker registry certificate.

    .. code-block:: none

       ~(keystone_admin)]$ system certificate-install --mode ssl_ca <pathTocertificate>

    where:

    **<pathTocertificate>**

    is the path to the intermediate or Root |CA| certificate associated with the
    Docker registry's intermediate or Root |CA|-signed certificate.

#.  Update the Docker registry certificate using the
    :command:`certificate-install` command.

    Set the mode (``-m`` or ``--mode``) parameter to docker_registry.

    .. code-block:: none

       ~(keystone_admin)]$ system certificate-install --mode docker_registry <pathTocertificateAndKey>

    where:

    **<pathTocertificateAndKey>**

    is the path to the file containing both the Docker registry's Intermediate
    or Root |CA|-signed certificate and private key to install.

In |DC| system, the server certificate of central registry and the server
certificate of subcloud’s local registry can be arranged to be generated from
the same root |CA| certificate.

In this case, the generated server certificates need to be installed on the
central cloud and each of the subclouds.

The root |CA| certificate only needs to install on central cloud, the |DC|
orchestration will sync the root |CA| certificate to all the subclouds.

---------------------------------
Renew local registry certificates
---------------------------------

The local registry certificate is not automatically renewed, user MUST renew
the certificate prior to expiry, otherwise a variety of system operations will
fail.