
.. rmn1594906401238
.. _create-certificates-locally-using-openssl:

=========================================
Create Certificates Locally using openssl
=========================================

You can use :command:`openssl` to locally create certificates suitable for
use in a lab environment.

.. rubric:: |proc|

.. _create-certificates-locally-using-openssl-steps-unordered-pln-qhc-jmb:

#.  Create a Root |CA| Certificate and Key

    #.  Create the Root CA private key.

        .. code-block:: none

            $ openssl genrsa -out my-root-ca-key.pem 2048

    #.  Generate the Root CA x509 certificate.

        .. code-block:: none

            $ openssl req -x509 -new -nodes -key my-root-ca-key.pem \
            -days 1024 -out my-root-ca-cert.pem -outform PEM

#.  Create and Sign a Server Certificate and Key.

    #.  Create the Server private key.

        .. code-block:: none

            $ openssl genrsa -out my-server-key.pem 2048

    #.  Create the Server certificate signing request (csr).

        Specify "CN=registry.local" and do not specify a challenge password.

        .. code-block:: none

            $ openssl req -new -key my-server-key.pem -out my-server.csr

    #.  Create the |SANs| list.

        .. code-block:: none

            $ echo subjectAltName = IP:<WRCP-OAM-Floating-IP>,IP:<WRCP-MGMT-Floating-IP>,DNS:registry.local,DNS:registry.central > extfile.cnf

    #.  Use the my-root-ca to sign the server certificate.

        .. code-block:: none

            $ openssl x509 -req -in my-server.csr -CA my-root-ca-cert.pem \
            -CAkey my-root-ca-key.pem -CAcreateserial -out my-server-cert.pem \
            -days 365 -extfile extfile.cnf

    #.  Put the server certificate and key into a single file.

        .. code-block:: none

            $ cat my-server-cert.pem my-server-key.pem > my-server.pem


