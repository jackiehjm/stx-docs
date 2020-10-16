
.. pzk1552673010743
.. _configuring-ptp-service-using-horizon:

===================================
Configure PTP Service Using Horizon
===================================

The |PTP| is a protocol used to synchronize clocks in a network. You can use
the Horizon Web interface to configure these services on the host.

|PTP| provides more accurate time synchronization than |NTP|. |NTP| typically
provides time synchronization accuracy on the order of milliseconds, while
|PTP| provides time synchronization accuracy on the order of microseconds.

.. xbooklink For more information on configuring the PTP service for clock
   synchronization, see |node-doc|: `Host Inventory <hosts-tab>`.

A |PTP| master must be present on the |OAM| Network, broadcasting |PTP| time
messages.

.. note::
    |NTP| and |PTP| are configured per host. Lock/unlock the host when
    updating **clock\_synchronization** for the host.

.. rubric:: |prereq|

Review the Fault Management page and ensure that any existing system alarms
are cleared.

.. rubric:: |proc|

.. _configuring-ptp-service-using-horizon-steps-xfh-24z-5p:

#.  In the |prod| Horizon, open the System Configuration page.

    The System Configuration page is available
    from **Admin** \> **Platform** \> **System Configuration** in the
    left-hand pane.

#.  Select the |PTP| tab.

    The |PTP| page appears.

#.  Click **Edit PTP**. Update the configuration of the |PTP| service.

    -   **PTP Time Stamping Mode**: Hardware time stamping is the default
        option, and achieves best time syncing.

    -   **PTP Network Transport**: Switch between IEEE 802.3 network
        transport \(L2\) or |UDP| IPv4/v6 network transport  for |PTP|
        messaging.

        .. note::
            L2 is the default option.

            If you use |UDP| for |PTP| transport, each |PTP| interface must have
            an IP assigned. This is enforced during host unlock, and when
            switching |PTP| transport to |UDP|.

    -   **PTP Delay Mechanism**

        Set the |PTP| delay mechanism, the options are:

        -   E2E: default delay request-response

        -   P2P: peer delay

#.  Click **Save**.

    This raises **250.001 Configuration out-of-date** alarms against the
    controllers, workers, and storages nodes. You can view the alarms on
    the Fault Management page.

#.  Lock and unlock the controllers, workers, and storage nodes to apply the
    configuration and clear the **Configuration out-of-date** alarms.

    Open the Host Inventory page, available
    from **Admin** \> **Platform** \> **Host Inventory** in the left-hand
    pane, and then select the **Hosts** tab. Hosts requiring attention are
    shown with the status **Config out-of-date**.

    To lock or unlock a host, click the **Action Menu** down arrow for the
    host and then use the menu selections.

    #.  Lock the standby controller.

        Wait for the lock operation to be completed.

    #.  Unlock the standby controller.

        Wait for the host to become available. Its configuration is
        updated, and its error message is cleared.

    #.  Perform a swact on the active controller.

        Click **Action Menu \(down arrow\)** \> **Swact Host** \>   for
        the active controller.

        Horizon Web interface access is interrupted, and the |prod| login
        screen appears. Wait briefly for the Web service to stabilize, and
        then log in again.

    #.  Lock the original controller \(now in standby mode\).

        Wait for the lock operation to be completed.

    #.  Unlock the original controller.

        Wait for it to become available. Its configuration is updated, and
        its error message is cleared.

#.  Ensure that the **Configuration out-of-date** alarms are cleared for
    both controllers.