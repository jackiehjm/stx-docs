..
.. _openstack-login-protection:

================
Login Protection
================

.. rubric:: |context|

The objective of login protection is to increase the overall security of the
system, thus preventing password-guessing attacks such as brute force. It is
implemented on Keystone service and it applies to all the services that depend
on it, such as Horizon.

When a user fails to login consecutively for a configured number of times, the
system will prevent the user from authenticating via Keystone for a configured
amount of time.

.. note::
    User admin is not affected by the login protection. For more information,
    see
    `https://docs.openstack.org/keystone/pike/admin/identity-security-compliance.html
    <https://docs.openstack.org/keystone/pike/admin/identity-security-compliance.html>`__.

    Login protection is enabled by default to lockout a user on 5 consecutive
    login failures, for a lockout duration of 1800 seconds.

    The following procedure allows you to customize the behaviour.

.. rubric:: |proc|

Keystone Helm Chart Override
****************************

The login protection has two key parameters:

* parameter for the number of failed attempts to lockout the user
  (lockout_failure_attempts)

* parameter for the period in seconds that the user remains locked out from
  authenticating on Keystone (lockout_duration).

The customization of these parameters is done via Helm overrides.

#. Set up admin privileges.

   .. code-block:: none

       $ source /etc/platform/openrc

#. Create the ``keystone-login-protection.yml`` Helm overrides file.

   .. code-block:: none

       conf:
         keystone:
           security_compliance:
             lockout_failure_attempts: <integer>
             lockout_duration: <integer>

   Where ``lockout_failure_attempts`` is the number of failed attempts
   (defaults to 5 attempts) for locking out the user temporarily, and
   ``lockout_duration`` is the period (defaults to 1800 seconds) that the user
   remains locked out from authenticating via Keystone.

   .. note::

       Login protection is enabled with the default values stated above.

#. Run the following command to apply Helm override.

   .. parsed-literal::

        ~(keystone_admin)]$ system helm-override-update --reuse-values --values keystone-login-protection.yml |prefix|-openstack keystone openstack

#. Run the following command to check applied user overrides.

   .. parsed-literal::

        ~(keystone_admin)]$ system helm-override-show |prefix|-openstack keystone openstack

   The following output is shown for the user_overrides property.

   .. code-block:: none

        +--------------------+-----------------------------------------------+
        | Property           | Value                                         |
        +--------------------+-----------------------------------------------+
        | user_overrides     | conf:                                         |
        |                    |   keystone:                                   |
        |                    |     security_compliance:                      |
        |                    |       lockout_duration: <integer>             |
        |                    |       lockout_failure_attempts: <integer>     |
        +--------------------+-----------------------------------------------+

#. Run the following command to reapply OpenStack with the updated Helm
   override values.

   .. parsed-literal::

        ~(keystone_admin)]$ system application-apply |prefix|-openstack

   .. note::

       |prefix|-openstack application must be in *Applied* or *Uploaded* state
       for the command to work.

#. Wait for the apply to complete.

   .. code-block:: none

       $ watch -n 5 system application-list

Helm Chart Overrides Removal
****************************

This section details how to restore the default values for the Login Protection
feature by removing the Helm overrides.

#. Set up admin privileges.

   .. code-block:: none

       $ source /etc/platform/openrc

#. List Keystone Helm overrides with the following command.

   .. parsed-literal::

        ~(keystone_admin)]$ system helm-override-show |prefix|-openstack keystone openstack

#. Create a new ``keystone-helm-overrides.yml`` with all user overrides except
   ``lockout_failure_attempts`` and ``lockout_duration`` parameters.

#. Run the following command to update the override with the created file.

   .. parsed-literal::

        ~(keystone_admin)]$ system helm-override-update --values keystone-helm-overrides.yml |prefix|-openstack keystone openstack

#. Run the following command to reapply OpenStack to restore default values.

   .. parsed-literal::

        ~(keystone_admin)]$ system application-apply |prefix|-openstack

   .. note::

       |prefix|-openstack application must be in *Applied* or *Uploaded* state
       for the command to work.

#. Wait for apply to complete.

   .. code-block:: none

       $ watch -n 5 system application-list
