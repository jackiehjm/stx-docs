
.. tzr1595963495431
.. _web-administration-login-timeout:

================================
Web Administration Login Timeout
================================

The |prod| Web administration tool (Horizon) will automatically log users
out after 50 minutes (the Keystone Token Expiry time), regardless of activity.

Operational complexity: No additional configuration is required.

You can also block user access after a set number of failed login attempts as
described in see :ref:`Configure Horizon User Lockout on Failed Logins
<configure-horizon-user-lockout-on-failed-logins>`.

