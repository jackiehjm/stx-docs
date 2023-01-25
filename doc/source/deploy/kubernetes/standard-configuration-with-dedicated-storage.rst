
.. gzi1565204095452
.. _standard-configuration-with-dedicated-storage:

=============================================
Standard Configuration with Dedicated Storage
=============================================

Deployment of |prod| with dedicated storage nodes provides the highest capacity
\(single region\), performance, and scalability.

.. image:: /deploy_install_guides/release/figures/starlingx-deployment-options-dedicated-storage.png
   :width: 800

See :ref:`Common Components <common-components>` for a description of common
components of this deployment configuration.

The differentiating physical feature of this model is that the controller,
storage, and worker functionalities are deployed on separate physical hosts
allowing controller nodes, storage nodes, and worker nodes to scale
independently from each other.

The controller nodes provide the control-plane function for the
system. Two controller nodes are required to provide redundancy. The controller
nodes' server and peripheral resources such as CPU cores/speed, memory,
storage, and network interfaces can be scaled to meet requirements.

Storage nodes provide a large scale Ceph cluster for the storage backend for
Kubernetes |PVCs|. They are deployed in replication groups of either two or
three for redundancy. For a system configured to use two storage hosts per
replication group, a maximum of eight storage hosts \(four replication groups\)
are supported. For a system with three storage hosts per replication group, up
to nine storage hosts \(three replication groups\) are supported. The system
provides redundancy and scalability through the number of Ceph |OSDs| installed
in a storage node group, with more |OSDs| providing more capacity and better
storage performance. The scalability and performance of the storage function is
affected by the |OSD| size and speed, optional |SSD| or |NVMe| Ceph journals,
CPU cores and speeds, memory, disk controllers, and networking. |OSDs| can be
grouped into storage tiers according to their performance characteristics.

Alternatively, instead of configuring Storage Nodes, you can configure an
external Netapp Trident storage backend.

.. xreflink    For more information,
    see the :ref:`|stor-doc| <storage-configuration-storage-resources>` guide.

On worker nodes, the primary disk is used for system requirements and for
container local ephemeral storage.
