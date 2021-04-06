
.. fan1552681866651
.. _establish-keystone-credentials-from-a-linux-account:

===============================================================================
For StarlingX and Platform OpenStack CLIs from a Local LDAP Linux Account Login
===============================================================================

You can establish Keystone credentials for executing StarlingX and Platform
OpenStack |CLIs| for a local |LDAP| user, if required; this is not setup by
default.

.. contents::
   :local:
   :depth: 1

.. rubric:: |context|

For more information about :command:`ldapusersetup`, see :ref:`Create LDAP
Linux Accounts <create-ldap-linux-accounts>`.

User accounts created using :command:`ldapusersetup` have access to the
StarlingX |CLIs| \(system, fm, sw-patch, dcmanager, etc.\) and the platform
'OpenStack' CLI as part of the shell.

.. rubric:: |prereq|

.. _establish-keystone-credentials-from-a-linux-account-ul-qyv-fzm-ynb:

-   You must have a platform Keystone user account. For more information about
    creating Keystone users, managing keystone projects, users and roles, see
    `https://docs.openstack.org/keystone/pike/admin/cli-manage-projects-users-and-roles.html
    <https://docs.openstack.org/keystone/pike/admin/cli-manage-projects-users-and-roles.html>`__.

-   It is recommended to use the same username for both your local |LDAP| user
    and your Keystone user.

.. rubric:: |context|

You can establish Keystone credentials, in order to use the StarlingX and
Platform OpenStack |CLIs|, using one of the following methods:

.. rubric:: |proc|

.. _estabilish-keystone-credentials-from-a-linux-account-steps-hjs-dwm-ynb:

#.  \(Method 1\) When you have logged into the Horizon Web interface with your
    Keystone user credentials, download an OpenStack RC file \(openrc.sh\), and
    use it to source the required environment within your local LDAP user shell
    . For more information on downloading your OpenStack RC file from Horizon,
    see, `http://docs.openstack.org <http://docs.openstack.org/>`__.

#.  \(Method 2\) Add the required environment variables manually into a
    wrcprc.sh file and use this to source the required environment within your
    local |LDAP| user shell.


.. note::
    For security and reliability, add all the variables.

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