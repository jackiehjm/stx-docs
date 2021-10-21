.. _vault-server-certificate-8573125eeea6:

========================
Vault Server Certificate
========================

|prod| integrates open source Vault containerized security application
\(Optional\) into the |prod| solution.

Vault is a containerized secrets management application that provides encrypted
storage with policy-based access control and supports multiple secrets storage
engines and auth methods.

Refer to :ref:`Vault Secret and Data Management
<vault-secret-and-data-management-security-index>` for details about Vault
installation and configuration.

Accessing Vault is secured by HTTPS. Vault server certificate and the Root |CA|
certificate from which the server certificate is generated are stored in
Kubernetes secrets in Vault namespace.

-   Vault-ca: the Vault Root |CA| certificate

-   Vault-server-tls: the Vault server certificate

The client that accesses Vault server verifies Vault server certificate with
vault-ca Root |CA| certificate. So the client needs to be configured to trust
vault-ca Root |CA| certificate.

In section :ref:`Configure Vault Using the Vault REST API <configure-vault>`,
there are examples using curl to access Vault services.

--------------------------------
Install Vault server certificate
--------------------------------

By default, the Root |CA| certificate and key are automatically created and the
Vault server certificate is generated from the Root |CA| certificate during the
Vault app application.

The Root |CA| certificate has 10 years validity while the server certificate
has 3 month validity.

-------------------------------
Update/Renew Vault certificates
-------------------------------

.. warning::

    Vault certificates are not auto renewed. They have to be updated manually
    by updating the secrets from the new certificate files.

Refer to :ref:`Create Certificates Locally using openssl
<create-certificates-locally-using-openssl>` on how to generate certificate
using openssl in general.

.. rubric:: |proc|

The following procedure is an example of the steps to generate new Vault server
certificate from the existing Root |CA| certificate using openssl and update
corresponding secret for Vault to use the new certificate.

The existing Root |CA| has 10 years validity so the example below is to renew
the Vault server certificate from it.

#.  Retrieve Vault Root |CA| certificate and private key from secret to files:

    .. code-block:: none

        ~(keystone_admin)]$ mkdir /home/sysadmin/vault_ca_cert
        ~(keystone_admin)]$ echo $(kubectl get secrets -n vault vault-ca -o jsonpath='{.data.tls\.crt}') | base64 --decode > /home/sysadmin/vault_ca_cert/vault_ca_cert.pem
        ~(keystone_admin)]$ echo $(kubectl get secrets -n vault vault-ca -o jsonpath='{.data.tls\.key}') | base64 --decode > /home/sysadmin/vault_ca_cert/vault_ca_key.pem

#.  Create and sign a server certificate and key:

    -   Create the Server private key.

        .. code-block::

            ~(keystone_admin)]$ mkdir /home/sysadmin/vault_new_certs
            ~(keystone_admin)]$ openssl genrsa -out /home/sysadmin/vault_new_certs/vault-server-tls-key.pem 2048

    -   Create the server certificate signing request (csr).

        Create a csr configuration file
        ``/home/sysadmin/vault_new_certs/extfile.cnf`` with the following content:

        .. code-block::

            [req]
            prompt = no
            x509_extensions = v3_req
            distinguished_name = dn
            [dn]
            O = stx
            [v3_req]
            basicConstraints = critical, CA:FALSE
            extendedKeyUsage = TLS Web Server Authentication, TLS Web Client Authentication
            subjectAltName = @alt_names
            [alt_names]
            DNS.1 = sva-vault
            DNS.2 = *.sva-vault-internal
            DNS.3 = *.vault.pod.cluster.local
            DNS.4 = sva-vault.vault
            DNS.5 = sva-vault.vault.svc
            DNS.6 = sva-vault.vault.svc.cluster.local
            DNS.7 = sva-vault-active.vault.svc.cluster.local
            IP.1 = 127.0.0.1

            ~(keystone_admin)]$ openssl req -new -key /home/sysadmin/vault_new_certs/vault-server-tls-key.pem -out /home/sysadmin/vault_new_certs/vault-server-tls.csr -config /home/sysadmin/vault_new_certs/extfile.cnf

    -   Use the Root |CA| to sign the server certificate:

        .. code-block::

            ~(keystone_admin)]$ openssl x509 -req -in /home/sysadmin/vault_new_certs/vault-server-tls.csr -CA /home/sysadmin/vault_ca_cert/vault_ca_cert.pem -CAkey /home/sysadmin/vault_ca_cert/vault_ca_key.pem -CAcreateserial -out /home/sysadmin/vault_new_certs/vault-server-tls-cert.pem -days 365 -extensions v3_req -extfile /home/sysadmin/vault_new_certs/extfile.cnf

#.  Update vault-server-tls secret with the new vault server certificate:

    .. code-block::

        ~(keystone_admin)]$ kubectl create secret tls vault-server-tls --cert=/home/sysadmin/vault_new_certs/vault-server-tls-cert.pem --key=/home/sysadmin/vault_new_certs/vault-server-tls-key.pem --save-config --dry-run=client -n vault -o yaml | kubectl apply -f -

#.  Restart vault-manager, agent-injector and vault servers to use the new server certificate:

    .. code-block::

        ~(keystone_admin)]$ kubectl rollout restart statefulset sva-vault-manager -n vault
        ~(keystone_admin)]$ kubectl rollout restart deployment sva-vault-agent-injector -n vault

        ~(keystone_admin)]$ kubectl delete pod sva-vault-0 -n vault
        ~(keystone_admin)]$ kubectl delete pod sva-vault-1 -n vault
        ~(keystone_admin)]$ kubectl delete pod sva-vault-2 -n vault

