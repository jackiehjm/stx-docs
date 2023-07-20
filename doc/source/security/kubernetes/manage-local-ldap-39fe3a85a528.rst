.. _manage-local-ldap-39fe3a85a528:

=============================================
Manage Composite Local LDAP Accounts at Scale
=============================================

.. rubric:: |context|

The purpose of this playbook is to simplify and automate the management of
composite Local |LDAP| accounts across multiple |DC| systems or standalone
systems. A composite Local |LDAP| account is defined as a Local |LDAP| account
that also has a unique Keystone account with same name (in the Admin Project)
and a specified Keystone role. The Local |LDAP| account can be optionally set
with ``sudo`` and/or ``sys_protected`` privileges. If the created |LDAP| account
is assigned ``sys_protected`` privileges, it will have access to a K8S
serviceAccount with ``cluster-admin`` role credentials.

A user with such a composite Local |LDAP| account can |SSH| to systems'
controllers and subclouds and:

-   execute Linux commands (with local |LDAP| account credentials; with or
    without sudo capabilities),

-   execute |prod| |CLI| commands (with its Keystone account credentials) and

-   execute K8S |CLI| commands if the |LDAP| account has ``sys_protected``
    privileges (with credentials of a ``cluster-admin`` K8S serviceAccount).

A unique Local |LDAP| account and unique Keystone account enables user-specific
command audit logging for security and tracking purposes.

The playbook can be used to create or delete such composite Local |LDAP|
Accounts, manage access to sudo capabilities and manage password change
parameters.


-----------------------------------------
Create inventory file using Ansible-Vault
-----------------------------------------

Users are required to create an inventory file to specify playbook parameters.
Using ``ansible-vault`` is highly recommended for improved security. An
``ansible-vault`` password needs to be created during this step, which is required
for subsequent access to the ``ansible-vault`` and ansible-playbook commands.

Create a secure inventory file:

.. code-block:: none

    ~(keystone_admin)]$ ansible-vault create secure-inventory

This will open a text editor where you can fill the inventory parameters as
shown in the example below. When this ansible playbook runs locally, this
inventory will always have the same contents except for the value of
``<sysadmin-password>``.

.. code-block:: none

    [all:vars]
    ansible_user=sysadmin
    ansible_password=<sysadmin-password>
    ansible_become_pass=<sysadmin-password>

    [systemcontroller]
    systemcontroller-0 ansible_host=127.0.0.1

The inventory parameters are:

``ansible_user``
    Specify the ``sysadmin`` user for ansible to use.

``ansible_password``
    The ``sysadmin`` password.

``ansible_become_pass``
    The ``sysadmin`` password for using sudo.

``systemcontroller-0 ansible_host``
    The target |DC|/Standalone system controller IP Address or |FQDN| to
    create/delete the composite Local |LDAP| account.  Use 127.0.0.1, loopback
    address, if running the ansible playbook locally on the target
    |DC|/Standalone system controller.


----------------
Run the playbook
----------------

After the inventory file is created, the ansible playbook can be run to perform
the user creation or removal process. The previously created ``ansible-vault``
password will be prompted during runtime.

.. code-block:: none

    ~(keystone_admin)]$ ansible-playbook --inventory secure-inventory --ask-vault-pass --extra-vars='user_id=na-admin mode=create' /usr/share/ansible/stx-ansible/playbooks/manage_local_ldap_account.yml

Extra-vars parameter options:

-   ``user_id``

    ``<string>``
        Username that will be used for both the Local |LDAP| account and the
        Keystone account (in the Admin Project) on the target |DC|/Standalone
        system and associated |DC| Subclouds.

-   ``mode`` (optional, default is "create"):

    ``create``
        Creates users within Local |LDAP| and Keystone.

    ``delete``
        Removes existing users from Local |LDAP| and Keystone.

-   ``sudo_permission`` (optional, default is "no"):

    ``yes``
        The created Local |LDAP| user will have ``sudo`` capabilities to
        execute commands with root privileges on the |DC|/Standalone system and
        associated |DC| Subclouds.

    ``no``
        The created Local |LDAP| user will NOT have ``sudo`` capabilities to
        execute commands with root privileges on the |DC|/Standalone system and
        associated |DC| Subclouds.

-   ``sys_protected`` (optional, default is "no"):

    ``yes``
        The created Local |LDAP| user will be added to ``sys_protected`` group,
        and will be able to access a K8S serviceAccount with ``cluster-admin``
        role credentials.

    ``no``
        The created Local |LDAP| user will NOT be added to ``sys_protected``
        group.

-   ``user_role`` (optional, default is "admin"):

    ``admin``
        Set the Keystone role of the user to be created as ``admin``.
        This role has permissions to execute all |prod| CLI commands.

    ``member``
        Set the Keystone role of the user to be created as ``member``.
        This role is for future use, currently it has the same permissions as
        Keystone ``reader`` role.

    ``reader``
        Set the Keystone role of the user to be created as ``reader``.
        This role has permissions to only execute passive display-type
        (e.g. list, get) |prod| CLI commands.

-   ``password_change_period`` (optional, default is "90"):

    ``<int>``
        Specifies the maximum number of days that the Local |LDAP| account's
        password is valid.

-   ``password_warning_period`` (optional, default is "2"):

    ``<int>``
        Specifies the number of days before password expiration that the Local
        |LDAP| user is warned.


---------------------------------------------
Use the created composite Local LDAP accounts
---------------------------------------------

For subclouds that were "managed" and with identity_sync_status "in-sync" when
the playbook run (this can be checked with command `dcmanager subcloud show
<subcloud-name>`), it may take up to 2 minutes for the created Keystone account
to propagate to these subclouds.

For subclouds that are not "managed" or were added after the playbook run, it is
sufficient to set these subclouds as "managed" and wait for them to have
identity_sync_status "in-sync".

If the created Local |LDAP| user has sudo permission, it may take up to 5
minutes for this permission to reach all nodes.

To test the created composite Local |LDAP| account, |SSH| to a cloud and
execute:

.. code-block:: none

    $ source local_starlingxrc
    Enter the password to be used with Keystone user na-admin:
    Created file /home/na-admin/na-admin-openrc
    ~(keystone_na-admin)]$ system host-list
    +----+--------------+-------------+----------------+-------------+--------------+
    | id | hostname     | personality | administrative | operational | availability |
    +----+--------------+-------------+----------------+-------------+--------------+
    | 1  | controller-0 | controller  | unlocked       | enabled     | available    |
    +----+--------------+-------------+----------------+-------------+--------------+

The operator should always execute `source local_starlingxrc` to load Keystone
credentials. This command prompts the user for the Keystone password, stores it
in the local file ``<USER>-openrc`` and loads it. Subsequent calls of `source
local_starlingxrc` will just load the created local openrc file.


---------------
Troubleshooting
---------------

This section describes common problems and their solutions.

.. code-block:: none

    ~(keystone_na-admin)]$ system host-list
    Must provide Keystone credentials or user-defined endpoint and token, error was: The request you have made requires authentication. (HTTP 401)

The error above happens either because the Keystone password is wrong and/or
because the Keystone user has not been propagated to all subclouds. Check if the
password is correct in the contents of the local file ``<USER>-openrc``. Check
the system controller if all subclouds are "managed" and with
identity_sync_status "in-sync". Wait for 2 minutes after the playbook is run for
Keystone user propagation in the subclouds that are already in a "managed"
state, and with identity_sync_status "in-sync".

.. code-block:: none

    ~(keystone_na-admin)]$ sudo ls -la
    Password:
    na-admin is not allowed to run sudo on controller-0. This incident will be reported.

The error above happens either because the |LDAP| account was created without
sudo permission or because the sudo permission for this |LDAP| account did not
reach the current node. Check if the playbook was run with
``sudo_permission=yes``. Wait 5 minutes for sudo permission to sync.
