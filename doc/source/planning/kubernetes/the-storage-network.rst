
.. hzz1585077472404
.. _the-storage-network:

===============
Storage Network
===============

The storage network is an optional network that is only required if using an
external Netapp Trident cluster as a storage backend.

The storage network provides connectivity between all nodes in the |prod-long|
cluster \(controller nodes and worker nodes\) and the Netapp
Trident cluster.

For the most part, the storage network shares the design considerations
applicable to the internal management network.


.. _the-storage-network-ul-c41-qwm-dlb:

-   It can be implemented using a 10 Gb Ethernet interface.

-   It can be |VLAN|-tagged, enabling it to share an interface with the
    management or |OAM| network.

-   It can own the entire IP address range on the subnet, or a specified
    range.

-   It supports dynamic or static IP address assignment.
