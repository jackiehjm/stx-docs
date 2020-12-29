
.. wzx1492541958551
.. _networks-for-a-simplex-system:

====================================
Networks for a |prod| Simplex System
====================================

For a |prod| Simplex system, only the |OAM| network and additional external
networks are used.

|prod| Simplex uses a small hardware footprint consisting of a single host.
Unlike other |prod| deployments, this configuration does not require management
or cluster host network connections for internal communications. An |OAM|
network connection is used for administrative and board management access. For
external connectivity of container payloads, either the |OAM| port or other
configured ports on the node can be used.

The management and cluster host networks are required internally. They are
configured to use the loopback interface.

.. note::
    You can enable secure HTTPS connectivity on the |OAM| network.

.. xbooklink For more information, see |sec-doc|: :ref:`Secure HTTPS Connectivity <starlingx-rest-api-applications-and-the-web-administration-server>`
