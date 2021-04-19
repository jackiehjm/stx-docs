
.. oim1582827207220
.. _configure-the-internal-ceph-storage-backend:

===========================================
Configure the Internal Ceph Storage Backend
===========================================

This section provides steps to configure the internal Ceph storage backend.
Depending on the system type, |prod| can be configured with an internal
Ceph storage backend on controller nodes or on dedicated storage nodes.

.. rubric:: |prereq|

Unlock all controllers before you run the following commands to configure
the internal Ceph storage backend.

.. rubric:: |proc|


.. _configuring-the-internal-ceph-storage-backend-steps-xdm-tmz-vkb:

#.  Run the following command:

    .. code-block:: none

        ~(keystone_admin)$ system storage-backend-add ceph --confirmed

#.  Wait for Ceph storage to be configured. Run the following command to
    check if Ceph storage is configured:

    .. code-block:: none

        ~(keystone_admin)$ system storage-backend-list

#.  On a Standard configuration with Controller Storage, that is, where
    Ceph OSDs are to be configured on the controller nodes, configure the
    third Ceph monitor instance on a worker node, using the following
    command:

    .. code-block:: none

        ~(keystone_admin)$ system ceph-mon-add <worker_node>

    .. note::
        For Standard configuration with dedicated Storage, that is, where
        Ceph OSDs are to be configured on dedicated Storage nodes, the
        third Ceph monitor instance is configured by default on the first
        storage node.

    .. note::
        CephFS support requires Metadata servers \(MDS\) to be deployed. When
        CephFS is configured, an MDS is deployed automatically along with each
        node that has been configured to run a Ceph Monitor.

#.  Configure Ceph OSDs. For more information, see :ref:`Provision
    Storage on a Controller or Storage Host Using Horizon
    <provision-storage-on-a-controller-or-storage-host-using-horizon>`.


