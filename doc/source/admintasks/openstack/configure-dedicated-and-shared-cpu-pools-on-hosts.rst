
.. _configure-dedicated-and-shared-cpu-pools-on-hosts:

========================================================
Configure Nova's Dedicated and Shared CPU Pools on Hosts
========================================================

|prod| supports configuring Nova's dedicated and shared CPU pools on a per
openstack-compute host basis.

This provides support for users to customize their VM's CPU pinning policies to
either dedicated or shared, with the dedicated policy providing improved near-real-time
performance. For more details, see: `https://docs.openstack.org/nova/latest/admin/cpu-topologies.html <https://docs.openstack.org/nova/latest/admin/cpu-topologies.html>`_.

For an openstack-compute host:

- host CPUs configured as **application** function will be mapped to Nova's
  Shared CPU pool,

  and

- host CPUs configured as **application-isolated** function will be mapped to
  Nova's Dedicated CPU pool.

The above mapping is done automatically, via system-generated Nova Helm Chart
overrides, when the openstack application is applied.

The following restrictions apply when configuring host CPU functions:

-   There must be at least one platform and at least one application or
    application-isolated core on each openstack-compute host.

For example:

.. code-block:: none

    ~(keystone)admin)$ system host-lock worker-1
    ~(keystone)admin)$ system host-cpu-modify -f platform -p0 1 worker-1
    ~(keystone)admin)$ system host-cpu-modify -f application-isolated -p0 15 worker-1
    ~(keystone)admin)$ system host-cpu-modify -f application-isolated -p1 15 worker-1
    ~(keystone)admin)$ system host-unlock worker-1

To configure a flavor to use the dedicated CPU policy, run:

.. code-block:: none

    ~(keystone)$ openstack flavor set [FLAVOR_ID] --property hw:cpu_policy=dedicated

It is also possible to configure the CPU policy via image metadata:

.. code-block:: none

    ~(keystone)$ openstack image set [IMAGE_ID] --property hw_cpu_policy=dedicated

