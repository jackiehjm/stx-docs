
.. not1578924824783
.. _password-recovery:

=================
Password Recovery
=================

.. rubric:: |proc|

-   Do one of the following to change a Keystone admin user password at any
    time.


    -   Use the Identity panel in the Horizon Web interface.

    -   Use the following command from the controller CLI.

        .. code-block:: none

            ~(keystone_admin)$ openstack user password set

        .. warning::
            Both controller nodes must be locked and unlocked after changing
            the Keystone admin password. You must wait five minutes before
            performing the lock/unlock operations.


-   Use the following command to reset a Keystone non-admin user \(tenant user\) account.

    .. code-block:: none

        ~(keystone_admin)$ openstack user set --password <temp_password> <user>

    where <user> is the username and <temp\_password> is a temporary password.


