
.. ifk1581957631610
.. _configuring-remote-helm-client:

============================
Configure Remote Helm Client
============================

For non-admin users use of the helm client, you must create your own Tiller
server, in a namespace that you have access to, with the required :abbr:`RBAC
(role-based access control)` capabilities and optionally TLS protection.

.. rubric:: |context|

To create a Tiller server with RBAC permissions within the default namespace,
complete the following steps on the controller: Except where indicated, these
commands can be run by the non-admin user, locally or remotely.

.. note::
    If you are using container-backed helm CLIs and clients \(method 1\),
    ensure you change directories to <$HOME>/remote\_cli\_wd.

.. rubric:: |prereq|

.. _configuring-remote-helm-client-ul-jhh-byv-nlb:

-   Your remote **kubectl** access is configured. For more information, see,
    :ref:`Configuring Container-backed Remote CLIs
    <kubernetes-user-tutorials-configuring-container-backed-remote-clis-and-clients>`,
    or :ref:`Installing Kubectl and Helm Clients Directly on a Host
    <kubernetes-user-tutorials-installing-kubectl-and-helm-clients-directly-on-a-host>`.

-   Your |prod| administrator has setup the required RBAC policies for the
    tiller ServiceAccount in your namespace.

.. rubric:: |proc|

.. _configuring-remote-helm-client-steps-isx-dsd-tkb:

#.  Set the namespace.

    .. code-block:: none

        ~(keystone_admin)]$ NAMESPACE=default

#.  Set up your Tiller account, roles, and bindings in your namespace.

    #.  Execute the following commands.

        .. code-block:: none

            % cat <<EOF > default-tiller-sa.yaml
            apiVersion: v1
            kind: ServiceAccount
            metadata:
              name: tiller
              namespace: <namespace>
            ---
            apiVersion: rbac.authorization.k8s.io/v1
            kind: Role
            metadata:
              name: tiller
              namespace: <namespace>
            rules:
            - apiGroups: ["*"]
              resources: ["*"]
              verbs: ["*"]
            ---
            apiVersion: rbac.authorization.k8s.io/v1
            kind: RoleBinding
            metadata:
              name: tiller
              namespace: <namespace>
            roleRef:
              apiGroup: rbac.authorization.k8s.io
              kind: Role
              name: tiller
            subjects:
            - kind: ServiceAccount
              name: tiller
              namespace: <namespace>
            EOF
            % kubectl apply -f default-tiller-sa.yaml

#.  Initialize the Helm account.

    .. code-block:: none

        ~(keystone_admin)]$ helm init --service-account=tiller --tiller-namespace=$NAMESPACE --output yaml | sed 's@apiVersion: extensions/v1beta1@apiVersion: apps/v1@' | sed 's@ replicas: 1@ replicas: 1\n \ selector: {"matchLabels": {"app": "helm", "name": "tiller"}}@' > helm-init.yaml
        ~(keystone_admin)]$ kubectl apply -f helm-init.yaml
        ~(keystone_admin)]$ helm init –client-only

    .. note::
        Ensure that each of the patterns between single quotes in the above
        :command:`sed` commands are on single lines when run from your
        command-line interface.

    .. note::
        Add the following options if you are enabling TLS for this Tiller:

        ``--tiller-tls``
            Enable TLS on Tiller.

        ``--tiller-tls-cert <certificate_file>``
            The public key/certificate for Tiller \(signed by
            ``--tls-ca-cert``\).

        ``--tiller-tls-key <key_file>``
            The private key for Tiller.

        ``--tiller-tls-verify``
            Enable authentication of client certificates \(i.e. validate they
            are signed by ``--tls-ca-cert``\).

        ``--tls-ca-cert <certificate_file>``
            The public certificate of the CA used for signing Tiller server and
            helm client certificates.

.. rubric:: |result|

You can now use the private Tiller server remotely or locally by specifying the
``--tiller-namespace`` default option on all helm CLI commands. For example:

.. code-block:: none

    helm version --tiller-namespace <namespace>
    helm install --name wordpress stable/wordpress --tiller-namespace <namespace>

.. note::
    If you are using container-backed helm CLI and Client \(method 1\), then
    you change directory to <$HOME>/remote\_cli\_wd and include the following option
    on all helm commands:

    .. code-block:: none

        --home "./.helm"

.. seealso::
    :ref:`Configuring Container-backed Remote CLIs
    <kubernetes-user-tutorials-configuring-container-backed-remote-clis-and-clients>`

    :ref:`Using Container-backed Remote CLIs
    <usertask-using-container-backed-remote-clis-and-clients>`

    :ref:`Installing Kubectl and Helm Clients Directly on a Host
    <kubernetes-user-tutorials-installing-kubectl-and-helm-clients-directly-on-a-host>`