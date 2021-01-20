
.. srt1552049815547
.. _the-cluster-host-network:

====================
Cluster Host Network
====================

The cluster host network provides the physical network required for Kubernetes
management and control, as well as private container networking.

Kubernetes uses logical networks for communication between containers, pods,
services, and external sites. These networks are implemented over the cluster
host network using the |CNI| service, Calico, in |prod|.

All nodes in the cluster must be attached to the cluster host network. This
network shares an interface with the management network. A container workload's
external connectivity is either through the |OAM| port or through other
configured ports on both the controller and worker nodes, depending on
containerized workload requirements. Container network endpoints will be
exposed externally with **NodePort** Kubernetes services. This exposes selected
application containers network ports on *all* interfaces of both controller
nodes and *all* worker nodes, on either the |OAM| interface or other configured
interfaces for external connectivity on all nodes. This is typically done
either directly to the application containers service or through an ingress
controller service to reduce external port usage. HA would be achieved through
either an external HA load balancer across two or more controller and/or worker
nodes, or simply using multiple records \(two or more destination controller
and/or worker node IPs\) for the application's external DNS entry.

Alternatively, the cluster host network can be deployed as an external network
and provides the container workload's external connectivity as well. Container
network endpoints will be exposed externally with **NodePort** Kubernetes
services. This exposes selected Application Containers network ports on *all*
interfaces \(e.g. external cluster host interfaces\) of both controller nodes
and *all* worker nodes. This would typically be done either directly to the
Application Containers service or through an ingress controller service to
reduce external port usage. HA would be achieved through either an external HA
load balancer across two or more controller and/or worker nodes, or simply
using multiple records \(2 or more destination controller and/or worker node
IPs\) for the Application's external DNS Entry.

If using an external cluster host network, container network endpoints could be
exposed through |BGP| within the Calico |CNI| service. Calico |BGP|
configuration could be modified to advertise selected Application Container
services or the ingress controller service to a |BGP| Peer, specifying the
available next hop controller and/or worker nodes' cluster host IP Addresses.
