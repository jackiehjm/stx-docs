
.. izv1596552030484
.. _vault-unaware:

=============
Vault Unaware
=============

The Vault Unaware method uses the **Vault Agent Injector** to attach a sidecar
container to a given pod. The sidecar handles all authentication with Vault,
retrieves the specified secrets, and mounts them on a shared filesystem to make
them available to all containers in the pod. The applications running in the
pod can access these secrets as files.

.. rubric:: |prereq|

.. _vault-unaware-ul-y32-svm-4mb:

-   Configure and enable the Kubernetes Auth Method before configuring the
    Vault Unaware method.

.. xreflink For more information, see, |sec-doc|:
    :ref:`Configuring Vault <configuring-vault>`.

-   Ensure a policy and role exists for the Application's service account to
    access the 'secret' path secret engine, and a secret actually exists in
    this secret engine.

.. _vault-unaware-ol-nfj-qlk-qmb:

#.  Set environment variables on controller-0.

    .. code-block:: none

        $ ROOT_TOKEN=$(kubectl exec -n vault sva-vault-manager-0 -- cat /mnt/data/cluster_keys.json | grep -oP --color=never '(?<="root_token":")[^"]*')

        $ SA_CA_CERT=$(kubectl exec -n vault sva-vault-0 -- awk 'NF {sub(/\r/, ""); printf "%s\\n",$0;}' /var/run/secrets/kubernetes.io/serviceaccount/ca.crt)

        $ TOKEN_JWT=$(kubectl exec -n vault sva-vault-0 -- cat /var/run/secrets/kubernetes.io/serviceaccount/token)

        $ KUBERNETES_PORT_443_TCP_ADDR=$(kubectl exec -n vault sva-vault-0 -- sh -c 'echo $KUBERNETES_PORT_443_TCP_ADDR')

        $ echo $(kubectl get secrets -n vault vault-ca -o jsonpath='{.data.tls\.crt}') | base64 --decode > /home/sysadmin/vault_ca.pem

#.  Create the policy.

    .. code-block:: none

        $ curl --cacert /home/sysadmin/vault_ca.pem --header "X-Vault-Token:$ROOT_TOKEN" -H "Content-Type: application/json" --request PUT -d '{"policy":"path \"secret/basic-secret/*\" {capabilities = [\"read\"]}"}' https://sva-vault.vault.svc.cluster.local:8200/v1/sys/policy/basic-secret-policy

#.  Create the role with policy and namespace.

    .. code-block:: none

        $ curl --cacert /home/sysadmin/vault_ca.pem --header "X-Vault-Token:$ROOT_TOKEN" --request POST --data '{ "bound_service_account_names": "basic-secret", "bound_service_account_namespaces": "default",  "policies": "basic-secret-policy",  "max_ttl": "1800000"}' https://sva-vault.vault.svc.cluster.local:8200/v1/auth/kubernetes/role/basic-secret-role

#.  Create the secret.

    .. code-block:: none

        $ curl --cacert /home/sysadmin/vault_ca.pem --header "X-Vault-Token:$ROOT_TOKEN" -H "Content-Type: application/json" -X POST -d '{"username":"pvtest","password":"Li69nux*"}' https://sva-vault.vault.svc.cluster.local:8200/v1/secret/basic-secret/helloworld

#.  Verify the secret.

    .. code-block:: none

        $ curl --cacert /home/sysadmin/vault_ca.pem --header "X-Vault-Token:$ROOT_TOKEN" https://sva-vault.vault.svc.cluster.local:8200/v1/secret/basic-secret/helloworld

.. rubric:: |proc|

#.  Copy the Vault certs to the default namespace.

    .. code-block:: none

        $ kubectl get secret vault-server-tls --namespace=vault --export -o yaml | kubectl apply --namespace=default -f-

#.  Use the following vault-injector.yaml file to create a test namespace, an
    example Vault-Unaware deployment, 'basic-secret', with vault annotations
    for creating the Vault Agent Injector sidecar container:

    .. code-block:: yaml

        cat <<EOF >> vault-injector.yaml
        apiVersion: v1
        kind: Namespace
        metadata:
          name: test
        ---
        apiVersion: apps/v1
        kind: Deployment
        metadata:
          name: basic-secret
          namespace: test
          labels:
            app: basic-secret
        spec:
          selector:
            matchLabels:
              app: basic-secret
          replicas: 1
          template:
            metadata:
              annotations:
                vault.hashicorp.com/agent-inject: "true"
                vault.hashicorp.com/tls-skip-verify: "true"
                vault.hashicorp.com/agent-inject-secret-helloworld: "secret/basic-secret/helloworld"
                vault.hashicorp.com/agent-inject-template-helloworld: |
                  {{- with secret "secret/basic-secret/helloworld" -}}
                  {
                    "username" : "{{ .Data.username }}",
                    "password" : "{{ .Data.password }}"
                  }
                  {{- end }}
                vault.hashicorp.com/role: "basic-secret-role"
              labels:
                app: basic-secret
            spec:
              serviceAccountName: basic-secret
              containers:
              - name: app
                image: jweissig/app:0.0.1
        ---
        apiVersion: v1
        kind: ServiceAccount
        metadata:
          name: basic-secret
          labels:
            app: basic-secret
        EOF

#.  Apply the application and verify the pod is running.

    .. code-block:: none

        $ kubectl create -f helloworld.yaml

#.  Verify secrets are injected into the pod.

    .. code-block:: none

        $ kubectl exec -n pvtest basic-secret-55d6c9bb6f-4whbp -- cat /vault/secrets/helloworld

.. _vault-unaware-ul-jsf-dqm-4mb:

.. seealso::
   `https://www.vaultproject.io/docs/platform/k8s/injector
   <https://www.vaultproject.io/docs/platform/k8s/injector>`__

   `https://learn.hashicorp.com/vault/kubernetes/sidecar
   <https://learn.hashicorp.com/vault/kubernetes/sidecar>`__
