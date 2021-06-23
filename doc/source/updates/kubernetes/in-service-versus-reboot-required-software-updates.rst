
.. gwe1552920505159
.. _in-service-versus-reboot-required-software-updates:

==================================================
In-Service Versus Reboot-Required Software Updates
==================================================

In-Service \(Reboot-not-Required\) and a Reboot-Required software updates are
available depending on the nature of the update to be performed.

In-Service software updates provides a mechanism to issue updates that do not
require a reboot, allowing the update to be installed on in-service nodes and
restarting affected processes as needed.

Depending on the area of software being updated and the type of software
change, installation of the update may or may not require the |prod| hosts to
be rebooted. For example, a software update to the kernel would require the
host to be rebooted in order to apply the update. Software updates are
classified as reboot-required or reboot-not-required \(also referred to as
in-service\) type updates to indicate this. For reboot-required updates, the
hosted application pods are automatically relocated to an alternate host as
part of the update procedure, prior to applying the update and rebooting the
host.
