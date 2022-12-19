.. _sssd-support-5fb6c4b0320b:

============================================================
SSH User Authentication using Windows Active Directory (WAD)
============================================================

By default, |SSH| to |prod| hosts supports authentication using the 'sysadmin'
Local Linux Account and |prod| Local |LDAP| Linux User Accounts.  |SSH| can
also be optionally configured to support authentication with 1 or more remote
|LDAP| identity providers (such as Windows Active Directory (WAD)). Internally,
|SSH| uses |SSSD| service to provide NSS and PAM interfaces and a backend
system able to remotely connect to multiple different |LDAP| domains.

|SSSD| provides a secure solution by using data encryption for |LDAP| user
authentication. |SSSD| supports authentication only over an encrypted channel.

In summary the |SSH|/|SSSD| solution for remote |LDAP| authentication includes:

-   Multi domain remote |LDAP| authentication

-   Extra security by using data encryption for |LDAP| user authentication

-   Offline authentication if a |LDAP| identity store is unavailable, by
    caching users and managing caching timeout and refresh

-   High authentication and authorization performance

In |prod| a maximum of 3 |LDAP| |WAD| domains are supported besides the local
Openldap domain.

.. note::

    SSH/SSSD authentication configuration described in this section also
    applies to local console logins.

You can find more information about |SSSD| configuration at
`https://linux.die.net/man/5/sssd.conf
<https://linux.die.net/man/5/sssd.conf>`__ and
`https://linux.die.net/man/5/sssd-ldap
<https://linux.die.net/man/5/sssd-ldap>`__.


--------------------------
Install WAD CA Certificate
--------------------------

To be able to successfully connect to a |WAD| domain through a secure |SSL|
connection, |SSSD| requires the |SSL| Certificate of the |CA| that signed the
remote |WAD| server's SSL Certificate to be installed on the |prod| system. The
|WAD| |CA| |SSL| certificate needs to be installed before the corresponding AD
domain is added.

The command to add |WAD| |CA| certificate:

.. code-block:: none

    system certificate-install --mode ssl_ca <AD CA certificate file>


---------------------
Add Remote WAD Domain
---------------------

A maximum of three remote |LDAP| AD domains are supported in |prod|:
``ldap-domain1``, ``ldap-domain2``, ``ldap-domain3``. Each domain needs to be
configured using mandatory and optional service parameters. Each parameter will
be validated according to industry standard validation rules for correct syntax
that apply to domain names, ldap url, and directory names. An error message
will be displayed if the parameter does not have the standard syntax.

Mandatory parameters
--------------------

To add a new remote ldap |WAD| domain the following mandatory |SSSD| parameters
need to be added using system service parameter commands:

-   ``domain_name``

-   ``ldap_uri``

-   ``ldap_access_filter``

-   ``ldap_search_base``

-   ``ldap_default_bind_dn``

-   ``ldap_default_authtok``

If a mandatory parameter is missing, an error will be displayed, naming the
missing parameter for the domain and the domain will not be created.

Commands to add mandatory parameters for a remote ldap domain:

.. code-block:: none

    system service-parameter-add <service_name> <section_name> parameter_name=<parameter_value>

    # <service_name> is “identity” for all domains.
    # <section_name> identifies a domain as either “ldap-domain1”, “ldap-domain2” or “ldap-domain3”.

    E.g.:

    system service-parameter-add identity ldap-domain1 domain_name=ad.wad-server.com

    system service-parameter-add identity ldap-domain1 ldap_uri=ldaps://ad.wad-server.com

    system service-parameter-add identity ldap-domain1 ldap_access_filter=memberOf=CN=WRCP_Admin,CN=Users,DC=wad-server,DC=com

    system service-parameter-add identity ldap-domain1 ldap_search_base=CN=Users,DC=wad-server,DC=com

    system service-parameter-add identity ldap-domain1 ldap_default_bind_dn=CN=Administrator,CN=Users,DC=wad-server,DC=com

    system service-parameter-add identity ldap-domain1 ldap_default_authtok =Passw0rd*


Optional Parameters
-------------------

There are two optional domain parameters that can be added using system service
parameter commands:

-   ``ldap_user_search_base``

-   ``ldap_group_search_base``

For example:

.. code-block:: none

    system service-parameter-add identity ldap-domain1 ldap_user_search_base=CN=Users,DC=wad-server,DC=com

    system service-parameter-add identity ldap-domain1 ldap_group_search_base=CN=Groups,DC=wad-server,DC=com

.. note::

    When not set, the 2 optional service parameters, will have as default
    value, the value of ``ldap_search_base`` service parameter.

Apply parameters
----------------

After all the domain mandatory parameters are added and if needed, the optional
ones, the parameters will be applied using :command:`service-parameter-apply`
command. Only after “apply” command the sssd domain configuration will be added to
``/etc/sssd/sssd.conf`` and becomes active, and the SSSD daemon will connect to
the remote |WAD| server.

The :command:`system service-parameter-apply` command has been enhanced for
this feature to include a ``section`` parameter that did not exist in the
previous release. The new ``section`` parameter is an optional parameter of the
:command:`service-parameter-apply` command. In the context of the ``identity``
service ldap domains it is needed to specify the domain section name, as
follows:

.. code-block:: none

    system service-parameter-apply <service-name> --section <section-name>

    E.g.:

    system service-parameter-apply identity --section ldap-domain1

Default WAD  Domain Configuration
---------------------------------

The default WAD domain configuration parameters are pre-configured. Main |SSSD|
default configuration settings include:

-   Offline Authentication is enabled, allowing users to still authenticate
    even if the ldap identity provider is unavailable. using their cached
    credentials. User credentials caching is enabled by parameter setting
    ``cache_credentials = true``. After a successful login user credentials are
    stored as part of the user account in the |SSSD| cache.

-   |WAD| Domain enumeration is disabled by using the default setting
    ``enumerate = false`` for performance reasons.

-   User home directory on the |prod| platform gets created after the first
    user login with the following path ``/home/<domain_name>/<user_name>``.

-   |CA| server certificate verification is always required by using the default
    setting for ``ldap_tls_reqcert`` parameter as ``demand``.


-----------------------------
SSH using the WAD domain user
-----------------------------

Verify SSSD is Connected to the Domain
--------------------------------------

If the |SSSD| is connected to a |WAD| domain, then the domain users have been
discovered and cached on the host. The same applies to the domain groups.

Run ``getent passwd <user_login_name>@<domain_name>``, to see if the user has
been cached on the host.

.. code-block:: none

    getent passwd pvtest1@ad.wad-server.com

Run ``getent group <group_name>@<domain_name>`` to see the group and its members.

.. code-block:: none

    getent passwd eng@ad.wad-server.com


Remote SSH
----------

Once the |SSSD| is connected to the domain, a domain user can be used to |SSH|
to the |prod| host. If a user has the same user login name in multiple domains,
the domain name can be used to distinguish between the common name users.

.. code-block:: none

    ssh -l <domain_user_name>@<domain_name> <host_IP_address>

The automatically created home directory for the user is
``/home/<domain_name>/<user_name>``.

-----------------------------------
Modify/Delete WAD Domain parameters
-----------------------------------

Modify an |SSSD| parameter for an ldap domain using system service parameter
command.

The ``service-parameter-apply`` needs to follow the
``service-parameter-modify`` so the parameter value change can take effect.

For example:

.. code-block:: none

    system service-parameter-modify identity ldap-domain1 ldap_group_search_base=CN=Users,DC=wad-server,DC=com

    system service-parameter-apply identity --section ldap-domain1

Regarding deleting |WAD| domain parameters, only optional |SSSD| service
parameters can be individually deleted:

.. code-block:: none

    system service-parameter-delete <parameter-uuid>

    system service-parameter-apply identity --section <domain_section_name>

---------------------------------
Delete a WAD Domain configuration
---------------------------------

Optional domain parameters can be deleted individually.

Mandatory parameters cannot be deleted individually, is all or none.

To fully delete a domain, delete all the mandatory parameters and the
configured optional parameters. After that, execute the :command:`service-parameter-apply``
command.

.. code-block:: none

    system service-parameter-delete <parameter-uuid>

    ------------ delete all parameters of the domain-----------

    system service-parameter-apply identity --section <domain_section_name>

Deleting a domain will cause the users to not show up with ``getent passwd``
command anymore even if they may have not been removed from cache just yet. The
users will be removed from cache according to cache expiration configuration.
The cache expiry configuration for this release, uses default values.

The |WAD| users home directories created on the platform will not be removed
after the |WAD| domain configuration is removed. It is administrator's
responsibility to clean up users' home directories that are no longer used.

------------------------------------------
SUDO Capability and Local Group Membership
------------------------------------------

Support of sudo users and local linux group membership (e.g. ``sys_protected``)
in |prod| platform is done locally after |WAD| users have been discovered by
|SSSD|.

For example:

.. code-block:: none

    # To add the WAD-discovered user "pvtest1" to the group 'sudo'
    sudo usermod -a -G sudo pvtest1@ad.wad-server.com

    # To add the WAD-discovered user "pvtest1" to the group 'sys_protected'
    sudo usermod -a -G sys_protected pvtest1@ad.wad-server.com

-------------------------------------------
Default Local OpenLDAP Domain Configuration
-------------------------------------------

The configuration for the local OpenLDAP domain is part of the default |SSSD|
configuration.

All the local OpenLDAP domain parameters are pre-configured. Main |SSSD|
default configuration settings include:

-   Domain enumeration is enabled as the local domain number of users is not as
    large to pose performance issues. The use of command :command:`getent passwd`
    will list all the remote domain discovered users.

-   The user home directory on the |prod| platform gets created after the
    first user login and has the following path ``/home/<user_name>``.

-   |CA| server certificate verification is always required by using the default
    setting for ``ldap_tls_reqcert`` parameter as ``demand``.

The OpenLDAP |SSL| certificate is created and managed internally by
|prod| platform.

---------
SSSD logs
---------

|SSSD| logs can be viewed on the host, in directory ``/var/log/sssd/sssd.log``.
Each domain also has its own log file: ``/var/log/sssd/sssd_<domain_name>.log``.

