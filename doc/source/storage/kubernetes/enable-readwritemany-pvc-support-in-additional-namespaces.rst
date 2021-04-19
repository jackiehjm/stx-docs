
.. wyf1616954377690
.. _enable-readwritemany-pvc-support-in-additional-namespaces:

=========================================================
Enable ReadWriteMany PVC Support in Additional Namespaces
=========================================================

The default general **cephfs-provisioner** storage class is enabled for the
default, kube-system, and kube-public namespaces. To enable an additional
namespace, for example for an application-specific namespace, a modification
to the configuration \(Helm overrides\) of the **cephfs-provisioner** service
is required.

.. rubric:: |context|

The following example illustrates the configuration of three additional
application-specific namespaces to access the **cephfs-provisioner**
**cephfs** storage class.

.. note::

    Due to limitations with templating and merging of overrides, the entire
    storage class must be redefined in the override when updating specific
    values.

.. rubric:: |proc|

#.  List installed Helm chart overrides for the platform-integ-apps.

    .. code-block:: none

        ~(keystone_admin)]$ system helm-override-list platform-integ-apps
        +--------------------+----------------------+
        | chart name         | overrides namespaces |
        +--------------------+----------------------+
        | ceph-pools-audit   | [u'kube-system']     |
        | cephfs-provisioner | [u'kube-system']     |
        | helm-toolkit       | []                   |
        | rbd-provisioner    | [u'kube-system']     |
        +--------------------+----------------------+

#.  Review existing overrides for the cephfs-provisioner chart. You will refer
    to this information in the following step.

    .. code-block:: none

        ~(keystone_admin)]$ system helm-override-show platform-integ-apps cephfs-provisioner kube-system

        +--------------------+----------------------------------------------------------+
        | Property           | Value                                                    |
        +--------------------+----------------------------------------------------------+
        | attributes         | enabled: true                                            |
        |                    |                                                          |
        | combined_overrides | classdefaults:                                           |
        |                    |   adminId: admin                                         |
        |                    |   adminSecretName: ceph-secret-admin                     |
        |                    |   monitors:                                              |
        |                    |   - 192.168.204.3:6789                                   |
        |                    |   - 192.168.204.1:6789                                   |
        |                    |   - 192.168.204.2:6789                                   |
        |                    | classes:                                                 |
        |                    | - additionalNamespaces:                                  |
        |                    |   - default                                              |
        |                    |   - kube-public                                          |
        |                    |   chunk_size: 64                                         |
        |                    |   claim_root: /pvc-volumes                               |
        |                    |   crush_rule_name: storage_tier_ruleset                  |
        |                    |   data_pool_name: kube-cephfs-data                       |
        |                    |   fs_name: kube-cephfs                                   |
        |                    |   metadata_pool_name: kube-cephfs-metadata               |
        |                    |   name: cephfs                                           |
        |                    |   replication: 2                                         |
        |                    |   userId: ceph-pool-kube-cephfs-data                     |
        |                    |   userSecretName: ceph-pool-kube-cephfs-data             |
        |                    | global:                                                  |
        |                    |   replicas: 2                                            |
        |                    |                                                          |
        | name               | cephfs-provisioner                                       |
        | namespace          | kube-system                                              |
        | system_overrides   | classdefaults:                                           |
        |                    |   adminId: admin                                         |
        |                    |   adminSecretName: ceph-secret-admin                     |
        |                    |   monitors: ['192.168.204.3:6789', '192.168.204.1:6789', |
        |                    | '192.168.204.2:6789']                                    |
        |                    | classes:                                                 |
        |                    | - additionalNamespaces: [default, kube-public]           |
        |                    |   chunk_size: 64                                         |
        |                    |   claim_root: /pvc-volumes                               |
        |                    |   crush_rule_name: storage_tier_ruleset                  |
        |                    |   data_pool_name: kube-cephfs-data                       |
        |                    |   fs_name: kube-cephfs                                   |
        |                    |   metadata_pool_name: kube-cephfs-metadata               |
        |                    |   name: cephfs                                           |
        |                    |   replication: 2                                         |
        |                    |   userId: ceph-pool-kube-cephfs-data                     |
        |                    |   userSecretName: ceph-pool-kube-cephfs-data             |
        |                    | global: {replicas: 2}                                    |
        |                    |                                                          |
        | user_overrides     | None                                                     |
        +--------------------+----------------------------------------------------------+

#.  Create an overrides yaml file defining the new namespaces.

    In this example, create the file /home/sysadmin/update-namespaces.yaml with the following content:

    .. code-block:: none

        ~(keystone_admin)]$ cat <<EOF > ~/update-namespaces.yaml
        classes:
        - additionalNamespaces: [default, kube-public, new-app, new-app2, new-app3]
          chunk_size: 64
          claim_root: /pvc-volumes
          crush_rule_name: storage_tier_ruleset
          data_pool_name: kube-cephfs-data
          fs_name: kube-cephfs
          metadata_pool_name: kube-cephfs-metadata
          name: cephfs
          replication: 2
          userId: ceph-pool-kube-cephfs-data
          userSecretName: ceph-pool-kube-cephfs-data
        EOF

#.  Apply the overrides file to the chart.

    .. code-block:: none

        ~(keystone_admin)]$ system helm-override-update  --values /home/sysadmin/update-namespaces.yaml platform-integ-apps cephfs-provisioner kube-system
        +----------------+----------------------------------------------+
        | Property       | Value                                        |
        +----------------+----------------------------------------------+
        | name           | cephfs-provisioner                           |
        | namespace      | kube-system                                  |
        | user_overrides | classes:                                     |
        |                | - additionalNamespaces:                      |
        |                |   - default                                  |
        |                |   - kube-public                              |
        |                |   - new-app                                  |
        |                |   - new-app2                                 |
        |                |   - new-app3                                 |
        |                |   chunk_size: 64                             |
        |                |   claim_root: /pvc-volumes                   |
        |                |   crush_rule_name: storage_tier_ruleset      |
        |                |   data_pool_name: kube-cephfs-data           |
        |                |   fs_name: kube-cephfs                       |
        |                |   metadata_pool_name: kube-cephfs-metadata   |
        |                |   name: cephfs                               |
        |                |   replication: 2                             |
        |                |   userId: ceph-pool-kube-cephfs-data         |
        |                |   userSecretName: ceph-pool-kube-cephfs-data |
        +----------------+----------------------------------------------+

#.  Confirm that the new overrides have been applied to the chart.

    The following output has been edited for brevity.

    .. code-block:: none

        ~(keystone_admin)]$ system helm-override-show platform-integ-apps cephfs-provisioner kube-system
        +--------------------+---------------------------------------------+
        | Property           | Value                                       |
        +--------------------+---------------------------------------------+
        | user_overrides     | classes:                                    |
        |                    | - additionalNamespaces:                     |
        |                    |   - default                                 |
        |                    |   - kube-public                             |
        |                    |   - new-app                                 |
        |                    |   - new-app2                                |
        |                    |   - new-app3                                |
        |                    |   chunk_size: 64                            |
        |                    |   claim_root: /pvc-volumes                  |
        |                    |   crush_rule_name: storage_tier_ruleset     |
        |                    |   data_pool_name: kube-cephfs-data          |
        |                    |   fs_name: kube-cephfs                      |
        |                    |   metadata_pool_name: kube-cephfs-metadata  |
        |                    |   name: cephfs                              |
        |                    |   replication: 2                            |
        |                    |   userId: ceph-pool-kube-cephfs-data        |
        |                    |   userSecretName: ceph-pool-kube-cephfs-data|
        +--------------------+---------------------------------------------+

#.  Apply the overrides.

    #.  Run the :command:`application-apply` command.

        .. code-block:: none

            ~(keystone_admin)]$ system application-apply platform-integ-apps
            +---------------+----------------------------------+
            | Property      | Value                            |
            +---------------+----------------------------------+
            | active        | True                             |
            | app_version   | 1.0-24                           |
            | created_at    | 2019-05-26T06:22:20.711732+00:00 |
            | manifest_file | manifest.yaml                    |
            | manifest_name | platform-integration-manifest    |
            | name          | platform-integ-apps              |
            | progress      | None                             |
            | status        | applying                         |
            | updated_at    | 2019-05-26T22:27:26.547181+00:00 |
            +---------------+----------------------------------+

    #.  Monitor progress using the :command:`application-list` command.

        .. code-block:: none

            ~(keystone_admin)]$ system application-list
            +-------------+---------+---------------+---------------+---------+-----------+
            | application | version | manifest name | manifest file | status  | progress  |
            +-------------+---------+---------------+---------------+---------+-----------+
            | platform-   | 1.0-24  | platform      | manifest.yaml | applied | completed |
            | integ-apps  |         | -integration  |               |         |           |
            |             |         | -manifest     |               |         |           |
            +-------------+---------+---------------+---------------+---------+-----------+

    You can now create and mount PVCs from the default |RBD| provisioner's
    **general** storage class, from within these application-specific
    namespaces.


