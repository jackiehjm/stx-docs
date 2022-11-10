
.. vbz1578928340182
.. _private-namespace-and-restricted-rbac:

=====================================
Private Namespace and Restricted RBAC
=====================================

A non-admin type user typically does **not** have permissions for any
cluster-scoped resources and only has read and/or write permissions to
resources in one or more namespaces.

.. rubric:: |context|

.. note::
    All of the |RBAC| resources for managing non-admin type users, although
    they may apply to private namespaces, are created in **kube-system**
    such that only admin level users can manager non-admin type users,
    roles, and rolebindings.

The following example creates a non-admin service account called dave-user
with read/write type access to a single private namespace
\(**billing-dept-ns**\).

.. note::
    The following example creates and uses ServiceAccounts as the user
    mechanism and subject for the rolebindings, however the procedure
    equally applies to user accounts defined in an external Windows Active
    Directory as the subject of the rolebindings.

.. rubric:: |proc|

#.  If it does not already exist, create a general user role defining
    restricted permissions for general users.

    This is of the type **ClusterRole** so that it can be used in the
    context of any namespace when binding to a user.


    #.  Create the user role definition file.

        .. code-block:: none

            % cat <<EOF > general-user-clusterrole.yaml
            apiVersion: rbac.authorization.k8s.io/v1
            kind: ClusterRole
            metadata:
              # "namespace" omitted since ClusterRoles are not namespaced
              name: general-user

            rules:

            # For the core API group (""), allow full access to all resource types
            # EXCEPT for resource policies (limitranges and resourcequotas) only allow read access
            - apiGroups: [""]
              resources: ["bindings", "configmaps", "endpoints", "events", "persistentvolumeclaims", "pods", "podtemplates", "replicationcontrollers", "secrets", "serviceaccounts", "services"]
              verbs: ["get", "list", "watch", "create", "update", "patch", "delete"]
            - apiGroups: [""]
              resources: [ "limitranges", "resourcequotas" ]
              verbs: ["get", "list"]

            # Allow full access to all resource types of the following explicit list of apiGroups.
            # Notable exceptions here are:
            #     ApiGroup                      ResourceTypes
            #     -------                       -------------
            #     policy                        podsecuritypolicies, poddisruptionbudgets
            #     networking.k8s.io             networkpolicies
            #     admissionregistration.k8s.io  mutatingwebhookconfigurations, validatingwebhookconfigurations
            #
            - apiGroups: ["apps", "batch", "extensions", "autoscaling", "apiextensions.k8s.io", "rbac.authorization.k8s.io"]
              resources: ["*"]
              verbs: ["get", "list", "watch", "create", "update", "patch", "delete"]

            # Cert Manager API access
            - apiGroups: ["cert-manager.io", "acme.cert-manager.io"]
              resources: ["*"]
              verbs: ["get", "list", "watch", "create", "update", "patch", "delete"]

            EOF

    #.  Apply the definition.

        .. code-block:: none

            ~(keystone_admin)$ kubectl apply -f general-user-cluster-role.yaml


#.  Create the **billing-dept-ns** namespace, if it does not already exist.

    .. code-block:: none

        ~(keystone_admin)$ kubectl create namespace billing-dept-ns

#.  Create both the **dave-user** service account and the namespace-scoped
    RoleBinding.

    The RoleBinding binds the **general-user** role to the **dave-user**
    ServiceAccount for the **billing-dept-ns** namespace.


    #.  Create the account definition file.

        .. code-block:: none

            % cat <<EOF > dave-user.yaml
            apiVersion: v1
            kind: ServiceAccount
            metadata:
              name: dave-user
              namespace: kube-system
            ---
            apiVersion: rbac.authorization.k8s.io/v1
            kind: RoleBinding
            metadata:
              name: dave-user
              namespace: billing-dept-ns
            roleRef:
              apiGroup: rbac.authorization.k8s.io
              kind: ClusterRole
              name: general-user
            subjects:
            - kind: ServiceAccount
              name: dave-user
              namespace: kube-system
            EOF

    #.  Apply the definition.

        .. code-block:: none

            % kubectl apply -f dave-user.yaml


#.  If the user requires use of the local docker registry, create an
    openstack user account for authenticating with the local docker registry.


    #.  If a project does not already exist for this user, create one.

        .. code-block:: none

            % openstack project create billing-dept-ns

    #.  Create an openstack user in this project.

        .. code-block:: none

            % openstack user create --password P@ssw0rd \
            --project billing-dept-ns dave-user

        .. note::
            Substitute a password conforming to your password formatting
            rules for P@ssw0rd.

    #.  Create a secret containing these userid/password credentials for use
        as an ImagePullSecret

        .. code-block:: none

            % kubectl create secret docker-registry registry-local-dave-user --docker-server=registry.local:9001 --docker-username=dave-user  --docker-password=P@ssw0rd --docker-email=noreply@windriver.com -n billing-dept-ns


    dave-user can now push images to registry.local:9001/dave-user/ and use
    these images for pods by adding the secret above as an ImagePullSecret
    in the pod spec.

#.  If the user requires the ability to create persistentVolumeClaims in his
    namespace, then execute the following commands to enable the rbd-provisioner
    in the user's namespace.


    #.  Create an RBD namespaces configuration file.

        .. code-block:: none

            % cat <<EOF > rbd-namespaces.yaml
            classes:
            - additionalNamespaces: [default, kube-public, billing-dept-ns]
              chunk_size: 64
              crush_rule_name: storage_tier_ruleset
              name: general
              pool_name: kube-rbdkube-system
              replication: 1
              userId: ceph-pool-kube-rbd
              userSecretName: ceph-pool-kube-rbd
            EOF

    #.  Update the helm overrides.

        .. code-block:: none

            ~(keystone_admin)$ system helm-override-update --reuse-values --values rbd-namespaces.yaml \
            platform-integ-apps rbd-provisioner kube-system

    #.  Apply the application.

        .. code-block:: none

            ~(keystone_admin)$ system application-apply platform-integ-apps

    #.  Monitor the system for the application-apply to finish

        .. code-block:: none

            ~(keystone_admin)$ system application-list


#.  If this user requires the ability to use helm, do the following.


    #.  Create a ClusterRole for reading namespaces, if one does not already exist.

        .. code-block:: none

            % cat <<EOF > namespace-reader-clusterrole.yaml
            apiVersion: rbac.authorization.k8s.io/v1
            kind: ClusterRole
            metadata:
              name: namespace-reader
            rules:
            - apiGroups: [""]
              resources: ["namespaces"]
              verbs: ["get", "watch", "list"]
            EOF

        Apply the configuration.

        .. code-block:: none

            % kubectl apply -f namespace-reader-clusterrole.yaml

    #.  Create a RoleBinding for the tiller account of the user's namespace.

        .. note::

            .. xbooklink

            The tiller account of the user's namespace **must** be named
            'tiller'. See |sysconf-doc|: :ref:`Configure Remote Helm Client
            for Non-Admin Users
            <configure-remote-helm-client-for-non-admin-users>`.

        .. code-block:: none

            % cat <<EOF > read-namespaces-billing-dept-ns-tiller.yaml
            apiVersion: rbac.authorization.k8s.io/v1
            kind: ClusterRoleBinding
            metadata:
              name: read-namespaces-billing-dept-ns-tiller
            subjects:
            - kind: ServiceAccount
              name: tiller
              namespace: billing-dept-ns
            roleRef:
              kind: ClusterRole
              name: namespace-reader
              apiGroup: rbac.authorization.k8s.io
            EOF

        Apply the configuration.

        .. code-block:: none

            % kubectl apply -f read-namespaces-billing-dept-ns-tiller.yaml



..
  .. rubric:: |postreq|

.. xbooklink

   See |sysconf-doc|: :ref:`Configure Remote CLI Access
    <configure-remote-cli-access>` for details on how to setup remote CLI
    access using tools such as :command:`kubectl` and :command:`helm` for a
    service account such as this.

