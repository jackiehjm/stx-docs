.. _handling-maintenance-heartbeat-failure-for-active-controller-service-activation-70fb51663717:

=============================================================================
Handle Maintenance Heartbeat Failure for Active Controller Service Activation
=============================================================================

Maintenance is started by Service Management (along with other active
controller services) based on one of the following 3 events:

-   on initial controller activity startup, or

-   on a controlled or uncontrolled controller |SWACT|, or

-   on active controller selection following a double controller reboot/power
    outage; i.e. |DOR|

In such events, Maintenance process startup queries System Inventory for a list
of provisioned hosts along with their configuration and state information.

Hosts that are found to be in the unlocked/enabled state are expected to
service Maintenance heartbeat.

However, the uptime on the active controller can impact how quickly Maintenance
reacts to unlocked-enabled hosts that fail heartbeat following controller
services activation.

If the active controller reboots or loses power, then the standby controller
takes over by way of an uncontrolled |SWACT|.

**Greater than 15 minute uptime**: When maintenance starts on a controller whose
uptime is greater than 15 minutes, any host found to be in the unlocked/enabled
state and not servicing heartbeat will be given a 5 second grace period before
Maintenance declares the node failed and puts it into **Graceful Recovery**.

**Graceful Recovery** is a maintenance heartbeat failure state capable of avoiding
a second reboot if the host was found to have already rebooted upon heartbeat
loss recovery.

If both controllers reboot or lose power, then Service Management will start
services on the first healthy controller following the outage.

**Less than 15 minute uptime**: When maintenance starts on a controller whose
uptime is less than 15 minutes, it assumes the system is in |DOR| mode.
Maintenance is more tolerant of unlocked/enabled hosts that are not immediately
servicing heartbeat following maintenance process startup in |DOR| mode.
Instead of failing a node after 5 seconds, it waits up to 10 minutes to give
servers a longer grace period to recover, knowing that power outage recovery
time can vary from server to server.


