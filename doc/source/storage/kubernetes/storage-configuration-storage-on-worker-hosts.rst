
.. fap1552671560683
.. _storage-configuration-storage-on-worker-hosts:

=======================
Storage on Worker Hosts
=======================

A worker host's root disk provides storage for host configuration files,
local docker images, and hosted container's ephemeral filesystems.

.. note::

    On |prod| Simplex or Duplex systems, worker storage is provided
    using resources on the combined host. For more information, see
    :ref:`Storage on Controller Hosts
    <controller-hosts-storage-on-controller-hosts>`.


.. _storage-configuration-storage-on-worker-hosts-d18e38:

-----------------------
Root Filesystem Storage
-----------------------

Space on the root disk is allocated to provide filesystem storage.

You can increase the allotments for the following filesystems using the
Horizon Web interface interface or the CLI. Resizing must be done on a
host-by-host basis for non-DRBD synced filesystems.

**Docker Storage**

The storage allotment for the docker image cache for this host, and for
the ephemeral filesystems of containers on this host.

**Kubelet Storage**

The storage allotment for ephemeral storage related to kubernetes pods on this host.

**Scratch Storage**

The storage allotment for a variety of miscellaneous transient host operations.

**Logs Storage**

The storage allotment for log data. This filesystem is not resizable.
Logs are rotated within the fixed space as allocated.

