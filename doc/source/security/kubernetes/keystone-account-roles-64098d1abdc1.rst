.. _keystone-account-roles-64098d1abdc1:

======================
Keystone Account Roles
======================

In |prod|, 3 different keystone roles are supported: ``admin``, ``member``
and ``reader``.

Users with an ``admin`` role in the ``admin`` project can execute any action in the system.

Users with a ``reader`` role in the ``admin`` project have read-only access. They cannot
perform any changes in the system but can read any configuration. In
the |CLI|, commands with prefix or suffix, such as, ``list``, ``query``, ``show``
and ``summary`` get the configuration from the system, and are allowed for this
type of user, all other commands are denied. Some examples of |CLI| commands
executed by a user with ``reader`` role are shown below.

.. code-block:: none

    ~(keystone_admin)]$ system host-list

    +-----+--------------+-------------+----------------+-------------+--------------+
    | id  | hostname     | personality | administrative | operational | availability |
    +-----+--------------+-------------+----------------+-------------+--------------+
    | 1   | controller-0 | controller  | unlocked       | enabled     | degraded     |
    +-----+--------------+-------------+----------------+-------------+--------------+

.. code-block:: none

    ~(keystone_admin)]$ system host-lock controller-0

    Error: Forbidden

.. code-block:: none

    ~(keystone_admin)]$ fm alarm-summary

    +-----------------+--------------+--------------+----------+
    | Critical Alarms | Major Alarms | Minor Alarms | Warnings |
    +-----------------+--------------+--------------+----------+
    | 1               | 13           | 0            | 0        |
    +-----------------+--------------+--------------+----------+

.. code-block:: none

    ~(keystone_admin)]$ fm event-suppress --alarm_id 100.103

    Error: Forbidden.


**Exception**: all :command:`fm` read-only commands require ``reader`` role but there is no
project verification, so a user in a project different from ``admin`` may execute
them. Examples: :command:`alarm-list`, :command:`alarm-show`, :command:`alarm-summary`,
:command:`event-list`, :command:`event-show` and :command:`event-suppress-list`.

Currently, the ``member`` role is equivalent to ``reader`` role, but this may change
in the future, allowing a user with ``member`` role to execute some actions that
change the system configuration.

The following sections describe how to create users with specific keystone
roles in |prod|.

----------------------------------------------------
Creation of user with specific role for Horizon only
----------------------------------------------------

Use the following commands to add a new user named ``readeruser`` with password
"Passw0rd*" and role ``reader``:

.. code-block:: none

    ~(keystone_admin)]$ openstack user create readeruser --project admin --password Passw0rd*

.. code-block:: none

   ~(keystone_admin)]$ openstack role add --project admin --user readeruser reader

To create a user with ``admin`` role instead of ``reader`` role, change
``reader`` to ``admin`` using the :command:`openstack role add` command.

When this user is added in the central cloud, it is propagated to the managed
subclouds. To check if this new user is already present in a host, use the
:command:`openstack user list` command.

-------------------------------------------------------
Creation of user with specific role for Horizon and CLI
-------------------------------------------------------

Follow the instructions in
:ref:`Manage Composite Local LDAP Accounts at Scale <manage-local-ldap-39fe3a85a528>`
using the parameter ``user_role=reader`` in ``extra-vars`` of ``manage_local_ldap_account.yml``
playbook to create a user with ``reader`` role. To create a user with ``admin``
role, use ``user_role=admin`` instead.

.. warning::

   Users with ``reader`` role do not have ``sudo`` capabilities, use
   ``sudo_permission=false`` when the users role is ``user_role=reader``.