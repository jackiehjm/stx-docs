
.. ikv1595849619976
.. _manage-keystone-accounts:

========================
Manage Keystone Accounts
========================

You can create and manage Keystone projects and users from the web management
interface, the CLI, or the |prod|'s Keystone REST API.

See:

`https://docs.openstack.org/keystone/pike/admin/cli-manage-projects-users-and-roles.html
<https://docs.openstack.org/keystone/pike/admin/cli-manage-projects-users-and-roles.html>`_
for details on managing Keystone projects, users, and roles.

:ref:`Password Recovery <password-recovery>` for details on how to change or
reset a Keystone user password.

:ref:`System Account Password Rules <starlingx-system-accounts-system-account-password-rules>`
for details on password rules, as all Kubernetes accounts are subject to system
password rules.

:ref:`Change the Admin Password on Distributed Cloud <changing-the-admin-password-on-distributed-cloud>`
for details on changing the keystone admin user password across the entire
|prod-dc| system.

.. only:: partner

    .. include:: /_includes/dm-credentials-on-keystone-pwds.rest