
.. cic1603143369680
.. _config-and-management-ceph-placement-group-number-dimensioning-for-storage-cluster:

============================================================
Ceph Placement Group Number Dimensioning for Storage Cluster
============================================================

Ceph pools are created automatically by |prod-long|, |prod-long| applications,
or by |prod-long| supported optional applications. By default, no
pools are created after the Ceph cluster is provisioned \(monitor\(s\) enabled
and |OSDs| defined\) until it is created by an application or the Rados Gateway
\(RADOS GW\) is configured.

The following is a list of pools created by |prod-os|, and Rados Gateway applications.


.. _config-and-management-ceph-placement-group-number-dimensioning-for-storage-cluster-table-gvc-3h5-jnb:


.. table:: Table 1. List of Pools
    :widths: auto

    +----------------------------------+---------------------+---------------------------------------------------------------+----------+----------------------------------------------------------------------------------------+
    | Service/Application              | Pool Name           | Role                                                          | PG Count | Created                                                                                |
    +==================================+=====================+===============================================================+==========+========================================================================================+
    | Platform Integration Application | kube-rbd            | Kubernetes RBD provisioned PVCs                               | 64       | When the platform automatically upload/applies after the Ceph cluster is provisioned   |
    +----------------------------------+---------------------+---------------------------------------------------------------+----------+----------------------------------------------------------------------------------------+
    | Wind River OpenStack             | images              | -   glance image file storage                                 | 256      | When the user applies the application for the first time                               |
    |                                  |                     |                                                               |          |                                                                                        |
    |                                  |                     | -   used for VM boot disk images                              |          |                                                                                        |
    +----------------------------------+---------------------+---------------------------------------------------------------+----------+----------------------------------------------------------------------------------------+
    |                                  | ephemeral           | -   ephemeral object storage                                  | 256      |                                                                                        |
    |                                  |                     |                                                               |          |                                                                                        |
    |                                  |                     | -   used for VM ephemeral disks                               |          |                                                                                        |
    +----------------------------------+---------------------+---------------------------------------------------------------+----------+----------------------------------------------------------------------------------------+
    |                                  | cinder-volumes      | -   persistent block storage                                  | 512      |                                                                                        |
    |                                  |                     |                                                               |          |                                                                                        |
    |                                  |                     | -   used for VM boot disk volumes                             |          |                                                                                        |
    |                                  |                     |                                                               |          |                                                                                        |
    |                                  |                     | -   used as aditional disk volumes for VMs booted from images |          |                                                                                        |
    |                                  |                     |                                                               |          |                                                                                        |
    |                                  |                     | -   snapshots and persistent backups for volumes              |          |                                                                                        |
    +----------------------------------+---------------------+---------------------------------------------------------------+----------+----------------------------------------------------------------------------------------+
    |                                  | cinder.backups      | backup cinder volumes                                         | 256      |                                                                                        |
    +----------------------------------+---------------------+---------------------------------------------------------------+----------+----------------------------------------------------------------------------------------+
    | Rados Gateway                    | rgw.root            | Ceph Object Gateway data                                      | 64       | When the user enables the RADOS GW through the :command:`system service-parameter` CLI |
    +----------------------------------+---------------------+---------------------------------------------------------------+----------+----------------------------------------------------------------------------------------+
    |                                  | default.rgw.control | Ceph Object Gateway control                                   | 64       |                                                                                        |
    +----------------------------------+---------------------+---------------------------------------------------------------+----------+----------------------------------------------------------------------------------------+
    |                                  | default.rgw.meta    | Ceph Object Gateway metadata                                  | 64       |                                                                                        |
    +----------------------------------+---------------------+---------------------------------------------------------------+----------+----------------------------------------------------------------------------------------+
    |                                  | default.rgw.log     | Ceph Object Gateway log                                       | 64       |                                                                                        |
    +----------------------------------+---------------------+---------------------------------------------------------------+----------+----------------------------------------------------------------------------------------+

.. note::
    Considering PG value/|OSD| has to be less than 2048 PGs, the default PG
    values are calculated based on a setup with one storage replication group
    and up to 5 |OSDs| per node.


.. _config-and-management-ceph-placement-group-number-dimensioning-for-storage-cluster-section-vkx-qmt-jnb:

---------------
Recommendations
---------------

For more information on how placement group numbers, \(pg\_num\) can be set
based on how many |OSDs| are in the cluster, see, Ceph PGs per pool calculator:
`https://ceph.com/pgcalc/ <https://ceph.com/pgcalc/>`__.

You must collect the current pool information \(replicated size, number of
|OSDs| in the cluster\), and enter it into the calculator, calculate placement
group numbers \(pg\_num\) required based on pg\_calc algorithm, estimates on
|OSD| growth, and data percentage to balance Ceph as the number of |OSDs|
scales.

When balancing placement groups for each individual pool, consider the following:


.. _config-and-management-ceph-placement-group-number-dimensioning-for-storage-cluster-ul-vmq-g4t-jnb:

-   pgs per osd

-   pgs per pool

-   pools per osd

-   replication

-   the crush map \(Ceph |OSD| tree\)


Running the command, :command:`ceph -s`, displays one of the following
**HEALTH\_WARN** messages:


.. _config-and-management-ceph-placement-group-number-dimensioning-for-storage-cluster-ul-sdd-v4t-jnb:

-   too few pgs per osd

-   too few pgs per pool

-   too many pgs per osd


Each of the health warning messages requires manual adjustment of placement
groups for individual pools:


.. _config-and-management-ceph-placement-group-number-dimensioning-for-storage-cluster-ul-dny-15t-jnb:

-   To list all the pools in the cluster, use the following command,
    :command:`ceph osd lspools`.

-   To list all the pools with their pg\_num values, use the following command,
    :command:`ceph osd dump`.

-   To get only the pg\_num / pgp\_num value, use the following command,
    :command:`ceph osd get <pool-name\>pg\_num`.


**Too few PGs per OSD**
    Occurs when a new disk is added to the cluster. For more information on how
    to add a disk as an |OSD|, see, |stor-doc|: :ref:`Provisioning Storage on a
    Storage Host Using the CLI
    <provision-storage-on-a-storage-host-using-the-cli>`.

To fix this warning, the number of placement groups should be increased, using
the following commands:

.. code-block:: none

    ~(keystone_admin)$ ceph osd pool set <pool-name> pg_num <new_pg_num>

.. code-block:: none

    ~(keystone_admin)$ ceph osd pool set <pool-name> pgp_num <new_pg_num>

.. note::

    Increasing pg\_num of a pool has to be done in increments of 64/|OSD|,
    otherwise, the above commands are rejected. If this happens, decrease the
    pg\_num number, retry and wait for the cluster to be **HEALTH\_OK** before
    proceeding to the the next step. Multiple incremental steps may be required
    to achieve the targeted values.

**Too few PGs per Pool**
    This indicates that the pool has many more objects per PG than average
    \(too few PGs allocated\). This warning is addressed by increasing the
    pg\_num of that pool, using the following commands:

.. code-block:: none

    ~(keystone_admin)$ ceph osd pool set <pool-name> pg_num <new_pg_num>

.. code-block:: none

    ~(keystone_admin)$ ceph osd pool set <pool-name> pgp_num <new_pg_num>

.. note::
    pgp\_num should be equal to pg\_num.

Otherwise, Ceph will issue a warning:

.. code-block:: none

    ~(keystone_admin)$ ceph -s
    cluster:
    id: 92bfd149-37c2-43aa-8651-eec2b3e36c17
    health: HEALTH_WARN
    1 pools have pg_num > pgp_num

**Too many PGs / per OSD**
    This warning indicates that the maximum number of 300 PGs per |OSD| is
    exceeded. The number of PGs cannot be reduced after the pool is created.
    Pools that do not contain any data can safely be deleted and then recreated
    with a lower number of PGs. Where pools already contain data, the only
    solution is to add OSDs to the cluster so that the ratio of PGs per |OSD|
    becomes lower.

.. caution::

    Pools have to be created with the exact same properties.

To get these properties, use :command:`ceph osd dump`, or use the following commands:

.. code-block:: none

    ~(keystone_admin)$ ceph osd pool get cinder-volumes crush_rule
    crush_rule: storage_tier_ruleset

.. code-block:: none

    ~(keystone_admin)$ ceph osd pool get cinder-volumes pg_num
    pg_num: 512

.. code-block:: none

    ~(keystone_admin)$ ceph osd pool get cinder-volumes pgp_num
    pg_num: 512

Before you delete a pool, use the following properties to recreate the pool;
pg\_num, pgp\_num, crush\_rule.

To delete a pool, use the following command:

.. code-block:: none

    ~(keystone_admin)$ ceph osd pool delete <pool-name> <<pool-name>>

To create a pool, use the parameters from ceph osd dump, and run the following command:

.. code-block:: none

    ~(keystone_admin)$ ceph osd pool create {pool-name}{pg-num} {pgp-num} {replicated} <<crush-ruleset-name>>

