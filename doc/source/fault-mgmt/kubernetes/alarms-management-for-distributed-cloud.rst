
.. gge1558616301307
.. _alarms-management-for-distributed-cloud:

=======================================
Alarms Management for Distributed Cloud
=======================================

The System Controller collects alarm summaries from subclouds.

You can monitor and review a summary count of alarms from all systems by using
either the CLI or the Horizon Web interface.

The System Controller polls all subclouds periodically for alarm summaries.

Alarm summaries are gathered if a subcloud is online. However, they are not
gathered for a subcloud that has never been moved to the Managed state. In
this case, alarm counts are not available for the subcloud and dashes are shown
instead.

You can access detailed alarm information for a subcloud from the System
Controller page by clicking **Alarm and Event Details** for the subcloud from
Horizon. This action automatically switches from the interface from the System
Controller page to the subcloud page.
