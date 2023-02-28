
.. uyd1552672677585
.. _converting-a-duplex-system-to-direct-connection:

============================================
Convert a Duplex System to Direct Connection
============================================

On a |prod| |AIO| system configured to use switch-based network connection for
the management and cluster host networks, you can convert to direct
\(peer-to-peer) connection.

The connection type is initially configured at installation. You can change
it at any time. You must use the CLI to make the change.

.. xbooklinkFor more about the available connection modes,
   see |planning-doc|: `Networks for a Duplex System <networks-for-a-starlingx-duplex-system>`.

.. rubric:: |proc|

#.  Use the :command:`system modify` command to specify direct
    connection (**duplex-direct**).

    .. code-block:: none

        ~(keystone_admin)]$ system modify --system_mode=duplex-direct

    This raises **Config-out-of-date** alarm messages on both controllers.

#.  Lock and then unlock the standby controller to update its configuration.

    Wait for the controller to be reported as **Unlocked**, **Available**,
    and **Online**, and its **Config-out-of-date** alarm message to be
    cleared.

#.  Swact the controllers.

#.  Lock the new standby controller.

#.  Disconnect the management and infrastructure cables from the |ToR| switch.

    This raises **Port failed** and **Interface failed** alarms on the
    active controller for the management and infrastructure interfaces.

#.  Reconnect the cables in a peer-to-peer configuration.

    Wait for the network interface alarms to be cleared.

#.  Unlock the standby controller to update its configuration.

    Wait for the controller to be reported as **Unlocked**, **Available**,
    and **Online**, and its **Config-out-of-date** alarm message to be
    cleared.

.. rubric:: |result|

The system is now reconfigured to use direct connections for the internal
networks.
