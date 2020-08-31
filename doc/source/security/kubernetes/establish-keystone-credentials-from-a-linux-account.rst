
.. fan1552681866651
.. _establish-keystone-credentials-from-a-linux-account:

===================================================
Establish Keystone Credentials from a Linux Account
===================================================

The preferred method for establishing Keystone credentials is to log in to
an LDAP account created using :command:`ldapusersetup`.

.. contents::
   :local:
   :depth: 1

.. rubric:: |context|

For more information about :command:`ldapusersetup`, see :ref:`Create LDAP
Linux Accounts <create-ldap-linux-accounts>`.

User accounts created using :command:`ldapusersetup` have access to the
Keystone CLI as part of the shell. To list the available commands, type
**?** at the command line:

.. code-block:: none

    user1@controller-0:~$ ?

    awk       echo    history   ls         pwd       source     cat    clear
    env       grep    keystone  lsudo      rm        system     cd      cp
    exit      ll      man       openstack  scp       vim       cut     export
    help      lpath     env     passwd    sftp       kubectl    helm

When a user logs in to an account of this type, they are prompted to store
Keystone credentials for the duration of the session:

.. code-block:: none

    Pre-store Keystone user credentials for this session? (y/N):y

This invokes a script to obtain the credentials. The user can invoke the
same script at any time during the session as follows:

.. code-block:: none

    user1@controller-0:~$ source /home/sysadmin/lshell_env_setup

Any Keystone credentials created by the script persist for the duration of
the session. This includes credentials added by previous invocations of the
script in the same session.


.. _establish-keystone-credentials-from-a-linux-account-section-N10079-N10020-N10001:

-------------------------------
The Keystone Credentials Script
-------------------------------

The Keystone credentials script offers the LDAP user name as the default
Keystone user name:

.. code-block:: none

    Enter Keystone username [user1]:

.. code-block:: none

    Enter Keystone user domain name:

It requires the name of the tenant for which the user requires access:

.. code-block:: none

    Enter Project name:tenant1

.. note::
    The Keystone user must be a member of a Keystone tenant. This is
    configured using Keystone.

.. code-block:: none

    Enter Project domain name:

It also requires the Keystone user password:

.. code-block:: none

    Enter Keystone password:

When the script is run during login, it sets the default **Keystone Region
Name** and **Keystone Authentication URL**.

.. code-block:: none

    Selecting default Keystone Region Name: RegionOne
    Selecting default Keystone Authentication URL: http://192.168.204.2:5000/v2.0/
    To re-configure your environment run "source ~/lshell_env_setup" in your shell

    Keystone credentials preloaded!

If the script is run from the shell after login, it provides an option to
change the **Keystone Region Name** and **Keystone Authentication URL**.


.. _establishing-keystone-credentials-from-a-linux-account-section-N100B5-N10020-N10001:

---------------------------------------------------------
Alternative Methods for Establishing Keystone Credentials
---------------------------------------------------------

You can also establish Keystone credentials using the following methods:


.. _establish-keystone-credentials-from-a-linux-account-ul-scj-rch-t5:

-   Download an OpenStack RC file \(openrc.sh\) from the Horizon Web
    interface, and use it to source the required environment. For more
    information, refer to `http://docs.openstack.org
    <http://docs.openstack.org>`__.

    .. note::
        Only users with bash shell can source the required environment. This
        does not apply to users with limited shell.

-   Add the required environment variables manually:

    **OS\_USERNAME**
        the Keystone user name

    **OS\_USER\_DOMAIN\_NAME**
        the default domain for the user

    **OS\_PROJECT\_NAME**
        the tenant name

    **OS\_PROJECT\_DOMAIN\_NAME**
        the default domain for the project

    **OS\_PASSWORD**
        a clear text representation of the Keystone password

    **OS\_AUTH\_URL**
        the Keystone Authentication URL

    **OS\_IDENTITY\_API\_VERSION**
        the identity API version

    **OS\_INTERFACE**
        the interface

    **OS\_REGION\_NAME**
        the Keystone Region Name

    For security and reliability, add all of the variables.

-   Provide credentials as command-line options.

    .. code-block:: none

        user1@controller-0:~$ system --os-username admin --os-password seeCaution host-list


.. caution::
    |org| does not recommend using the command-line option to provide
    Keystone credentials. It creates a security risk, because the
    supplied credentials are visible in the command-line history.


