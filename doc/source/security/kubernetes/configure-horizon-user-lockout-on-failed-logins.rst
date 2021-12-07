
.. dzm1496244723149
.. _configure-horizon-user-lockout-on-failed-logins:

===============================================
Configure Horizon User Lockout on Failed Logins
===============================================

For security, login to the Web administration interface can be disabled for a
user after several consecutive failed attempts. You can configure how many
failed attempts are allowed before the user is locked out, and how long the
user must wait before the lockout is reset.

.. rubric:: |context|

.. caution::
    This procedure requires the Web service to be restarted, which causes
    all current user sessions to be lost. To avoid interrupting user
    sessions, perform this procedure during a scheduled maintenance period
    only.

By default, after five consecutive failed login attempts, a user must wait
thirty minutes \(1800 seconds\) before attempting another login. During this
period, all Web administration interface login attempts by the user are
refused, including those using the correct password.

This behavior is controlled by the lockout\_retries parameter and the
lockout\_seconds service parameter. To review their current values, use the
:command:`system service-parameter-list` command.

You can change the duration of the lockout using the following |CLI| command:

.. code-block:: none

    ~(keystone_admin)]$ system service-parameter-modify identity security_compliance lockout_seconds=<duration>

where ``<duration>`` is the time in seconds.

You can change the number of allowed retries before a lockout is imposed
using the following |CLI| command:

.. code-block:: none

    ~(keystone_admin)]$ system service-parameter-modify identity security_compliance lockout_retries=<attempts>

where ``<attempts>`` is the number of allowed retries.

For the changes to take effect, you must apply them:

.. code-block:: none

    ~(keystone_admin)]$ system service-parameter-apply identity

Allow about 30 seconds after applying the changes for the Web service to
restart.

