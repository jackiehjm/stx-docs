
.. dqo1565196952042
.. _deployment-options:

==================
Deployment Options
==================

A variety of |prod-long| deployment configuration options are supported.

**All-in-one Simplex**
    A single physical server providing all three cloud functions \(controller,
    worker and storage\).

**All-in-one Duplex \(up to 50 worker nodes\)**
    Two HA-protected physical servers, both running all three cloud functions
    \(controller, worker and storage\), optionally with up to 50 worker nodes
    added to the cluster.

**Standard with Storage Cluster on Controller Nodes**
    A two node HA controller + storage node cluster, managing up to 200 worker
    nodes.

**Standard with Storage Cluster on dedicated Storage Nodes**
    A two node HA controller node cluster with a 2-9 node Ceph storage
    cluster, managing up to 200 worker nodes.

.. xreflink        For more
        information, see the :ref:`Storage
        <storage-configuration-storage-resources>` guide.

All |prod| systems can use worker platforms \(worker hosts, or the worker
function on a simplex or duplex system\) configured for either standard or
low-latency worker function performance profiles.