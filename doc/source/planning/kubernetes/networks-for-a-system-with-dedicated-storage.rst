
.. leh1463606429329
.. _networks-for-a-starlingx-with-dedicated-storage:

============================================
Networks for a System with Dedicated Storage
============================================

For a system that uses dedicated storage, |org| recommends a full network
configuration.

|prod| systems with dedicated storage include storage hosts to provide
Ceph-backed block storage. Network loading is moderate to high, depending on
the number of worker hosts, containers, and storage hosts. The following
network configuration typically meets the requirements of such a system:

.. _networks-for-a-starlingx-with-dedicated-storage-ul-j2d-thb-1w:

-   An internal management network.

-   A 10GE cluster host network for disk IO traffic to storage nodes and for
    private container-to-container networking within a cluster, by default
    consolidated on the management interface.

    The cluster host network can be configured on an interface separate from
    the internal management interface for external connectivity of container
    workloads.

-   An |OAM| network.

-   A cluster host network not used for external connectivity of container
    workloads. Either the |OAM| port or other configured ports on the
    controller and worker nodes would be used for container workloads'
    connectivity to external networks.

-   An optional |PXE| boot network:

    -   if the internal management network is required to be on a |VLAN|-tagged
        network

    -   if the internal management network is shared with other equipment

On moderately loaded systems, the |OAM| network can be consolidated on the
management or infrastructure interfaces.

.. note::
    You can enable secure HTTPS connectivity on the |OAM| network.

.. xbooklink For more information, see |sec-doc|: :ref:`Secure HTTPS Connectivity <starlingx-rest-api-applications-and-the-web-administration-server>`
