
.. kzy1552678575570
.. _add-a-storage-tier-using-the-cli:

================================
Add a Storage Tier Using the CLI
================================

You can add custom storage tiers for |OSDs| to meet specific container disk
requirements.

.. rubric:: |context|

For more information about storage tiers, see |stor-doc|: :ref:`Storage on
Storage Hosts <storage-hosts-storage-on-storage-hosts>`.

.. rubric:: |prereq|

.. _adding-a-storage-tier-using-the-cli-ul-eyx-pwm-k3b:

-   On an All-in-One Simplex or Duplex system, controller-0 must be
    provisioned and unlocked before you can add a secondary tier.

-   On Standard (2+2) and Standard with Storage (2+2+2) system, both
    controllers must be unlocked and available before secondary tiers can be
    added.


.. rubric:: |proc|

#.  Ensure that the **storage** tier has a full complement of OSDs.

    You cannot add new tiers until the default **storage** tier contains
    the number of OSDs required by the replication factor for the storage
    backend.

    .. code-block:: none

        ~(keystone_admin)]$ system storage-tier-show ceph_cluster storage
        +--------------+--------------------------------------+
        | Property     | Value                                |
        +--------------+--------------------------------------+
        | uuid         | acc8fb74-6dc9-453f-85c8-884f85522639 |
        | name         | storage                              |
        | type         | ceph                                 |
        | status       | in-use                               |
        | backend_uuid | 649830bf-b628-4170-b275-1f0b01cfc859 |
        | cluster_uuid | 364d4f89-bbe1-4797-8e3b-01b745e3a471 |
        | OSDs         | [0, 1]                               |
        | created_at   | 2018-02-15T19:32:28.682391+00:00     |
        | updated_at   | 2018-02-15T20:01:34.557959+00:00     |
        +--------------+--------------------------------------+


#.  List the names of any other existing storage tiers.

    To create a new tier, you must assign a unique name.

    .. code-block:: none

        ~(keystone_admin)]$ system storage-tier-list ceph_cluster
        +---------+---------+--------+--------------------------------------+
        | uuid    | name    | status | backend_using                        |
        +---------+---------+--------+--------------------------------------+
        | acc8... | storage | in-use | 649830bf-b628-4170-b275-1f0b01cfc859 |
        +---------+---------+--------+--------------------------------------+

#.  Use the :command:`system storage-tier-add` command to add a new tier.

    For example, to add a storage tier called **gold**:

    .. code-block:: none

        ~(keystone_admin)]$ system storage-tier-add ceph_cluster gold

        +--------------+--------------------------------------+
        | Property     | Value                                |
        +--------------+--------------------------------------+
        | uuid         | 220f17e2-8564-4f4d-8665-681f73d13dfb |
        | name         | gold                                 |
        | type         | ceph                                 |
        | status       | defined                              |
        | backend_uuid | None                                 |
        | cluster_uuid | 5c48ed22-2a03-4b90-abc4-73757a594494 |
        | OSDs         | [0, 1]                               |
        | created_at   | 2018-02-19T21:36:59.302059+00:00     |
        | updated_at   | None                                 |
        +--------------+--------------------------------------+


#.  Add a storage backend to provide access to the tier.

    .. code-block:: none

        ~(keystone_admin)]$ system storage-backend-add -n <name> -t <tier_uuid> ceph


    For example, to add a storage backend named **gold-store** using the
    new tier:

    .. code-block:: none

        ~(keystone_admin)]$ system storage-backend-add -n gold-store -t 220f17e2-8564-4f4d-8665-681f73d13dfb ceph
        System configuration has changed.
        Please follow the administrator guide to complete configuring the system.

        +-----------+--------------+----------+------------+-----------+----------+--------------------+
        | uuid      | name         | backend  | state      | task      | services | capabilities       |
        +-----------+--------------+----------+------------+-----------+----------+--------------------+
        | 23e396f2- | shared_servi | external | configured | None      | glance   |                    |
        |           | ces          |          |            |           |          |                    |
        |           |              |          |            |           |          |                    |
        | 558e5573- | gold-store   | ceph     | configured | None      | None     | min_replication: 1 |
        |           |              |          |            |           |          | replication:     2 |
        |           |              |          |            |           |          |                    |
        | 5ccdf53a- | ceph-store   | ceph     | configured | provision | None     | min_replication: 1 |
        |           |              |          |            |-storage   |          | replication:     2 |
        |           |              |          |            |           |          |                    |
        |           |              |          |            |           |          |                    |
        +-----------+--------------+----------+------------+-----------+----------+--------------------+

#.  Enable the Cinder service on the new storage backend.

    .. note::
        The Cinder Service is ONLY applicable to the |prod-os| application.

    .. code-block:: none

        ~(keystone_admin)]$ system storage-backend-modify gold-store
        +----------------------+-----------------------------------------+
        | Property             | Value                                   |
        +----------------------+-----------------------------------------+
        | backend              | ceph                                    |
        | name                 | gold-store                              |
        | state                | configuring                             |
        | task                 | {u'controller-1': 'applying-manifests', |
        |                      | u'controller-0': 'applying-manifests'}  |
        | services             | cinder                                  |
        | capabilities         | {u'min_replication': u'1',              |
        |                      | u'replication': u'2'}                   |
        | object_gateway       | False                                   |
        | ceph_total_space_gib | 0                                       |
        | object_pool_gib      | None                                    |
        | cinder_pool_gib      | 0                                       |
        | glance_pool_gib      | None                                    |
        | ephemeral_pool_gib   | None                                    |
        | tier_name            | gold                                    |
        | tier_uuid            | 220f17e2-8564-4f4d-8665-681f73d13dfb    |
        | created_at           | 2018-02-20T19:55:49.912568+00:00        |
        | updated_at           | 2018-02-20T20:14:57.476317+00:00        |
        +----------------------+-----------------------------------------+


    .. note::
        During storage backend configuration, Openstack services may not be
        available for a short period of time. Proceed to the next step once
        the configuration is complete.


.. rubric:: |postreq|

You must assign OSDs to the tier. For more information, see |stor-doc|:
:ref:`Provision Storage on a Storage Host
<provision-storage-on-a-controller-or-storage-host-using-horizon>`.

To delete a tier that is not in use by a storage backend and does not have
OSDs assigned to it, use the command:

.. code-block:: none

    ~(keystone_admin)]$ system storage-tier-delete
    usage: system storage-tier-delete <cluster name or uuid> <storage tier name or uuid>

For example:

.. code-block:: none

    ~(keystone_admin)]$ system storage-tier-delete ceph_cluster 268c967b-207e-4641-bd5a-6c05cc8706ef

To use the tier for a container volume, include the ``--volume-type`` parameter
when creating the Cinder volume, and supply the name of the cinder type.
For example:

.. code-block:: none

    ~(keystone_admin)]$ cinder create --volume-type ceph-gold --name debian-guest 2
    +---------+-----------+-------------+-----------+
    | ID      | Name      | Description | Is_Public |
    +---------+-----------+-------------+-----------+
    | 77b2... | ceph-gold | -           | True      |
    | df25... | ceph      | -           | True      |
    +---------+-----------+-------------+-----------+

