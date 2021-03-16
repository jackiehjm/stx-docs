
.. pxs1552677322419
.. _about-host-memory-provisioning:

==============================
About Host Memory Provisioning
==============================

.. only:: starlingx

    For each |NUMA| node on a host, you can adjust the amount of memory
    reserved for platform use, and the size and number of memory pages
    allocated for use by applications.

.. only:: partner

    .. include:: ../../../_includes/about-host-memory-provisioning.rest

    :start-after: introduction-text-begin
    :end-before: introduction-text-end

Due to limitations in Kubernetes, only a single huge page size can be used
per host.

The amount of platform memory reserved differs between |AIO| and standard
configurations.

.. note::
    For |prod| Simplex deployments implemented on an Intel Xeon D-based
    platform, the default platform memory is reduced automatically to limit
    the number of worker threads, reducing the platform resource usage. You
    can increase the allotment if required to restore the default maximum
    number of worker threads.

.. only:: starlingx

    Memory not reserved for platform use is made available as application
    memory. You can provision individual |NUMA| nodes to use either 2 MiB or 1
    GiB hugepages. Due to limitations in Kubernetes, only a single huge page
    size can be used per host. Using larger pages can reduce page management
    overhead and improve system performance for systems with large amounts of
    virtual memory and many running instances.

.. only:: partner

    .. include:: ../../../_includes/about-host-memory-provisioning.rest

    :start-after: memory-text-begin
    :end-before: memory-text-end

You can use the :command:`system host-memory-list` and
:command:`system host-memory-show` commands to see how much memory is
available for applications. This information is also shown on the **Memory**
tab of the Host Inventory page \(see :ref:`Memory Tab <memory-tab>`\).

For individual containers \(or hosted applications if you are running
OpenStack\), you can specify which page size is required.

.. only:: partner

   .. include:: ../../../_includes/about-host-memory-provisioning.rest

   :start-after: memory-text-end