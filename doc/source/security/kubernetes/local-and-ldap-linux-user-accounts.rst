
.. xgp1595963622893
.. _local-and-ldap-linux-user-accounts:

==============================
Local LDAP Linux User Accounts
==============================

You can manage regular Linux \(shadow\) user accounts on any host in the
cluster using standard Linux commands.


.. _local-and-ldap-linux-user-accounts-ul-zrv-zwf-mmb:

-   Local Linux user accounts should NOT be configured, only use local |LDAP|
    accounts for internal system purposes that would usually not be created by
    an end-user.

-   Password changes are not enforced automatically on the first login, and
    they are not propagated by the system \(only for 'sysadmin'\).

-   **If the administrator wants to provision additional access to the system, it is better to configure local LDAP Linux accounts.**

-   |LDAP| accounts are centrally managed; changes made on any host are
    propagated automatically to all hosts on the cluster.

-   |LDAP| user accounts behave as any local user account. They can be added
    to the sudoers list and can acquire OpenStack administration credentials.

-   The initial password must be changed immediately upon the first login.

-   Login sessions are logged out automatically after about 15 minutes of
    inactivity.

-   The accounts block following five consecutive unsuccessful login
    attempts. They unblock automatically after a period of about five minutes.

-   All authentication attempts are recorded on the file /var/log/auth.log
    of the target host.


.. note::
    For security reasons, it is recommended that ONLY admin level users be
    allowed to |SSH| to the nodes of the |prod|. Non-admin level users should
    strictly use remote |CLIs| or remote web GUIs.

Operational complexity:

.. _local-and-ldap-linux-user-accounts-ul-bsv-zwf-mmb:

-   Passwords aging is automatically configured.

-   |LDAP| user accounts \(operator, admin\) are available by default on
    newly deployed hosts. For increased security, the admin and operator
    accounts must be used from the console ports of the hosts; no |SSH| access
    is allowed.

-   |prod| includes a script for creating |LDAP| Linux accounts with built-in
    Keystone user support. It provides an interactive method for setting up
    |LDAP| Linux user accounts with access to OpenStack commands. You can
    assign a limited shell or a bash shell.


