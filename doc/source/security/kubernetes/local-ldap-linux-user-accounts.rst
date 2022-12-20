
.. eof1552681926485
.. _local-ldap-linux-user-accounts:

==============================
Local LDAP Linux User Accounts
==============================

You can create regular Linux user accounts using the |prod| |LDAP| service.

Local |LDAP| accounts are centrally managed on the active controller;  all
hosts in the cloud/cluster use the Local |LDAP| server on the active controller
for |SSH| and Console authentication.

The intended use of these accounts is to provide additional admin level user
accounts \(in addition to sysadmin\) that can |SSH| to the nodes of the |prod|.

.. note::
    For security reasons, it is recommended that ONLY admin level users be
    allowed to |SSH| to the nodes of the |prod|. Non-admin level users should
    strictly use remote |CLIs| or remote web GUIs.

Apart from being centrally managed, Local |LDAP| user accounts behave as any
local user account. They can be added to the sudoers list, and can acquire
Keystone administration credentials, Kubernetes kubectl, and helm
administrative commands as the Kubernetes admin user, when executing on the
active controller.

Local |LDAP| user accounts share the following set of attributes:


.. _local-ldap-linux-user-accounts-ul-d4q-g5c-5p:

-   The initial password is the name of the account.

-   The initial password must be changed immediately upon first login.

-   For complete details on password rules, see :ref:`System Account
    Password Rules <starlingx-system-accounts-system-account-password-rules>`.

-   Login sessions are logged out automatically after about 15 minutes of
    inactivity.

-   After each unsuccessful login attempt, a 3 second delay is imposed before
    making another attempt. After five consecutive unsuccessful login attempts,
    further attempts are blocked for about five minutes. On further attempts
    within 5 minutes, the system will display a message such as:

    ``Account locked due to 6 failed logins``

    .. note::

        This delay is 3 seconds.

        You are alerted on the 6th and subsequent attempts:

        ``Account locked due to 6 failed logins``

        and an error message is displayed on subsequent attempts.

        When you login to the console you are alerted on the 6th, and subsequent
        attempts:

        ``The account is locked due to 5 failed logins (2 minutes left to unlock)``

        When you login remotely using SSH, you have 3 attempts to try and login
        before an error ``Permission denied (publickey,password)`` is displayed,
        during an SSH login session. You can continue to login by starting a new
        login session, until the user is locked out after 5 consecutive failed
        attempts. For security reasons, there is no reason or error displayed to
        the user.

        5 mins after the account is locked, the failed attempts will be reset
        and failed attempts re-counted.

-   All authentication attempts are recorded on the file /var/log/auth.log
    of the target host.

-   Home directories and passwords are backed up and restored by the system
    backup utilities. Note that only passwords are synced across hosts (both
    |LDAP| users and **sysadmin**). Home directories are not automatically
    synced and are local to that host.


.. _local-ldap-linux-user-accounts-section-kts-bvh-ynb:

--------------------------
Default LDAP User Accounts
--------------------------

The following Local |LDAP| user accounts are available by default on newly
deployed hosts, regardless of their personality:

**operator**
    A cloud administrative account, comparable to the default **admin**
    account used in the web management interface.

    This user account has access to all native Linux commands not requiring
    root or sudo privileges, and it's shell is preconfigured to have
    administrative access to StarlingX commands.

**admin**
    A host administrative account. It has access to all native Linux
    commands and is included in the sudoers list.

For increased security, the **admin** and **operator** accounts must be used
from the console ports of the hosts; no |SSH| access is allowed.


.. _local-ldap-linux-user-accounts-ul-h22-ql4-tz:

-   These accounts serve as system access redundancies in the event that |SSH|
    access is unavailable. In the event of any issues with connectivity, user
    lockout, or **sysadmin** passwords being forgotten or not getting propagated
    properly, the presence of these accounts can be essential in gaining access
    to the deployment and rectifying things. This is why these accounts are
    restricted to the console port only, as a form of “manual over-ride.” The
    **operator** account enables access to the cloud deployment only, without
    giving unabated sudo access to the entire system.

.. seealso::

    :ref:`Create LDAP Linux Accounts <create-ldap-linux-accounts>`
