
.. cms1597171128588
.. _configure-vault-using-the-cli:

===================================
Configure Vault Using the Vault CLI
===================================

After Vault has been installed, you can configure Vault for use with |prod|
using the |CLI|. This section describes the minimum configuration
requirements for server secrets for hosted Kubernetes applications.

.. rubric:: |context|

You can configure Vault by logging into a Vault server pod and using Vault CLI.

.. rubric:: |proc|

#.  Get the root token for logging into Vault.

    .. code-block:: none

        $ kubectl exec -n vault sva-vault-manager-0 -- cat /mnt/data/cluster_keys.json | grep -oP --color=never '(?<="root_token":")[^"]*'

#.  Log in to the Vault server container.

    .. code-block:: none

        $ kubectl exec -it -n vault sva-vault-0 -- sh


    #.  Log into Vault, and provide the root token when prompted. Refer to
        step 1 for the root token.

        .. code-block:: none

            $ vault login

    #.  Enable the Kubernetes Auth method.

        .. code-block:: none

            $ vault auth enable kubernetes

    #.  Configure the Kubernetes Auth method.

        .. code-block:: none

            $ vault write auth/kubernetes/config token_reviewer_jwt="$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)" kubernetes_host="https://$KUBERNETES_PORT_443_TCP_ADDR:443" kubernetes_ca_cert=@/var/run/secrets/kubernetes.io/serviceaccount/ca.crt


    #.  Verify the Kubernetes Auth method.

        .. code-block:: none

            $ vault auth list

        and

        .. code-block:: none

            $ vault read auth/kubernetes/config


#.  Enable a secrets engine at the path "secret".

    Vault supports a variety of secret engines, as an example, create a
    **kv-v2** secrets engine. The **kv-v2** secrets engine allows for
    storing arbitrary key-value pairs. Secrets engines are enabled at a
    "path" in Vault. When a request comes to Vault, the router
    automatically routes anything with the route prefix to the secrets
    engine. In this way, each secrets engine defines its own paths and
    properties. To the user, secrets engines behave similar to a virtual
    filesystem, supporting operations like read, write, and delete.

    .. code-block:: none

        $ vault secrets enable -path=secret kv-v2

    For more information, see:

    -   `https://www.vaultproject.io/docs/secrets
        <https://www.vaultproject.io/docs/secrets>`__

    -   `https://www.vaultproject.io/docs/secrets/kv/kv-v2
        <https://www.vaultproject.io/docs/secrets/kv/kv-v2>`__


#.  Create a sample policy and role for allowing access to the configured
    **kv-v2** secrets engine.

    A Vault policy specifies read and/or write capabilities for a
    particular secret engine path, and the Vault role binds a specific
    Kubernetes service account to a policy.


    #.  Create a policy.

        .. code-block:: none

            $ vault policy write basic-secret-policy - <<EOF
            path "secret/basic-secret/*" {
              capabilities = ["read"]
            }
            EOF


        For more information, see
        `https://www.vaultproject.io/docs/concepts/policies
        <https://www.vaultproject.io/docs/concepts/policies>`__.

    #.  Create the role mapped to the policy.

        .. note::
            The service account and namespace used for the values below must
            exist on the kubernetes cluster.


            -   **bound\_service\_account\_names**

            -   **bound\_service\_account\_namespaces**


        .. code-block:: none

            $ vault write auth/kubernetes/role/basic-secret-role bound_service_account_names=basic-secret bound_service_account_namespaces=default policies=basic-secret-policy ttl=24h

    #.  Verify the policy.

        .. code-block:: none

            $ vault policy read basic-secret-policy

    #.  Verify the role.

        .. code-block:: none

            $ vault read auth/kubernetes/role/basic-secret-role


#.  Create an initial example secret in the configured **kv-v2** secrets
    engine.


    #.  Create a secret.

        .. code-block:: none

            $ vault kv put secret/basic-secret/helloworld username="test" password="supersecret"

    #.  Verify the secret.

        .. code-block:: none

            $ vault kv get secret/basic-secret/helloworld


#.  \(Optional\) To enable audit logging, use the steps below:

    .. note::
        It is recommended to enable file logging and stdout.


    #.  Enable Vault logging to file for persistent log storage.

        .. code-block:: none

            $ vault audit enable -path="/vault/audit/vault_audit.log" file file_path=/vault/audit/vault_audit.log

    #.  Enable Vault logging to stdout for easy log reading from the Vault container.

        .. code-block:: none

            $ vault audit enable -path="stdout" file file_path=stdout

    #.  Verify the configuration.

        .. code-block:: none

            $ vault audit list


#.  Delete the cached credentials to log out of Vault.

    .. code-block:: none

        $ rm ~/.vault-token

#.  Exit the Vault container.

    .. code-block:: none

        $ exit


..
  .. rubric:: |result|

.. xbooklink

   For more information, see, |usertasks-doc|::ref:`Vault Overview
   <kubernetes-user-tutorials-vault-overview>`.

