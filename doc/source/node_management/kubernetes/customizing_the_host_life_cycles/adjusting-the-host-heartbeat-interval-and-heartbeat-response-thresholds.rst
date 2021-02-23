
.. unf1553797842814
.. _adjusting-the-host-heartbeat-interval-and-heartbeat-response-thresholds:

====================================================================
Adjust the Host Heartbeat Interval and Heartbeat Response Thresholds
====================================================================

You can adjust the heartbeat interval, as well as the thresholds for missed
heartbeat challenges that cause a host to be moved to the **Degraded** or
**Failed** state.

The settings apply to all hosts \(controller, worker, and storage\). For more
information about host states,
see :ref:`The Life Cycle of a Host <the-life-cycle-of-a-host>`.

.. note::
    The heartbeat\_degrade threshold must not exceed the
    heartbeat\_failure\_threshold.

.. rubric:: |proc|

.. _adjusting-the-host-heartbeat-interval-and-heartbeat-response-thresholds-steps-sgv-rkh-cz:

#.  To view the current settings, use the :command:`system service-parameter-list` command.

    .. code-block:: none

        ~(keystone_admin)$ system service-parameter-list --service platform
        +---------+----------+---------------+-----------------------------+-------+
        | uuid    | service  | section       | name                        | value |
        +---------+----------+---------------+-----------------------------+-------+
        | 6d60... | platform | maintenance   | worker_boot_timeout         | 720   |
        | bd04... | platform | maintenance   | controller_boot_timeout     | 1200  |
        | c3a9... | platform | maintenance   | heartbeat_degrade_threshold | 6     |
        | 9089... | platform | maintenance   | heartbeat_failure_action    | fail  |
        | 8df8... | platform | maintenance   | heartbeat_failure_threshold | 10    |
        | 16b5... | platform | maintenance   | heartbeat_period            | 100   |
        | 4712... | platform | maintenance   | mnfa_threshold              | 2     |
        | 4ba7... | platform | maintenance   | mnfa_timeout                | 0     |
        +---------+----------+---------------+-----------------------------+-------+

#.  Use the :command:`system service-parameter-modify` command to specify
    the new heartbeat setting.

    .. code-block:: none

        ~(keystone_admin)$ system service-parameter-modify platform maintenance heartbeat_parm=<heartbeat_value>

    The following service parameters control the heartbeat interval and the
    response thresholds for moving a host to the **Degraded** or **Failed**
    state.

    **heartbeat\_period**
        The time in milliseconds between heartbeat challenges from the
        controller to the other hosts \(100–1000 ms\). The default is
        100 ms.

    **heartbeat\_degrade\_threshold**
        The number of consecutive missing responses to heartbeat challenges
        before a host is moved into the **Degraded** state \(4–100\). The
        default is six consecutive missing responses.

    **heartbeat\_failure\_threshold**
        The number of consecutive missing responses to heartbeat challenges
        before a host is moved into the **Failed** state \(10–100\). The
        default is 10 consecutive missing responses.

    For example, to change the heartbeat failure threshold for all hosts to
    20 consecutive missing heartbeat responses:

    .. code-block:: none

        ~(keystone_admin)$ system service-parameter-modify platform maintenance heartbeat_failure_threshold=20
        +----------+--------------------------------------+
        | Property | Value                                |
        +----------+--------------------------------------+
        | uuid     | d3202d28-acad-4b6f-8e44-cbeeb396eaff |
        | service  | platform                             |
        | section  | maintenance                          |
        | name     | heartbeat_failure_threshold          |
        | value    | 20                                   |
        +----------+--------------------------------------+

#.  Apply the service parameter change.

    .. code-block:: none

        ~(keystone_admin)$ system service-parameter-apply platform
        Applying platform service parameters
