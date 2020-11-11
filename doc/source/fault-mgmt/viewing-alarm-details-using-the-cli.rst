
.. kfs1580755127017
.. _viewing-alarm-details-using-the-cli:

================================
View Alarm Details Using the CLI
================================

You can view detailed information to help troubleshoot an alarm.

.. rubric:: |proc|

-   Use the following command to view details about an alarm.

    .. code-block:: none

        fm alarm-show <uuid>

    <uuid> is the ID of the alarm to query. Use the :command:`fm alarm-list`
    to obtain UUIDs as described in
    :ref:`Viewing Active Alarms Using the CLI <viewing-active-alarms-using-the-cli>`.

    .. code-block:: none

        ~(keystone_admin)$ fm alarm-show 4ab5698a-19cb-4c17-bd63-302173fef62c
        +------------------------+-------------------------------------------------+
        | Property               | Value                                           |
        +------------------------+-------------------------------------------------+
        | alarm_id               | 100.104                                         |
        | alarm_state            | set                                             |
        | alarm_type             | operational-violation                           |
        | entity_instance_id     | system=hp380-1_4.host=controller-0              |
        | entity_type_id         | system.host                                     |
        | probable_cause         | threshold-crossed                               |
        | proposed_repair_action | /dev/sda3 check usage                           |
        | reason_text            | /dev/sda3 critical threshold set (0.00 MB left) |
        | service_affecting      | False                                           |
        | severity               | critical                                        |
        | suppression            | True                                            |
        | timestamp              | 2014-06-25T16:58:57.324613                      |
        | uuid                   | 4ab5698a-19cb-4c17-bd63-302173fef62c            |
        +------------------------+-------------------------------------------------+

    The pair of attributes **\(alarm\_id, entity\_instance\_id\)** uniquely
    identifies an active alarm:

    **alarm\_id**
        An ID identifying the particular alarm condition. Note that there are
        some alarm conditions, such as *administratively locked*, that can be
        raised by more than one entity-instance-id.

    **entity\_instance\_id**
        Type and instance information of the object raising the alarm. A
        period-separated list of \(key, value\) pairs, representing the
        containment structure of the overall entity instance. This structure
        is used for processing hierarchical clearing of alarms.