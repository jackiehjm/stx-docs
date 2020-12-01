
.. csl1561030322454
.. _enable-additional-storage-classes:

=================================
Enable Additional Storage Classes
=================================

Additional storage classes can be added to the default rbd-provisioner
service.

.. rubric:: |context|

Some reasons for adding an additional storage class include:

.. _enable-additional-storage-classes-ul-nz1-r3q-43b:

-   managing Ceph resources for particular namespaces in a separate Ceph
    pool; simply for Ceph partitioning reasons

-   using an alternate Ceph Storage Tier, for example. with faster drives

A modification to the configuration \(helm overrides\) of the
**rbd-provisioner** service is required to enable an additional storage class

The following example that illustrates adding a second storage class to be
utilized by a specific namespace.

.. note::
    Due to limitations with templating and merging of overrides, the entire
    storage class must be redefined in the override when updating specific
    values.

.. rubric:: |proc|

#.  List installed helm chart overrides for the platform-integ-apps.

    .. code-block:: none

        ~(keystone_admin)$ system helm-override-list platform-integ-apps
        +------------------+----------------------+
        | chart name       | overrides namespaces |
        +------------------+----------------------+
        | ceph-pools-audit | [u'kube-system']     |
        | helm-toolkit     | []                   |
        | rbd-provisioner  | [u'kube-system']     |
        +------------------+----------------------+


#.  Review existing overrides for the rbd-provisioner chart. You will refer
    to this information in the following step.

    .. code-block:: none

        ~(keystone_admin)$ system helm-override-show platform-integ-apps rbd-provisioner kube-system

#.  Create an overrides yaml file defining the new namespaces.

    In this example we will create the file
    /home/sysadmin/update-namespaces.yaml with the following content:

    .. code-block:: none

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

#.  Apply the overrides file to the chart.

    .. code-block:: none

        ~(keystone_admin)$ system helm-override-update  --values /home/sysadmin/update-namespaces.yaml \
         platform-integ-apps rbd-provisioner

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

        ~(keystone_admin)$ system helm-override-show platform-integ-apps rbd-provisioner kube-system

        +--------------------+-----------------------------------------+
        | Property           | Value                                   |
        +--------------------+-----------------------------------------+
        | combined_overrides | ...                                     |
        |                    |                                         |
        | name               |                                         |
        | namespace          |                                         |
        | system_overrides   | ...                                     |
        |                    |                                         |
        |                    |                                         |
        | user_overrides     | classes:                                |
        |                    | - additionalNamespaces:                 |
        |                    |   - default                             |
        |                    |   - kube-public                         |
        |                    |   - new-app                             |
        |                    |   - new-app2                            |
        |                    |   - new-app3                            |
        |                    |   chunk_size: 64                        |
        |                    |   crush_rule_name: storage_tier_ruleset |
        |                    |   name: general                         |
        |                    |   pool_name: kube-rbd                   |
        |                    |   replication: 1                        |
        |                    |   userId: ceph-pool-kube-rbd            |
        |                    |   userSecretName: ceph-pool-kube-rbd    |
        |                    | - additionalNamespaces:                 |
        |                    |   - new-sc-app                          |
        |                    |   chunk_size: 64                        |
        |                    |   crush_rule_name: storage_tier_ruleset |
        |                    |   name: special-storage-class           |
        |                    |   pool_name: new-sc-app-pool            |
        |                    |   replication: 1                        |
        |                    |   userId: ceph-pool-new-sc-app          |
        |                    |   userSecretName: ceph-pool-new-sc-app  |
        +--------------------+-----------------------------------------+

#.  Apply the overrides.


    #.  Run the :command:`application-apply` command.

        .. code-block:: none

            ~(keystone_admin)$ system application-apply platform-integ-apps

            +---------------+----------------------------------+
            | Property      | Value                            |
            +---------------+----------------------------------+
            | active        | True                             |
            | app_version   | 1.0-5                            |
            | created_at    | 2019-05-26T06:22:20.711732+00:00 |
            | manifest_file | manifest.yaml                    |
            | manifest_name | platform-integration-manifest    |
            | name          | platform-integ-apps              |
            | progress      | None                             |
            | status        | applying                         |
            | updated_at    | 2019-05-26T22:50:54.168114+00:00 |
            +---------------+----------------------------------+

    #.  Monitor progress using the :command:`application-list` command.

        .. code-block:: none

            ~(keystone_admin)$ system application-list

            +-------------+---------+---------------+---------------+---------+-----------+
            | application | version | manifest name | manifest file | status  | progress  |
            +-------------+---------+---------------+---------------+---------+-----------+
            | platform-   | 1.0-8   | platform-     | manifest.yaml | applied | completed |
            | integ-apps  |         | integration-  |               |         |           |
            |             |         | manifest      |               |         |           |
            +-------------+---------+------ --------+---------------+---------+-----------+


    You can now create and mount persistent volumes from the new
    rbd-provisioner's **special** storage class from within the
    **new-sc-app** application-specific namespace.


