
.. ggg1595963659829
.. _local-linux-account-for-sysadmin:

==================================
Local Linux Account for 'sysadmin'
==================================

This is a local, per-host, sudo-enabled account created automatically when a
new host is provisioned.

This Linux user account is used by the system administrator as it has extended
privileges.


.. _local-linux-account-for-sysadmin-ul-zgk-1wf-mmb:

-   The initial password must be changed immediately when you log in to the
    initial host for the first time.

-   After five consecutive unsuccessful login attempts, further attempts
    are blocked for about five minutes.

Operational complexity: None. The above security hardening features are set by
default \(see :ref:`System Account Password Rules
<system-account-password-rules>` for password rules\).

