
.. oiz1581955060428
.. _configure-remote-helm-client-for-non-admin-users:

================================================
Configure Remote Helm Client for Non-Admin Users
================================================

For non-admin users \(i.e. users without access to the default Tiller
server running in kube-system namespace\), you must create a Tiller server
for this specific user in a namespace that they have access to.

.. rubric:: |context|

By default, helm communicates with the default Tiller server in the
kube-system namespace. This is not accessible by non-admin users.

For non-admin users use of the helm client, you must create your own Tiller
server, in a namespace that you have access to, with the required |RBAC|
capabilities and optionally |TLS| protection.

To create a Tiller server with |RBAC| permissions within the default
namespace, complete the following steps on the controller: Except where
indicated, these commands can be run by the non-admin user, locally or
remotely.

.. note::
    If you are using container-backed helm CLIs and clients \(method 1\),
    ensure you change directories to <$HOME>/remote\_wd

.. rubric:: |proc|


.. _configure-remote-helm-client-for-non-admin-users-steps-isx-dsd-tkb:

#.  Set the namespace.

    .. code-block:: none

        ~(keystone_admin)$ NAMESPACE=default

#.  Set up accounts, roles and bindings.


    #.  Execute the following commands.

        .. note::
            These commands could be run remotely by the non-admin user who
            has access to the default namespace.

        .. code-block:: none

            % cat <<EOF > default-tiller-sa.yaml
            apiVersion: v1
            kind: ServiceAccount
            metadata:
              name: tiller
              namespace: default
            ---
            apiVersion: rbac.authorization.k8s.io/v1
            kind: Role
            metadata:
              name: tiller
              namespace: default
            rules:
            - apiGroups: ["*"]
              resources: ["*"]
              verbs: ["*"]
            ---
            apiVersion: rbac.authorization.k8s.io/v1
            kind: RoleBinding
            metadata:
              name: tiller
              namespace: default
            roleRef:
              apiGroup: rbac.authorization.k8s.io
              kind: Role
              name: tiller
            subjects:
            - kind: ServiceAccount
              name: tiller
              namespace: default
            EOF
            % kubectl apply -f default-tiller-sa.yaml


    #.  Execute the following commands as an admin-level user.

        .. code-block:: none

            ~(keystone_admin)$ kubectl create clusterrole tiller --verb get
            --resource namespaces
            ~(keystone_admin)$ kubectl create clusterrolebinding tiller
            --clusterrole tiller --serviceaccount ${NAMESPACE}:tiller


#.  Initialize the Helm account.

    .. code-block:: none

        ~(keystone_admin)$ helm init --service-account=tiller
        --tiller-namespace=$NAMESPACE --output yaml | sed 's@apiVersion:
        extensions/v1beta1@apiVersion: apps/v1@' | sed 's@ replicas: 1@
        replicas: 1\n \ selector: {"matchLabels": {"app": "helm", "name":
        "tiller"}}@' > helm-init.yaml
        ~(keystone_admin)$ kubectl apply -f helm-init.yaml
        ~(keystone_admin)$ helm init –client-only

    .. note::
        Ensure that each of the patterns between single quotes in the above
        :command:`sed` commands are on single lines when run from your
        command-line interface.

    .. note::
        Add the following options if you are enabling TLS for this Tiller:

        ``--tiller-tls``
            Enable TLS on Tiller.

        ``--tiller-tls-cert <certificate\_file>``
            The public key/certificate for Tiller \(signed by ``--tls-ca-cert``\).

        ``--tiller-tls-key <key\_file>``
            The private key for Tiller.

        ``--tiller-tls-verify``
            Enable authentication of client certificates \(i.e. validate
            they are signed by ``--tls-ca-cert``\).

        ``--tls-ca-cert <certificate\_file>``
            The public certificate of the |CA| used for signing Tiller
            server and helm client certificates.

.. rubric:: |result|

You can now use the private Tiller server remotely or locally by specifying
the ``--tiller-namespace`` default option on all helm CLI commands. For
example:

.. code-block:: none

    helm version --tiller-namespace default
    helm install --name wordpress stable/wordpress --tiller-namespace default

.. note::
    If you are using container-backed helm CLI and Client \(method 1\), then
    you change directory to <$HOME>/remote\_wd and include the following
    option on all helm commands:

    .. code-block:: none

        —home "./.helm"

.. note::
    Use the remote Windows Active Directory server for authentication of
    remote :command:`kubectl` commands.

.. seealso::

    :ref:`Configure Container-backed Remote CLIs and Clients
    <security-configure-container-backed-remote-clis-and-clients>`

    :ref:`Install Kubectl and Helm Clients Directly on a Host
    <security-install-kubectl-and-helm-clients-directly-on-a-host>`

