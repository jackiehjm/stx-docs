
.. bew1572888575258
.. _isolating-cpu-cores-to-enhance-application-performance:

========================================================
Isolate the CPU Cores to Enhance Application Performance
========================================================

|prod| supports running the most critical low-latency applications on host CPUs
which are completely isolated from the host process scheduler.

This allows you to customize Kubernetes CPU management when policy is set to
static so that low-latency applications run with optimal efficiency.

The following restriction applies when using application-isolated cores:

-   There must be at least one platform and one application core on each host.

For example:

.. code-block:: none

    ~(keystone_admin)]$ system host-lock worker-1
    ~(keystone_admin)]$ system host-cpu-modify  -f platform -p0 1 worker-1
    ~(keystone_admin)]$ system host-cpu-modify  -f application-isolated -p0 15 worker-1
    ~(keystone_admin)]$ system host-cpu-modify  -f application-isolated -p1 15 worker-1
    ~(keystone_admin)]$ system host-unlock worker-1

All |SMT| siblings (hyperthreads, if enabled) on a core will have the same
assigned function. On host boot, any CPUs designated as isolated will be
specified as part of the isolcpus kernel boot argument, which will isolate them
from the process scheduler.

The use of application-isolated cores is only applicable when using the static
Kubernetes CPU Manager policy. For more information,
see :ref:`Kubernetes CPU Manager Policies <kubernetes-cpu-manager-policies>`.

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
other than |AIO-SX| is to administratively lock the host, causing all the
pods to be restarted on an alternate host, before changing CPU assigned
functions. On |AIO-SX| systems, you must explicitly delete the pods.

This advanced feature introduces changes in |prod| Kubernetes relative to
standard Kubernetes.

Kubernetes will report a new **windriver.com/isolcpus** resource for each
worker node. This corresponds to the application-isolated CPUs. Pods in the
**Best-effort** or **Burstable** |QoS| class may specify some number of
**windriver.com/isolcpus** resources and the pod will be scheduled on a host
\(and possibly |NUMA| node depending on topology manager policy\) with
sufficient application-isolated cores available, and the container requesting
the resource will be affined \(and restricted\) to those CPUs via cgroups.

Pods in the Guaranteed |QoS| class should not specify **windriver.com/isolcpus**
resources as they will be allocated but not used. If there are multiple
processes within one container, they can be individually affined to separate
isolated CPUs if the container requests multiple resources. This is highly
recommended as the Linux kernel does not load balance across application-isolated
CPUs. Start-up code in the container can determine the available CPUs by
running :command:`sched_getaffinity()` command, or by parsing
``/sys/fs/cgroup/cpuset/cpuset.cpus`` within the container.

Isolated CPUs can be identified in the container by looking for files such as
``/dev/cpu/<X>`` where ``<X>`` is a number, or by referencing
``/sys/devices/system/cpu/isolated`` against the CPUs associated with this container.


-------------------------------------
Isolating CPU Cores from Kernel Noise
-------------------------------------

For better performance of latency-sensitive applications, and to improve energy
efficiency on idle CPUs, it is possible to isolate CPU cores from kernel noise
with the ``nohz_full`` kernel parameter. This configuration is supported in both
low-latency and standard kernel types. However, for standard kernels, it is
possible to disable the CPU isolation by assigning a label to the target host
with worker sub function.

To summarize, the configuration is supported by default in workers of any
kernel type, but for standard kernels, you can enable the ``disable-nohz-full``
label to disable it.

Use the procedure below to disable the ``nohz_full`` parameter on standard
kernels.

.. only:: starlingx

    .. note::
        For VirtualBox environments, you must add the `disable-nohz-full=enabled`
        label prior to host unlock.

.. rubric:: |proc|

#.  Lock the host.

    .. code-block:: none

        ~(keystone_admin)]$ system host-lock <worker>

#.  Assign the ``disable-nohz-full`` label.

    .. code-block:: none

        ~(keystone_admin)]$ system host-label-assign <worker> disable-nohz-full=enabled

#.  Unlock the host.

    .. code-block:: none

        ~(keystone_admin)]$ system host-unlock <worker>

