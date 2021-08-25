
.. vpi1552679480629
.. _view-storage-utilization-using-horizon:

======================================
View Storage Utilization Using Horizon
======================================

You can view storage utilization in the Horizon Web interface.

.. rubric:: |context|

The storage utilization shows the free, used and total capacity for the
system, as well as storage I/O throughput.

For more information on per-host storage, see |node-doc|: :ref:`Storage Tab
<storage-tab>`.

.. rubric:: |proc|

#.  Navigate to **Admin** \> **Platform** \> **Storage Overview** in Horizon.

    In the following example screen, two controllers on an AIO-Duplex
    system are configured with storage with Ceph OSDs **osd.0** through
    **osd.5**.

    .. image:: /shared/figures/storage/gzf1569521230362.png

    Rank is evaluated and assigned when a monitor is added to the cluster. It
    is based on the IP address and port assigned.


