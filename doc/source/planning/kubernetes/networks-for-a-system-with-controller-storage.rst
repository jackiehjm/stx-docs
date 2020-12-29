
.. gbo1463606348114
.. _networks-for-a-starlingx-system-with-controller-storage:

=============================================
Networks for a System with Controller Storage
=============================================

For a system that uses controller storage, |org| recommends an intermediate
network configuration.

|prod| systems with controller storage use controller and worker hosts only.
Network loading is low to moderate, depending on the number of worker hosts and
containers. The following network configuration typically meets the
requirements of such a system:


.. _networks-for-a-starlingx-system-with-controller-storage-ul-j2d-thb-1w:

-   An internal management network.

-   An |OAM| network, optionally consolidated on the management interface.

-   A cluster host network for private container-to-container networking within
    the cluster, by default consolidated on the management interface.

    The cluster host network can also be used for external connectivity of
    container workloads, in which case it would be configured on an interface
    separate from the internal management interface.

-   If a cluster host network is not used for external connectivity of
    container workloads, then either the |OAM| port or other configured ports on
    both the controller and worker nodes are used for container workloads
    connectivity to external networks.

-   A |PXE| Boot server to support controller-0 initialization.

.. note::
    You can enable secure HTTPS connectivity on the |OAM| network.

.. xbooklink For more information, see |sec-doc|: :ref:`Secure HTTPS Connectivity <starlingx-rest-api-applications-and-the-web-administration-server>`

