
.. rde1565203741901
.. _deployment-and-configuration-options-standard-configuration-with-controller-storage:

==============================================
Standard Configuration with Controller Storage
==============================================

|prod| supports a small-scale deployment option using a small Ceph cluster as a
back-end for Kubernetes |PVCs| deployed on the
controller nodes instead of using dedicated storage nodes.

.. image:: /shared/figures/deploy_install_guides/starlingx-deployment-options-controller-storage.png
   :width: 800

See :ref:`Common Components <common-components>` for a description of common
components of this deployment configuration.

This deployment configuration consists of a two node HA controller+storage
cluster managing up to 200 worker nodes. The limit on the size of the worker
node pool is due to the performance and latency characteristics of the small
integrated Ceph cluster on the controller+storage nodes.

This configuration optionally uses dedicated physical disks configured on each
controller+storage node as Ceph |OSDs|. The typical solution requires one
primary disk used by the platform for system purposes and subsequent disks
are used for Ceph |OSDs|.

Optionally, instead of using an internal Ceph cluster across controllers, you
can configure an external Netapp Trident storage backend.

On worker nodes, the primary disk is used for system requirements and for
container local ephemeral storage.

HA controller services run across the two controller+storage nodes in either
Active/Active or Active/Standby mode. The two node Ceph cluster on the
controller+storage nodes provides HA storage through |OSD| replication between
the two nodes.

In the event of an overall controller+storage node failure, all controller HA
services become active on the remaining healthy controller+storage node, and
the above mentioned nodal Ceph replication protects the Kubernetes |PVCs|.

On overall worker node failure, hosted application containers on the failed
worker node are recovered on the remaining healthy worker nodes.
