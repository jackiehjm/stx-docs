.. Greg updates required for -High Security Vulnerability Document Updates
.. Is this the target file that the rest of the updates need to point to??


.. _migrate-platform-certificates-to-use-cert-manager-c0b1727e4e5d:

===========================================================================
Update system-local-ca or Migrate Platform Certificates to use Cert Manager
===========================================================================

The playbook described in this section can be used to either update
``system-local-ca`` or migrate platform Certificates to use Cert Manager. For
updating ``system-local-ca``, this playbook will update the ``system-local-ca``
Secret and Issuer, re-sign all the Platform certificates using this issuer, and
in a Distributed Cloud environment, iterate thru all of the subclouds and do
the same updates and re-signing on each Subcloud. In the migration use case,
this playbook can be used to switch from using Platform certificates generated
from the legacy certificate management APIs/CLIs, which will be deprecated in a
future release, to the new method of configuring Platform certificates using
Cert-Manager which enables auto-renewals of Platform certificates.  And again
in a Distributed Cloud environment will iterate thru all of the Subclouds.

.. rubric:: |context|

This playbook can be configured to execute on any :ref:`deployment
configuration <deployment-options>` supported by |prod| (|AIO|, standard, and
distributed cloud configurations), allowing you to update system-local-ca and
re-sign certificates or migrate certificates at scale.

The certificates (if they exist) that will be updated / migrated with this
playbook are:

* system-local-ca
* system-openldap-local-certificate
* REST API & Web Server certificate ( system-restapi-gui-certificate signed by system-local-ca)
* Docker Registry certificate (system-registry-local-certificate signed by system-local-ca)
* OIDC-Auth-Apps certificate (<user-specified> signed by system-local-ca)

.. rubric:: |proc|

#.  Create an inventory file using Ansible-Vault.

    You must create an inventory file to specify the playbook parameters. Using
    ansible-vault is highly recommended in order to securely store the contents
    of the inventory file which includes the ``system-local-ca`` public
    certificate and private key, and the Root |CA| public certificate for
    ``system-local-ca``. Ansible vault will ask for a password in this step,
    which is used for subsequent ansible-vault access and ansible-playbook
    commands.

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
        Both values being the single-line base64 encoding of the corresponding
        pem file; i.e. the output of :command:`base64 -w0 <pem-file>`.

        It is highly recommended that you use an Intermediate |CA|
        ``system-local-ca``, where the ``system-local-ca``'s certificate and
        key are generated and signed by an external trusted Root |CA|.  Refer
        to the documentation for the external trusted Root |CA| that you are
        using, on how to create a public certificate and private key pair, for
        use in an Intermediate |CA|.

        The duration of the Intermediate CA public certificate and private key
        pair should be at least 3 years.  See *ca_duration* to modify this
        semantic check.

    ``system_root_ca_cert``
        The public certificate of the Root |CA| that signed
        ``system_local_ca_cert``.

    ``ca_duration``
        |CA| duration validation parameter. This will be used against
        ``system_local_ca_cert`` and ``system_root_ca_cert`` to ensure that
        they have sufficient duration remaining. It defaults to 3 years, as
        this is typical for |CA| certificates and this certificate must be
        renewed manually. Only override if necessary.

    ``system_platform_certificate.dns_domain``
        The |DNS| domain that will be used to build a full DNS name for the
        |SANs| List of the Platform Certificates. E.g.
        ``starlingx-restapi-gui.<dns_domain>`` would appear in the |SANs| list
        of the REST API & Web Server certificate. in the server certificates.

    ``system_platform_certificate.duration``
        The duration of certificate validity to use in all Platform
        Certificates, in hours; defaults to 2160h (or 90 days). The Platform
        Server Certificates will be auto-renewed by Cert-Manager.

    ``system_platform_certificate.renewBefore``
        The number of hours before certificate expiry that the Platform
        Certificate should be auto-renewed by Cert-Manager; defaults to 360h
        (or 15 days).

    ``system_platform_certificate.subject_*fields``
        Subject related fields that will be added to all platform certificates:

        - ``system_platform_certificate.subject_C``: country

        - ``system_platform_certificate.subject_ST``: State or Province

        - ``system_platform_certificate.subject_L``: Location

        - ``system_platform_certificate.subject_O``: Organization

        - ``system_platform_certificate.subject_OU``: Organization Unit

        - ``system_platform_certificate.subject_CN``: Common Name

        - ``system_platform_certificate.subject_prefix``: An optional field to add a prefix to further identify the certificate, such as |prod| for instance.

    ``ansible_ssh_user``
        The username to use to connect to the target system using ``ssh``.

    ``ansible_ssh_pass``
        The password to use to connect to the target system using ``ssh``.

    ``ansible_become_pass``
        The ``ansible_ssh_user``'s sudo password.

    If a separate set of overrides are required for a group of hosts,
    ``children`` groups can be added under ``target_group``.

    .. include:: /shared/_includes/recommended-renewbefore-value-for-certificates-c929cf42b03b.rest 

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

    .. note::

       In |prod-dc| systems, the playbook must be executed from the System
       Controller, and the ``target_list`` parameter should be used to target
       the desired subclouds.

    The behavior of the update/migration can be customized using the following
    ``--extra-vars`` parameter options:

    ``mode``
        * ``update``: Creates or updates platform certificates. Also supports
          ongoing updates, which is useful for operations such as replacing the
          |ICA| or changing other parameters.

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
        ``yes``/``no``: When not specified defaults to no. Using
        ``ignore_alarms=yes`` should be avoided as much as possible. Only use
        it after a careful analysis of the alarm in question and for specific
        hosts.

