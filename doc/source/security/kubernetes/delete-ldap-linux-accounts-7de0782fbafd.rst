.. _delete-ldap-linux-accounts-7de0782fbafd:

==========================
Delete LDAP Linux Accounts
==========================

The following steps describe the procedure to delete |LDAP| Linux accounts.

#.  Log in as **sysadmin**, and create a new LDAP user, if not already created.

    .. code-block:: none

        ~(keystone_admin)]$ sudo ldapusersetup


#.  Check that the Linux user has been created on |prod| using one of the
    commands:

    .. code-block:: none

        id <username>

    .. code-block:: none

        getent passwd <username>

#.  SSH to |prod| as the new |LDAP| user and change the initial password when
    prompted at first login.

    .. note::

        This step is only required for new users that were never used to login
        the platform.

#.  Check that the home directory was created as ``/home/<username>``.

#.  Delete |LDAP| user.

    .. code-block:: none

        ~(keystone_admin)]$ sudo ldapdeleteuser <username>

#.  Check that the |LDAP| user was removed from the local |LDAP| server.

    .. code-block:: none

        ~(keystone_admin)]$ sudo ldapsearch -x -LLL -b dc=cgcs,dc=local

    or

    .. code-block:: none

        ~(keystone_admin)]$ sudo ldapfinger <username>

    .. note::

        SSSD service will sync-up |LDAP| linux users from the |LDAP| server,
        and this might take several minutes because is done according to
        ``ldap_enumeration_refresh_timeout`` time interval setting.

#.  Check that the local |LDAP| Linux user was removed from the cloud platform.

    .. code-block:: none

        ~(keystone_admin)]$ id <username>

    or

    .. code-block:: none

        ~(keystone_admin)]$ getent passwd <username>

#.  Check that the Linux home directory still exists after the user has
    been removed.

    The Linux home directories of the deleted Linux |LDAP| users will be
    managed by the system administrator. The platform will not remove them
    together with the removal of the user.
