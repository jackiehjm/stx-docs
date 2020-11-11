
.. fcv1552680708686
.. _viewing-the-event-log-using-the-cli:

================================
View the Event Log Using the CLI
================================

You can use CLI commands to work with historical alarms and logs in the event log.

.. rubric:: |proc|

.. _viewing-the-event-log-using-the-cli-steps-v3r-stf-pkb:

#.  Log in with administrative privileges.

    .. code-block:: none

        $ source /etc/platform/openrc

#.  Use the :command:`fm event-list` command to view historical alarms'
    sets/clears and logs. By default, only unsuppressed events are shown.

    For more about event suppression, see
    :ref:`Events Suppression Overview <events-suppression-overview>`.

    The syntax of the command is:

    .. code-block:: none

        fm event-list [-q <QUERY>] [-l <NUMBER>] [--alarms] [--logs] [--include_suppress]

    Optional arguments:

    ``-q QUERY, --query QUERY``
        \- key\[op\]data\_type::value; list. data\_type is optional, but if
        supplied must be string, integer, float, or boolean.

    ``-l NUMBER, --limit NUMBER``
        Maximum number of event logs to return.

    ``--alarms``
        Show historical alarms set/clears only.

    ``--logs``
        Show customer logs only.

    ``--include\_suppress``
        Show suppressed alarms as well as unsuppressed alarms.

    ``--uuid``
        Include the unique event UUID in the listing such that it can be used
        in displaying event details with :command:`fm event-show` <uuid>.

    ``-nopaging``
        Disable output paging.

        For details on CLI paging, see
        :ref:`CLI Commands and Paged Output <cli-commands-and-paged-output>`.

    For example:

    .. code-block:: none

        [sysadmin@controller-0 ~(keystone_admin)]$ fm event-list -l 5
        +-----------+-----+-----+--------------------+-----------------+---------+
        |Time Stamp |State|Event|Reason Text         |Entity Instance  |Severity |
        |           |     |Log  |                    |ID               |         |
        |           |     |ID   |                    |                 |         |
        +-----------+-----+-----+--------------------+-----------------+---------+
        |2019-05-21T| set |100. |Platform Memory     |host=controller-0|major    |
        | 13:15:26. |     |103  |threshold exceeded ;|numa=node0       |         |
        | 464231    |     |     |threshold 80%,actual|                 |         |
        |           |     |     |80%                 |                 |         |
        |           |     |     |                    |                 |         |
        |2019-05-21T| set | 100.|Platform Memory     |host=controller-0|major    |
        | 13:15:26. |     | 103 |threshold exceeded; |                 |         |
        | 456738    |     |     |threshold 80%,actual|                 |         |
        |           |     |     |80%                 |                 |         |
        |           |     |     |                    |                 |         |
        |2019-05-21T|clear| 100.|Platform Memory     |host=controller-0|major    |
        | 13:07:26. |     | 103 |threshold exceeded; |numa=node0       |         |
        | 658374    |     |     |threshold 80%,actual|                 |         |
        |           |     |     |79%                 |                 |         |
        |           |     |     |                    |                 |         |
        |2019-05-21T|clear| 100.|Platform Memory     |host=controller-0|major    |
        | 13:07:26. |     | 103 |threshold exceeded; |                 |         |
        | 656608    |     |     |threshold 80%,actual|                 |         |
        |           |     |     |79%                 |                 |         |
        |           |     |     |                    |                 |         |
        |2019-05-21T| set | 100 |Platform Memory     |host=controller-0|major    |
        | 13:05:26. |     | 103 |threshold exceeded; |numa=node0       |         |
        | 481240    |     |     |threshold 80%,actual|                 |         |
        |           |     |     |79%                 |                 |         |
        |           |     |     |                    |                 |         |
        +-----------+-----+-----+--------------------+-----------------+---------+

    .. note::
        You can also use the ``--nopaging`` option to avoid paging long event
        lists.

    In the following example, the :command:`fm event-list` command shows
    alarms only; the **State** column indicates either **set** or **clear**.

    .. code-block:: none

        [sysadmin@controller-0 ~(keystone_admin)]$ fm event-list -l 5 --alarms
        +-------------+-------+-------+--------------------+---------------+----------+
        | Time Stamp  | State | Event | Reason Text        | Entity        | Severity |
        |             |       | Log   |                    | Instance ID   |          |
        |             |       | ID    |                    |               |          |
        +-------------+-------+-------+--------------------+---------------+----------+
        | 2019-05-21T | set   | 100.  | Platform Memory    | host=         | major    |
        | 13:15:26.   |       | 103   | threshold exceeded | controller-0. |          |
        | 464231      |       |       | ; threshold 80%,   | numa=node0    |          |
        |             |       |       | actual 80%         |               |          |
        |             |       |       |                    |               |          |
        | 2019-05-21T | set   | 100.  | Platform Memory    | host=         |          |
        | 13:15:26.   |       | 103   | threshold exceeded | controller-0  | major    |
        | 456738      |       |       | ; threshold 80%,   |               |          |
        |             |       |       | actual 80%         |               |          |
        |             |       |       |                    |               |          |
        | 2019-05-21T | clear | 100.  | Platform Memory    | host=         |          |
        | 13:07:26.   |       | 103   | threshold exceeded | controller-0. | major    |
        | 658374      |       |       | ; threshold 80%,   | numa=node0    |          |
        |             |       |       | actual 79%         |               |          |
        |             |       |       |                    |               |          |
        | 2019-05-21T | clear | 100.  | Platform Memory    | host=         |          |
        | 13:07:26.   |       | 103   | threshold exceeded | controller-0  | major    |
        | 656608      |       |       | ; threshold 80%,   |               |          |
        |             |       |       | actual 79%         |               |          |
        |             |       |       |                    |               |          |
        | 2019-05-21T | set   | 100.  | Platform Memory    | host=         |          |
        | 13:05:26.   |       | 103   | threshold exceeded | controller-0. | major    |
        | 481240      |       |       | ; threshold 80%,   | numa=node0    |          |
        |             |       |       | actual 79%         |               |          |
        |             |       |       |                    |               |          |
        +-------------+-------+-------+--------------------+---------------+----------+


    In the following example, the :command:`fm event-list` command shows logs
    only; the **State** column indicates **log**.

    .. code-block:: none

        [sysadmin@controller-0 ~(keystone_admin)]$ fm event-list -l 5 --logs
        +-------------+-------+-------+---------------------+---------------+----------+
        | Time Stamp  | State | Event | Reason Text         | Entity        | Severity |
        |             |       | Log   |                     | Instance ID   |          |
        |             |       | ID    |                     |               |          |
        +-------------+-------+-------+---------------------+---------------+----------+
        | 2019-05-21T | log   | 700.  | Exited Multi-Node   | subsystem=vim | critical |
        | 00:50:29.   |       | 217   | Recovery Mode       |               |          |
        | 525068      |       |       |                     |               |          |
        |             |       |       |                     |               |          |
        | 2019-05-21T | log   | 700.  | Entered Multi-Node  | subsystem=vim | critical |
        | 00:49:49.   |       | 216   | Recovery Mode       |               |          |
        | 979021      |       |       |                     |               |          |
        |             |       |       |                     |               |          |
        | 2019-05-21T | log   | 401.  | Service group vim-  | service       |          |
        | 00:49:31.   |       | 002   | services redundancy | _domain=      | critical |
        | 205116      |       |       | restored            | controller.   |          |
        |             |       |       |                     | service_group |          |
        |             |       |       |                     | =vim-         |          |
        |             |       |       |                     | services      |          |
        |             |       |       |                     |               |          |
        | 2019-05-21T | log   | 401.  | Service group vim-  | service       |          |
        | 00:49:30.   |       | 001   | services state      | _domain=      | critical |
        | 003221      |       |       | change from go-     | controller.   |          |
        |             |       |       | active to active on | service_group |          |
        |             |       |       | host controller-0   | =vim-services |          |
        |             |       |       |                     | .host=        |          |
        |             |       |       |                     | controller-0  |          |
        |             |       |       |                     |               |          |
        | 2019-05-21T | log   | 401.  | Service group       | service       |          |
        | 00:49:29.   |       | 002   | controller-services | _domain=      | critical |
        | 950524      |       |       | redundancy restored | controller.   |          |
        |             |       |       |                     | service       |          |
        |             |       |       |                     | _group=       |          |
        |             |       |       |                     | controller    |          |
        |             |       |       |                     | -services     |          |
        |             |       |       |                     |               |          |
        +-------------+-------+-------+---------------------+---------------+----------+