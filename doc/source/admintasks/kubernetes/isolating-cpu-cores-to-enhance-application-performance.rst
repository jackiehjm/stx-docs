
.. bew1572888575258
.. _isolating-cpu-cores-to-enhance-application-performance:

====================================================
Isolate CPU Cores to Enhance Application Performance
====================================================

|prod| supports running the most critical low-latency applications on host CPUs
which are completely isolated from the host process scheduler.

This allows you to customize Kubernetes CPU management when policy is set to
static so that low-latency applications run with optimal efficiency.

The following restriction applies when using application-isolated cores:

-   There must be at least one platform and one application core on each host.

For example:

.. code-block:: none

    ~(keystone)admin)$ system host-lock worker-1
    ~(keystone)admin)$ system host-cpu-modify  -f platform -p0 1 worker-1
    ~(keystone)admin)$ system host-cpu-modify  -f application-isolated -p0 15 worker-1
    ~(keystone)admin)$ system host-cpu-modify  -f application-isolated -p1 15 worker-1
    ~(keystone)admin)$ system host-unlock worker-1

.. note::

    It is possible to explicitly specify 1 or more cores or a range of cores to
    be application-isolated:

    .. code-block::

        ~(keystone_admin)]$ system host-cpu-modify -f application-isolated -c 3 controller-0
        ~(keystone_admin)]$ system host-cpu-modify -f application-isolated -c 3,4 controller-0
        ~(keystone_admin)]$ system host-cpu-modify -f application-isolated -c 3-5 controller-0

All |SMT| siblings (hyperthreads, if enabled) on a core will have the same
assigned function. On host boot, any CPUs designated as isolated will be
specified as part of the isolcpus kernel boot argument, which will isolate them
from the process scheduler.

.. only:: partner

.. note::

   |prod| isolcpus allocation is |SMT|-aware. If a container requests multiple
   isolcpus it will provide |SMT| siblings to the extent possible. If an odd
   number of isolcpus are requested it will provide as many |SMT| siblings as
   are available, then allocate singletons whose sibling has already been
   allocated, then allocate one sibling from a free |SMT| sibling pair. If
   hyperthreading is enabled in the BIOS then containers should request isolcpus
   in pairs. If all containers on a system do this then they will never have
   different containers being allocated |SMT| siblings from the same core.

When using the static CPU manager policy before increasing the number of
platform CPUs or changing isolated CPUs to application CPUs on a host, ensure
that no pods on the host are making use of any isolated CPUs that will be
affected. Otherwise, the pod\(s\) will transition to a Topology Affinity Error
state. Although not strictly necessary, the simplest way to do this on systems
other than AIO Simplex is to administratively lock the host, causing all the
pods to be restarted on an alternate host, before changing CPU assigned
functions. On AIO Simplex systems, you must explicitly delete the pods.

.. only:: partner

   .. include:: /_includes/isolating-cpu-cores-to-enhance-application-performance.rest
      :start-after: changes-relative-to-root-begin
      :end-before: changes-relative-to-root-end
