
.. efv1552681472194
.. _operator-login-authentication-logging:

=====================================
Operator Login/Authentication Logging
=====================================

|prod| logs all operator login and authentication attempts.

For security purposes, all login attempts (success and failure) are
logged. This includes the Horizon Web Interface logins, SSH logins, Local
Console Logins and internal database login attempts.


The logs include the timestamp, user name, remote IP Address, and number of
failed login attempts (if applicable). They are located under the /var/log
directory, and include the following:


.. _operator-login-authentication-logging-ul-wg4-bkz-zw:

-   /var/log/auth.log

-   /var/log/horizon/horizon.log

-   /var/log/pmond.log

-   /var/log/hostwd.log

-   /var/log/sysinv.log

-   /var/log/user.log

-   /var/log/ima.log

.. only:: partner

   .. include:: /_includes/operator-login-authentication-logging.rest
      :start-after: begin-remote-log-server-options
      :end-before: end-remote-log-server-options

.. only:: starlingx

   You can examine the log files locally on the controllers.

