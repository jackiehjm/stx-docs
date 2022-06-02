
.. thp1552681882191
.. _password-recovery-for-linux-user-accounts:

=========================================
Password Recovery for Linux User Accounts
=========================================

You can reset the password for a Linux user if required. The procedure
depends on the class of user.


.. _password-recovery-for-linux-user-accounts-section-N1001F-N1001C-N10001:

------------------
Linux System Users
------------------

This class includes the **sysadmin** account, and optionally other Linux
system user accounts created to support a multi-admin scenario. If another
Linux system account is available, you can use it to reset the password for
this type of account as follows:

.. code-block:: none

    $ sudo passwd <user>
    $ sudo chage -d 0 <user>

where `<user>` is the user name of the account to be reset \(for, example,
**sysadmin**\) and :command:`sudo passwd <user>` will prompt for the new
password. The :command:`chage` command forces immediate expiration, so that
the user must change the password at first login.

If no other Linux system user accounts have been created, you can recover
using the default LDAP **operator** or **admin** accounts. For more
information, see :ref:`Local LDAP Linux User Accounts
<local-ldap-linux-user-accounts>`.


.. _password-recovery-for-linux-user-accounts-section-N10066-N1001C-N10001:

-----------------
LDAP System Users
-----------------

This class includes users created using LDAP utilities.

You can reset the password for an LDAP account as follows:

.. code-block:: none

    $ sudo ldapmodifyuser <user> replace userPassword <temp_password>
    $ sudo ldapmodifyuser <user> replace shadowLastChange 0

where <user> is the username, and <temp\_password> is a temporary password.
The second command forces a password change on first login.

