
.. suc1558616448885
.. _monitoring-subclouds-using-horizon:

===============================
Monitor Subclouds Using Horizon
===============================

You can list subclouds, delete subclouds, and monitor or change the status of
subclouds from the System Controller.

.. rubric:: |proc|

-   To list subclouds, select **Distributed Cloud Admin** \> **Cloud Overview**.

    .. image:: figures/cloud-overview.png
        :width: 800


    You can perform full-text searches or filter by column using the search-bar
    above the subcloud list.

    .. image:: figures/cloud-overview-search.png


-   To perform operations on a subcloud, use the **Actions** menu.

    .. image:: figures/cloud-overview-actions.png

-   To change a Subcloud Group for a specific Subcloud, select the Subcloud
    Group name.

    .. image:: figures/cloud-overview-edit-subcloud.png
        :width: 800

-   Confirm changes and check the new assignment in the Subcloud summary.

    .. image:: figures/cloud-overview-summary.png

    .. caution::

        If you delete a subcloud, then you must reinstall it before you can
        re-add it.

    The **Host Details** menu selection for a subcloud switches to the Horizon
    Web interface for that subcloud. To switch back to the System Controller,
    use the subcloud or region selection menu at the top left of the Horizon
    window.

-   To show detailed information about subcloud ``install/bootstrap/deploy``
    failures, you select Distributed **Cloud Admin** > **Cloud Overview**.

    Then click on dropdown arrow. At the end you can get the subcloud error
    information.

    .. figure:: ./figures/bootrap_failed_regis_horiz.png
        :width: 800
