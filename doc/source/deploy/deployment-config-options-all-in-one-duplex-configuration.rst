
.. nex1565202435470
.. _deployment-config-options-all-in-one-duplex-configuration:

=====================================
All-in-one (AIO) Duplex Configuration
=====================================

|prod| AIO Duplex provides a scaled-down |prod| deployment
option that combines controller, storage, and worker functionality on a
redundant pair of hosts.

.. contents::
   :local:
   :depth: 1

.. image:: /deploy_install_guides/r5_release/figures/starlingx-deployment-options-duplex.png
   :width: 800

See :ref:`Common Components <common-components>` for a description of common
components of this deployment configuration.

This deployment configuration provides a solution for situations in which
protection against overall server hardware faults and only a small amount of
cloud processing / storage power is required.

HA services run on the controller function across the two physical servers in
either Active/Active or Active/Standby mode.

The storage function is provided by a small-scale two node Ceph cluster using
one or more disks/|OSDs| from each server, and
provides the backend for Kubernetes' |PVCs|.

The solution requires two or more disks per server; one for system
requirements and container ephemeral storage, and one or more for Ceph
|OSDs|.

Hosted application containers are scheduled on both worker functions.

In the event of an overall server hardware fault:

.. _deployment-config-options-all-in-one-duplex-configuration-ul-jr3-tcy-q3b:

-   all controller HA services enter active mode on the remaining healthy
    server, and

-   all hosted application containers impacted by the failed server are
    recovered on the remaining healthy server.

On an All-in-one Duplex system, two modes of connection are supported for the
management and cluster host network.

**Direct**
    This mode uses direct peer-to-peer connections between the two nodes for
    the management and an internal cluster host network connection,
    eliminating the need for a |ToR| switch port for these
    networks.

    |org| recommends a 10GE shared management and cluster host network with
    |LAG| for direct connections. If the management
    network must be 1GE \(to support PXE booting\), then a separate 10GE
    cluster host network with |LAG| is also
    recommended. The use of |LAG| addresses failover
    considerations unique to peer-to-peer connections.

**Switch-based**
    This mode uses a |ToR| switch to complete the
    management and cluster host network connections.

.. _deployment-config-options-all-in-one-duplex-configuration-section-N10099-N1001C-N10001:

----------------------
Intel Xeon D Processor
----------------------

In addition to regular all-in-one deployments, |prod| Simplex and Duplex
provide support for small scale deployments on the Intel Xeon D family of
processors using a smaller memory and CPU footprint than the standard Simplex
configuration.

For low-cost or low-power applications with minimal performance demands \(40
containers or fewer\), |prod| Simplex can be deployed on a server with a
single Intel Xeon D class processor. The platform-reserved memory and the
maximum number of worker threads are reduced by default, but can be
reconfigured if required.

.. _deployment-config-options-all-in-one-duplex-configuration-section-N100AA-N1001C-N10001:

---------------------------------------------------
Extending the capacity of the AIO-Duplex Deployment
---------------------------------------------------

Up to fifty worker/compute nodes can be added to the  All-in-one Duplex
deployment, allowing a capacity growth path if starting with an AIO-Duplex
deployment.

.. image:: /deploy_install_guides/r5_release/figures/starlingx-deployment-options-duplex-extended.png
   :width: 800

The extended capacity is limited up to fifty worker/compute nodes as the
controller/worker function on the AIO controllers has only a portion of the
processing power of the overall server.

Hosted application containers can be scheduled on either of the AIO controller
nodes and/or the worker nodes.
