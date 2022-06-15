
.. pdd1551804388161
.. _viewing-active-alarms-using-the-cli:

================================
View Active Alarms Using the CLI
================================

You can use the CLI to find information about currently active system alarms.

.. rubric:: |context|

.. note::
    You can also use the command :command:`fm alarm-summary` to view the count
    of alarms and warnings for the system.

To review detailed information about a specific alarm instance, see
:ref:`Viewing Alarm Details Using the CLI
<viewing-alarm-details-using-the-cli>`.

.. rubric:: |proc|

.. _viewing-active-alarms-using-the-cli-steps-gsj-prg-pkb:

#.  Log in with administrative privileges.

    .. code-block:: none

        $ source /etc/platform/openrc

#.  Run the :command:`fm alarm-list` command to view alarms.

    The command syntax is:

    .. code-block:: none

        fm alarm-list [--nowrap] [-q <QUERY>] [--uuid] [--include_suppress] [--mgmt_affecting] [--degrade_affecting]

    **--nowrap**
        Prevent word-wrapping of output. This option is useful when output will
        be piped to another process.

    **-q**
        <QUERY> is a query string to filter the list output. The typical
        OpenStack CLI syntax for this query string is used. The syntax is a
        combination of attribute, operator and value. For example:
        severity=warning would filter alarms with a severity of warning. More
        complex queries can be built. See the upstream OpenStack CLI syntax
        for more details on <QUERY> string syntax. Also see additional query
        examples below.

        You can use one of the following ``--query`` command filters to view
        specific subsets of alarms, or a particular alarm:

        .. table::
            :widths: auto

            +-----------------------------------------------------+----------------------------------------------------------------------------+
            |     Query Filter                                    |     Comment                                                                |
            +=====================================================+============================================================================+
            |     :command:`uuid=<uuid\>`                         |     Query alarms by UUID, for example:                                     |
            |                                                     |                                                                            |
            |                                                     |     .. code-block:: none                                                   |
            |                                                     |                                                                            |
            |                                                     |             ~(keystone_admin)$ fm alarm-list --query uuid=4ab5698a-19cb... |
            +-----------------------------------------------------+----------------------------------------------------------------------------+
            |     :command:`alarm_id=<alarm id\>`                 |     Query alarms by alarm ID, for example:                                 |
            |                                                     |                                                                            |
            |                                                     |     .. code-block:: none                                                   |
            |                                                     |                                                                            |
            |                                                     |             ~(keystone_admin)$ fm alarm-list --query alarm_id=100.104      |
            +-----------------------------------------------------+----------------------------------------------------------------------------+
            |     :command:`alarm_type=<type\>`                   |     Query alarms by type, for example:                                     |
            |                                                     |                                                                            |
            |                                                     |     .. code-block:: none                                                   |
            |                                                     |                                                                            |
            |                                                     |             ~(keystone_admin)$ fm alarm-list --query \                     |
            |                                                     |             alarm_type=operational-violation                               |
            +-----------------------------------------------------+----------------------------------------------------------------------------+
            |     :command:`entity_type_id=<type id\>`            |     Query alarms by entity type ID, for example:                           |
            |                                                     |                                                                            |
            |                                                     |     .. code-block:: none                                                   |
            |                                                     |                                                                            |
            |                                                     |             ~(keystone_admin)$ fm alarm-list --query \                     |
            |                                                     |             entity_type_id=system.host                                     |
            +-----------------------------------------------------+----------------------------------------------------------------------------+
            |     :command:`entity_instance_id=<instance id\>`    |     Query alarms by entity instance id, for example:                       |
            |                                                     |                                                                            |
            |                                                     |     .. code-block:: none                                                   |
            |                                                     |                                                                            |
            |                                                     |             ~(keystone_admin)$ fm alarm-list --query \                     |
            |                                                     |             entity_instance_id=host=worker-0                               |
            +-----------------------------------------------------+----------------------------------------------------------------------------+
            |     :command:`severity=<severity\>`                 |     Query alarms by severity type, for example:                            |
            |                                                     |                                                                            |
            |                                                     |     .. code-block:: none                                                   |
            |                                                     |                                                                            |
            |                                                     |             ~(keystone_admin)$ fm alarm-list --query severity=warning      |
            |                                                     |                                                                            |
            |                                                     |     The valid severity types are critical, major, minor, and warning.      |
            +-----------------------------------------------------+----------------------------------------------------------------------------+

        Query command filters can be combined into a single expression
        separated by semicolons, as illustrated in the following example:

        .. code-block:: none

            ~(keystone_admin)$ fm alarm-list -q 'alarm_id=400.002;entity_instance_id=service_domain=controller.service_group=directory-services'

        This option indicates that all active alarms should be displayed,
        including suppressed alarms. Suppressed alarms are displayed with
        their Alarm ID set to S<\(alarm-id\)>.

    **--uuid**
        The ``--uuid`` option on the :command:`fm alarm-list` command lists the
        active alarm list with unique UUIDs for each alarm such that this
        UUID can be used in display alarm details with the
        :command:`fm alarm-show` <UUID> command.

    **--include_suppress**
        Use this option to include suppressed alarms in the list.

    **--mgmt_affecting**
        Management affecting alarms prevent some critical administrative
        actions from being performed. For example, software upgrades. Using the
        ``--mgmt_affecting`` option will list an additional column in the output,
        'Management Affecting', which indicates whether the alarm is management
        affecting or not.

    **--degrade_affecting**
        Include degrade affecting status in output.

    The following example shows alarm UUIDs.

    .. code-block:: none

        ~(keystone_admin)$ fm alarm-list ``--uuid``
        +--------------+-------+------------------+---------------+----------+-----------+
        | UUID         | Alarm | Reason Text      | Entity ID     | Severity | Time      |
        |              | ID    |                  |               |          | Stamp     |
        +--------------+-------+------------------+---------------+----------+-----------+
        | 6056e290-    | 200.  | compute-0 was    | host=         | warning  | 2019      |
        | 2e56-        | 001   | administratively | compute-0     |          | -08-29T   |
        | 4e22-b07a-   |       | locked to take   |               |          | 17:00:16. |
        | ff9cf4fbd81a |       | it out-of        |               |          | 363072    |
        |              |       | -service.        |               |          |           |
        |              |       |                  |               |          |           |
        |              |       |                  |               |          |           |
        | 0a8a4aec-    | 100.  | NTP address      | host=         | minor    | 2019      |
        | a2cb-        | 114   | 2607:5300:201:3  | controller-1. |          | -08-29T   |
        | 46aa-8498-   |       | is not a valid   | ntp=          |          | 15:44:44. |
        | 9ed9b6448e0c |       | or a reachable   | 2607:5300:    |          | 773704    |
        |              |       | NTP server.      | 201:3         |          |           |
        |              |       |                  |               |          |           |
        |              |       |                  |               |          |           |
        +--------------+-------+------------------+---------------+----------+-----------+

    This command shows a column to track the management affecting severity of each alarm type.

    .. code-block:: none

        ~(keystone_admin)$ fm alarm-list --mgmt_affecting
        +-------+-------------------+---------------+----------+------------+-------------+
        | Alarm | Reason Text       | Entity ID     | Severity | Management | Time Stamp  |
        | ID    |                   |               |          | Affecting  |             |
        +-------+-------------------+---------------+----------+------------+-------------+
        | 100.  | Platform Memory   | host=         | major    | False      | 2019-05-21T |
        | 103   | threshold         | controller-0. |          |            | 13:15:26.   |
        |       | exceeded ;        | numa=node0    |          |            | 464231      |
        |       | threshold 80%,    |               |          |            |             |
        |       | actual 80%        |               |          |            |             |
        |       |                   |               |          |            |             |
        | 100.  | Platform Memory   | host=         | major    | False      | 2019-05-21T |
        | 103   | threshold         | controller-0  |          |            | 13:15:26.   |
        |       | exceeded ;        |               |          |            | 456738      |
        |       | threshold 80%,    |               |          |            |             |
        |       | actual 80%        |               |          |            |             |
        |       |                   |               |          |            |             |
        | 200.  | controller-0 is   | host=         | major    | True       | 2019-05-20T |
        | 006   | degraded due to   | controller-0. |          |            | 23:56:51.   |
        |       | the failure of    | process=ceph  |          |            | 557509      |
        |       | its 'ceph (osd.0, | (osd.0, )     |          |            |             |
        |       | )' process. Auto  |               |          |            |             |
        |       | recovery of this  |               |          |            |             |
        |       | major process is  |               |          |            |             |
        |       | in progress.      |               |          |            |             |
        |       |                   |               |          |            |             |
        | 200.  | controller-0 was  | host=         | warning  | True       | 2019-05-17T |
        | 001   | administratively  | controller-0  |          |            | 14:17:32.   |
        |       | locked to take it |               |          |            | 794640      |
        |       | out-of-service.   |               |          |            |             |
        |       |                   |               |          |            |             |
        +-------+-------------------+---------------+----------+------------+-------------+
