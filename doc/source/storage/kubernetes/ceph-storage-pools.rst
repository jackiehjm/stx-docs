
.. cmn1552678621471
.. _ceph-storage-pools:

==================
Ceph Storage Pools
==================

On a system that uses a Ceph storage backend, kube-rbd pool |PVCs| are
configured on the storage hosts.

|prod| uses four pools for each Ceph backend:

.. _ceph-storage-pools-ul-z5w-xwp-dw:

-   Cinder Volume Storage pool

-   Glance Image Storage pool

-   Nova Ephemeral Disk Storage pool

-   Swift Object Storage pool

.. note::
    To increase the available storage, you can also add storage hosts. The
    maximum number depends on the replication factor for the system; see
    :ref:`Storage on Storage Hosts <storage-hosts-storage-on-storage-hosts>`.

