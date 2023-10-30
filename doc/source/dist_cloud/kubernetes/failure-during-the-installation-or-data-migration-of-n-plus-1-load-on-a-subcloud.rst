
.. oeo1597292999568
.. _failure-during-the-installation-or-data-migration-of-n-plus-1-load-on-a-subcloud:

===========================================================================
Failure During the Installation or Data Migration of N+1 Load on a Subcloud
===========================================================================

You may encounter some errors during Installation or Data migration of the
**N+1** load on a subcloud. This section explains the errors and the steps
required to fix these errors.

.. contents:: |minitoc|
    :local:
    :depth: 1

Errors can occur due to one of the following:


.. _failure-during-the-installation-or-data-migration-of-n+1-load-on-a-subcloud-ul-j5r-czs-qmb:

-   One or more invalid install values

-   A network error that results in the subcloud being temporarily unreachable

To get detailed information about errors during installation or data migration,
run the :command:`dcmanager subcloud errors <subcloud_name/subcloud_id>` command.

If you are using the web interface, you can get the error details within the
corresponding strategy step or access the comprehensive information related to
the affected subcloud. To do so, navigate to the subcloud view and click
**Distributed Cloud Admin > Cloud Overview**. In the given list of subclouds,
expand a specific subcloud. You can see any error messages at the end of the
details for each subcloud.

**Failure Caused by Install Values**

If the subcloud install values contain an incorrect value, use the following
command to fix it.

.. code-block:: none

    ~(keystone_admin)]$ dcmanager subcloud update <subcloud-name> --install-values <subcloud-install-values-yaml>

This type of failure is recoverable and you can retry the orchestrated
upgrade for each of the failed subclouds using the following procedure:

.. rubric:: |proc|

.. _failure-during-the-installation-or-data-migration-of-n+1-load-on-a-subcloud-ol-lc1-cyr-qmb:

#.  Delete the failed upgrade strategy.

    .. code-block:: none

        ~(keystone_admin)]$ dcmanager upgrade-strategy delete

#.  Create a new upgrade strategy for the failed subcloud.

    .. code-block:: none

        ~(keystone_admin)]$ dcmanager upgrade-strategy create <subcloud-name> --force <additional options>

    .. note::

        If the upgrade failed during the |AIO|-SX upgrade or data migration, the
        subcloud availability status is displayed as 'offline'. Use the
        :command:`--force` option when creating the new strategy.

#.  Apply the new upgrade strategy.

    .. code-block:: none

        ~(keystone_admin)]$ dcmanager upgrade-strategy apply

#.  Verify the upgrade strategy status.

    .. code-block:: none

        ~(keystone_admin)]$ dcmanager strategy-step list

.. _failure-during-the-installation-or-data-migration-of-n+1-load-on-a-subcloud-section-f5f-j1y-qmb:

-----------------------------------------
Failure Post Data Migration on a Subcloud
-----------------------------------------

Once the data migration on the subcloud is completed, the upgrade is activated
and finalized. If failure occurs:


.. rubric:: |proc|

.. _failure-during-the-installation-or-data-migration-of-n+1-load-on-a-subcloud-ul-ogc-cp5-qmb:

-   Get detailed information about errors during activation step by running the
    :command:`dcmanager subcloud errors <subcloud_name/subcloud_id>` command.

-   If you are using the web interface, you can get the error details within the
    corresponding strategy step or access the comprehensive information related to
    the affected subcloud. To do so, navigate to the subcloud view and click **Distributed
    Cloud Admin > Cloud Overview**. In the given list of subclouds, expand a
    specific subcloud. You can see any error messages at the end of the
    details for each subcloud.

-   Check specified log files

-   Follow the recovery procedure. See :ref:`failure-prior-to-the-installation-of-n-plus-1-load-on-a-subcloud`

.. only:: partner

    .. include:: /_includes/distributed-upgrade-orchestration-process-using-the-cli.rest
