
.. rrh1558616429378
.. _managing-subclouds-using-the-cli:

==============================
Manage Subclouds Using the CLI
==============================

You can use the |CLI| to list subclouds, reconfigure subclouds if deployment
fails, delete subclouds, and monitor or change the managed status of subclouds.

.. rubric:: |proc|

.. _managing-subclouds-using-the-cli-steps-unordered-r4m-2w5-5cb:

-   To list subclouds, use the :command:`subcloud list` command.

    For example:

    .. code-block:: none

        ~(keystone_admin)]$ dcmanager subcloud list
        +----+-----------+--------------+--------------------+-------------+
        | id | name      | management   | availability       | sync        |
        +----+-----------+--------------+--------------------+-------------+
        |  1 | subcloud1 | managed      | online             | in-sync     |
        |  2 | subcloud2 | managed      | online             | in-sync     |
        |  3 | subcloud3 | managed      | online             | out-of-sync |
        |  4 | subcloud4 | managed      | offline            | unknown     |
        +----+-----------+--------------+--------------------+-------------+
        

-   To show information for a subcloud, use the :command:`subcloud show` command.

    .. code-block:: none

        ~(keystone_admin)]$ dcmanager subcloud show <subcloud-name>
        

    For example:

    .. code-block:: none

        ~(keystone_admin)]$ dcmanager subcloud show subcloud2
        +-----------------------------+----------------------------+
        | Field                       | Value                      |
        +-----------------------------+----------------------------+
        | id                          | 2                          |
        | name                        | subcloud2                  |
        | description                 | subcloud2 description      |
        | location                    | subcloud 2 location        |
        | software_version            | 20.06                      |
        | management                  | managed                    |
        | availability                | online                     |
        | deploy_status               | complete                   |
        | management_subnet           | 192.168.101.0/24           |
        | management_start_ip         | 192.168.101.2              |
        | management_end_ip           | 192.168.101.50             |
        | management_gateway_ip       | 192.168.101.1              |
        | systemcontroller_gateway_ip | 192.168.204.101            |
        | created_at                  | 2020-03-05 21:43:46.525251 |
        | updated_at                  | 2020-03-06 19:53:39.560771 |
        | identity_sync_status        | in-sync                    |
        | patching_sync_status        | in-sync                    |
        | platform_sync_status        | in-sync                    |
        +-----------------------------+----------------------------+
        

-   To show information about the oam-floating-ip field for a specific
    subcloud, use the :command:`subcloud
    show`<<subcloud-name\>>:command:`--detail` command.

    For example,

    .. code-block:: none

        ~(keystone_admin)]$ dcmanager subcloud show subcloud2 --detail
        +-----------------------------+----------------------------+
        | Field                       | Value                      |
        +-----------------------------+----------------------------+
        | id                          | 2                          |
        | name                        | subcloud2                  |
        | description                 | subcloud2 description      |
        | location                    | subcloud 2 location        |
        | software_version            | 20.06                      |
        | management                  | managed                    |
        | availability                | online                     |
        | deploy_status               | complete                   |
        | management_subnet           | 192.168.101.0/24           |
        | management_start_ip         | 192.168.101.2              |
        | management_end_ip           | 192.168.101.50             |
        | management_gateway_ip       | 192.168.101.1              |
        | systemcontroller_gateway_ip | 192.168.204.101            |
        | created_at                  | 2020-03-05 21:43:46.525251 |
        | updated_at                  | 2020-03-06 19:53:39.560771 |
        | identity_sync_status        | in-sync                    |
        | patching_sync_status        | in-sync                    |
        | platform_sync_status        | in-sync                    |
        | oam_floating_ip             | 10.10.10.12                |
        +-----------------------------+----------------------------+
        

-   To edit the settings for a subcloud, use the :command:`subcloud update`
    command.

    .. code-block:: none

        ~(keystone_admin)]$ dcmanager subcloud update \
        [–- description] <description> \
        [– location] <location> \
        <subcloud-name>
        

-   To toggle a subcloud between **Unmanaged** and **Managed**, pass these
    parameters to the :command:`subcloud` command.

    For example:

    .. code-block:: none

        ~(keystone_admin)]$ dcmanager subcloud unmanage <subcloud-name>
        

    .. code-block:: none

        ~(keystone_admin)]$ dcmanager subcloud manage <subcloud-name>
        

-   To reconfigure a subcloud, if deployment fails, use the :command:`subcloud reconfig` command.

    .. note::
        You can enter the sysadmin password to avoid being prompted for the password.

    .. code-block:: none

        ~(keystone_admin)]$ dcmanager subcloud reconfig <subcloud-id/name> --deploy-config \
        <<filepath>> --sysadmin-password <<password>>
        

    where``--deploy-config`` must reference the deployment configuration file.
    For more information, see either, 
    
.. xbooklink |inst-doc|: :ref:`The
    Deployment Manager <the-deployment-manager>` or |inst-doc|:
    :ref:`Deployment Manager Examples <deployment-manager-examples>` for more
    information on how to generate the file.

    .. note::

        The subcloud can be managed only if the deploy status is 'complete'.

    Run the following command to manage the subcloud:

    .. code-block:: none

        ~(keystone_admin)]$ dcmanager subcloud manage <subcloud-id/name>
        

-   To delete a subcloud, use the :command:`subcloud delete` command.

    .. code-block:: none

        ~(keystone_admin)]$ dcmanager subcloud delete <subcloud-name>
        

    .. caution::

        You must reinstall a deleted subcloud before re-adding it.


