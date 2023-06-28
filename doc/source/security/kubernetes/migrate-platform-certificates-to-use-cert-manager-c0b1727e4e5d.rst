.. Greg updates required for -High Security Vulnerability Document Updates
.. Is this the target file that the rest of the updates need to point to??


.. _migrate-platform-certificates-to-use-cert-manager-c0b1727e4e5d:

========================================================
Migrate/Update Platform Certificates to use Cert Manager
========================================================

Platform Certificates from the legacy certificate management APIs/CLIs, which
will be deprecated in a future release, to the new method of configuring
Platform Certificates using Cert-Manager which enables auto-renewals of
Platform Certificates.

.. rubric:: |context|

This migration script can be configured to execute on any
:ref:`deployment configuration <deployment-options>` supported by |prod|
(|AIO|, standard, and distributed cloud configurations), allowing you to migrate
the certificates at scale. The script will replace old certificates and a backup
of the original certificates will be retained for reference. The certificates
that will be migrated/updated with this playbook are:

* REST API & Web Server certificate
* Docker Registry certificate
* OIDC-Auth-Apps certificate

The |CA| against which the server certificates will be validated can be generated
on-platform (self-signed) or use an external Root |CA| and |ICA|. Using an external
Root |CA| and |ICA| is recommended. Note that this ansible-playbook will use the same
|ICA| cert & key to create the Issuers and/or ClusterIssuers for all
controllers/subclouds.

.. note::

   This playbook can also be used to update certificates, which is useful for
   situations such as |ICA| approaching expiry.

.. rubric:: |proc|

#.  Create an inventory file using Ansible-Vault.

    You must create an inventory file to specify the playbook parameters. Using
    ansible-vault is highly recommended for enhanced security. Ansible vault
    will ask for a password in this step, which is used for subsequent
    ansible-vault access and ansible-playbook commands.

    For example:

    .. code-block:: none

        ~(keystone_admin)]$ ansible-vault create migration-inventory.yml

    This will open up an editor in which you need to manually add or paste
    your inventory parameters, as specified in the example below.

    An example ``migration-inventory.yaml`` file is shown below:

    .. code-block:: none

        all:
          vars:
            system_local_ca_cert: <base64_cert>
            system_local_ca_key: <base64_key>
            system_root_ca_cert: <base64_cert>
          children:
            target_group:
              vars:
                system_platform_certificate:
                  dns_domain: xyz.com
                  duration: 2160h # 90d
                  renewBefore: 360h # 15d
                  subject_C: CA
                  subject_ST: Ontario
                  subject_L: Ottawa
                  subject_O: myorganization
                  subject_OU: engineering
                  subject_CN: myorganization.com
                  subject_prefix: starlingx2`
                # SSH password to connect to all subclouds
                ansible_ssh_user: sysadmin
                ansible_ssh_pass: <sysadmin-passwd>
                # Sudo password
                ansible_become_pass: <sysadmin-passwd>


    The inventory parameters have the following meanings:

    ``system_local_ca_cert`` and ``system_local_ca_key``
        You may choose to generate a certificate & key on the platform
        (self-signed, internal Root |CA|) or use an external Root
        |CA| that would make this an Intermediate |CA|.

    .. note::
      
        Ensure the certificates have RSA key length >= 2048 bits before
        migrating to |prod-long| Release |this-ver|. The |prod-long| Release
        |this-ver| provides a new version of ``openssl`` which requires a
        minimum of 2048-bit keys for RSA for better security / encryption
        strength.
        
        You can check the key length by running ``openssl x509 -in <the certificate file> -noout -text``
        and looking for the "Public-Key" in the output. For more information see
        :ref:`Create Certificates Locally using openssl <create-certificates-locally-using-openssl>`.

    ``system_root_ca_cert``
        The Root |CA| that signed ``system_local_ca_cert``. If
        ``system_local_ca_cert`` is a self-signed, internal Root |CA|
        certificate, duplicate the value of ``system_local_ca_cert`` in this
        field.

    ``ca_duration``
        |CA| duration validation parameter. This will be used against
        ``system_local_ca_cert`` and ``system_root_ca_cert`` to ensure that
        they have sufficient duration remaining. It defaults to 3 years, as
        this is typical for |CA| certificates and this certificate must be
        renewed manually. Only override if necessary.

    ``system_platform_certificate.dns_domain``
        The |DNS| domain that will be used to build the full dns name for the
        |SANs| List of the Platform Certificates. E.g.
        ``starlingx-restapi-gui.<dns_domain>`` would appear in the |SANs| list
        of the REST API & Web Server certificate. in the server certificates.

    ``system_platform_certificate.duration``
        The duration of certificate validity to use in all Platform
        Certificates, in hours. The Platform Server Certificates will be
        auto-renewed by Cert-Manager.

    ``system_platform_certificate.renewBefore``
        The number of hours before certificate expiry that the Platform
        Certificate should be auto-renewed by Cert-Manager.

    ``system_platform_certificate.subject_*fields``
        Subject related fields that will be added to all platform certificates:

        - ``system_platform_certificate.subject_C``: country

        - ``system_platform_certificate.subject_ST``: State or Province

        - ``system_platform_certificate.subject_L``: Location

        - ``system_platform_certificate.subject_O``: Organization

        - ``system_platform_certificate.subject_OU``: Organization Unit

        - ``system_platform_certificate.subject_CN``: Common Name

        - ``system_platform_certificate.subject_prefix``: An optional field
            to add a prefix to further identify the certificate, such as |prod|
            for instance

    ``ansible_ssh_user``
        The username to use to connect to the target system using ``ssh``.

    ``ansible_ssh_pass``
        The password to use to connect to the target system using ``ssh``.

    ``ansible_become_pass``
        The target system's sudo password.

    If a separate set of overrides are required for a group of hosts,
    ``children`` groups can be added under ``target_group``.

    The following example illustrates using one set of ssh/sudo passwords for
    subcloud1 and subcloud2 and another set of ssh/sudo passwords for
    subcloud3.

    .. code-block:: none

        all:
          vars:
            ...
          children:
            target_group:
              vars:
                ...
              children:
                different_password_group:
                  vars:
                    ansible_ssh_user: sysadmin
                    ansible_ssh_pass: <sysadmin-passwd>
                    ansible_become_pass: <sysadmin-passwd>
                  hosts:
                    subcloud1:
                    subcloud2:
                different_password_group2:
                  vars:
                    ansible_ssh_user: sysadmin
                    ansible_ssh_pass: <different-sysadmin-passwd>
                    ansible_become_pass: <different-sysadmin-passwd>
                  hosts:
                    subcloud3:

#.  Run the playbook.

    Execute the Ansible playbook to start the migration process. You will be
    prompted for the vault password created in the previous step.

    For example:

    .. code-block:: none

        ~(keystone_admin)]$ ansible-playbook /usr/share/ansible/stx-ansible/playbooks/migrate_platform_certificates_to_certmanager.yml -i migration-inventory.yml --extra-vars "target_list=subcloud1 mode=update ignore_alarms=yes" --ask-vault-pass

    The behavior of the migration can be customized using the following
    ``--extra-vars`` parameter options:

    ``mode``
        * ``update``: Creates or updates platform certificates. Also supports
          ongoing updates, which is useful for operations such as such as
          replacing the |ICA| or changing other parameters.

        * ``check``: Gathers certificates from all subclouds and prints them on
          the system controller

    ``target_list``
        * ``subcloud1``, ``subcloud2``: A comma separated list of hosts the
          playbook will target.

        * ``localhost``: Will target the localhost (standalone systems or
          system controller)

        * ``all_online_subclouds``: Will query ``dcmanager subcloud list`` and
          retrieve a list of online subclouds to target.

    ``ignore_alarms``
        ``yes``/``no``: When not specified defaults to no.


    .. note::

        The ``ignore_alarms`` extra-var should be avoided as much as possible.
        Only use it after a careful analysis of the alarm in question and for
        specific hosts.
