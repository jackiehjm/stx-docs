
.. pxs1552677322419
.. _about-host-memory-provisioning:

==============================
About Host Memory Provisioning
==============================

For each |NUMA| node on a host, you can
adjust the amount of memory reserved for platform use, and the size and
number of memory pages allocated for use by applications and the virtual
switch \(vSwitch\). vSwitch is only applicable on an openstack-compute
labeled worker node, when running the |prod-os| OpenStack application.

Due to limitations in Kubernetes, only a single huge page size can be used
per host.

The amount of platform memory reserved differs between
|AIO| and standard configurations.

.. note::
    For |prod| Simplex deployments implemented on an Intel Xeon D-based
    platform, the default platform memory is reduced automatically to limit
    the number of worker threads, reducing the platform resource usage. You
    can increase the allotment if required to restore the default maximum
    number of worker threads.

Memory not reserved for platform and vSwitch use is made available as
application memory. By default, no application memory is reserved. You can
provision individual |NUMA| nodes to use
either 2 MiB or 1 GiB hugepages. Using larger pages can reduce page
management overhead and improve system performance for systems with large
amounts of virtual memory and many running instances.

For an openstack-compute labeled worker node, the vSwitch memory is
partitioned using 1 GiB huge pages by default. You can change this for
individual |NUMA| nodes to use 2 MiB huge
pages for systems without 1 GiB huge page support.

You can use the :command:`system host-memory-list` and
:command:`system host-memory-show` commands to see how much memory is
available for applications. This information is also shown on the **Memory**
tab of the Host Inventory page \(see :ref:`Memory Tab <memory-tab>`\).

For individual containers \(or hosted applications if you are running
OpenStack\), you can specify which page size is required.

.. only:: partner

   .. include:: ../../../_includes/about-host-memory-provisioning.rest
