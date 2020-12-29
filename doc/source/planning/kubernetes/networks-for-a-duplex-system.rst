
.. gju1463606289993
.. _networks-for-a-starlingx-duplex-system:

============================
Networks for a Duplex System
============================

For a |prod| Duplex system, |org| recommends a minimal network configuration.

|prod| Duplex uses a small hardware footprint consisting of two hosts, plus a
network switch for connectivity. Network loading is typically low. The
following network configuration typically meets the requirements of such a
system:

.. _networks-for-a-starlingx-duplex-system-ul-j2d-thb-1w:

-   An internal management network

-   An |OAM| network, optionally consolidated on the management interface.

-   A cluster host network for private container-to-container networking within
    a cluster. By default, this is consolidated on the management interface.

    The cluster host network can also be used for external connectivity of
    container workloads. In this case, the cluster host network would be
    configured on an interface separate from the internal management interface.

-   If a cluster host network is not used for external connectivity of
    container workloads, then either the |OAM| port or additionally configured
    ports on both the controller and worker nodes are used for the container
    workloads connectivity to external networks.


.. note::
    You can enable secure HTTPS connectivity on the |OAM| network.

.. xbooklink For more information, see |sec-doc|: :ref:`Secure HTTPS Connectivity <starlingx-rest-api-applications-and-the-web-administration-server>`
