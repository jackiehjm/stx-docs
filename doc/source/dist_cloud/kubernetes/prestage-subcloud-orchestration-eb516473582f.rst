.. _prestage-subcloud-orchestration-eb516473582f:

===============================
Prestage Subcloud Orchestration
===============================

This section describes the prestage strategy for a single subcloud, default
subcloud group or a specific subcloud group.

.. rubric:: |prereq|

For more information on prerequisites for prestage upgrade and reinstall, see
:ref:`prestage-a-subcloud-using-dcmanager-df756866163f`.


   ..note::

      Any existing strategy must be deleted first as only one type
      of strategy can exist at a time.

   .. only:: partner

      .. include:: /_includes/prestage-subcloud-orchestration-eb516473582f.rest
         :start-after: strategy-begin
         :end-before: strategy-end

.. rubric:: |proc|

#.  Create a prestage strategy.

    Prestage strategy can be created for a single subcloud, the default
    subcloud group (all subclouds), or a specific subcloud group.

    To create a prestage strategy for a specific subcloud, use the following
    command:

    .. code-block:: none

        ~(keystone_admin)]$ dcmanager prestage-strategy create subcloud1

        Enter the sysadmin password for the subcloud:
        Re-enter sysadmin password to confirm:

        +-----------------------------+----------------------------+
        | Field                       | Value                      |
        +-----------------------------+----------------------------+
        | id                          | 1                          |
        | name                        | subcloud1                  |
        | description                 | None                       |
        | location                    | False                      |
        | software_version            | nn.nn                      |
        | management                  | managed                    |
        | availability                | online                     |
        | deploy_status               | prestage-prepare           |
        | management_subnet           | 2620:10a:a001:ac01::20/123 |
        | management_start_ip         | 2620:10a:a001:ac01::22     |
        | management_end_ip           | 2620:10a:a001:ac01::3e     |
        | management_gateway_ip       | 2620:10a:a001:ac01::21     |
        | systemcontroller_gateway_ip | 2620:10a:a001:a113::1      |
        | group_id                    | 3                          |
        | created_at                  | 2202-03-18 20:31:16.548903 |
        | updated_at                  | 2202-03-22 18:55:56:251643 |
        +-----------------------------+----------------------------+

    To create a prestage strategy for the default subcloud group, use the
    following command:

    .. code-block:: none

        ~(keystone_admin)]$ dcmanager prestage-strategy create
        Enter the sysadmin password for the subcloud:
        Re-enter sysadmin password to confirm:

        +------------------------+-----------------------------+
        | Field                  | Value                       |
        +------------------------+-----------------------------+
        | strategy type          | prestage                    |
        | subcloud apply type    | parallel                    |
        | max parallel subclouds | 50                          |
        | stop on failure        | False                       |
        | state                  | initial                     |
        | created_at             | 2202-03-22T18:54:45.037336  |
        | updated_at             | None                        |
        +------------------------+-----------------------------+

    To create a prestage strategy for a specific subcloud group, use the
    following command:

    .. code-block:: none

        ~(keystone_admin)]$ dcmanager prestage-strategy create –group First_10_Subclouds

        Enter the sysadmin password for the subcloud:
        Re-enter sysadmin password to confirm:

        +------------------------+-----------------------------+
        | Field                  | Value                       |
        +------------------------+-----------------------------+
        | strategy type          | prestage                    |
        | subcloud apply type    | parallel                    |
        | max parallel subclouds | 10                          |
        | stop on failure        | False                       |
        | state                  | initial                     |
        | created_at             | 2202-03-22T18:54:45.037336  |
        | updated_at             | None                        |
        +------------------------+-----------------------------+

    .. note::

        Unlike other types of orchestration, prestage orchestration requires
        sysadmin password as all communications with the subclouds are done
        using ansible over the oam network to avoid disruptions to management
        traffic.

#.  Apply the strategy.

    .. code-block:: none

        ~(keystone_admin)]$ dcmanager prestage-strategy apply

        +------------------------+-----------------------------+
        | Field                  | Value                       |
        +------------------------+-----------------------------+
        | strategy type          | prestage                    |
        | subcloud apply type    | None                        |
        | max parallel subclouds | None                        |
        | stop on failure        | False                       |
        | state                  | applying                    |
        | created_at             | 2202-03-22T18:33:20:100712  |
        | updated_at             | 2202-03-22T18:36:03.895542  |
        +------------------------+-----------------------------+

#.	Monitor the progress of the strategy.

    .. code-block:: none

        ~(keystone_admin)]$ dcmanager strategy-step list

        +-----------+-------+---------------------+---------+----------------------------+-------------+
        | cloud     | stage | state               | details | started_at                 | finished_at |
        +-----------+-------+---------------------+---------+----------------------------+-------------+
        | subcloud1 |   1   | prestaging-packages |         | 2202-03-22 18:55:11.523970 | None        |
        +-----------+-------+---------------------+---------+----------------------------+-------------+

#.  (Optional) Abort the strategy, if required.

    The abort command can be used to abort the prestage orchestration strategy
    after the current step of the currently applying state is completed.

#.  Delete the strategy.

    .. code-block:: none

        ~(keystone_admin)]$ dcmanager prestage-strategy delete

        +------------------------+-----------------------------+
        | Field                  | Value                       |
        +------------------------+-----------------------------+
        | strategy type          | prestage                    |
        | subcloud apply type    | None                        |
        | max parallel subclouds | None                        |
        | stop on failure        | False                       |
        | state                  | deleting                    |
        | created_at             | 2202-03-22T19:09:03.576053  |
        | updated_at             | 2202-03-22T19:09:09.436732  |
        +------------------------+-----------------------------+

--------------------------------------------
Troubleshoot Subcloud Prestage Orchestration
--------------------------------------------

If an orchestrated prestage fails for a subcloud, check the log specified in
the error message for reasons of failure. After the issue has been resolved,
prestage can be retried using one of the following options:

.. rubric:: |proc|

-   Run :command:`dcmanager subcloud prestage` command on the failed subcloud.

-   Create a subcloud group, for example, ``prestage-retry``, add the failed
    subcloud(s) to group ``prestage-retry``, and finally create and apply the
    prestage strategy for the group.

    .. warning::

        Do not retry orchestration with an existing group unless the subclouds
        that have been successfully prestaged are removed from the group.
        Otherwise, prestage will be repeated for ALL subclouds in the group.

For more information on the following, see
:ref:`prestage-a-subcloud-using-dcmanager-df756866163f`

-  Upload Prestage Image List

-  Single Subcloud Prestage

-  Rerun Subcloud Prestage

-  Verify Subcloud Prestage

-  Verifying Usage of Prestaged Data
