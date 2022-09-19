.. _manage-local-ldap-39fe3a85a528:

=============================================
Manage Composite Local LDAP Accounts at Scale
=============================================

.. rubric:: |context|

The purpose of this playbook is to simplify and automate the management of
composite Local |LDAP| accounts across multiple |DC| systems or standalone
systems. A composite Local |LDAP| account is defined as a Local |LDAP| account
that also has a unique keystone account with admin role credentials and access
to a K8S serviceAccount with ``cluster-admin`` role credentials.

A user with such a composite Local |LDAP| account can |SSH| to systems'
controllers and subclouds and:

-   execute Linux commands (with local |LDAP| account credentials; with or
    without sudo capabilities),

-   execute |prod| |CLI| commands (with its keystone account (admin role)
    credentials) and

-   execute K8S |CLI| commands (with credentials of a ``cluster-admin`` K8S
    serviceAccount).

A unique Local |LDAP| account and unique keystone account enables user-specific
command audit logging for security and tracking purposes.

Besides creating the required Local |LDAP|, Keystone and K8S accounts, the
playbook also fully sets up Keystone and K8S credentials in the Local |LDAP|
user's home directory on all controllers of all systems (i.e. standalone
systems, |DC| SystemControllers and |DC| Subclouds).

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
shown on the example below:

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

    ~(keystone_admin)]$ ansible-playbook --inventory secure-inventory --ask-vault-pass --extra-vars='user_id=na-admin mode=create' \ /usr/share/ansible/stx-ansible/ playbooks/manage_local_ldap_account.yml

-   Extra-vars parameter options:

    ``user_id``
        Username that will be used for both the Local |LDAP| account and the
        Keystone account on the target |DC|/Standalone system and associated
        |DC| Subclouds.

-   mode:

    ``create``
        Creates users within Local |LDAP| and Keystone. This is the default
        value when not specified.

    ``delete``
        Removes existing users from Local |LDAP| and Keystone.

-   ``sudo_permission`` (optional):

    ``yes``
        The created Local |LDAP| user will have ``sudo`` capabilities to
        execute commands with root privileges on the |DC|/Standalone system and
        associated |DC| Subclouds.

    ``no``
        The created Local |LDAP| user will NOT have ``sudo`` capabilities to
        execute commands with root privileges on the |DC|/Standalone system and
        associated |DC| Subclouds.

-   ``user_role`` (optional):

    ``admin``
        Set the keystone role of the user to be created as ``admin``.
        This role has permissions to execute all StarlingX CLI commands.
        This is the default value when not specified.

    ``member``
        Set the keystone role of the user to be created as ``member``.
        This role is for future use, currently it has the same permissions as
        keystone ``reader`` role.

    ``reader``
        Set the keystone role of the user to be created as ``reader``.
        This role has permissions to only execute passive display-type
        (e.g. list, get) StarlingX CLI commands.

-   ``password_change_period``:

    ``<int>``
        Related to the /etc/shadow file, this attribute specifies the maximum
        number of days that the Local |LDAP| account's is valid.

-   ``password_warning_period``:

    ``<int>``
        Related to the /etc/shadow file, this attribute specifies the number
        of days before password expiration that the Local |LDAP| user is warned.
