
.. csl1561030322454
.. _enable-rbd-readwriteonly-additional-storage-classes:

===================================================
Enable RBD ReadWriteOnly Additional Storage Classes
===================================================

Additional storage classes can be added to the default |RBD| provisioner
service.

.. rubric:: |context|

Some reasons for adding an additional storage class include:

.. _enable-rbd-readwriteonly-additional-storage-classes-ul-nz1-r3q-43b:

-   managing Ceph resources for particular namespaces in a separate Ceph
    pool; simply for Ceph partitioning reasons

-   using an alternate Ceph Storage Tier, for example. with faster drives

A modification to the configuration (Helm overrides) of the
|RBD| provisioner service is required to enable an additional storage class

The following example that illustrates adding a second storage class to be
utilized by a specific namespace.

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
        | ceph-pools-audit   | ['kube-system']      |
        | cephfs-provisioner | ['kube-system']      |
        | rbd-provisioner    | ['kube-system']      |
        +--------------------+----------------------+

#.  Review existing overrides for the rbd-provisioner chart. You will refer
    to this information in the following step.

    .. code-block:: none

        ~(keystone_admin)$ system helm-override-show platform-integ-apps rbd-provisioner kube-system

#.  Create an overrides yaml file defining the new namespaces.

    In this example we will create the file
    ``/home/sysadmin/update-storageclass.yaml`` with the following content:

    .. code-block:: none

        ~(keystone_admin)]$ cat <<EOF > ~/update-storageclass.yaml
        classes:
        - additionalNamespaces: [default, kube-public, new-app, new-app2, new-app3]
          chunk_size: 64
          crush_rule_name: storage_tier_ruleset
          name: general
          pool_name: kube-rbd
          replication: 1
          userId: ceph-pool-kube-rbd
          userSecretName: ceph-pool-kube-rbd
        - additionalNamespaces: [ new-sc-app ]
          chunk_size: 64
          crush_rule_name: storage_tier_ruleset
          name: special-storage-class
          pool_name: new-sc-app-pool
          replication: 1
          userId: ceph-pool-new-sc-app
          userSecretName: ceph-pool-new-sc-app
        EOF

#.  Apply the overrides file to the chart.

    .. code-block:: none

        ~(keystone_admin)]$ system helm-override-update --values /home/sysadmin/update-storageclass.yaml platform-integ-apps rbd-provisioner kube-system
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
        |                |   replication: 1                        |
        |                |   userId: ceph-pool-kube-rbd            |
        |                |   userSecretName: ceph-pool-kube-rbd    |
        |                | - additionalNamespaces:                 |
        |                |   - new-sc-app                          |
        |                |   chunk_size: 64                        |
        |                |   crush_rule_name: storage_tier_ruleset |
        |                |   name: special-storage-class           |
        |                |   pool_name: new-sc-app-pool            |
        |                |   replication: 1                        |
        |                |   userId: ceph-pool-new-sc-app          |
        |                |   userSecretName: ceph-pool-new-sc-app  |
        +----------------+-----------------------------------------+

#.  Confirm that the new overrides have been applied to the chart.

    The following output has been edited for brevity.

    .. code-block:: none

        ~(keystone_admin)]$ system helm-override-show platform-integ-apps rbd-provisioner kube-system
        +--------------------+------------------------------------------------------+
        | Property           | Value                                                |
        +--------------------+------------------------------------------------------+
        | attributes         | enabled: true                                        |
        |                    |                                                      |
        | combined_overrides | ...                                                  |
        |                    |                                                      |
        | name               |                                                      |
        | namespace          |                                                      |
        | system_overrides   | ...                                                  |
        |                    |                                                      |
        | user_overrides     | classes:                                             |
        |                    | - additionalNamespaces:                              |
        |                    |   - default                                          |
        |                    |   - kube-public                                      |
        |                    |   - new-app                                          |
        |                    |   - new-app2                                         |
        |                    |   - new-app3                                         |
        |                    |   chunk_size: 64                                     |
        |                    |   crush_rule_name: storage_tier_ruleset              |
        |                    |   name: general                                      |
        |                    |   pool_name: kube-rbd                                |
        |                    |   replication: 1                                     |
        |                    |   userId: ceph-pool-kube-rbd                         |
        |                    |   userSecretName: ceph-pool-kube-rbd                 |
        |                    | - additionalNamespaces:                              |
        |                    |   - new-sc-app                                       |
        |                    |   chunk_size: 64                                     |
        |                    |   crush_rule_name: storage_tier_ruleset              |
        |                    |   name: special-storage-class                        |
        |                    |   pool_name: new-sc-app-pool                         |
        |                    |   replication: 1                                     |
        |                    |   userId: ceph-pool-new-sc-app                       |
        |                    |   userSecretName: ceph-pool-new-sc-app               |
        +--------------------+------------------------------------------------------+

#.  Apply the overrides.

    #.  Run the :command:`application-apply` command.

        .. code-block:: none

            ~(keystone_admin)]$ system application-apply platform-integ-apps
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
            | updated_at    | 2022-12-14T04:45:09.204231+00:00     |
            +---------------+--------------------------------------+

    #.  Monitor progress using the :command:`application-list` command.

        .. code-block:: none

            ~(keystone_admin)]$ system application-list
            +--------------------------+---------+-------------------------------------------+------------------+----------+-----------+
            | application              | version | manifest name                             | manifest file    | status   | progress  |
            +--------------------------+---------+-------------------------------------------+------------------+----------+-----------+
            | platform-integ-apps      | 1.0-62  | platform-integ-apps-fluxcd-manifests      | fluxcd-manifests | applied  | completed |
            +--------------------------+---------+-------------------------------------------+------------------+----------+-----------+

    You can now create and mount persistent volumes from the new |RBD|
    provisioner's **special** storage class from within the **new-sc-app**
    application-specific namespace.


