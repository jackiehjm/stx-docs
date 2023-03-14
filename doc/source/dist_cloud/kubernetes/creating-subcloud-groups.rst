
.. enf1600200276330
.. _creating-subcloud-groups:

======================
Create Subcloud Groups
======================

All subclouds belong to a subcloud group. When a subcloud is created, it will
be added to the 'Default' group, unless a different subcloud group has been
specified.

A subcloud can be moved to a different subcloud group using the
:command:`dcmanager subcloud update` command for the group attribute. A
subcloud group cannot be deleted if it contains any subclouds. Removing a
subcloud from a subcloud group is done by moving the subcloud back to the
'Default' subcloud group.


.. rubric:: |context|

You can use |CLI| commands to add new subcloud groups, list, update or delete
subcloud groups. The |CLI| commands for managing subcloud groups are:


.. _creating-subcloud-groups-ul-fvw-cj4-3jb:

:command:`dcmanager subcloud-group add`:
Adds a new subcloud group.

:command:`dcmanager subcloud-group delete`:
Deletes subcloud group details from the database.

.. note::

    The 'Default' subcloud group cannot be deleted

    :command:`dcmanager subcloud-group list`:
    Lists subcloud groups.

    :command:`dcmanager subcloud-group list-subclouds`:
    List subclouds referencing a subcloud group.

    :command:`dcmanager subcloud-group show`:
    Shows the details of a subcloud group.

    :command:`dcmanager subcloud-group update`:
    Updates attributes of a subcloud group.

.. note::

    The name of the 'Default' subcloud group cannot be changed

.. rubric:: |proc|

-   To create a subcloud group, use the following command:

    .. code-block:: none

        ~(keystone_admin)]$ dcmanager subcloud-group add --name <group>
        usage: dcmanager subcloud-group add [-h] [-f {json,shell,table,value,yaml}]
         [-c COLUMN] [--max-width <integer>]
         [--fit-width] [--print-empty] [--noindent]
         [--prefix PREFIX] --name NAME
         [--description DESCRIPTION]
         [--update_apply_type UPDATE_APPLY_TYPE]
         [--max_parallel_subclouds MAX_PARALLEL_SUBCLOUDS]

    For example,

    .. code-block:: none

        ~(keystone_admin)]$ dcmanager subcloud-group add --name <Group1>
        +------------------------+----------------------------+
        | Field                  | Value                      |
        +------------------------+----------------------------+
        | id                     | 1                          |
        | name                   | Group1                     |
        | description            | No description provided    |
        | update apply type      | parallel                   |
        | max parallel subclouds | 20                         |
        | created_at             | 2020-09-15 19:03:30.050353 |
        | updated_at             | None                       |
        +------------------------+----------------------------+

    To create an upgrade strategy, if required, use the :command:`dcmanager
    upgrade-strategy create`, :command:`dcmanager patch-strategy create`, or
    :command:`dcmanager fw-update-strategy create` commands. For more
    information, see :ref:`Managing Subcloud Groups
    <managing-subcloud-groups>`.

-   To list subcloud groups, use the following command:

    .. code-block:: none

        ~(keystone_admin)]$ dcmanager subcloud-group list

    To list subclouds referencing a subcloud group, use the following command:

    .. code-block:: none

        ~(keystone_admin)]$ dcmanager subcloud-group list-subclouds

    For example,

    .. code-block:: none

        ~(keystone_admin)]$ dcmanager subcloud-group list-subclouds Group1

        +--+------+----+----+-------+-------+------+-----------+-----------+-------------+-----------+------------+------------+------+----------+----------+
        |id|name  |desc|loc.|sof.ver|mgmnt  |avail |deploy_stat|mgmt_subnet|mgmt_start_ip|mgmt_end_ip|mgmt_gtwy_ip|sysctrl_gtwy|grp_id|created_at|updated_at|
        +--+------+----+----+-------+-------+------+-----------+-----------+-------------+-----------+------------+------------+------+----------+----------+
        |3 |subcl1|None|None|nn.nn  |managed|online|complete   |fd01:12::0.|fd01:12::2   |fd01:12::11|fd01:12::1  |fd01:11::1  | 2    |2021-01-09|2021-01-12|
        |4 |subcl2|None|None|nn.nn  |managed|online|complete   |fd01:13::0.|fd01:13::2   |fd01:13::11|fd01:13::1  |fd01:11::1  | 2    |2021-01-09|2021-01-12|
        +--+------+----+----+-------+-------+------+-----------+-----------+-------------+-----------+------------+------------+------+----------+----------+

-   To show the details of a subcloud group, use the following command:

    .. code-block:: none

        ~(keystone_admin)]$ dcmanager subcloud-group show

    For example,

    .. code-block:: none

        ~(keystone_admin)]$ dcmanager subcloud-group show Group1
        +------------------------+----------------------------+
        | Field                  | Value                      |
        +------------------------+----------------------------+
        | id                     | 2                          |
        | name                   | Group1                     |
        | description            | subcloud 3 and 4           |
        | update apply type      | parallel                   |
        | max parallel subclouds | 2                          |
        | created_at             | 2021-01-12 18:57:38.382269 |
        | updated_at             | None                       |
        +------------------------+----------------------------+

-   To update the attributes and associate a subcloud with a specific subcloud
    group, use the following command, for example:

    .. code-block:: none

        ~(keystone_admin)]$ dcmanager subcloud update --group Group1 Subcloud1
        usage: dcmanager subcloud update [-h] [-f {json,shell,table,value,yaml}]
                                         [-c COLUMN] [--max-width <integer>]
                                         [--fit-width] [--print-empty] [--noindent]
                                         [--prefix PREFIX] [--description DESCRIPTION]
                                         [--location LOCATION] [--group GROUP]
                                         [--install-values INSTALL_VALUES]
                                         [--bmc-password BMC_PASSWORD]
                                         subcloud

-   A subcloud must always belong to a subcloud group. In order to remove a
    subcloud from a given group, update its group to be the 'Default' subcloud
    group.

    For example,

    .. code-block:: none

        ~(keystone_admin)]$ dcmanager subcloud update --group Default Subcloud1
        +------------------------------+-----------------------------------+
        | Field                        | Value                             |
        +------------------------------+-----------------------------------+
        | id                           | 665                               |
        | name                         | Subcloud1                         |
        | description                  | Subcloud1                         |
        | location                     | somewhere                         |
        | software_version             | nn.nn                             |
        | management                   | managed                           |
        | availability                 | online                            |
        | deploy_status                | complete                          |
        | management_subnet            | 2607:f160:10:905f:2001::/80       |
        | management_start_ip          | 2607:f160:10:905f:2001:290:0:3000 |
        | management_end_ip            | 2607:f160:10:905f:2001:290:0:3020 |
        | management_gateaway_ip       | 2607:f160:10:905f:2001:290::      |
        | systemcontroller_gateaway_ip | 2607:f160:10:923e:ce:23:0:0       |
        | group_id                     | 1                                 |
        | created_at                   | 2020-11-08T02:04:34.678248        |
        | updated_at                   | 2020-12-03T17:48:59.644206        |
        +------------------------------+-----------------------------------+
