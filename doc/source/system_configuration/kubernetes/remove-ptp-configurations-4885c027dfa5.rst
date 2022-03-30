.. _remove-ptp-configurations-4885c027dfa5:

=========================
Remove PTP Configurations
=========================

Disable a PTP instance
======================

To disable a |PTP| instance without removing any configuration, simply remove
the association with a given host. This can be useful for troubleshooting or
testing different configurations.

#. Remove the host association.

   .. code-block::

      ~(keystone_admin)]$ system host-ptp-instance-remove <hostname> <ptp-instance-name>

#. Apply the configuration.

   .. code-block::

      ~(keystone_admin)]$ system ptp-instance-apply

Remove a PTP Instance
=====================

Instances, interfaces and parameters can all be removed with associated
``-delete`` commands. In some cases, the system will alert that a unit cannot
be deleted because a dependent unit is still associated with it. For example,
a |PTP| instance cannot be deleted if there are still interfaces assigned to
it, so the interfaces must be removed first. In such cases, remove the
dependent unit first.
