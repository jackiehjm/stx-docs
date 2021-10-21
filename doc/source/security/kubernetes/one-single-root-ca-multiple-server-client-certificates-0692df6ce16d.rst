.. _one-single-root-ca-multiple-server-client-certificates-0692df6ce16d:

=================================
Certificate Management Guidelines
=================================

A recommended guideline is to use one single Root |CA| certificate to generate
multiple server/client certificates for different uses in the system.

This simplifies the overall configuration of your certificate chains, as well
as it means you need only provide a single Root |CA| certificate for clients to
trust when interfacing to the system.

.. rubric:: |proc|

The following is a use case for |DC| system where one single Root |CA| is used
to generate REST API/Horizon server certificates, central/subcloud registry
server certificates, and how to install these certificates and update system’s
trusted |CA| list.

#.  Generate a Root |CA| certificate on System Controller or a Linux server
    with openssl installed.

    Refer to :ref:`Create Certificates Locally using openssl
    <create-certificates-locally-using-openssl>` on how to generate a Root |CA|
    certificate, and save the Root |CA| certificate and corresponding private
    key in a directory, for example:

    .. code-block:: none

        ../root_CA/root-ca-cert.pem
        ../root_CA/root-ca-key.pem

#.  Generate REST API/Horizon server certificates for System Controller and
    subclouds.

    Refer to :ref:`Create Certificates Locally using openssl
    <create-certificates-locally-using-openssl>` on how to generate server
    certificates from the Root |CA| certificate.

    Pay attention to the notes about the certificate’s |SAN| on section
    :ref:`Install/Update the StarlingX Rest and Web Server Certificate
    <install-update-the-starlingx-rest-and-web-server-certificate>`.

    Optionally, set the subject fields uniquely for systemController and each of
    the subclouds.

    Generate REST API/Horizon server certificate for the central cloud and each
    of the subclouds, and save them in a directory, for example:

    .. code-block:: none

        .. /REST_certificates/central-rest-server-cert.pem
        .. /REST_certificates/subcloud1-rest-server-cert.pem
        .. /REST_certificates/subcloud2-rest-server-cert.pem
        ...

#.  Generate registry server certificates for central cloud and subclouds.

    Refer to :ref:`Create Certificates Locally using openssl
    <create-certificates-locally-using-openssl>` on how to generate server
    certificates from the self-signed Root |CA| certificate.

    Refer to :ref:`Install/Update the Local Docker Registry Certificate
    <installing-updating-the-docker-registry-certificate>` for the requirements
    on certificate’s |SANs|.

    Optionally set the subject fields uniquely for System Controller and each
    of the subclouds.

    Generate registry server certificate for central cloud and each of the
    subclouds, and save them is a directory, for example:

    .. code-block:: none

        .. /registry_certificates/central-registry-server-cert.pem
        .. /registry_certificates/subcloud1-registry-server-cert.pem
        .. /registry_certificates/subcloud2-registry-server-cert.pem
        ...

#.  Install the Root |CA| certificate as trusted |CA| on System Controller.

    The single Root |CA| certificate only need to be installed on System
    Controller.

    It will sync to all the subclouds.

    Wait until subclouds are insync.

#.  Install the REST API/Horizon server certificates to the central and subclouds.

    Once all subclouds are insync, install the central cloud’s REST
    API/Horizon server certificate to the central cloud, and the subcloud’s
    REST API/Horizon server certificate to each of the subclouds.

    This can be done manually or by some auto tools such as ansible.

#.  Install the registry server certificates to central and subclouds.

    Similarly, once all subclouds are in-sync, install the central cloud’s
    registry certificate to the central cloud, and the subcloud’s registry
    server certificate to each of the subclouds.

    This can be done manually or by some auto tools such as ansible.

#.  Provide the single Root |CA| public certificate, from step 1
    (`../root_CA/root-ca-cert.pem`), to any remote user using remote clients to
    interface with the |prod| system.

    These remote users/clients will need to be configured to trust this Root
    |CA|.
