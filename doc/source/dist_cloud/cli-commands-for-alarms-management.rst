
.. hmg1558616220923
.. _cli-commands-for-alarms-management:

==================================
CLI Commands for Alarms Management
==================================

You can use the |CLI| to review alarm summaries for the |prod-dc|.


.. _cli-commands-for-alarms-management-ul-ncv-m4y-fdb:

-   To show the status of all subclouds, as well as a summary count of alarms
    and warnings for each one, use the :command:`alarm summary` command.

    For example:

    .. code-block:: none

        ~(keystone_admin)]$ dcmanager alarm summary
        +------------+-----------------+--------------+--------------+----------+----------+
        | NAME       | CRITICAL_ALARMS | MAJOR_ALARMS | MINOR_ALARMS | WARNINGS | STATUS   |
        +------------+-----------------+--------------+--------------+----------+----------+
        | subcloud-5 |               0 |            2 |            0 |        0 | degraded |
        | subcloud-1 |               0 |            0 |            0 |        0 | OK       |
        +------------+-----------------+--------------+--------------+----------+----------+


    System Controller alarms and warnings are not included.

    The status is one of the following:

    **OK**
        There are no alarms or warnings, or only warnings.

    **degraded**
        There are minor or major alarms.

    **critical**
        There are critical alarms.

-   To show the count of alarms and warnings for the System Controller, use the
    :command:`alarm-summary` command.

    For example:

    .. code-block:: none

        ~(keystone_admin)]$ fm alarm-summary
        +-----------------+--------------+--------------+----------+
        | Critical Alarms | Major Alarms | Minor Alarms | Warnings |
        +-----------------+--------------+--------------+----------+
        | 0               | 0            | 0            | 0        |
        +-----------------+--------------+--------------+----------+


    The following command is equivalent to the :command:`fm alarm-summary`,
    providing a count of alarms and warnings for the System Controller:


    -   :command:`fm --os-region-name RegionOne alarm-summary`


-   To show the alarm and warning count for a specific subcloud only, add the
    --os-region-name parameter and supply the region name:

    For example:

    .. code-block:: none

        ~(keystone_admin)]$ fm --os-region-name subcloud2 --os-auth-url http://192.168.121.2:5000/v3  alarm-summary
        +-----------------+--------------+--------------+----------+
        | Critical Alarms | Major Alarms | Minor Alarms | Warnings |
        +-----------------+--------------+--------------+----------+
        | 0               | 0            | 0            | 0        |
        +-----------------+--------------+--------------+----------+


-   To list the alarms for a subcloud:

    .. code-block:: none

        ~(keystone_admin)]$ fm --os-region-name subcloud2 --os-auth-url http://192.168.121.2:5000/v3  alarm-list
        +----------+--------------------------------------------+-------------------+----------+-------------------+
        | Alarm ID | Reason Text                                | Entity ID         | Severity | Time Stamp        |
        +----------+--------------------------------------------+-------------------+----------+-------------------+
        | 250.001  | controller-0 Configuration is out-of-date. | host=controller-0 | major    | 2018-02-06T21:37: |
        |          |                                            |                   |          | 32.650217         |
        |          |                                            |                   |          |                   |
        | 250.001  | controller-1 Configuration is out-of-date. | host=controller-1 | major    | 2018-02-06T21:37: |
        |          |                                            |                   |          | 29.121674         |
        |          |                                            |                   |          |                   |
        +----------+--------------------------------------------+-------------------+----------+-------------------+



