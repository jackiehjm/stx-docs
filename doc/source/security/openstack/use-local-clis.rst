
.. tok1566218039402
.. _use-local-clis:

==============
Use Local CLIs
==============

|prod-os| administration and other tasks can be carried out from the
command-line interface (|CLI|).

.. rubric:: |context|

.. warning::
    For security reasons, only administrative users should have |SSH|
    privileges.

You can access |prod-os| via container-backed Local |CLIs| from the active
controller node's local console or by |SSH|-ing to the |OAM| Floating IP
Address.

This procedure shows how to obtain the credentials to access Local |CLIs|,
depending on your account type, and provides guidance on how to customize
|prod-os|-specific resources and switch between |prod| and |prod-os| |CLI|
contexts.

.. rubric:: |prereq|

In order for you to perform this procedure, you will need an account that is
either:

*   the **Sysadmin Local Linux Account**; or
*   a **Local LDAP Linux User Account**.

The **Sysadmin Local Linux Account** is the account that, by default, has
access to the credentials of the Keystone user **admin** that comes pre-created
with |prod-os|.

A **Local LDAP Linux User Account**, on the other hand, is an account with SSH
privileges that is typically configured with only access to the credentials of
a Keystone user *who has the same username* as the |LDAP| account. To create
such a composite Local |LDAP| and Keystone user account, see
:ref:`Manage Composite Local LDAP Accounts at Scale <manage-local-ldap-39fe3a85a528>`.

.. important::
    The Local |LDAP| Linux User Account *must* be a member of the |LDAP| group
    **openstack** to have access to the |prod-os| configuration files. This
    group is automatically created and made available after |prod-os| is
    applied on the platform.

    You can add an |LDAP| account to the |LDAP| group **openstack** by running:

    .. code-block:: none

        sudo ldapaddusertogroup <USER> openstack

    See :ref:`Local LDAP Linux User Accounts <local-ldap-linux-user-accounts>`
    for more details.

If this is your first access to the system, you can use the **Sysadmin Local
Linux Account** for Local CLI access.

.. rubric:: |proc|

#.  Log in to the active controller via console or |SSH| to the |OAM| Floating
    IP Address.

    *   If accessing with **Sysadmin Local Linux Account**, use the username
        **sysadmin** with your <sysadmin-password>.

    *   If accessing with a **Local LDAP Linux Account**, use the username
        and password for that account.

#.  Acquire the Keystone credentials for |prod-os|.

    *   If accessing with **Sysadmin Local Linux Account**:

        .. code-block:: none

            $ source /var/opt/openstack/admin-openrc
            ~(keystone_admin)$

    *   If accessing with a **Local LDAP Linux Account**:

        .. code-block:: none
        
            $ source /var/opt/openstack/local_openstackrc
            Enter password for Keystone user `ldap-user`:
            Created file `/home/ldap-user/ldap-user-openrc-openstack`.
            ~(keystone_ldap-user)$

        The Local |LDAP| Linux User Account should always
        :command:`source /var/opt/openstack/local_openstackrc` to load Keystone
        credentials. This command prompts the user for the Keystone password,
        stores it in the local file ``<USER>-openrc-openstack`` and loads it.
        Subsequent calls of
        :command:`source /var/opt/openstack/local_openstackrc` will just load
        the created local openrc file.

.. rubric:: |result|

OpenStack |CLI| commands for the |prod-os| Cloud Application are now available
via the :command:`openstack` command.

For example:

.. code-block:: none

    ~(keystone_admin)$ openstack flavor list
    +-----------------+------------------+------+------+-----+-------+-----------+
    | ID              | Name             |  RAM | Disk | Eph.| VCPUs | Is Public |
    +-----------------+------------------+------+------+-----+-------+-----------+
    | 054531c5-e74e.. | squid            | 2000 |   20 |  0  |   2   | True      |
    | 2fa29257-8842.. | medium.2c.1G.2G  | 1024 |    2 |  0  |   2   | True      |
    | 4151fb10-f5a6.. | large.4c.2G.4G   | 2048 |    4 |  0  |   4   | True      |
    | 78b75c6d-93ca.. | small.1c.500M.1G |  512 |    1 |  0  |   1   | True      |
    | 8b9971df-6d83.. | vanilla          |    1 |    1 |  0  |   1   | True      |
    | e94c8123-2602.. | xlarge.8c.4G.8G  | 4096 |    8 |  0  |   8   | True      |
    +-----------------+------------------+------+------+-----+-------+-----------+

    ~(keystone_admin)$ openstack image list
    +----------------+----------------------------------------+--------+
    | ID             | Name                                   | Status |
    +----------------+----------------------------------------+--------+
    | 92300917-49ab..| Fedora-Cloud-Base-30-1.2.x86_64.qcow2  | active |
    | 15aaf0de-b369..| opensquidbox.amd64.1.06a.iso           | active |
    | eeda4642-db83..| xenial-server-cloudimg-amd64-disk1.img | active |
    +----------------+----------------------------------------+--------+

If you need to run a |CLI| command that references a local file, then that file
must be copied to or created in the shared directory between the host and the
clients container. On the host side, the directory is located at
``/var/opt/openstack``.

.. note::
    You can use a different directory for this purpose after specifying an
    alternate path in the Helm overrides and reapplying the application:

    .. code-block:: none

        ~(keystone_admin)$ system helm-override-update <app_name> clients openstack \
            --reuse-values --set workingDirectoryPath=/var/opt/another-directory
        ~(keystone_admin)$ system application-apply <app_name>

If you are logged in as **sysadmin**, you just have to move your file to
``/var/opt/openstack`` and reference it by its filename:

.. code-block:: none

    ~(keystone_admin)$ mv ubuntu.qcow2 /var/opt/openstack/ubuntu.qcow2
    ~(keystone_admin)$ openstack image create --public --disk-format qcow2 \
        --container-format bare --file ubuntu.qcow2 ubuntu_image

Similarly, if you are logged in as an |LDAP| user, you just have to move your
file to ``/var/opt/openstack/<USER>`` and reference it by its filename:

.. code-block:: none

    ~(keystone_ldap-user)$ mv ubuntu.qcow2 /var/opt/openstack/ldap-user/ubuntu.qcow2
    ~(keystone_ldap-user)$ openstack image create --public --disk-format qcow2 \
        --container-format bare --file ubuntu.qcow2 ubuntu_image

.. note::
    The subdirectory ``/var/opt/openstack/<USER>`` is created automatically
    after the first execution of a command by an |LDAP| user. If it does not
    exist, you can create it by running:

    .. code-block:: none

        ~(keystone_ldap-user)$ mkdir -p /var/opt/openstack/${USER}


.. note::
    After running :command:`source /var/opt/openstack/admin-openrc`, all
    OpenStack |CLIs| are aliased to the containerized OpenStack |CLIs|.

    This means that, after sourcing ``admin-openrc`` or ``local_openstackrc``,
    the :command:`openstack` command no longer references the Platform
    OpenStack |CLI|. Instead, it references the OpenStack |CLI| of the
    containerized OpenStack application.

    You can verify this by running:

    .. code-block:: none

        ~(keystone_admin)$ source /var/opt/openstack/admin-openrc
        ~(keystone_admin)$ type openstack
        openstack is aliased to `/var/opt/openstack/clients-wrapper.sh openstack'

    If you want to go back to using the OpenStack Platform |CLIs|, you can do
    so by clearing the aliases:

    .. code-block:: none

       ~(keystone_admin)$ source /var/opt/openstack/clear-aliases.sh
