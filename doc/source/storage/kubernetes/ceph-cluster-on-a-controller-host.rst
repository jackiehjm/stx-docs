
.. gow1564588201550
.. _ceph-cluster-on-a-controller-host:

=================================
Ceph Cluster on a Controller Host
=================================

You can add one or more Ceph disks \(OSD disks\) per controller host
for data storage.

.. rubric:: |context|

See :ref:`Configure Ceph OSDs on a Host <ceph-storage-pools>` for
details on configuring Ceph on a host.

For Standard-with-controller storage and All-in-one Duplex scenarios with
2x controllers, Ceph replication is nodal. For All-in-one Simplex, with a
single controller, replication is across OSDs.

For All-in-one Simplex and Duplex there is a single Ceph monitor; on
Duplex, the Ceph monitor floats between controllers. For
Standard-with-controller storage, there are 3 Ceph monitors; 2
automatically configured on each controller and the third Ceph monitor
configured on one of the worker nodes.

.. rubric:: |prereq|

The worker must be locked.

.. rubric:: |proc|

-   To configure a Ceph monitor on a worker node, execute the following
    command:

    .. code-block:: none

        ~(keystone_admin)$ system ceph-mon-add compute-0

-   To add OSDs on an AIO-SX, AIO-DX and Standard systems, see
    :ref:`Provision Storage on a Controller or Storage Host Using Horizon
    <provision-storage-on-a-controller-or-storage-host-using-horizon>` for
    more information.


