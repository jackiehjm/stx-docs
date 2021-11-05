
.. vaq1552681912484
.. _create-ldap-linux-accounts:

==========================
Create LDAP Linux Accounts
==========================

|prod| includes a script for creating |LDAP| Linux accounts.

.. rubric:: |context|

.. note::
    For security reasons, it is recommended that ONLY admin level users be
    allowed to |SSH| to the nodes of the |prod|. Non-admin level users should
    strictly use remote |CLIs| or remote web GUIs.

The :command:`ldapusersetup` command provides an interactive method for setting
up |LDAP| Linux user accounts.

Centralized management is implemented using two |LDAP| servers, one running on
each controller node. |LDAP| server synchronization is automatic using the
native |LDAP| content synchronization protocol.

A set of |LDAP| commands is available to operate on |LDAP| user accounts. The
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

.. rubric:: |proc|

#.  Log in as **sysadmin**, and start the :command:`ldapusersetup` script.

    .. code-block:: none

        controller-0: ~$ sudo ldapusersetup

#.  Follow the interactive steps in the script.


    #.  Provide a user name.

        .. code-block:: none

            Enter username to add to |LDAP|:

        .. code-block:: none

            Successfully added user user1 to |LDAP|
            Successfully set password for user user1


    #.  Specify  a secondary user group for this |LDAP| user.

        .. code-block:: none

            Add user1 to secondary user group (yes/No):

    #.  Change the password duration.

        .. code-block:: none

            Enter days after which user password must be changed [90]:

        .. code-block:: none

            Successfully modified user entry uid=ldapuser1, ou=People, dc=cgcs, dc=local in |LDAP|
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

The |LDAP| account is created. For information about the user login process,
see :ref:`For StarlingX and Platform OpenStack CLIs from a Local LDAP Linux
Account Login <establish-keystone-credentials-from-a-linux-account>`.

