
.. efv1552681472194
.. _operator-login-authentication-logging:

=====================================
Operator Login/Authentication Logging
=====================================

|prod| logs all operator login and authentication attempts.

For security purposes, all login attempts \(success and failure\) are
logged. This includes the Horizon Web interface and SSH logins as well as
internal local LDAP login attempts and internal database login attempts.

SNMP authentication requests \(success and failure\) are logged with
operator commands \(see :ref:`Operator Command Logging
<operator-command-logging>`\). Authentication failures are logged
explicitly, whereas successful authentications are logged when the request
is logged.

The logs include the timestamp, user name, remote IP Address, and number of
failed login attempts \(if applicable\). They are located under the /var/log
directory, and include the following:


.. _operator-login-authentication-logging-ul-wg4-bkz-zw:

-   /var/log/auth.log

-   /var/log/horizon.log

-   /var/log/pmond.log

-   /var/log/hostwd.log

-   /var/log/snmp-api.log

-   /var/log/sysinv.log

-   /var/log/user.log

-   /var/log/ima.log


You can examine the log files locally on the controllers, or using a remote
log server if the remote logging feature is configured.

