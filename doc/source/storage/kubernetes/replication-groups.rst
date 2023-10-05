
.. awp1552678699112
.. _replication-groups:

==================
Replication Groups
==================

The storage hosts on Ceph systems are organized into replication groups to
provide redundancy.

Each replication group contains a number of hosts, referred to as peers.
Each peer independently replicates the same data. |prod| supports a minimum
of two peers and a maximum of three peers per replication group. This
replication factor is defined when the Ceph storage backend is added.

For a system with two peers per replication group, up to four replication
groups are supported. For a system with three peers per replication group,
up to three replication groups are supported.

For best performance, |org| recommends a balanced storage capacity, in
which each peer has sufficient resources to meet the operational
requirements of the system.

A replication group is considered healthy when all its peers are available.
When only a minimum number of peers are available (as indicated by the
**min_replication** value reported for the group), the group continues to
provide storage services but without full replication, and a HEALTH_WARN
state is declared. When the number of available peers falls below the
**min_replication** value, the group no longer provides storage services,
and a HEALTH_ERR state is declared. The **min_replication** value is
always one less than the replication factor for the group.

It is not possible to lock more than one peer at a time in a replication
group.

Replication groups are created automatically. When a new storage host is
added and an incomplete replication group exists, the host is added to the
existing group. If all existing replication groups are complete, then a new
incomplete replication group is defined and the host becomes its first
member.

.. note::
    Ceph relies on monitoring to detect when to switch from a primary OSD
    to a replicated OSD. The Ceph parameter :command:`osd heartbeat grace` sets
    the amount of time required to wait before switching OSDs when the
    primary OSD is not responding. |prod| currently uses the default value
    of 20 seconds. This means that a Ceph filesystem may not respond to I/O
    for up to 20 seconds when a storage node or OSD goes out of service.
    For more information, see the Ceph documentation:
    http://docs.ceph.com/docs/master/rados/configuration/mon-osd-interaction.

Replication groups are shown on the Hosts Inventory page in association
with the storage hosts. You can also use the following CLI commands to
obtain information about replication groups:

.. code-block:: none

    ~(keystone_admin)]$ system cluster-list
    +--------------------------------------+--------------+------+----------+------------------+
    | uuid                                 | cluster_uuid | type | name     | deployment_model |
    +--------------------------------------+--------------+------+----------+------------------+
    | 335766eb-8564-4f4d-8665-681f73d13dfb | None         | ceph | ceph_clu | controller-nodes |
    |                                      |              |      | ster     |                  |
    |                                      |              |      |          |                  |
    +--------------------------------------+--------------+------+----------+------------------+


.. code-block:: none

    ~(keystone_admin)]$ system cluster-show 335766eb-968e-44fc-9ca7-907f93c772a1

    +--------------------+----------------------------------------+
    | Property           | Value                                  |
    +--------------------+----------------------------------------+
    | uuid               | 335766eb-968e-44fc-9ca7-907f93c772a1   |
    | cluster_uuid       | None                                   |
    | type               | ceph                                   |
    | name               | ceph_cluster                           |
    | replication_groups | ["group-0:['storage-0', 'storage-1']"] |
    | storage_tiers      | ['storage (in-use)']                   |
    | deployment_model   | controller-nodes                       |
    +--------------------+----------------------------------------+

