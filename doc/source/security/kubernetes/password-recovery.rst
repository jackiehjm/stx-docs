
.. not1578924824783
.. _password-recovery:

==========================
Keystone Password Recovery
==========================

.. rubric:: |context|

This section describes how to change or reset a Keystone user password.

.. rubric:: |proc|

-   Do one of the following to change a Keystone admin user password at any
    time.


    -   Use the Identity panel in the Horizon Web interface.

    -   Use the following command from the controller CLI.

        .. code-block:: none

            ~(keystone_admin)]$ openstack user password set

-   Use the following command to reset a Keystone non-admin user \(tenant user\) account.

    .. code-block:: none

        ~(keystone_admin)]$ openstack user set --password <temp_password> <user>

    where <user> is the username and <temp\_password> is a temporary password.

.. only:: partner

    .. include:: /_includes/dm-credentials-on-keystone-pwds.rest
