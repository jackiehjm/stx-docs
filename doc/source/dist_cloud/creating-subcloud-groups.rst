
.. enf1600200276330
.. _creating-subcloud-groups:

======================
Create Subcloud Groups
======================

When a subcloud is created it is automatically added to the 'Default' subcloud
group, unless the group is specified. Subclouds can be associated with a
particular group when they are created, and that association can be changed to
a different subcloud group, if required.

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

        ~(keystone_admin)]$ dcmanager subcloud-group add --name <<group>>
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
        |3 |subcl1|None|None|20.06  |managed|online|complete   |fd01:12::0.|fd01:12::2   |fd01:12::11|fd01:12::1  |fd01:11::1  | 2    |2021-01-09|2021-01-12|
        |4 |subcl2|None|None|20.06  |managed|online|complete   |fd01:13::0.|fd01:13::2   |fd01:13::11|fd01:13::1  |fd01:11::1  | 2    |2021-01-09|2021-01-12|
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


