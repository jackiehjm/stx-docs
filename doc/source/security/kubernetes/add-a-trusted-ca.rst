
.. qfk1564403051860
.. _add-a-trusted-ca:

==============================
Manage Trusted CA Certificates
==============================

Generally a trusted |CA| certificate needs to be added if |prod| clients on
the hosts will be connecting to server\(s\) secured with SSL and whose
certificate is signed by an unknown |CA|.

.. contents::
   :local:
   :depth: 1

For example, a trusted |CA| certificate is required if your helm charts or
yaml manifest files refer to images stored in a docker registry whose
certificate has been signed by an unknown Certificate Authority.

Trusted |CA| certificates can be added as part of the Ansible Bootstrap
Playbook or by using the StarlingX/system REST API or CLI after installation.


.. _add-a-trusted-ca-section-N1002C-N1001C-N10001:

--------------------------
Ansible Bootstrap Playbook
--------------------------

A trusted |CA| certificate may need to be specified as an override parameter
for the Ansible Bootstrap Playbook. Specifically, if the docker registries,
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

-----------------------------------------------------
StarlingX/System CLI – Trusted CA Certificate Install
-----------------------------------------------------

After installation, adding a trusted |CA| to the |prod| system may be required.
This is the case if images stored in a docker registry, whose certificate has
been signed by an unknown Certificate Authority, are referred to by helm
charts and/or yaml manifest files.

The certificate must be in |PEM| file format.
From the command line, run the :command:`certificate-install` command.

.. code-block:: none

    ~(keystone_admin)]$ system certificate-install -m ssl_ca <trusted-ca-bundle-pem-file>


For example:

.. code-block:: none

    ~(keystone_admin)]$ system certificate-install -m ssl_ca external-registry-ca-crt.pem
    WARNING: For security reasons, the original certificate,
    containing the private key, will be removed,
    once the private key is processed.
    +-------------+--------------------------------------+
    | Property    | Value                                |
    +-------------+--------------------------------------+
    | uuid        | c986249f-b304-4ab4-b88e-14f92e75269d |
    | certtype    | ssl_ca                               |
    | signature   | ssl_ca_14617336624230451058          |
    | start_date  | 2019-05-22 18:24:41+00:00            |
    | expiry_date | 2020-05-21 18:24:41+00:00            |
    +-------------+--------------------------------------+


.. note::
    Multiple trusted |CA| certificates can be added with single install
    command by including multiple |CA| certificates in the |PEM| file.


.. _add-a-trusted-ca-section-phr-jw4-3mb:

-------------------------------------------------------
StarlingX/System CLI – Trusted CA Certificate Uninstall
-------------------------------------------------------

To remove a Trusted |CA| Certificate, first list the trusted |CAs| by
running the following command:

.. code-block:: none

    ~(keystone_admin)]$ system certificate-list

where, all entries with certtype = ssl\_ca are trusted |CA| certificates.

Then remove a Trusted |CA| Certificate from the list of trusted |CAs| by
running the following command:

.. code-block:: none

    ~(keystone_admin)]$ system certificate-uninstall -m ssl_ca <UUID>

where, <UUID> is the UUID of the ssl\_ca certtype to be removed.

