.. _update-keystone-service-bb6a67e18d36:

=======================
Update Keystone Service
=======================

.. rubric:: |context|

The Keystone service can be configured to use customized regular expressions
for password validation. For more information, see the keystone documentation:
`Configuring password strength requirements
<https://docs.openstack.org/keystone/ussuri/admin/configuration.html#configuring-password-strength-requirements>`__.


.. rubric:: |proc|

The steps below can be used as a reference to update the Keystone service via
``helm-override`` to customize the password validation regular expression and
description.

Create the override file and update the keystone service.

#.  Create the yaml override with the following contents:

    .. code-block:: none

        conf:
            keystone:
                security_compliance:
                    password_regex: ^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[!@#$%^&*()<>{}+=_\\\[\]\-?|~`,.;:]).{12,}$
                    password_regex_description: Password must have a minimum length of 12 characters, and must contain at least 1 upper case, 1 lower case, 1 digit, and 1 special character

#.  Apply the override:

    .. parsed-literal::

        system helm-override-update |prefix|-openstack keystone openstack --reuse-values --values keystone-password-override.yaml

