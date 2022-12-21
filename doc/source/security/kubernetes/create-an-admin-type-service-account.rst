
.. ily1578927061566
.. _create-an-admin-type-service-account:

====================================
Create an Admin Type Service Account
====================================

An admin type user typically has full permissions to cluster-scoped
resources as well as full permissions to all resources scoped to any
namespaces.

.. rubric:: |context|

A cluster-admin ClusterRole is defined by default for such a user. To create
an admin service account with cluster-admin role, use the following procedure:

.. note::
  It is recommended that you create and manage service accounts within the
  kube-system namespace.

.. rubric:: |proc|

#.  Create the user definition.

    For example:

    .. code-block:: none

        % cat <<EOF > admin-user.yaml
        apiVersion: v1
        kind: ServiceAccount
        metadata:
          name: admin-user
          namespace: kube-system
        ---
        apiVersion: v1
        kind: Secret
        type: kubernetes.io/service-account-token
        metadata:
          name: admin-user-sa-token
          namespace: kube-system
          annotations:
            kubernetes.io/service-account.name: admin-user
        ---
        apiVersion: rbac.authorization.k8s.io/v1
        kind: ClusterRoleBinding
        metadata:
          name: admin-user
        roleRef:
          apiGroup: rbac.authorization.k8s.io
          kind: ClusterRole
          name: cluster-admin
        subjects:
        - kind: ServiceAccount
          name: admin-user
          namespace: kube-system
        EOF

#.  Apply the configuration.

    .. code-block:: none

        % kubectl apply -f admin-user.yaml


..
  .. rubric:: |postreq|

.. xbooklink

    See |sysconf-doc|: :ref:`Configure Remote CLI Access
    <configure-remote-cli-access>` for details on how to setup remote CLI
    access using tools such as :command:`kubectl` and :command:`helm` for a
    service account such as this.

.. note::
    |prod| can also use user accounts defined in an external Windows Active
    Directory to authenticate Kubernetes API, :command:`kubectl` CLI or the
    Kubernetes Dashboard. For more information, see :ref:`Configure OIDC
    Auth Applications <configure-oidc-auth-applications>`.
