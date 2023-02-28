
.. afr1600186951848
.. _ochestration-strategy-using-subcloud-groups:

============================================
Orchestration Strategy Using Subcloud Groups
============================================

When an upgrade, update, or firmware update orchestration strategy is created,
the strategy ensures that the application of software upgrades, and updates are
done in the following order for the subclouds.

The order in which :command:`dcmanager subcloud-group list` displays the
subcloud groups, is the order they are processed by orchestration.


.. _ochestration-strategy-using-subcloud-groups-ol-hzg-q2v-ymb:

#.  First, all subclouds in the default group.

#.  All subclouds in the first, second, and third group, etc.

#.  Subclouds from different groups will never be included in the same stage of
    the strategy to ensure they are not upgraded, updated (patched) at the
    same time.


