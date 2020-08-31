
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

.. rubric:: |proc|

#.  Create the user definition.

    For example:

    .. code-block:: none

        % cat <<EOF > joe-admin.yaml
        apiVersion: v1
        kind: ServiceAccount
        metadata:
          name: joe-admin
          namespace: kube-system
        ---
        apiVersion: rbac.authorization.k8s.io/v1
        kind: ClusterRoleBinding
        metadata:
          name: joe-admin
        roleRef:
          apiGroup: rbac.authorization.k8s.io
          kind: ClusterRole
          name: cluster-admin
        subjects:
        - kind: ServiceAccount
          name: joe-admin
          namespace: kube-system
        EOF

#.  Apply the configuration.

    .. code-block:: none

        % kubectl apply -f joe-admin.yaml


..
  .. rubric:: |postreq|

.. xbooklink

    See |sysconf-doc|: :ref:`Configure Remote CLI Access
    <configure-remote-cli-access>` for details on how to setup remote CLI
    access using tools such as :command:`kubectl` and :command:`helm` for a
    service account such as this.

