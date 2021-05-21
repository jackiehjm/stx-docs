
.. cmn1552678621471
.. _ceph-storage-pools:

==================
Ceph Storage Pools
==================

On a system that uses a Ceph storage backend, kube-rbd pool |PVCs| are
configured on the storage hosts.

|prod| uses up to three pools for the Ceph backend:

-   kube-rbd

-   kube-cephfs-data

-   kube-cephfs-metadata