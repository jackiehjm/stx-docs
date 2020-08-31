
.. lgd1552571882796
.. _overview-of-system-accounts:

=====================================
Overview of StarlingX System Accounts
=====================================

A brief description of the system accounts available in a |prod| system.


.. _overview-of-system-accounts-section-N1001F-N1001C-N10001:

------------------------
Types of System Accounts
------------------------

-   **sysadmin Local Linux Account**
    This is a local, per-host, account created automatically when a new host
    is provisioned. This account has extended privileges and is used by the
    system administrator.

-   **Local Linux User Accounts**
    These are local, regular Linux user accounts that are typically used for
    internal system purposes and generally should not be created by an end
    user.

    If the administrator wants to provision additional access to the system,
    it is better to configure local LDAP Linux accounts.

-   **Local LDAP Linux User Accounts**
    |prod| provides support for Local Ldap Linux User Accounts. Local LDAP
    accounts are centrally managed; changes to local LDAP accounts made on
    any host are propagated automatically to all hosts on the cluster.

    |prod| includes a set of scripts for creating LDAP Linux accounts with
    support for providing Keystone user account credentials. \(The scripts do
    not create Keystone accounts for you. The scripts allow for sourcing or
    accessing the Keystone user account credentials.\)

    The intended use of these accounts is to provide additional admin level
    user accounts \(in addition to sysadmin\) that can SSH to the nodes of
    the |prod|.

    .. note::
        For security reasons, it is recommended that ONLY admin level users
        be allowed to SSH to the nodes of the |prod|. Non-admin level users
        should strictly use remote CLIs or remote web GUIs..

    These Local LDAP Linux user accounts can be associated with a Keystone
    account. You can use the provided scripts to create these Local LDAP
    Linux user accounts and synchronize them with the credentials of an
    associated Keystone account, so that the Linux user can leverage
    StarlingX CLI commands.

-   **Kubernetes Service Accounts**
    |prod| uses Kubernetes service accounts and |RBAC| policies for
    authentication and authorization of users of the Kubernetes API, CLI, and
    Dashboard.

-   **Keystone Accounts**
    |prod-long| uses Keystone for authentication and authorization of users
    of the StarlingX REST APIs, the CLI, the Horizon Web interface and the
    Local Docker Registry. |prod|'s Keystone uses the default local SQL
    Backend.

-   **Remote Windows Active Directory Accounts**
    |prod| can optionally be configured to use remote Windows Active
    Directory Accounts and native Kubernetes |RBAC| policies for
    authentication and authorization of users of the Kubernetes API,
    CLI, and Dashboard.

