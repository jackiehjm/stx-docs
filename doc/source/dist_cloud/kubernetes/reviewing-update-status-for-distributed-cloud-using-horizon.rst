
.. dma1558616138777
.. _reviewing-update-status-for-distributed-cloud-using-horizon:

========================================================
Review Update Status for Distributed Cloud Using Horizon
========================================================

You can review updates across the |prod-dc| from the Horizon Web interface.

.. rubric:: |context|

If you prefer, you can use the |CLI|. For more information, see :ref:`Reviewing
Update Status for Distributed Cloud Using the CLI
<reviewing-update-status-for-distributed-cloud-using-the-cli>`.

From Horizon, you can use only the **SystemController** region to
review updates in the central update repository and the update sync status of
subclouds.

.. rubric:: |proc|

#.  Select the **SystemController** region.

#.  Select **Distributed Cloud Admin** \> **Software Management**.

#.  On the **Software Management** page, select the **Patches** tab.

    .. image:: figures/tmj1525095688715.png
        :width: 1000px

    .. note::

        The Patch State indicates whether the patch is available,
        partially-applied or applied. Applied indicates that the update has
        been installed on all hosts of the cloud \(SystemController in this
        case\).

#.  Check the Update Sync Status of the subclouds.

    Update \(or Patch\) Sync Status is part of the overall Sync status of a
    subcloud. To review the synchronization status of subclouds, see
    :ref:`Monitoring Subclouds Using Horizon
    <monitoring-subclouds-using-horizon>`.

.. rubric:: |postreq|

To update the SystemController's central update repository, see :ref:`Reviewing
Update Status for Distributed Cloud Using the CLI
<reviewing-update-status-for-distributed-cloud-using-the-cli>`.

