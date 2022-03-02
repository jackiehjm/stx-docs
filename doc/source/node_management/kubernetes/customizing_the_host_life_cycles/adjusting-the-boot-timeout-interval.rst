
.. axh1553797724179
.. _adjusting-the-boot-timeout-interval:

================================
Adjust the Boot Timeout Interval
================================

You can adjust how long the controller waits for a host to boot before it
moves the host into the **Failed** state.

For more information about host states,
see :ref:`The Life Cycle of a Host <the-life-cycle-of-a-host-93640aa2b707>`.

.. rubric:: |proc|

.. _adjusting-the-boot-timeout-interval-steps-sgv-rkh-cz:

#.  To view the current settings, use the
    :command:`system service-parameter-list` command.

    For example:

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
    the new timeout value.

    .. code-block:: none

        ~(keystone_admin)$ system service-parameter-modify platform maintenance \timeout_parm=<timeout_value>

    The following service parameters control the boot timeout interval.

    **worker\_boot\_timeout**
        The time in seconds to allow for a worker or storage host to boot
        \(720–1800 seconds\). The default value is 720 seconds \(12 minutes\).

        .. note::
            This parameter also applies to storage nodes.

    **controller\_boot\_timeout**
        The time in seconds to allow for a controller host to boot
        \(1200-1800 seconds\). The default value is 1200 seconds
        \(20 minutes\).

    For example, to change the boot timeout for the worker and storage
    hosts to 840 seconds:

    .. code-block:: none

        ~(keystone_admin)$ system service-parameter-modify platform maintenance \worker_boot_timeout=840
        +----------+--------------------------------------+
        | Property | Value                                |
        +----------+--------------------------------------+
        | uuid     | ca82767b-4575-407a-8fc5-ea5ac20f3c21 |
        | service  | platform                             |
        | section  | maintenance                          |
        | name     | worker _boot_timeout                 |
        | value    | 840                                  |
        +----------+--------------------------------------+

#.  Apply the service parameter change.

    .. code-block:: none

        ~(keystone_admin)$ system service-parameter-apply platform
        Applying platform service parameters
