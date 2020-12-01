
.. uma1552671621577
.. _storage-hosts-storage-on-storage-hosts:

========================
Storage on Storage Hosts
========================

Storage hosts provide a large-scale, persistent, and highly available Ceph
cluster for backing Persistent Volume Claims.

The storage hosts can only be provisioned in a Standard with dedicated
storage deployment and comprise the storage cluster for the system. Within
the storage cluster, the storage hosts are deployed in replication groups
for redundancy. On dedicated storage setups Ceph storage backend is enabled
automatically, and the replication factor is updated later, depending on
the number of storage hosts provisioned.


.. _storage-hosts-storage-on-storage-hosts-section-N1003F-N1002B-N10001:

----------------------
OSD Replication Factor
----------------------


.. _storage-hosts-storage-on-storage-hosts-d61e23:


.. table::
    :widths: auto

    +--------------------+-----------------------------+--------------------------------------+
    | Replication Factor | Hosts per Replication Group | Maximum Replication Groups Supported |
    +====================+=============================+======================================+
    | 2                  | 2                           | 4                                    |
    +--------------------+-----------------------------+--------------------------------------+
    | 3                  | 3                           | 3                                    |
    +--------------------+-----------------------------+--------------------------------------+

You can add up to 16 object storage devices \(OSDs\) per storage host for
data storage.

Space on the storage hosts must be configured at installation before you
can unlock the hosts. You can change the configuration after installation
by adding resources to existing storage hosts or adding more storage hosts.
For more information, see the `StarlingX Installation and Deployment Guide
<https://docs.starlingx.io/deploy_install_guides/index.html>`__.

Storage hosts can achieve faster data access using SSD-backed transaction
journals \(journal functions\). NVMe-compatible SSDs are supported.

.. seealso::

    -   :ref:`Provision Storage on a Controller or Storage Host Using
        Horizon
        <provision-storage-on-a-controller-or-storage-host-using-horizon>`

    -   :ref:`Ceph Storage Pools <ceph-storage-pools>`

    -   :ref:`Change Hardware Components for a Storage Host
        <changing-hardware-components-for-a-storage-host>`
