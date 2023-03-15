
.. sod1552673143944
.. _resynchronizing-a-host-to-the-ntp-server:

======================================
Resynchronize a Host to the NTP Server
======================================

If host synchronization is lost for any reason, you must lock and then
unlock the host to restore the synchronization safely.

If a large time discrepancy (greater than 1000 seconds, or about 17
minutes) develops between the clock time on a host and the time as reported
by an |NTP| server, the **ntpd** service on the host stops, and Alarm
200.006 (<hostname\> 'ntpd' process has failed) is logged in the Alarm Log
and the Customer Log. This can occur if the clock on the host is
inadvertently set incorrectly, or cannot access the |NTP| server for the
correct time at initialization and defaults to an incorrect time.

.. rubric:: |proc|

.. _resynchronizing-a-host-to-the-ntp-server-steps-rl4-xmy-hkb:

-   To recover, lock and then unlock the host.

    .. caution::
        Do not attempt to recover by restarting the **ntpd** service. This
        can cause problems for other running services.

.. rubric:: |result|

The time is automatically synchronized to the |NTP| server when the host is
unlocked and alarm 200.006 for this host will be cleared.
