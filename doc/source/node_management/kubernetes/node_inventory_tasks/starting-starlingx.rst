
.. qpz1552674764891
.. _starting-starlingx:

================
Start the System
================

Restarting an entire |prod| system may become necessary, for instance, after
the underlying hardware has been shut down and physically moved.

This may be necessary, for instance, after the underlying hardware has been
shut down and physically moved.

.. rubric:: |proc|

#.  Boot up **controller-0**.

    #.  Apply power to the system.

    #.  Log in using a local console or |BMC| console.

    #.  Use the :command:`system host-list` command to ensure that the host
        is fully booted before proceeding.

#.  Boot on and unlock **controller-1**.

    #.  Apply power to the system.

    #.  Log in using a local console or |BMC| console.

    #.  Unlock the system.

    #.  Use the :command:`system host-list` command to ensure that the host
        is fully booted before proceeding.

#.  Power on **storage-0**.

    .. note::
        This step applies to Ceph-backed systems  \(systems with storage
        nodes\) only.

    #.  Apply power to the system.

    #.  Log in using a local console or |BMC| console.

    #.  Use the :command:`system host-list` command to ensure that the
        host is fully booted before proceeding.

#.  Power on and unlock **storage-1**.

    .. note::
        This step applies to Ceph-backed systems \(systems with storage nodes\)
        only.

    #.  Apply power to the system.

    #.  Log in using a local console or |BMC| console.

    #.  Unlock the system.

    #.  Use the :command:`system host-list` command to ensure that the
        host is fully booted before proceeding.

#.  Power on and unlock each worker node.

    #.  Follow the instructions for the node's hardware to power it up.

    #.  On the Hosts tab of the **Admin** \> **Platform** \>
        **Host Inventory** page, select **Edit Host** \> **Unlock Host**.

        .. figure:: /node_management/kubernetes/figures/rst1446643548268.png
            :scale: 100%
