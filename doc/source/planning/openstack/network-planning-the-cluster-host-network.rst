
.. nzw1555338241460
.. _network-planning-the-cluster-host-network:

========================
The Cluster Host Network
========================

The cluster host network provides the physical network required for Kubernetes
container networking in support of the containerized OpenStack control plane
traffic.

All nodes in the cluster must be attached to the cluster host network.

In the |prod-os| scenario, this network is considered internal and by default
shares an L2 network / interface with the management network \(although can be
configured on a separate interface, if required\). External access to the
Containerized OpenStack Service Endpoints is through a deployed nginx ingress
controller using host networking to expose itself on ports 80/443
\(http/https\) on the |OAM| Floating IP.
