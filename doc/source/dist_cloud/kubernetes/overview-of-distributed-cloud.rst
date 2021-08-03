
.. eho1558617205547
.. _overview-of-distributed-cloud:

=============================
Overview of Distributed Cloud
=============================

|prod-long| |prod-dc| configuration supports an edge computing solution
by providing central management and orchestration for a geographically
distributed network of |prod| systems.

The |prod-dc| system is designed to meet the needs of edge-based data centers
in which NFC worker resources are localized for maximum responsiveness, while
management and control functions are centralized for efficient administration.
The system supports a scalable number of |prod| edge systems, centrally managed
and synchronized over L3 networks from a |prod| central region. Each edge
system is also highly scalable, from a single |prod| Simplex deployment to a
full Standard Cloud configuration with storage nodes.

The architecture features a synchronized distributed control plane for reduced
latency, with an autonomous control plane such that all subcloud local services
are operational even during loss of Northbound connectivity to the Central
Region.

