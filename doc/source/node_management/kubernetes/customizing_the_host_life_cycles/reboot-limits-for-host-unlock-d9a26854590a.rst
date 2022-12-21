.. _reboot-limits-for-host-unlock-d9a26854590a:

=============================
Reboot Limits for Host Unlock
=============================

During a host unlock, the host is rebooted. If the host fails to boot,
|prod| waits for a predetermined interval and then attempts to reboot the
host again. For certain types of failure, the number of reboot attempts is
limited to prevent the host from being rebooted indefinitely.

The following types of failure use reboot limitations. The failures are
reported on the Host Inventory page of the Horizon Web interface, in the
**Status** field for the host.

.. _reboot-limits-for-host-unlock-table-g3q-5tq-jgb:

.. table::
    :widths: auto

    +--------------------------+---------------+----------------------------+---------------------------------------------------------------------------------------------+
    | Reboot Failure           | Wait Interval | Additional Reboot Attempts | Remarks                                                                                     |
    +==========================+===============+============================+=============================================================================================+
    | Enable Heartbeat Failure | 10 minutes    | One                        | A 10-minute wait time is provided to allow for user-initiated collect and debug operations. |
    +--------------------------+---------------+----------------------------+---------------------------------------------------------------------------------------------+
    | Configuration Failure    | 30 seconds    | One                        |                                                                                             |
    +--------------------------+---------------+----------------------------+---------------------------------------------------------------------------------------------+
    | In-Test Failed           | 30 seconds    | One                        |                                                                                             |
    +--------------------------+---------------+----------------------------+---------------------------------------------------------------------------------------------+
    | Start Services Failed    | 30 seconds    | One                        |                                                                                             |
    +--------------------------+---------------+----------------------------+---------------------------------------------------------------------------------------------+

After the designated number of reboots, |prod| leaves the host in an
**Unlocked**, **Disabled**, and **Failed** state to allow troubleshooting.
You can lock the host manually and then unlock it to attempt recovery.


