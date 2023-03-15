
.. nur1552673269771
.. _changing-the-timezone-configuration:

=================================
Change the Timezone Configuration
=================================

You can change the timezone defined for |prod| at any time after installation.

You can use the CLI to view and change the timezone configuration.

.. rubric:: |proc|

-   To view the existing timezone configuration, use the following command.

    .. code-block:: none

        $ system show

        +----------------------+--------------------------------------+
        | Property             | Value                                |
        --------------------------------------------------------------+
        | contact              | None                                 |
        | created_at           | 2019-12-09T16:08:34.271346+00:00     |
        | description          | None                                 |
        | https_enabled        | False                                |
        | location             | None                                 |
        | name                 | 468f57ef-34c1-4e00-bba0-fa1b3f134b2b |
        | region_name          | RegionOne                            |
        | sdn_enabled          | False                                |
        | security_feature     | spectre_meltdown_v1                  |
        | service_project_name | services                             |
        | software_version     | nn.nn                                |
        | system_mode          | duplex                               |
        | system_type          | Standard                             |
        | timezone             | Canada/Eastern                       |
        | updated_at           | 2019-12-09T16:19:56.987581+00:00     |
        | uuid                 | c0e35924-e139-4dfc-945d-47f9a663d710 |
        | vswitch_type         | none                                 |
        +----------------------+--------------------------------------+


-   To change the timezone, use the following command syntax:

    :command:`system modify --timezone=<one_specific_timezone>`

    For example:

    .. code-block:: none

        $ system modify --timezone=Asia/Hong_Kong

    Check that the timezone name you are using is installed in /usr/share/zoneinfo.

    After this command is executed, a several seconds delay is expected before
    the configuration is applied to the system.