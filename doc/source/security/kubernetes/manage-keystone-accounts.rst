
.. ikv1595849619976
.. _manage-keystone-accounts:

========================
Manage Keystone Accounts
========================

See
`https://docs.openstack.org/keystone/pike/admin/cli-manage-projects-users-and-roles.html
<https://docs.openstack.org/keystone/pike/admin/cli-manage-projects-users-and-roles.html>`_
_ for details on managing Keystone projects, users, and roles.

.. note::
    All Kubernetes accounts are subject to system password rules. For
    complete details on password rules, see :ref:`System Account Password
    Rules <starlingx-system-accounts-system-account-password-rules>`.

.. _managing-keystone-accounts-ol-wyq-l4d-mmb:

If using the FIXME: REMOVE, when changing the Keystone 'admin' user
password, you must:

#.  Update the password in the 'system-endpoint' secret in the FIXME:
    REMOVE's deployment-config.yaml file, with the new Keystone 'admin'
    user password.

    Make this change to the OS\_PASSWORD value. It must be base64 encoded. For example:

    .. code-block:: none

        OS_PASSWORD: U3Q4cmxpbmdYKg==

#.  Apply the updated deployment configuration.

    .. code-block:: none

        kubectl apply -f deployment-config.yaml


