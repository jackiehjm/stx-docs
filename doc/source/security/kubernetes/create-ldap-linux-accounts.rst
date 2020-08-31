
.. vaq1552681912484
.. _create-ldap-linux-accounts:

==========================
Create LDAP Linux Accounts
==========================

|prod| includes a script for creating LDAP Linux accounts with built-in
Keystone user support.

.. rubric:: |context|

The :command:`ldapusersetup` command provides an interactive method for
setting up LDAP Linux user accounts with access to StarlingX commands. You
can assign a limited shell or a bash shell.

Users have the option of providing Keystone credentials at login, and can
establish or change Keystone credentials at any time during a session.
Keystone credentials persist for the duration of the session.

Centralized management is implemented using two LDAP servers, one running on
each controller node. LDAP server synchronization is automatic using the
native LDAP content synchronization protocol.

A set of LDAP commands is available to operate on LDAP user accounts. The
commands are installed in the directory /usr/local/sbin, and are available to
any user account in the sudoers list. Included commands are
:command:`lsldap`, :command:`ldapadduser`, :command:`ldapdeleteuser`, and
several others starting with the prefix :command:`ldap`.

Use the command option --help on any command to display a brief help message,
as illustrated below.

.. code-block:: none

    $ ldapadduser --help
    Usage : /usr/local/sbin/ldapadduser <username> <groupname | gid> [uid]
    $ ldapdeleteuser --help
    Usage : /usr/local/sbin/ldapdeleteuser <username | uid>

.. rubric:: |prereq|

For convenience, identify the user's Keystone account user name in |prod-long|.

.. note::
    There is an M:M relationship between a Keystone user account and a user
    Linux account. That is, the same Keystone user account may be used across
    multiple Linux accounts. For example, the Keystone user **tenant user**
    may be used by several Linux users, such as Kam, Greg, and Jim.
    Conversely, contingent on the policy of the organization, 3 Keystone
    cloud users \(Kam, Greg, and Jim\), may be used by a single Linux
    account: **operator**. That is, Kam logs into |prod| with the
    **operator** account, and sources Kam's Keystone user account. Jim does
    the same and logs into |prod| with the **operator** account, but sources
    Jim's Keystone user account.

.. rubric:: |proc|

#.  Log in as **sysadmin**, and start the :command:`ldapusersetup` script.

    .. code-block:: none

        controller-0: ~$ sudo ldapusersetup

#.  Follow the interactive steps in the script.


    #.  Provide a user name.

        .. code-block:: none

            Enter username to add to LDAP:

        For convenience, use the same name as the one assigned for the user's
        Keystone account. \(This example uses **user1**\). When the LDAP user
        logs in and establishes Keystone credentials, the LDAP user name is
        offered as the default Keystone user name.

        .. code-block:: none

            Successfully added user user1 to LDAP
            Successfully set password for user user1


    #.  Specify whether to provide a limited shell or a bash shell.

        .. code-block:: none


            Select Login Shell option # [2]:
            1) Bash
            2) Lshell

        To provide a limited shell with access to the StarlingX CLI only,
        specify the Lshell option.

        If you select Bash, you are offered the option to add the user to the
        sudoer list:

        .. code-block:: none

            Add user1 to sudoer list? (yes/No):

    #.  Specify a secondary user group for this LDAP user.

        .. code-block:: none

            Add user1 to secondary user group (yes/No):

    #.  Change the password duration.

        .. code-block:: none

            Enter days after which user password must be changed [90]:

        .. code-block:: none

            Successfully modified user entry uid=ldapuser1, ou=People, dc=cgcs, dc=local in LDAP
            Updating password expiry to 90 days

    #.  Change the warning period before the password expires.

        .. code-block:: none

            Enter days before password is to expire that user is warned [2]:

        .. code-block:: none

            Updating password expiry to 2 days


On completion of the script, the command prompt is displayed.

.. code-block:: none

    controller-0: ~$


.. rubric:: |result|

The LDAP account is created. For information about the user login process,
see :ref:`Establish Keystone Credentials from a Linux Account
<establish-keystone-credentials-from-a-linux-account>`.

