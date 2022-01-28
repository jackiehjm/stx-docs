
.. qcq1552678925205
.. _storage-backends:

================
Storage Backends
================

|prod-long| supports an internal Ceph block storage backend and connecting
to an external NetApp block storage backend. Configuring a storage
backend is optional, but it is required if the applications being hosted
require persistent volume claims \(PVCs\).


.. _storage-backends-section-bgt-gv5-blb:

-------------
Internal Ceph
-------------

|prod| can be configured with an internal Ceph storage backend on |prod|
controller nodes or on dedicated |prod| storage nodes.

You can organize the OSDs in the hosts into *tiers* with different
performance characteristics such as SATA, SAS, SSD and NVME.

The following internal Ceph deployment models are supported:


.. _storage-backends-table-hdq-pv5-blb:


.. table:: Table 1. Internal Ceph Deployment Models
    :widths: auto

    +----------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
    | Name                 | Description                                                                                                                                                                          |
    +======================+======================================================================================================================================================================================+
    | **storage-nodes**    | Applies to the Standard with Dedicated Storage deployment configuration.                                                                                                             |
    |                      |                                                                                                                                                                                      |
    |                      | Storage nodes are deployed in replication groups of 2 or 3, depending on the configured replication factor.                                                                          |
    |                      |                                                                                                                                                                                      |
    |                      | Ceph OSDs are configured only on storage nodes. Ceph monitors are automatically configured on controller-0, controller-1 and storage-0.                                              |
    |                      |                                                                                                                                                                                      |
    |                      | Data replication is done between storage nodes within a replication group.                                                                                                           |
    |                      |                                                                                                                                                                                      |
    |                      | After configuring a storage node, OSDs cannot be added to controllers.                                                                                                               |
    +----------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
    | **controller-nodes** | Applies to the Standard with Controller Storage and the All-in-One Duplex deployment configurations.                                                                                 |
    |                      |                                                                                                                                                                                      |
    |                      | Ceph OSDs are configured on controller nodes. For All-in-One Duplex configurations, a single Ceph monitor is automatically configured that runs on the 'active' controller.          |
    |                      |                                                                                                                                                                                      |
    |                      | For Standard with Controller Storage, Ceph monitors are automatically configured on controller-0 and controller-1, and a third must be manually configured by user on a worker node. |
    |                      |                                                                                                                                                                                      |
    |                      | Data replication is done between controllers.                                                                                                                                        |
    |                      |                                                                                                                                                                                      |
    |                      | After configuring an OSD on a controller, storage nodes cannot be installed.                                                                                                         |
    +----------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
    | **aio-sx**           | Applies to All-in-One Simplex deployment configurations.                                                                                                                             |
    |                      |                                                                                                                                                                                      |
    |                      | Ceph OSDs are configured on controller-0. A single Ceph monitor is automatically configured on controller-0.                                                                         |
    |                      |                                                                                                                                                                                      |
    |                      | Replication is done per OSD, not per node. Configuration updates are applied without requiring a host lock/unlock.                                                                   |
    |                      |                                                                                                                                                                                      |
    |                      | You can set replication to 1, 2 or 3 \(default is 1\).                                                                                                                               |
    |                      |                                                                                                                                                                                      |
    |                      | -   A replication setting of 1 requires a minimum of one OSD.                                                                                                                        |
    |                      |                                                                                                                                                                                      |
    |                      | -   A replication setting of 2 requires a minimum of two OSDs to provide data security.                                                                                              |
    |                      |                                                                                                                                                                                      |
    |                      | -   A replication setting of 3 requires a minimum of three OSDs to provide data security.                                                                                            |
    |                      |                                                                                                                                                                                      |
    |                      |                                                                                                                                                                                      |
    |                      | When replication 2-3 is set, data is replicated between OSDs on the node.                                                                                                            |
    +----------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

For more information on Ceph storage backend provisioning, see
:ref:`Configure the Internal Ceph Storage Backend
<configure-the-internal-ceph-storage-backend>`.


.. _storage-backends-section-N10151-N10028-N10001:

-----------------------
External NetApp Storage
-----------------------

|prod| can be configured to connect to and use an external NetApp storage
deployment as its storage backend.

NetApp Trident supports:


.. _storage-backends-d201e23:

-   AWS Cloud Volumes

-   E and EF-Series SANtricity

-   ONTAP AFF, FAS, Select, and Cloud

-   Element HCI and SolidFire

-   Azure NetApp Files service



.. _storage-backends-d201e56:

For more information about Trident, see
`https://netapp-trident.readthedocs.io
<https://netapp-trident.readthedocs.io>`__.

.. seealso::

    -   :ref:`Configure the Internal Ceph Storage Backend
        <configure-the-internal-ceph-storage-backend>`

    -   :ref:`Configure an External NetApp Deployment as the Storage Backend
        <configure-an-external-netapp-deployment-as-the-storage-backend>`

    -   :ref:`Uninstall the NetApp Trident Software <uninstall-the-netapp-backend>`
