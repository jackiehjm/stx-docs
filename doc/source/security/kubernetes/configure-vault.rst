
.. xgp1596216287484
.. _configure-vault:

===============
Configure Vault
===============

After Vault has been installed, you can configure Vault for use by hosted
Kubernetes applications on |prod|. This section describes the minimum
configuration requirements for secret management for hosted Kubernetes
applications.

.. rubric:: |context|

You can configure Vault using Vault's REST API. Configuration can also be
done by logging into a Vault server pod and using the Vault CLI directly.
For more information, see :ref:`Configure Vault Using the CLI
<configure-vault-using-the-cli>`.

The following steps use Vault's REST API and is run from controller-0.

.. rubric:: |proc|

#.  Set environment variables.

    .. code-block:: none

        $ ROOT_TOKEN=$(kubectl exec -n vault sva-vault-manager-0 -- cat /mnt/data/cluster_keys.json | grep -oP --color=never '(?<="root_token":")[^"]*')

        $ SA_CA_CERT=$(kubectl exec -n vault sva-vault-0 -- awk 'NF {sub(/\r/, ""); printf "%s\\n",$0;}' /var/run/secrets/kubernetes.io/serviceaccount/ca.crt)

        $ TOKEN_JWT=$(kubectl exec -n vault sva-vault-0 -- cat /var/run/secrets/kubernetes.io/serviceaccount/token)

        $ KUBERNETES_PORT_443_TCP_ADDR=$(kubectl exec -n vault sva-vault-0 -- sh -c 'echo $KUBERNETES_PORT_443_TCP_ADDR')

        $ echo $(kubectl get secrets -n vault vault-ca -o jsonpath='{.data.tls\.crt}') | base64 --decode > /home/sysadmin/vault_ca.pem

#.  Enable the Kubernetes Auth method.

    This allows Vault to use Kubernetes service accounts for authentication of Vault commands.

    For more information, see:


    -   `https://www.vaultproject.io/docs/auth <https://www.vaultproject.io/docs/auth>`__

    -   `https://www.vaultproject.io/docs/auth/kubernetes%20 <https://www.vaultproject.io/docs/auth/kubernetes%20>`__


    .. code-block:: none

        $ curl --cacert /home/sysadmin/vault_ca.pem --header "X-Vault-Token:$ROOT_TOKEN" --request POST --data '{"type":"kubernetes","description":"kubernetes auth"}' https://sva-vault.vault.svc.cluster.local:8200/v1/sys/auth/kubernetes


    #.  Configure the Kubernetes Auth method.

        .. code-block:: none

            $ curl --cacert /home/sysadmin/vault_ca.pem --header "X-Vault-Token:$ROOT_TOKEN" --request POST --data '{"kubernetes_host": "'"https://$KUBERNETES_PORT_443_TCP_ADDR:443"'", "kubernetes_ca_cert":"'"$SA_CA_CERT"'", "token_reviewer_jwt":"'"$TOKEN_JWT"'"}' https://sva-vault.vault.svc.cluster.local:8200/v1/auth/kubernetes/config

    #.  Verify the Kubernetes Auth method.

        .. code-block:: none

            $ curl --cacert /home/sysadmin/vault_ca.pem --header "X-Vault-Token:$ROOT_TOKEN" https://sva-vault.vault.svc.cluster.local:8200/v1/auth/kubernetes/config


#.  Enable a secrets engine.

    Vault supports a variety of secret engines, as an example, create a
    **kv-v2** secrets engine. The **kv-v2** secrets engine allows for
    storing arbitrary key-value pairs. Secrets engines are enabled at a
    "path" in Vault. When a request comes to Vault, the router
    automatically routes anything with the route prefix to the secrets
    engine. In this way, each secrets engine defines its own paths and
    properties. To the user, secrets engines behave similar to a virtual
    filesystem, supporting operations like read, write, and delete.

    .. code-block:: none

        $ curl --cacert /home/sysadmin/vault_ca.pem --header "X-Vault-Token:$ROOT_TOKEN" --request POST --data '{"type": "kv","version":"2"}' https://sva-vault.vault.svc.cluster.local:8200/v1/sys/mounts/secret

    For more information, see:


    -   `https://www.vaultproject.io/docs/secrets <https://www.vaultproject.io/docs/secrets>`__

    -   `https://www.vaultproject.io/docs/secrets/kv/kv-v2 <https://www.vaultproject.io/docs/secrets/kv/kv-v2>`__


#.  Create a sample policy and role for allowing access to the configured **kv-v2** secrets engine.


    #.  Create a policy.

        A Vault policy specifies read and/or write capabilities for a
        particular secret engine path, and the Vault role binds a specific
        Kubernetes service account to a policy.

        .. code-block:: none

            $ curl --cacert /home/sysadmin/vault_ca.pem --header "X-Vault-Token:$ROOT_TOKEN" -H "Content-Type: application/json" --request PUT -d '{"policy":"path \"secret/basic-secret/*\" {capabilities = [\"read\"]}"}' https://sva-vault.vault.svc.cluster.local:8200/v1/sys/policy/basic-secret-policy

        For more information, see, `https://www.vaultproject.io/docs/concepts/policies <https://www.vaultproject.io/docs/concepts/policies>`__.

    #.  Create the role mapped to the policy.

        .. note::
            The service account and namespace used for the values below must exist on the kubernetes cluster.


            -   **bound\_service\_account\_names**

            -   **bound\_service\_account\_namespaces**


        .. code-block:: none

            $ curl --cacert /home/sysadmin/vault_ca.pem --header "X-Vault-Token:$ROOT_TOKEN" --request POST --data '{ "bound_service_account_names": "basic-secret",  "bound_service_account_namespaces": "pvtest",  "policies": "basic-secret-policy",  "max_ttl": "1800000"}' https://sva-vault.vault.svc.cluster.local:8200/v1/auth/kubernetes/role/basic-secret-role

    #.  Verify the role configuration.

        .. code-block:: none

            $ curl --cacert /home/sysadmin/vault_ca.pem --header "X-Vault-Token:$ROOT_TOKEN" https://sva-vault.vault.svc.cluster.local:8200/v1/auth/kubernetes/role/basic-secret-role


#.  Create an initial example secret in the configured **kv-v2** secrets engine.


    #.  Create a secret.

        .. code-block:: none

            $ curl --cacert /home/sysadmin/vault_ca.pem --header "X-Vault-Token:$ROOT_TOKEN" -H "Content-Type: application/json" -X POST -d '{"username":"pvtest","password":"<password>"}' https://sva-vault.vault.svc.cluster.local:8200/v1/secret/basic-secret/helloworld

    #.  Verify the secret.

        .. code-block:: none

            $ curl --cacert /home/sysadmin/vault_ca.pem --header "X-Vault-Token:$ROOT_TOKEN" https://sva-vault.vault.svc.cluster.local:8200/v1/secret/basic-secret/helloworld


#.  \(Optional\) To enable and configure logging, use the steps below:


    #.  Enable Vault logging to file for persistent log storage.

        .. code-block:: none

            $ curl --cacert /home/sysadmin/vault_ca.pem --request POST --header "X-Vault-Token:$ROOT_TOKEN" --data '{"type": "file", "description": "ctest", "options": {"file_path": "/vault/audit/vault_audit.log"}}' https://sva-vault.vault.svc.cluster.local:8200/v1/sys/audit/vaultfile

    #.  Enable Vault logging to stdout for easy log reading from the Vault container.

        .. code-block:: none

            $ curl --cacert /home/sysadmin/vault_ca.pem --request POST --header "X-Vault-Token:$ROOT_TOKEN" --data '{"type": "file", "description": "stdout", "options": {"file_path": "stdout"}}' https://sva-vault.vault.svc.cluster.local:8200/v1/sys/audit/stdout

    #.  Verify the configuration.

        .. code-block:: none

            $ curl --cacert /home/sysadmin/vault_ca.pem --header "X-Vault-Token:$ROOT_TOKEN" https://sva-vault.vault.svc.cluster.local:8200/v1/sys/audit



..
  .. rubric:: |result|

.. xbooklink

   For more information, see |usertasks-doc|::ref:`Vault Overview
   <kubernetes-user-tutorials-vault-overview>`.

.. seealso::

    :ref:`Configure Vault Using the CLI <configure-vault-using-the-cli>`


