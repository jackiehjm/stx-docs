
.. hgc1558615286351
.. _applying-the-update-strategy-for-distributed-cloud:

===============================================
Apply the Update Strategy for Distributed Cloud
===============================================

You can update the platform software across the |prod-dc| system by applying
the update strategy for |prod-dc| Update Orchestration.

.. rubric:: |context|

You can apply the update strategy from the Horizon Web interface or the CLI.
To use the CLI, see :ref:`update-management-for-distributed-cloud`.

.. rubric:: |prereq|

Before you can apply the update strategy to the subclouds:

-   Upload and apply one or more updates to the SystemController / central
    update repository.

-   Install the updates on the SystemController RegionOne.

-   Create the update strategy for subclouds.

-   Optionally adjust the configuration settings for updating nodes.

For more information, see :ref:`Update Management for Distributed Cloud
<update-management-for-distributed-cloud>`.

.. rubric:: |proc|

.. _applying-the-update-strategy-for-distributed-cloud-steps-hrv-4nl-rdb:

Use |prod-dc| patch orchestration to update the subclouds:

#.  Select the **SystemController** region.

#.  Select **Distributed Cloud Admin** \> **Orchestration**.

#.  On the **Orchestration** page, select the **Orchestration Strategy**
    tab.

    .. image:: figures/bqu1525123082913.png
        :width: 1000px

#.  Click **Apply Strategy**.

    To monitor the progress of the overall update orchestration, use the
    **Orchestration Strategy** tab.

    To monitor the progress of host updates on a subcloud, use the **Host
    Inventory** page on the subcloud.

.. seealso::

    :ref:`creating-an-update-strategy-for-distributed-cloud-update-orchestration`

    :ref:`customizing-the-update-configuration-for-distributed-cloud-update-orchestration`

