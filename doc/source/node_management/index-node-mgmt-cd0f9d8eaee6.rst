.. _index-node-mgmt-cd0f9d8eaee6:

===============
Node Management
===============

----------
Kubernetes
----------

.. kub-begin

You can perform |prod-long| node management of worker hosts that comprise
resource pools for hosting guest applications.

You can change the resource pool in several ways:

.. _introduction-ul-bb3-1mk-lq:

-   You can add or remove hosts to increase or decrease the size of the pool.

-   You can replace a host with another that has different resources; for
    example, memory, or number of CPU cores.

-   You can adjust the resources on an existing host.

-   You can replace a failed worker node host with an equivalent.

-   You can add or remove standard and low-latency worker hosts to adjust the
    mix of performance profiles on a system.

.. caution::
    When replacing or adjusting a host, ensure that the overall resource pool
    still meets the requirements for your system.

Complete instructions for adding a worker node are provided in the
:ref:`index-install-r7-8966076f0e81`.

.. kub-end

.. toctree::
   :maxdepth: 2

   kubernetes/index-node-mgmt-kub-5ff5993b9c60

---------
OpenStack
---------

.. os-begin

You can add OpenStack compute nodes to an existing |AIO| Duplex system,
and use labels to identify OpenStack Nodes.

Guidelines for |VMs| in a duplex system remain unchanged.

.. os-end

*****************************
Add an OpenStack compute node
*****************************

.. toctree::
   :maxdepth: 2

   openstack/index-node-mgmt-os-ccb47338adbc

