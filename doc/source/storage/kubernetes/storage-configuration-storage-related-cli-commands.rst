
.. opm1552678478222
.. _storage-configuration-storage-related-cli-commands:

============================
Storage-Related CLI Commands
============================

You can use |CLI| commands when working with storage.

.. contents::
   :local:
   :depth: 1

.. _storage-configuration-storage-related-cli-commands-section-N1001F-N1001C-N10001:

-------------------------------
Modify Ceph Monitor Volume Size
-------------------------------

You can change the space allotted for the Ceph monitor, if required.

.. code-block:: none

    ~(keystone_admin)]$ system ceph-mon-modify <controller> ceph_mon_gib=<size>

where ``<partition\_size>`` is the size in GiB to use for the Ceph monitor.
The value must be between 21 and 40 GiB.

.. code-block:: none

    ~(keystone_admin)]$ system ceph-mon-modify controller-0 ceph_mon_gib=21

    +--------------------------------+-------+--------------+------------+------+
    | uuid                           | ceph_ | hostname     | state      | task |
    |                                | mon_g |              |            |      |
    |                                | ib    |              |            |      |
    +--------------------------------+-------+--------------+------------+------+
    | 069f106-4f4d-8665-681f73d13dfb | 21    | compute-0    | configured | None |
    | 4763139-4f4d-8665-681f73d13dfb | 21    | controller-1 | configured | None |
    | e39970e-4f4d-8665-681f73d13dfb | 21    | controller-0 | configured | None |
    +--------------------------------+-------+--------------+------------+------+

    NOTE: ceph_mon_gib for both controllers are changed.

    System configuration has changed.
    please follow the System Configuration guide to complete configuring system.


The configuration is out of date after running this command. To update it,
you must lock and then unlock the host.


.. _storage-configuration-storage-related-cli-commands-section-N10044-N1001C-N10001:

----------------------------------------
Add, Modify, or Display Storage Backends
----------------------------------------

To list the storage backend types installed on a system:

.. code-block:: none

    ~(keystone_admin)]$ system storage-backend-list

    +-------------------------------+------------+----------+-------+--------------+---------+-----------------+
    | uuid                          | name       | backend  | state | task         | services| capabilities    |
    +-------------------------------+------------+----------+-------+--------------+---------+-----------------+
    | 248a106-4r54-3324-681f73d13dfb| ceph-store | ceph     | config| resize-ceph..| None    |min_replication:1|
    |                               |            |          |       |              |         |replication: 2   |
    | 76dd106-6yth-4356-681f73d13dfb| shared_serv| external | config| None         | glance  |                 |
    |                               | ices       |          |       |              |         |                 |
    +-------------------------------+------------+----------+-------+--------------+---------+-----------------+


To show details for a storage backend:

.. code-block:: none

    ~(keystone_admin)]$ system storage-backend-show <name>


For example:

.. code-block:: none

    ~(keystone_admin)]$ system storage-backend-show ceph-store
    +----------------------+--------------------------------------+
    | Property             | Value                                |
    +----------------------+--------------------------------------+
    | backend              | ceph                                 |
    | name                 | ceph-store                           |
    | state                | configured                           |
    | task                 | provision-storage                    |
    | services             | None                                 |
    | capabilities         | min_replication: 1                   |
    |                      | replication: 2                       |
    | object_gateway       | False                                |
    | ceph_total_space_gib | 0                                    |
    | object_pool_gib      | None                                 |
    | cinder_pool_gib      | None                                 |
    | kube_pool_gib        | None                                 |
    | glance_pool_gib      | None                                 |
    | ephemeral_pool_gib   | None                                 |
    | tier_name            | storage                              |
    | tier_uuid            | 249bb348-f1a0-446c-9dd1-256721f043da |
    | created_at           | 2019-10-07T18:33:19.839445+00:00     |
    | updated_at           | None                                 |
    +----------------------+--------------------------------------+



To add a backend:

.. code-block:: none

    ~(keystone_admin)]$  system storage-backend-add   \
    [-s <services>] [-n <name>] [-t <tier_uuid>] \
    [-c <ceph_conf>] [--confirmed] [--ceph-mon-gib <ceph-mon-gib>] \
    <backend> [<parameter>=<value> [<parameter>=<value> ...]]


The following are positional arguments:

**backend**
    The storage backend to add. This argument is required.

**<parameter>**
    Required backend/service parameters to apply.

The following are optional arguments:

**-s,** ``--services``
    A comma-delimited list of storage services to include.

    For a Ceph backend, this is an optional parameter. Valid values are
    cinder, glance, and swift.

**-n,** ``--name``
    For a Ceph backend, this is a user-assigned name for the backend. The
    default is **ceph-store** for a Ceph backend.

**-t,** ``--tier\_uuid``
    For a Ceph backend, is the UUID of a storage tier to back.

**-c,** ``--ceph\_conf``
    Location of the Ceph configuration file used for provisioning an
    external backend.

``--confirmed``
    Provide acknowledgment that the operation should continue as it is not
    reversible.

``--ceph-mon-gib``
    For a Ceph backend, this is the space in gibibytes allotted for the
    Ceph monitor.

.. note::
    A Ceph backend is configured by default.

To modify a backend:

.. code-block:: none

    ~(keystone_admin)]$  system storage-backend-modify [-s <services>] [-c <ceph_conf>] \
    <backend_name_or_uuid> [<parameter>=<value> [<parameter>=<value> ...]]


To delete a failed backend configuration:

.. code-block:: none

    ~(keystone_admin)]$  system storage-backend-delete <backend>



.. note::
    If a backend installation fails before completion, you can use this
    command to remove the partial installation so that you can try again.
    You cannot delete a successfully installed backend.


.. _storage-configuration-storage-related-cli-commands-section-N10247-N10024-N10001:

-------------------------------------
Add, Modify, or Display Storage Tiers
-------------------------------------

To list storage tiers:

.. code-block:: none

    ~(keystone)admin)]$ system storage-tier-list ceph_cluster

    +--------------------------------+---------+--------+--------------------------------------+
    | uuid                           | name    | status | backend_using                        |
    +--------------------------------+---------+--------+--------------------------------------+
    | acc8706-6yth-4356-681f73d13dfb | storage | in-use | 649830bf-b628-4170-b275-1f0b01cfc859 |
    +--------------------------------+---------+--------+--------------------------------------+

To display information for a storage tier:

.. code-block:: none

    ~(keystone)admin)]$ system storage-tier-show ceph_cluster <tier_name>


For example:

.. code-block:: none

    ~(keystone)admin)]$ system storage-tier-show ceph_cluster <storage>

    +--------------+--------------------------------------+
    | Property     | Value                                |
    +--------------+--------------------------------------+
    | uuid         | 2a50cb4a-659d-4586-a5a2-30a5e01172aa |
    | name         | storage                              |
    | type         | ceph                                 |
    | status       | in-use                               |
    | backend_uuid | 248a90e4-9447-449f-a87a-5195af46d29e |
    | cluster_uuid | 4dda5c01-6ea8-4bab-956c-c95eda4be99c |
    | OSDs         | [0, 1]                               |
    | created_at   | 2019-09-25T16:02:19.901343+00:00     |
    | updated_at   | 2019-09-25T16:04:25.884053+00:00     |
    +--------------+--------------------------------------+


To add a storage tier:

.. code-block:: none

    ~(keystone)admin)]$ system storage-tier-add ceph_cluster <tier_name>


To delete a tier that is not in use by a storage backend and does not have
OSDs assigned to it:

.. code-block:: none

    ~(keystone)admin)]$ system storage-tier-delete <tier_name>



.. _storage-configuration-storage-related-cli-commands-section-N1005E-N1001C-N10001:

-------------------
Display File System
-------------------

You can use the :command:`system controllerfs list` command to list the
storage space allotments on a host.

.. code-block:: none

    ~(keystone_admin)]$ system controllerfs-list

    +--------------------------------+------------+-----+-----------------------+-------+-----------+
    | UUID                           | FS Name    | Size| Logical Volume        | Rep.. | State     |
    |                                |            | in  |                       |       |           |
    |                                |            | GiB |                       |       |           |
    +--------------------------------+------------+-----+-----------------------+-------+-----------+
    | d0e8706-6yth-4356-681f73d13dfb | database   | 10  | pgsql-lv              | True  | available |
    | 40d8706-ssf4-4356-6814356145tf | docker-dist| 16  | dockerdistribution-lv | True  | available |
    | 20e8706-87gf-4356-681f73d13dfb | etcd       | 5   | etcd-lv               | True  | available |
    | 9e58706-sd42-4356-435673d1sd3b | extension  | 1   | extension-lv          | True  | available |
    | 55b8706-sd13-4356-681f73d16yth | platform   | 10  | platform-lv           | True  | available |
    +--------------------------------+------------+-----+-----------------------+-------+-----------+


For a system with dedicated storage:

.. code-block:: none

    ~(keystone_admin)]$  system storage-backend-show ceph-store

    +----------------------+--------------------------------------+
    | Property             | Value                                |
    +----------------------+--------------------------------------+
    | backend              | ceph                                 |
    | name                 | ceph-store                           |
    | state                | configured                           |
    | task                 | resize-ceph-mon-lv                   |
    | services             | None                                 |
    | capabilities         | min_replication: 1                   |
    |                      | replication: 2                       |
    | object_gateway       | False                                |
    | ceph_total_space_gib | 0                                    |
    | object_pool_gib      | None                                 |
    | cinder_pool_gib      | None                                 |
    | kube_pool_gib        | None                                 |
    | glance_pool_gib      | None                                 |
    | ephemeral_pool_gib   | None                                 |
    | tier_name            | storage                              |
    | tier_uuid            | 2a50cb4a-659d-4586-a5a2-30a5e01172aa |
    | created_at           | 2019-09-25T16:04:25.854193+00:00     |
    | updated_at           | 2019-09-26T18:47:56.563783+00:00     |
    +----------------------+--------------------------------------+



