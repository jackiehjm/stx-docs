
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
        | software_version            | nn.nn                      |
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
    subcloud, use the :command:`subcloud show <subcloud-name> --detail` command.

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
        | software_version            | nn.nn                      |
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
        You can enter the ``sysadmin`` password to avoid being prompted for the password.

    .. code-block:: none

        ~(keystone_admin)]$ dcmanager subcloud reconfig <subcloud-id/name> --deploy-config \
        <filepath> --sysadmin-password <password>


    where ``--deploy-config`` must reference the deployment configuration file.

    .. only:: partner

       .. include:: /_includes/managing-subclouds-using-the-cli.rest
          :start-after: deploy-config-begin
          :end-before: deploy-config-end

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

-   To show detailed information about subcloud ``install/bootstrap/deploy``
    failures, use the :command:`subcloud errors <subcloud-name>` command.

    For example:

    .. code-block:: none

        [sysadmin@controller-0 ~(keystone_admin)]$ dcmanager subcloud errors 4
        FAILED bootstrapping playbook of (subcloud1).
         detail: fatal: [subcloud1]: FAILED! => changed-false
          msg:
            - Failed to log in one of the registry. Please check if docker_registries parameter
            - "is properly configured in bootstrap overrides yaml file and docker registry certificate (where " - applicable) is valid.
            - Err_code=images_download_failure
            - "Possible failures: Logging into registry.k8s.io for user admin failed 500 Server Error: Internal Server Error ("Get "https://registry.k8s.io/v2/": net/http: request canceled while waiting for connection (Client.Timeout exceeded while awaiting headers)") | Logging into icr.io for user admin failed - 500 Server Error: Internal Server Error ("Get "https://icr.io/v2/": net/http: request canceled while waiting for connection (Client.Timeout exceeded while awaitin g headers)")"
        FAILED TASK: TASK [common/push-docker-images: Display registry login error] Tuesday 21 March 2023 0 31:13 +0000 (0:00:00.076)
        0:22:47.420
        Check docker_registries and docker proxy configurations in bootstrap values yaml file. Ensure you can manually log into the registry e.g. sudo docker login registry.local:9001 -u <registry-user> -p <registry-password>
        For bootstrap failures, please delete and re-add the subcloud after the cause of failure has been resolved.
