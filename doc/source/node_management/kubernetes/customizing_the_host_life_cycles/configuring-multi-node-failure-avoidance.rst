
.. aju1553797916220
.. _configuring-multi-node-failure-avoidance:

======================================
Configure Multi-Node Failure Avoidance
======================================

Multi-Node Failure Avoidance detects simultaneous in-service
maintenance heartbeat failures of more than one host, and gracefully
recovers the hosts once the heartbeat is re-established.

You can configure multi-node failure avoidance for recovery of failing hosts,
**mnfa\_threshold** \(default is 2, range is specified from 2 to 100\), and
the number of seconds the heartbeat can fail in this group of hosts,
**mnfa\_timeout** \(default is no-timeout, value of 0, or from 100 to 86400
secs=1 day\), before the hosts are declared failed, or are required to be
forced to reboot/reset. If the value is set outside the range, a warning is
displayed.

Multi-Node Failure Avoidance is based on four or more back to back heartbeat
pulse misses for a **mnfa\_threshold** or higher number of hosts within a
full heartbeat loss window. For example, given the default heartbeat period
of 100 msec and the **heartbeat\_failure\_threshold** of 10; if maintenance
sees **mnfa\_threshold** or more hosts missing four or more back to back
heartbeat responses within one second \( 100 msec times 10 \), then
Multi-Node Failure Avoidance is activated for those hosts. Any additional
hosts failing heartbeat while |MNFA| is active are added to the |MNFA| pool.

In Horizon, |MNFA| displays heartbeat failing hosts in the
**unlocked-enabled-degraded** state, and displays a status of “Graceful
Recovery Wait” while maintenance waits for heartbeat to that host to recover.
This degraded state and host status is true only for the **fail** and
**degrade** **heartbeat\_failure\_action** selections. For information on
viewing heartbeat-failing hosts from Horizon, see :ref:`Hosts Tab <hosts-tab>`.

Hosts whose heartbeat recovers, after ten back to back heartbeat responses,
are removed from the |MNFA| pool with state and status returned to what it was
prior to the event. Once the |MNFA| pool size drops below **mnfa\_threshold**,
then the remaining hosts have 6 seconds \(100 msec times 10 plus 5 second grace
period\) to recover before the selected **heartbeat\_failure\_action** is taken
against the hosts. With the **mnfa\_threshold** of two that would only be one
host \(or for 3 that could be 2\). If late recovering hosts recover, and if
their uptime shows that they had rebooted, then they are tested and brought
back into service like the others. Otherwise they are fully re-enabled
through reboot/reset.

In |MNFA| recovery, where the **heartbeat\_failure\_action** is **fail** and
the hosts do not reboot during the loss of heartbeat. It is possible that
maintenance will force a reboot of the **mnfa\_threshold-1** late recovering
hosts upon eventual recovery, as at that point they are treated as individual
heartbeat failures.

.. rubric:: |proc|

.. _configuring-multi-node-failure-avoidance-steps-m4h-j3h-gfb:

#.  Use the :command:`system service-parameter-modify` command to specify the
    new **mnfa\_threshold** and **mnfa\_timeout** setting. Changing this to
    an invalid value, results in a semantic check error similar to the
    following:

    .. code-block:: none

        ~(keystone_admin)$ system service-parameter-modify platform maintenance mnfa_threshold=<1>
        Parameter 'mnfa_threshold' must be between 2 and 100

    The **mnfa\_timeout** accepts a value of 0 indicating no-timeout or
    from 100 to 86400 secs \(1 day\). For example:

    .. code-block:: none

        ~(keystone_admin)$ system service-parameter-modify platform maintenance mnfa_timeout=<20>
        Parameter 'mnfa_timeout' must be zero or between 100 and 86400

    Customer logs are created. The customer logs record **from** and **to**
    changes in the log text. For example:

    .. figure:: /node_management/kubernetes/figures/oio1537823446860.jpeg
        :scale: 65%

#.  Apply the service parameter change.

    .. code-block:: none

        ~(keystone_admin)$ system service-parameter-apply platform
        Applying platform service parameters

    .. note::
        Multi-Node Failure Avoidance is never activated as it does not apply
        if the **heartbeat\_failure\_action** is set to **alarm** or **none**.

    For more information,  see :ref:`Configure Heartbeat Failure Action
    <configuring-heartbeat-failure-action>`.
