.. _enable-apparmor-log-bb600560d794:

===================
Enable AppArmor Log
===================

AppArmor usually outputs messages when it is interacting with an application
and if there are AppArmor denied messages. A message is logged, via the Linux
Auditing System, when a profile is in complain mode and application tries to
access denied resources. The Linux Auditing System is disabled in the |prod|
kernel by default. To enable it, please refer to :ref:`Enable Auditd in the
Kernel <auditd-support-339a51d8ce16>`.

.. note::

    Enabling Auditd in the kernel is necessary for AppArmor logging. User do
    NOT need to install Auditd system application.

Once enabled, the logged message can be seen at ``/var/log/kern.log``.

.. code-block:: none

    2023-02-01T01:48:45.412 controller-0 kernel: notice [ 4028.407687] audit: type=1400 audit(1675216125.410:3110): apparmor="ALLOWED" operation="open" profile="test-profile" name="/proc/1/attr/current" pid=331323 comm="cat" requested_mask="r" denied_mask="r" fsuid=0 ouid=0

If  auditd system application is installed as described in :ref:`Start Auditd
System Application <auditd-support-339a51d8ce16>`, the messages are logged at
``/var/log/audit/audit.log``.




