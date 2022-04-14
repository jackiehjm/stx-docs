
.. tfb1485354135500
.. _security-system-account-password-rules:

===============================
Keystone Account Password Rules
===============================

|prod-os| enforces a set of strength requirements for new or changed passwords.

By default, the following rules apply:


.. _security-system-account-password-rules-ul-jwb-g15-zw:

-   The password must be at least seven characters long.

-   You cannot reuse the last 2 passwords in history.

-   The password must contain:


    -   at least one lower-case character

    -   at least one upper-case character

    -   at least one numeric character

    -   at least one special character

The Keystone service can be configured to use customized password rules. For
more information, see the keystone documentation: `Configuring password
strength requirements
<https://docs.openstack.org/keystone/ussuri/admin/configuration.html#configuring-password-strength-requirements>`__.

The steps below can be used as a reference to update the Keystone service via
``helm-override`` to customize the password rules and their description.

#.  Create the yaml override file with the following contents:

    .. code-block:: none

        conf:
            keystone:
                security_compliance:
                    password_regex: ^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[!@#$%^&*()<>{}+=_\\\[\]\-?|~`,.;:]).{12,}$
                    password_regex_description: Password must have a minimum length of 12 characters, and must contain at least 1 upper case, 1 lower case, 1 digit, and 1 special character
                    unique_last_password_count = 5

#.  Update the Keystone helm overrides.

    .. parsed-literal::

        system helm-override-update |prefix|-openstack keystone openstack --reuse-values --values keystone-password-override.yaml

#.  Apply the new overrides.

    .. parsed-literal::

        system application-apply |prefix|-openstack

#.  Wait for apply to complete.

    .. code-block:: none

        watch system application-list

