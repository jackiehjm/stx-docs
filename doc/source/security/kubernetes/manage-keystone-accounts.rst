
.. ikv1595849619976
.. _manage-keystone-accounts:

========================
Manage Keystone Accounts
========================

See
`https://docs.openstack.org/keystone/pike/admin/cli-manage-projects-users-and-roles.html
<https://docs.openstack.org/keystone/pike/admin/cli-manage-projects-users-and-roles.html>`_
_ for details on managing Keystone projects, users, and roles.


All Kubernetes accounts are subject to system password rules. For complete
details on password rules, see :ref:`System Account Password Rules
<starlingx-system-accounts-system-account-password-rules>`.

If you are using  when changing the keystone 'admin' user password, you must:

.. _managing-keystone-accounts-ol-wyq-l4d-mmb:

#.  If the **deployment-config.yaml** file has been moved off-box for security
    reasons, upload the file back to the system to be updated.

    .. warning::
        The **deployment-config.yaml** file includes sensitive information
        \(including system credentials and passwords\). For increased security,
        it is recommended to store the **deployment-config.yaml** in a safe
        location off-box. Upload the file to the system only when it is
        required \(during initial configuration, and when reapplying an updated
        configuration\).

#.  Update the password in the 'system-endpoint' secret in the 's
    deployment-config.yaml file, with the new keystone 'admin' user password.
    Make this change to the OS\_PASSWORD value. It must be base64 encoded. For
    example:

    .. code-block:: none

        OS_PASSWORD: U3Q4cmxpbmdYKg==

#.  Apply the updated deployment configuration.

    .. code-block:: none

        kubectl apply -f deployment-config.yaml

#.  \(Optional\) For security reasons, copy the updated
    **deployment-config.yaml** file off-box and delete it from the system.
