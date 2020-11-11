
.. ohs1552680649558
.. _viewing-suppressed-alarms-using-the-cli:

====================================
View Suppressed Alarms Using the CLI
====================================

Alarms may be suppressed. List them to determine if any need to be unsuppressed
or otherwise managed.

.. rubric:: |proc|

.. _viewing-suppressed-alarms-using-the-cli-steps-hyn-g1x-nkb:

-   Use the :command:`fm event-suppress-list` CLI command to view a list of
    all currently suppressed alarms.

    This command shows all alarm IDs along with their suppression status.

    .. code-block:: none

        ~(keystone_admin)$ fm event-suppress-list [--nopaging] [--uuid] [--include-unsuppressed]

    where

    **--nopaging**
        disables paged output, see :ref:`CLI Commands and Paged Output <cli-commands-and-paged-output>`

    **--uuid**
        includes the alarm type UUIDs in the output

    **--include-unsuppressed**
        includes unsuppressed alarm types in the output. By default only
        suppressed alarm types are shown.

    For example:

    .. code-block:: none

        [sysadmin@controller-0 ~(keystone_admin)] fm event-suppress-list
        +----------+-------------+
        | Event ID | Status      |
        +----------+-------------+
        | 100.101  | suppressed  |
        | 100.103  | suppressed  |
        | 100.105  | suppressed  |
        | ...      | ...         |
        +----------+-------------+