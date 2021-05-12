
.. huk1552935670048
.. _starlingx-system-accounts-system-account-password-rules:

=============================
System Account Password Rules
=============================

|prod| enforces a set of strength requirements for new or changed passwords.

The following rules apply to all System Accounts \(Local LDAP, sysadmin,
other Linux Accounts, and Keystone accounts\):


.. _starlingx-system-accounts-system-account-password-rules-ul-evs-dsn-ynb:

-   The password must be at least seven characters long.

-   You cannot reuse the last 2 passwords in history.

-   The password must contain:


    -   at least one lower-case character

    -   at least one upper-case character

    -   at least one numeric character

    -   at least one special character


The following additional rules apply to Local Linux accounts only \(Local
LDAP, sysadmin, and other Linux accounts\):

.. _starlingx-system-accounts-system-account-password-rules-ul-rvj-jsn-ynb:

-   A changed password must differ from the previous password by at least three
    characters.

    .. note::

        This rule does not apply when the root user changes the password for
        other users, including sudo to root, to change other account's password.

-   A changed password using only character case differences is not allowed.
    For example, if nEtw!rk5 is the current password, Netw!RK5 is not allowed as
    the new password.

    .. note::

        This rule does not apply when the root user changes the password for
        other users, including sudo to root, to change other account's password.

-   After five consecutive incorrect password attempts, the user is locked
    out for 5 minutes.

    .. note::

        This rule does not apply to the root user.
