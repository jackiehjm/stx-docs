
.. czv1600179275955
.. _managing-subcloud-groups:

======================
Manage Subcloud Groups
======================

Subclouds can be organized into subcloud groups. These subcloud groups can
control how subclouds are updated.

When a subcloud is created it is automatically added to the 'Default' subcloud
group, unless the group is specified. Subclouds can be associated with a
particular group when they are created, and that association can be changed to
a different subcloud group, if required. To create a subcloud group, see,
:ref:`Creating Subcloud Groups <creating-subcloud-groups>`.

For example, while creating a strategy, if several subclouds can be upgraded or
updated in parallel, they can be grouped together in a subcloud group that
supports parallel upgrades or updates. In this case, the
:command:`max_parallel_subclouds`, and :command:`subcloud_apply_type` are
**not** specified when the strategy is created, so that the settings in the
subcloud group are used.

Alternatively, if several subclouds should be upgraded or updated individually,
they can be grouped together in a subcloud group that supports serial updates.
In this case, the :command:`max_parallel_subclouds`,
and:command:`subcloud_apply_type` are **not** specified when creating the
strategy, and the subcloud group settings for
:command:`max_parallel_subclouds` (not applicable), and the
:command:`subcloud_apply_type` (serial) associated with that subcloud group
are used.

For more information on creating a strategy for orchestration upgrades, updates
or firmware updates, see:


.. _managing-subcloud-groups-ul-a3s-nqf-1nb:

-   To create an upgrade orchestration strategy use the :command:`dcmanager
    upgrade-strategy create` command.

.. xbooklink For more information see, :ref:`Distributed
    Upgrade Orchestration Process Using the CLI
    <distributed-upgrade-orchestration-process-using-the-cli>`.

-   To create an update (patch) orchestration strategy use the
    :command:`dcmanager patch-strategy create` command.

.. xbooklink For more information see,
    :ref:`Creating an Update Strategy for Distributed Cloud Update Orchestration
    <creating-an-update-strategy-for-distributed-cloud-update-orchestration>`.

-   To create a firmware update orchestration strategy use the
    :command:`dcmanager fw-update-strategy create` command.

.. xbooklink For more information
    see, :ref:`Device Image Update Orchestration
    <device-image-update-orchestration>`.

.. seealso::

    :ref:`Creating Subcloud Groups <creating-subcloud-groups>`

    :ref:`Orchestration Strategy Using Subcloud Groups <ochestration-strategy-using-subcloud-groups>`


