
.. xvn1592596490325
.. _changing-the-admin-password-on-distributed-cloud:

==============================================
Change the Admin Password on Distributed Cloud
==============================================

You can change the keystone admin user password across the entire |prod-dc|
system.

.. rubric:: |prereq|

Ensure that all subclouds are managed and online.

.. rubric:: |proc|

#.  Change the password.


    #.  Do one of the following to change a keystone admin user password on
        System Controller.


        -   In the System Controller context, select **Identity** \> **Users**.
            Select **Change Password** from the **Edit** menu for the Admin user.

        -   From the |CLI|:

            .. code-block:: none

                ~(keystone_admin)]$ openstack --os-region-name SystemController user password set

            Respond to the prompts to complete the process.


    #.  Source the script /etc/platform/openrc if you will continue to use the
        environment from the previous |CLI| command.

        .. code-block:: none

            $ source /etc/platform/openrc
            ~(keystone_admin)]$


#.  After five minutes, lock and then unlock each controller in the System
    Controller.

#.  Lock and then unlock each controller in each subcloud.

    .. note::
        In a subcloud, if the |CLI| command returns an authentication error after
        you source the script /etc/platform/openrc, you can verify the password
        on the subcloud by using the command :command:`env \| grep
        OS\_PASSWORD`. If it returns the old password, you will need to run the
        command :command:`keyring set CGCS admin` and provide the new admin
        password.

.. only:: partner

    .. include:: /_includes/dm-credentials-on-keystone-pwds.rest
