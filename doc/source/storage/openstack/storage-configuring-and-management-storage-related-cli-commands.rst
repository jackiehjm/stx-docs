
.. jem1464901298578
.. _storage-configuring-and-management-storage-related-cli-commands:

============================
Storage-Related CLI Commands
============================

You can use |CLI| commands when working with storage specific to OpenStack.

For more information, see |stor-doc| :ref:`Storage Resources
<storage-configuration-storage-resources>`.

.. _storage-configuring-and-management-storage-related-cli-commands-section-N10044-N1001C-N10001:

.. contents::
   :local:
   :depth: 1

----------------------------------------
Add, Modify, or Display Storage Backends
----------------------------------------

To list the storage backend types installed on a system:

.. code-block:: none

    ~(keystone_admin)$  system storage-backend-list

    +--------+-----------------+----------+------------+------+----------+--------------+
    | uuid   | name            | backend  | state      | task | services | capabilities |
    +--------+-----------------+----------+------------+------+----------+--------------+
    | 27e... | ceph-store      | ceph     | configured | None | None     | min_repli.:1 |
    |        |                 |          |            |      |          | replicati.:1 |
    | 502... | shared_services | external | configured | None | glance   |              |
    +--------+-----------------+----------+------------+------+----------+--------------+



To show details for a storage backend:

.. code-block:: none

    ~(keystone_admin)$  system storage-backend-show <name>


For example:

.. code-block:: none

    ~(keystone_admin)$  system storage-backend-show ceph-store
    +----------------------+--------------------------------------+
    | Property             | Value                                |
    +----------------------+--------------------------------------+
    | backend              | ceph                                 |
    | name                 | ceph-store                           |
    | state                | configured                           |
    | task                 | None                                 |
    | services             | None                                 |
    | capabilities         | min_replication: 1                   |
    |                      | replication: 1                       |
    | object_gateway       | False                                |
    | ceph_total_space_gib | 198                                  |
    | object_pool_gib      | None                                 |
    | cinder_pool_gib      | None                                 |
    | kube_pool_gib        | None                                 |
    | glance_pool_gib      | None                                 |
    | ephemeral_pool_gib   | None                                 |
    | tier_name            | storage                              |
    | tier_uuid            | d3838363-a527-4110-9345-00e299e6a252 |
    | created_at           | 2019-08-12T21:08:50.166006+00:00     |
    | updated_at           | None                                 |
    +----------------------+--------------------------------------+


.. _storage-configuring-and-management-storage-related-cli-commands-section-N10086-N1001C-N10001:

------------------
List Glance Images
------------------

You can use this command to identify the storage backend type for Glance
images. \(The column headers in the following example have been modified
slightly to fit the page.\)

.. code-block:: none

    ~(keystone_admin)$ OS_AUTH_URL=http://keystone.openstack.svc.cluster.local/v3
    ~(keystone_admin)$  openstack image list
    +----+------+-------+--------+-----------+------+--------+------------+-----------+
    | ID | Name | Store | Disk   | Container | Size | Status | Cache Size | Raw Cache |
    |    |      |       | Format | Format    |      |        |            |           |
    +----+------+-------+--------+-----------+------+--------+------------+-----------+
    | .. | img1 | rbd   | raw    | bare      | 1432 | active |            |           |
    | .. | img2 | file  | raw    | bare      | 1432 | active |            |           |
    +----+------+-------+--------+-----------+------+--------+------------+-----------+


.. _storage-configuring-and-management-storage-related-cli-commands-ul-jvc-dnx-jnb:

-   The value **rbd** indicates a Ceph backend.

-   You can use the –long option to show additional information.



.. _storage-configuring-and-management-storage-related-cli-commands-section-N100A1-N1001C-N10001:

-----------------
Show Glance Image
-----------------

You can use this command to obtain information about a Glance image.

.. code-block:: none

    ~(keystone_admin)$ OS_AUTH_URL=http://keystone.openstack.svc.cluster.local/v3
    ~(keystone_admin)$  openstack image-show <<image-id>>
    +------------------+--------------------------------------+
    | Property         | Value                                |
    +------------------+--------------------------------------+
    | checksum         | c11edf9e31b416c46125600ddef1a8e8     |
    | name             | ubuntu-14.014.img                    |
    | store            | rbd                                  |
    | owner            | 05be70a23c81420180c51e9740dc730a     |
    +------------------+--------------------------------------+


The Glance **store** value can be either file or rbd. The rbd value indicates a Ceph backend.

