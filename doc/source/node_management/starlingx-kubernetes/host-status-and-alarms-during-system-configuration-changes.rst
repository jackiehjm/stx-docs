
.. qze1552674439161
.. _host-status-and-alarms-during-system-configuration-changes:

==========================================================
Host Status and Alarms During System Configuration Changes
==========================================================

For all types of configuration changes, alarms and status messages appear
while the system is in transition. You can use the information provided by
these messages to help guide the transition successfully.

Configuration changes may require multiple hosts to be reconfigured, during
which the settings across the cluster are not consistent. This causes alarms
to be raised for the system.

.. _host-status-and-alarms-during-system-configuration-changes-ul-uyz-tt5-4q:

-   Changes to the DNS server configuration cause transitory alarms. These
    alarms are cleared automatically when the configuration change is applied.

-   Changes to the External |OAM| network IP addresses or |NTP| server
    addresses, and in particular to the controller storage allotments, cause
    persistent alarms. These alarms must be cleared manually, by locking and
    unlocking the affected hosts or performing other administrative actions.


Alarms appear on the Fault Management page of the Horizon web interface, and
related status messages appear on the Hosts tab on the Host Inventory page.
A variety of alarms can be reported on the Fault Management page, depending
on the configuration change.

.. caution::
    To help identify alarms raised during a configuration change, ensure that
    any existing system alarms are cleared before you begin.

On the Hosts tab of the Host Inventory page, the status **Config out-of-date**
is shown for hosts affected by a configuration change. Each host with this
status must be locked and then unlocked to update its configuration and clear
the alarm.
