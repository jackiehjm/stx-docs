
.. byh1570029392020
.. _enable-https-access-for-starlingx-rest-and-web-server-endpoints:

===============================================================
Enable HTTPS Access for StarlingX REST and Web Server Endpoints
===============================================================

When secure HTTPS connectivity is enabled, HTTP is disabled.

.. rubric:: |context|

.. _enable-https-access-for-starlingx-rest-and-web-server-endpoints-ul-nt1-h5f-3kb:

.. note::
    When you change from HTTP to HTTPS, or from HTTPS to HTTP:

    -   Remote CLI users must re-source the |prod| rc file.

    -   Public endpoints are changed to HTTP or HTTPS, depending on which
        is enabled.

    -   You must change the port portion of the Horizon Web interface URL.

        For HTTP, use http:<oam-floating-ip-address>:8080

        For HTTPS, use https:<oam-floating-ip-address>:8443

    -   You must logout and re-login into Horizon for the HTTPS Access
        changes to be displayed accurately in Horizon.


.. rubric:: |proc|

-   To enable HTTPS for StarlingX REST and Web Server endpoints:

    .. code-block:: none

        ~(keystone_admin)]$ system modify --https_enabled true

-   To disable HTTPS for StarlingX REST and Web Server endpoints:

    .. code-block:: none

        ~(keystone_admin)]$ system modify --https_enabled false

-   Use the following command to display HTTPS settings:

    .. code-block:: none

        [sysadmin@controller-0 ~(keystone_admin)]$ system show
        +----------------------+--------------------------------------+
        | Property             | Value                                |
        --------------------------------------------------------------+
        | contact              | None                                 |
        | created_at           | 2020-02-27T15:47:23.102735+00:00     |
        | description          | None                                 |
        | https_enabled        | False                                |
        | location             | None                                 |
        | name                 | 468f57ef-34c1-4e00-bba0-fa1b3f134b2b |
        | region_name          | RegionOne                            |
        | sdn_enabled          | False                                |
        | security_feature     | spectre_meltdown_v1                  |
        | service_project_name | services                             |
        | software_version     | 20.06                                |
        | system_mode          | duplex                               |
        | system_type          | Standard                             |
        | timezone             | Canada/Eastern                       |
        | updated_at           | 2020-02-28T10:56:24.297774+00:00     |
        | uuid                 | c0e35924-e139-4dfc-945d-47f9a663d710 |
        | vswitch_type         | none                                 |
        +----------------------+--------------------------------------+


