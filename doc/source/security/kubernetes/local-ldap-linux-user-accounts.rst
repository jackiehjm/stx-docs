
.. eof1552681926485
.. _local-ldap-linux-user-accounts:

==============================
Local LDAP Linux User Accounts
==============================

You can create regular Linux user accounts using the |prod| LDAP service.

LDAP accounts are centrally managed; changes made on any host are propagated
automatically to all hosts on the cluster.

The intended use of these accounts is to provide additional admin level user
accounts \(in addition to sysadmin\) that can SSH to the nodes of the |prod|.

.. note::
    For security reasons, it is recommended that ONLY admin level users be
    allowed to SSH to the nodes of the |prod|. Non-admin level users should
    strictly use remote CLIs or remote web GUIs.

Apart from being centrally managed, LDAP user accounts behave as any local
user account. They can be added to the sudoers list, and can acquire
Keystone administration credentials when executing on the active controller.

LDAP user accounts share the following set of attributes:


.. _local-ldap-linux-user-accounts-ul-d4q-g5c-5p:

-   The initial password is the name of the account.

-   The initial password must be changed immediately upon first login.

-   For complete details on password rules, see :ref:`System Account Password Rules <starlingx-system-accounts-system-account-password-rules>`.

-   Login sessions are logged out automatically after about 15 minutes of
    inactivity.

-   The accounts are blocked following five consecutive unsuccessful login
    attempts. They are unblocked automatically after a period of about five
    minutes.

-   All authentication attempts are recorded on the file /var/log/auth.log
    of the target host.

-   Home directories and passwords are backed up and restored by the system
    backup utilities. Note that only passwords are synced across hosts \(both
    LDAP users and **sysadmin**\). Home directories are not automatically synced
    and are local to that host.


The following LDAP user accounts are available by default on newly deployed
hosts, regardless of their personality:

**operator**
    A cloud administrative account, comparable to the default **admin**
    account used in the web management interface.

    This user account operates on a restricted Linux shell, with very
    limited access to native Linux commands. However, the shell is
    preconfigured to have administrative access to StarlingX commands.

**admin**
    A host administrative account. It has access to all native Linux
    commands and is included in the sudoers list.

For increased security, the **admin** and **operator** accounts must be used
from the console ports of the hosts; no SSH access is allowed.


.. _local-ldap-linux-user-accounts-ul-h22-ql4-tz:

-   These accounts serve as system access redundancies in the event that SSH
    access is unavailable. In the event of any issues with connectivity, user
    lockout, or **sysadmin** passwords being forgotten or not getting propagated
    properly, the presence of these accounts can be essential in gaining access
    to the deployment and rectifying things. This is why these accounts are
    restricted to the console port only, as a form of “manual over-ride.” The
    **operator** account enables access to the cloud deployment only, without
    giving unabated sudo access to the entire system.


