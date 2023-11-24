
.. lgd1552571882796
.. _overview-of-system-accounts:

===================
Linux User Accounts
===================

A brief description of the system accounts available in a |prod| system.


**Sysadmin Local Linux Account**
    This is a local, per-host, sudo-enabled account created automatically when
    a new host is provisioned. It is used by the primary system administrator
    for |prod|, as it has extended privileges.

    See :ref:`The sysadmin Account <the-sysadmin-account>` for more details.

**Local Linux User Accounts**
    Local Linux User Accounts should NOT be created since they are used for
    internal system purposes.

**Local LDAP Linux User Accounts**
    These are local LDAP accounts that are centrally managed across all hosts
    in the cluster. These accounts are intended to provide additional admin
    level user accounts (in addition to sysadmin) that can SSH to the nodes
    of the |prod|.

    See :ref:`Local LDAP Linux User Accounts <local-ldap-linux-user-accounts>`
    and :ref:`Manage Composite Local LDAP Accounts at Scale
    <manage-local-ldap-39fe3a85a528>` for more details.

    .. note::
        For security reasons, it is recommended that ONLY admin level users be
        allowed to |SSH| to the nodes of the |prod|. Non-admin level users should
        strictly use remote |CLIs| or remote web GUIs.

For more information, refer to the following:

.. toctree::
   :maxdepth: 1

   the-sysadmin-account
   local-ldap-linux-user-accounts
   create-ldap-linux-accounts
   delete-ldap-linux-accounts-7de0782fbafd
   remote-access-for-linux-accounts
   password-recovery-for-linux-user-accounts
   estabilish-credentials-for-linux-user-accounts
   establish-keystone-credentials-from-a-linux-account
   starlingx-openstack-kubernetes-from-stsadmin-account-login
   kubernetes-cli-from-local-ldap-linux-account-login
   manage-local-ldap-39fe3a85a528
