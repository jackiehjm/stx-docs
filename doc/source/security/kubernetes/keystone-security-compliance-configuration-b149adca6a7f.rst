.. _keystone-security-compliance-configuration-b149adca6a7f:

==========================================
Keystone Security Compliance Configuration
==========================================

.. rubric:: |context|

You can configure custom password rules for keystone security compliance.

.. rubric:: |proc|

#.  Use the following parameters to set the rules for keystone security
    compliance.

    .. code-block::

        system service-parameter-add identity security_compliance unique_last_password_count
        system service-parameter-add identity security_compliance password_regex
        system service-parameter-add identity security_compliance password_regex_description

#.  In order for the changes to take effect, apply the new configuration with
    the command:

    .. code-block::

        system service-parameter-apply identity

    For security reasons these parameters are validated:

    -   ``unique_last_password_count`` must be an integer equal or greater than
        zero.

    -   ``password_regex`` must be a valid regex conforming to the Python
        Regular Expression (RE) syntax:
        https://docs.python.org/3/library/re.html.

    -   ``password_regex_description`` must be a non empty string.

    .. note::

        The ``password_regex_description`` will be used by keystone as part of
        the error message when the user tries a password that does not conform
        to the rules. Make sure to have an explanatory description.

    For example:

    .. code-block::

        [sysadmin@controller-0 ~(keystone_admin)]$ system service-parameter-add identity security_compliance unique_last_password_count=7
        +-------------+--------------------------------------+
        | Property    | Value                                |
        +-------------+--------------------------------------+
        | uuid        | 27e18c80-e8be-47ce-9b24-f21136682de6 |
        | service     | identity                             |
        | section     | security_compliance                  |
        | name        | unique_last_password_count           |
        | value       | 7                                    |
        | personality | None                                 |
        | resource    | None                                 |
        +-------------+--------------------------------------+
        [sysadmin@controller-0 ~(keystone_admin)]$ system service-parameter-add identity security_compliance password_regex='^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[!@#$%^&*()<>{}+=_\\\[\]\-?|~`,.;:]).{20,}$'
        +-------------+---------------------------------------------------------------------------------+
        | Property    | Value                                                                           |
        +-------------+---------------------------------------------------------------------------------+
        | uuid        | bab59259-4463-4bce-a6ed-e7b2dcfeb2ac                                            |
        | service     | identity                                                                        |
        | section     | security_compliance                                                             |
        | name        | password_regex                                                                  |
        | value       | ^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[!@#$%^&*()<>{}+=_\\\[\]\-?|~`,.;:]).{20,}$ |
        | personality | None                                                                            |
        | resource    | None                                                                            |
        +-------------+---------------------------------------------------------------------------------+
        [sysadmin@controller-0 ~(keystone_admin)]$ system service-parameter-modify identity security_compliance password_regex_description='Password must have a minimum length of 20 characters, and must contain at least 1 upper case, 1 lower case, 1 digit, and 1 special character'
        +-------------+----------------------------------------------------------------------------------------------------------------------------------------------+
        | Property    | Value                                                                                                                                        |
        +-------------+----------------------------------------------------------------------------------------------------------------------------------------------+
        | uuid        | 83ae409e-d5b5-4465-b71b-f29b81bdcb67                                                                                                         |
        | service     | identity                                                                                                                                     |
        | section     | security_compliance                                                                                                                          |
        | name        | password_regex_description                                                                                                                   |
        | value       | Password must have a minimum length of 20 characters, and must contain at least 1 upper case, 1 lower case, 1 digit, and 1 special character |
        | personality | None                                                                                                                                         |
        | resource    | None                                                                                                                                         |
        +-------------+----------------------------------------------------------------------------------------------------------------------------------------------+
        [sysadmin@controller-0 ~(keystone_admin)]$
        [sysadmin@controller-0 ~(keystone_admin)]$ system service-parameter-apply identity
        Applying platform service parameters

#.  The system :command:`service-parameter-apply` command will apply the
    configuration to ``/etc/keystone/keystone.conf`` and restart the keystone
    service.

    To see the exact moment keystone is restarted, check the ``sm-customer.log``:

    .. code-block::

        [sysadmin@controller-0 ~(keystone_admin)]$ date
        Wed Oct 20 02:03:12 UTC 2021
        [sysadmin@controller-0 ~(keystone_admin)]$ # let's check that keystone is being restarted
        [sysadmin@controller-0 ~(keystone_admin)]$ tailf -n 5 /var/log/sm-customer.log
        | 2021-10-20T02:02:42.109 |        398 | service-scn          | vim                              | enabling-throttle                | enabling                         | throttle open to enable service
        | 2021-10-20T02:02:42.110 |        399 | service-scn          | cert-mon                         | enabling                         | enabled-active                   | enable success
        | 2021-10-20T02:02:42.141 |        400 | service-scn          | hw-mon                           | enabling-throttle                | enabling                         | throttle open to enable service
        | 2021-10-20T02:02:42.480 |        401 | service-scn          | vim                              | enabling                         | enabled-active                   | enable success
        | 2021-10-20T02:02:43.584 |        402 | service-scn          | hw-mon                           | enabling                         | enabled-active                   | enable success
        | 2021-10-20T02:04:19.289 |        403 | service-scn          | keystone                         | enabled-active                   | disabling                        | restart safe requested
        | 2021-10-20T02:04:20.512 |        404 | service-scn          | keystone                         | disabling                        | disabled                         | disable success
        | 2021-10-20T02:04:20.980 |        405 | service-scn          | keystone                         | disabled                         | enabling-throttle                | enabled-active state requested
        | 2021-10-20T02:04:21.007 |        406 | service-scn          | keystone                         | enabling-throttle                | enabling                         | throttle open to enable service
        | 2021-10-20T02:04:22.431 |        407 | service-scn          | keystone                         | enabling                         | enabled-active                   | enable success

#.  Search for ``keystone.conf`` to see the new rules being persisted.

    .. code-block::

        [sysadmin@controller-1 ~(keystone_admin)]$ sudo grep "unique_last_password_count\|password_regex" /etc/keystone/keystone.conf
        #unique_last_password_count = 0
        unique_last_password_count = 7
        #password_regex = <None>
        password_regex = ^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[!@#$%^&*()<>{}+=_\\\[\]\-?|~`,.;:]).{20,}$
        #password_regex_description = <None>
        password_regex_description = 20 characters minimum, must have numbers and special characters

#.  After that, the new rules are already in place, and they can be used.

    .. code-block::

        [sysadmin@controller-1 ~(keystone_admin)]$ openstack user password set
        Current Password:
        New Password:
        Repeat New Password:
        The password does not match the requirements: 20 characters minimum, must have numbers and special characters. (HTTP 400) (Request-ID: req-3aa0f2f9-eef8-4f28-8e3c-ae4a7eaf1d29)
