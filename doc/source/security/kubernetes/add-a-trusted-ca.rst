
.. qfk1564403051860
.. _add-a-trusted-ca:

==============================
System Trusted CA Certificates
==============================

|prod| also supports the ability to update the trusted |CA| certificate
bundle on all nodes in the system. This is required, for example, when
container images are being pulled from an external Docker registry with a
certificate signed by a non-well-known |CA|.

Generally a trusted |CA| certificate needs to be added if |prod| clients on
the hosts will be connecting to server\(s\) secured with SSL and whose
certificate is signed by an unknown |CA|.

.. contents::
   :local:
   :depth: 1

For example, a trusted |CA| certificate is required if your Helm charts or
yaml manifest files refer to images stored in a Docker registry whose
certificate has been signed by an unknown Certificate Authority.

Trusted |CA| certificates can be added as part of the Ansible Bootstrap
Playbook or by using the StarlingX/system REST API or CLI after installation.

-----------------------------------------
Install/Uninstall Trusted CA certificates
-----------------------------------------

Trusted |CA| certificates can be added as part of the Ansible Bootstrap
Playbook or by using the StarlingX/system REST API or CLI after installation.


.. _add-a-trusted-ca-section-N1002C-N1001C-N10001:

--------------------------
Ansible Bootstrap Playbook
--------------------------

A trusted |CA| certificate may need to be specified as an override parameter
for the Ansible Bootstrap Playbook. Specifically, if the Docker registries,
specified by the bootstrap overrides file, use a certificate signed by an
unknown |CA|. If this is the case then the ssl\_ca\_cert parameter needs to
be specified in the ansible overrides file, /home/sysadmin/localhost.yml, as
part of bootstrap in the installation procedure.

For example:

.. code-block:: none

    ssl_ca_cert: /path/to/ssl_ca_cert_file

The *ssl\_ca\_cert* value is the absolute path of the file containing the
|CA| certificate\(s\) to trust. The certificate\(s\) must be in |PEM| format
and the file may contain one or more |CA| certificates.


.. _add-a-trusted-ca-section-N10047-N1001C-N10001:

-------------------------------------------
System CLI – Trusted CA certificate install
-------------------------------------------

After installation, adding a trusted |CA| to the |prod| system may be required.
This is the case if images stored in a Docker registry, whose certificate has
been signed by a not-well-known Certificate Authority, are referred to by Helm
charts and/or yaml manifest files.

Multiple trusted |CA| certificates can be added with single install command by
including multiple |CA| certificates in the specified |PEM| file.

The certificate must be in |PEM| file format.

From the command line, run the :command:`certificate-install` command.

.. code-block:: none

    ~(keystone_admin)]$ system certificate-install -m ssl_ca <trusted-ca-bundle-pem-file>

where ``<trusted-ca-bundle-pem-file>`` contains 1 or more public certificates
of |CAs| that should be trusted by |prod|.


The system will print a list of the certificates that were successfully
installed from the |PEM| file and a list of certificates that were not
installed from the |PEM| file due to a certificate error.

For example:

.. code-block:: none

    ~(keystone_admin)]$ system certificate-install -m ssl_ca ext-registry-ca-certificates.pem

    +-------------+------------------------------------------------+
    | Property    | Value                                          |
    +-------------+------------------------------------------------+
    | uuid        | 5f677003-a08a-4725-9082-2b4ea81b33d5           |
    | certtype    | ssl_ca                                         |
    | signature   | ssl_ca_252107869940582877573916937829152170776 |
    | start_date  | 2021-08-17 01:48:21+00:00                      |
    | expiry_date | 2021-08-17 02:48:21+00:00                      |
    +-------------+------------------------------------------------+
    WARNING: Some certificates were not installed.
    Error with cert number 2 in the file: certificate is not valid before 2021-08-13 14:00:21 nor after 2021-08-13 15:00:21
    Error with cert number 3 in the file: certificate is not valid before 2021-08-13 14:00:21 nor after 2021-08-13 15:00:21
    Error with cert number 4 in the file: certificate is not valid before 2018-08-16 20:28:20 nor after 2021-06-05 20:28:20

.. note::

    Installing a new ``ssl_ca`` with ``system certificate-install -m ssl_ca``
    or deleting an old ``ssl_ca`` with ``system certificate-uninstall`` must be
    followed by locking and unlocking all controller nodes for the change to
    take effect.

.. _add-a-trusted-ca-section-phr-jw4-3mb:

---------------------------------------------
System CLI – Trusted CA certificate uninstall
---------------------------------------------

To remove a Trusted |CA| Certificate, first list the trusted |CAs| by
running the following command:

.. code-block:: none

    ~(keystone_admin)]$ system certificate-list

where, all entries with certtype = ssl_ca are trusted |CA| certificates.

Then remove a Trusted |CA| Certificate from the list of trusted |CAs| by
running the following command:

.. code-block:: none

    ~(keystone_admin)]$ system certificate-uninstall -m ssl_ca <UUID>

where, <UUID> is the UUID of the ssl\_ca certtype to be removed.

.. note::

    Installing a new ``ssl_ca`` with ``system certificate-install -m ssl_ca``
    or deleting an old ``ssl_ca`` with ``system certificate-uninstall`` must be
    followed by locking and unlocking all controller nodes for the change to
    take effect.

------------------------------------
Update/Renew trusted CA certificates
------------------------------------

.. warning::

    System trusted |CA| certificates can not be auto renewed, as they are not
    owned by |prod|.

    The administrator should update the trusted |CA| certificates following the
    install/uninstall procedure as requested, or when trusted |CA| certificates
    in use are approaching expiration.

For example, when the |CA| certificate signing an external Docker registry’s
server certificate needs to be renewed, either because an external Docker
registry has a new server certificate signed by a new |CA|, or the |CA|
certificate signing an external Docker registry’s current server certificate
approaching expiration, the administrator can update the |CA| certificate for
the external Docker registry access by uninstalling the old one, and installing
the new one.
