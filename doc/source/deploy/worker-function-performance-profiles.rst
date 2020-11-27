
.. dle1565204388710
.. _worker-function-performance-profiles:

====================================
Worker Function Performance Profiles
====================================

|prod| offers a choice of two performance profiles for worker hosts
configurable at the Kubernetes platform level.

**Standard**
    This is the default profile, offering an optimal balance between throughput,
    latency and functionality. The standard profile is suitable for most
    applications.

**Low Latency**
    This profile is optimized for low-latency performance. Characteristics of a
    low-latency worker host include:

    -   lower throughput for most configurations

    -   higher power consumption at low CPU utilization

    -   disabled per-CPU scheduler watchdogs. This can result in increased
        fault detection time for some fault scenarios.

    |org| recommends the low-latency profile only for applications with
    stringent latency constraints such as |MEC|.

You can create a heterogeneous configuration in which standard and low-latency
worker hosts are mixed in the same standard deployment. Standard and
low-latency worker nodes are identified with node labels. When launching a
container, you can choose the required performance profile by specifying the
appropriate label in the node-selector.
