
.. efc1552681959124
.. _the-sysadmin-account:

====================
The sysadmin Account
====================

This is a local, per-host, sudo-enabled account created automatically when a
new host is provisioned.

This Linux user account is used by the system administrator as it has
extended privileges.

On controller nodes, this account is available even before :command:`ansible
bootstrap playbook` is executed.

The default initial password is **sysadmin**.


.. _the-sysadmin-account-ul-aqh-b41-pq:

-   The initial password must be changed immediately when you log in to each
    host for the first time. For details, see the `StarlingX Installation Guide
    <https://docs.starlingx.io/deploy_install_guides/index.html>`__.

-   After five consecutive unsuccessful login attempts, further attempts are
    blocked for about five minutes. To clarify, the 5 minute block is not an
    absolute window, but a sliding one. That is, if you keep attempting to log
    in within those 5 minutes, the window keeps sliding and the user remains
    blocked. Therefore, you should not attempt any further login attempts for 5
    minutes after 5 unsuccessful login attempts.


Subsequent password changes must be executed on the active controller in an
**unlocked**, **enabled**, and **available** state to ensure that they
propagate to all other unlocked-active hosts in the cluster. Otherwise, they
remain local to the host where they were executed, and are overwritten on
the next reboot or host unlock to match the password on the active controller.

From the **sysadmin** account, you can execute commands requiring different
privileges.


.. _the-sysadmin-account-ul-hlh-f2c-5p:

-   You can execute non-root level commands as a regular Linux user directly.

    If you do not have sufficient privileges to execute a command as a
    regular Linux user, you may receive a permissions error, or in some
    cases, the command may be reported as not found.

-   You can execute root-level commands as the **root** user.

    To become the root user, use the :command:`sudo` command to elevate your
    privileges, followed by the command to be executed. For example, to run
    the :command:`license-install` command as the :command:`root` user:

    .. code-block:: none

        $ sudo /usr/sbin/license-install license_file


    If a password is requested, provide the password for the **sysadmin**
    account.

-   You can execute StarlingX administrative commands as the Keystone
    **admin** user and Kubernetes kubectl and helm administrative commands as
    the Kubernetes admin user.

    To become the **admin** user from the Linux **sysadmin** account, source
    the script /etc/platform/openrc:

    .. code-block:: none

        $ source /etc/platform/openrc
        [sysadmin@controller-0 ~(keystone_admin)]$

    The system prompt changes to indicate the newly acquired privileges.

    .. note::
        The default Keystone prompt includes the host name and the current
        working path. For simplicity, this guide uses the following generic
        prompt instead:

        .. code-block:: none

            ~(keystone_admin)]$


