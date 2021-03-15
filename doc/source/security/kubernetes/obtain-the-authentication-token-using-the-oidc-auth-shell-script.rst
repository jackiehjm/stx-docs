
.. lrf1583447064969
.. _obtain-the-authentication-token-using-the-oidc-auth-shell-script:

================================================================
Obtain the Authentication Token Using the oidc-auth Shell Script
================================================================

You can obtain the authentication token using the **oidc-auth** shell script.

.. rubric:: |context|

You can use the **oidc-auth** script both locally on the active controller,
as well as on a remote workstation where you are running **kubectl** and
**helm** commands.

The **oidc-auth** script retrieves the ID token from Windows Active
Directory using the |OIDC| client, and **dex**, and updates the Kubernetes
credential for the user in the **kubectl** config file.


.. _obtain-the-authentication-token-using-the-oidc-auth-shell-script-ul-kxm-qnf-ykb:

-   On controller-0, **oidc-auth** is installed as part of the base |prod|
    installation, and ready to use.

.. xbooklink

   -   On a remote workstation using remote-cli container, **oidc-auth** is
        installed within the remote-cli container, and ready to use. For more
        information on configuring remote CLI access, see |sysconf-doc|:
        :ref:`Configure Remote CLI Access <configure-remote-cli-access>`.

-   On a remote host, when using directly installed **kubectl** and **helm**, the following setup is required:


    -   Install "Python Mechanize" module using the following command:

        .. code-block:: none

            # sudo pip2 install mechanize

    -   Get the **oidc-auth** script from WindShare.



.. note::
    **oidc-auth** script supports authenticating with a |prod|
    **oidc-auth-apps** configured with single, or multiple **ldap**
    connectors.

.. rubric:: |proc|

#.  Run **oidc-auth** script in order to authenticate and update user
    credentials in **kubectl** config file with the retrieved token.


    -   If **oidc-auth-apps** is deployed with a single backend **ldap** connector, run the following command:

        .. code-block:: none

            ~(keystone_admin)]$ oidc-auth -c <ip> -u <username>

        For example,

        .. code-block:: none

            ~(keystone_admin)]$ oidc-auth -c <OAM_ip_address> -u testuser
            Password:
            Login succeeded.
            Updating kubectl config ...
            User testuser set.

    -   If **oidc-auth-apps** is deployed with multiple backend **ldap** connectors, run the following command:

        .. code-block:: none

            ~(keystone_admin)]$ oidc-auth -b <connector-id> -c <ip> -u <username>



    .. note::
        If you are running **oidc-auth** within the |prod| containerized
        remote CLI, you must use the -p <password> option to run the command
        non-interactively.


