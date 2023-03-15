
.. egs1552672694354
.. _converting-a-duplex-system-to-switch-based-connection:

==================================================
Convert a Duplex System to Switch-Based Connection
==================================================

On a |prod| |AIO| Duplex system configured to use direct connections for
the management and cluster host networks, you can convert to switch-based
connections.

The connection type is initially configured at installation. You can change
it at any time. You must use the CLI to make the change.

.. xbooklink For more about the available connection modes,
   see |planning-doc|: `Networks for a Duplex System <networks-for-a-starlingx-duplex-system>`.

.. rubric:: |prereq|

Extra network cables are required to connect both controllers to the |ToR|
switch.

The |ToR| switch must be configured correctly for communication with the
controllers.

.. rubric:: |proc|

#.  Use the :command:`system modify` command to specify switch-based
    connection (**duplex**).

    .. code-block:: none

        ~(keystone_admin)$ system modify --system_mode=duplex


    This raises **Config-out-of-date** alarm messages on both controllers.

#.  Lock the standby controller.

#.  Disconnect the management and infrastructure cables from the standby
    controller.

    This raises **Port failed** and **Interface failed** alarms on the active
    controller for the management and infrastructure interfaces.

#.  Connect both controllers to the |ToR| switch.

    Connect the existing cables from the active controller to the |ToR| switch.
    Use additional cables to connect the standby controller to the |ToR|
    switch.

    Wait for the network interface alarms on the active controller to be
    cleared.

#.  Unlock the standby controller to update its configuration.

    Wait for the controller to be reported as **Unlocked**, **Available**,
    and **Online**, and for its **Config-out-of-date** alarm message to be
    cleared.

#.  Swact the controllers.

#.  Lock and then unlock the new standby controller to update its
    configuration.

    Wait for the controller to be reported as **Unlocked**, **Available**,
    and **Online**, and for its **Config-out-of-date** alarm message to be
    cleared.

.. rubric:: |result|

The system is now reconfigured to use switch-based connections for the
internal networks.