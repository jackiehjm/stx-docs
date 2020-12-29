
.. dbg1582122084062
.. _storage-planning-storage-on-worker-hosts:

=======================
Storage on Worker Hosts
=======================

A worker host's root disk provides storage for host configuration files, local
Docker images, and hosted container's ephemeral filesystems.

.. note::
    On |prod| Simplex or Duplex systems, worker storage is provided using
    resources on the combined host. For more information, see
    :ref:`Storage on Controller Hosts
    <storage-planning-storage-on-controller-hosts>`.

.. _storage-planning-storage-on-worker-hosts-d56e38:

-----------------------
Root filesystem storage
-----------------------

Space on the root disk is allocated to provide filesystem storage.

You can increase the allotments for the following filesystems using the Horizon
Web interface or the CLI. Resizing must be done on a host-by-host basis for
non-|DRBD| synced filesystems.

**Docker Storage**
    The storage allotment for the Docker image cache for this host, and for the
    ephemeral filesystems of containers on this host.

**Kubelet Storage**
    The storage allotment for ephemeral storage related to Kubernetes pods on
    this host.

**Scratch Storage**
    The storage allotment for a variety of miscellaneous transient host
    operations.

**Logs Storage**
    The storage allotment for log data. This filesystem is not resizable. Logs
    are rotated within the fixed space as allocated.

.. seealso::

   :ref:`Storage Resources <storage-planning-storage-resources>`

   :ref:`Storage on Controller Hosts
   <storage-planning-storage-on-controller-hosts>`

   :ref:`Storage on Storage Hosts <storage-planning-storage-on-storage-hosts>`
