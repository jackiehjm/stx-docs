
.. vqw1561030204071
.. _enable-readwriteonce-pvc-support-in-additional-namespaces:

=========================================================
Enable ReadWriteOnce PVC Support in Additional Namespaces
=========================================================

The default general **rbd-provisioner** storage class is enabled for the
default, kube-system, and kube-public namespaces. To enable an additional
namespace, for example for an application-specific namespace, a
modification to the configuration \(helm overrides\) of the
|RBD| provisioner service is required.

.. rubric:: |context|

The following example illustrates the configuration of three additional
application-specific namespaces to access the |RBD| provisioner's **general storage class**.

.. note::
    Due to limitations with templating and merging of overrides, the entire
    storage class must be redefined in the override when updating specific
    values.

.. rubric:: |proc|

#.  List installed helm chart overrides for the platform-integ-apps.

    .. code-block:: none

        ~(keystone_admin)$ system helm-override-list platform-integ-apps
        +--------------------+----------------------+
        | chart name         | overrides namespaces |
        +--------------------+----------------------+
        | ceph-pools-audit   | ['kube-system']      |
        | cephfs-provisioner | ['kube-system']      |
        | rbd-provisioner    | ['kube-system']      |
        +--------------------+----------------------+

#.  Review existing overrides for the rbd-provisioner chart. You will refer
    to this information in the following step.

    .. code-block:: none

        ~(keystone_admin)$ system helm-override-show platform-integ-apps rbd-provisioner kube-system
        +--------------------+------------------------------------------------------+
        | Property           | Value                                                |
        +--------------------+------------------------------------------------------+
        | attributes         | enabled: true                                        |
        |                    |                                                      |
        | combined_overrides | classdefaults:                                       |
        |                    |   adminId: admin                                     |
        |                    |   adminSecretName: ceph-admin                        |
        |                    |   monitors:                                          |
        |                    |   - 192.168.204.2:6789                               |
        |                    |   storageClass: general                              |
        |                    | classes:                                             |
        |                    | - additionalNamespaces:                              |
        |                    |   - default                                          |
        |                    |   - kube-public                                      |
        |                    |   chunk_size: 64                                     |
        |                    |   clusterID: 6d273112-f2a6-4aec-8727-76b690274c60    |
        |                    |   controllerExpandSecret: ceph-pool-kube-rbd         |
        |                    |   crush_rule_name: storage_tier_ruleset              |
        |                    |   name: general                                      |
        |                    |   nodeStageSecret: ceph-pool-kube-rbd                |
        |                    |   pool_name: kube-rbd                                |
        |                    |   provisionerSecret: ceph-pool-kube-rbd              |
        |                    |   replication: 1                                     |
        |                    |   userId: ceph-pool-kube-rbd                         |
        |                    |   userSecretName: ceph-pool-kube-rbd                 |
        |                    | csiConfig:                                           |
        |                    | - clusterID: 6d273112-f2a6-4aec-8727-76b690274c60    |
        |                    |   monitors:                                          |
        |                    |   - 192.168.204.2:6789                               |
        |                    | provisioner:                                         |
        |                    |   replicaCount: 1                                    |
        |                    |                                                      |
        | name               | rbd-provisioner                                      |
        | namespace          | kube-system                                          |
        | system_overrides   | classdefaults:                                       |
        |                    |   adminId: admin                                     |
        |                    |   adminSecretName: ceph-admin                        |
        |                    |   monitors: ['192.168.204.2:6789']                   |
        |                    |   storageClass: general                              |
        |                    | classes:                                             |
        |                    | - additionalNamespaces: [default, kube-public]       |
        |                    |   chunk_size: 64                                     |
        |                    |   clusterID: !!binary |                              |
        |                    |     NmQyNzMxMTItZjJhNi00YWVjLTg3MjctNzZiNjkwMjc0YzYw |
        |                    |   controllerExpandSecret: ceph-pool-kube-rbd         |
        |                    |   crush_rule_name: storage_tier_ruleset              |
        |                    |   name: general                                      |
        |                    |   nodeStageSecret: ceph-pool-kube-rbd                |
        |                    |   pool_name: kube-rbd                                |
        |                    |   provisionerSecret: ceph-pool-kube-rbd              |
        |                    |   replication: 1                                     |
        |                    |   userId: ceph-pool-kube-rbd                         |
        |                    |   userSecretName: ceph-pool-kube-rbd                 |
        |                    | csiConfig:                                           |
        |                    | - clusterID: !!binary |                              |
        |                    |     NmQyNzMxMTItZjJhNi00YWVjLTg3MjctNzZiNjkwMjc0YzYw |
        |                    |   monitors: ['192.168.204.2:6789']                   |
        |                    | provisioner: {replicaCount: 1}                       |
        |                    |                                                      |
        | user_overrides     | None                                                 |
        +--------------------+------------------------------------------------------+


#.  Create an overrides yaml file defining the new namespaces. In this example
    we will create the file ``/home/sysadmin/update-namespaces.yaml`` with the
    following content:

    .. code-block:: none

		~(keystone_admin)]$ cat <<EOF > ~/update-namespaces.yaml
        classes:
		- additionalNamespaces: [default, kube-public, new-app, new-app2, new-app3]
		  chunk_size: 64
		  crush_rule_name: storage_tier_ruleset
		  name: general
		  pool_name: kube-rbd
		  replication: 2
		  userId: ceph-pool-kube-rbd
		  userSecretName: ceph-pool-kube-rbd
		EOF

#.  Apply the overrides file to the chart.

    .. code-block:: none

        ~(keystone_admin)$ system helm-override-update  --values /home/sysadmin/update-namespaces.yaml platform-integ-apps rbd-provisioner kube-system
        +----------------+-----------------------------------------+
        | Property       | Value                                   |
        +----------------+-----------------------------------------+
        | name           | rbd-provisioner                         |
        | namespace      | kube-system                             |
        | user_overrides | classes:                                |
        |                | - additionalNamespaces:                 |
        |                |   - default                             |
        |                |   - kube-public                         |
        |                |   - new-app                             |
        |                |   - new-app2                            |
        |                |   - new-app3                            |
        |                |   chunk_size: 64                        |
        |                |   crush_rule_name: storage_tier_ruleset |
        |                |   name: general                         |
        |                |   pool_name: kube-rbd                   |
        |                |   replication: 2                        |
        |                |   userId: ceph-pool-kube-rbd            |
        |                |   userSecretName: ceph-pool-kube-rbd    |
        +----------------+-----------------------------------------+

#.  Confirm that the new overrides have been applied to the chart.

    The following output has been edited for brevity.

    .. code-block:: none

        ~(keystone_admin)$ system helm-override-show platform-integ-apps rbd-provisioner kube-system
        +---------------------+--------------------------------------+
        | Property           | Value                                  |
        +--------------------+------------------------------------- --+
        | combined_overrides | ...                                    |
        |                    |                                        |
        | name               |                                        |
        | namespace          |                                        |
        | system_overrides   | ...                                    |
        |                    |                                        |
        |                    |                                        |
        | user_overrides     | classes:                               |
        |                    | - additionalNamespaces:                |
        |                    |   - default                            |
        |                    |   - kube-public                        |
        |                    |   - new-app                            |
        |                    |   - new-app2                           |
        |                    |   - new-app3                           |
        |                    |   chunk_size: 64                       |
        |                    |   crush_rule_name: storage_tier_ruleset|
        |                    |   name: general                        |
        |                    |   pool_name: kube-rbd                  |
        |                    |   replication: 2                       |
        |                    |   userId: ceph-pool-kube-rbd           |
        |                    |   userSecretName: ceph-pool-kube-rbd   |
        +--------------------+----------------------------------------+

#.  Apply the overrides.

    #.  Run the :command:`application-apply` command.

        .. code-block:: none

            ~(keystone_admin)$ system application-apply platform-integ-apps
            +---------------+--------------------------------------+
            | Property      | Value                                |
            +---------------+--------------------------------------+
            | active        | True                                 |
            | app_version   | 1.0-62                               |
            | created_at    | 2022-12-14T04:14:08.878186+00:00     |
            | manifest_file | fluxcd-manifests                     |
            | manifest_name | platform-integ-apps-fluxcd-manifests |
            | name          | platform-integ-apps                  |
            | progress      | None                                 |
            | status        | applying                             |
            | updated_at    | 2022-12-14T04:16:33.197301+00:00     |
            +---------------+--------------------------------------+


    #.  Monitor progress using the :command:`application-list` command.

        .. code-block:: none

            ~(keystone_admin)$ system application-list
            +--------------------------+---------+-------------------------------------------+------------------+----------+-----------+
            | application              | version | manifest name                             | manifest file    | status   | progress  |
            +--------------------------+---------+-------------------------------------------+------------------+----------+-----------+
            | platform-integ-apps      | 1.0-62  | platform-integ-apps-fluxcd-manifests      | fluxcd-manifests | applied  | completed |
            +--------------------------+---------+-------------------------------------------+------------------+----------+-----------+

    You can now create and mount PVCs from the default |RBD| provisioner's
    **general storage class**, from within these application-specific namespaces.

#.  Apply the secret to the new rbd-provisioner namespace.

    Check if the secret has been created in the new namespace by running the
    following command:

    .. code-block:: none

        ~(keystone_admin)$ kubectl get secret ceph-pool-kube-rbd -n <namespace>

    If the secret has not been created in the new namespace, create it by
    running the following command:

    .. code-block:: none

        ~(keystone_admin)$ kubectl get secret ceph-pool-kube-rbd -n default -o yaml | grep -v '^\s*namespace:\s' | kubectl apply -n <namespace> -f -
