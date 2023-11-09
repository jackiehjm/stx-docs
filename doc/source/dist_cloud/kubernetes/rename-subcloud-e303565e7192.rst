.. _rename-subcloud-e303565e7192:

=================
Rename a Subcloud
=================

You can rename an existing subcloud using the |CLI| or Horizon.

.. rubric:: |prereq|

In order to rename a partucular subcloud, the subcloud must be in the
**unmanaged** mode and the deployment status must be either **complete** or
**prestage-complete**. Otherwise, you will get the following error message:

.. code-block:: none

    The server could not comply with the request since it is either malformed or otherwise incorrect.  Subcloud subcloud1 must be unmanaged and in a valid deploy state for the subcloud rename operation.
    ERROR (app) Unable to update subcloud subcloud1

---------------------------
Rename a Subcloud Using CLI
---------------------------

To rename a subcloud, you can run the :command:`dcmanager subcloud update <old-subcloud-name> --name <new-subcloud-name>` command.

Example:

.. code-block:: none

    ~(keystone_admin)]$ dcmanager subcloud update subcloud1 --name amea

    +-----------------------------+----------------------------------------------------------+
    | Field                       | Value                                                    |
    +-----------------------------+----------------------------------------------------------+
    | id                          | 1                                                        |
    | name                        | amea                                                     |
    | description                 | VBOX DC 1 subcloud 1                                     |
    | location                    | VBOX workstation: workstation_central address: 127.0.0.1 |
    | software_version            | 23.09                                                    |
    | management                  | unmanaged                                                |
    | availability                | online                                                   |
    | deploy_status               | prestage-complete                                        |
    | management_subnet           | 192.168.1.0/26                                           |
    | management_start_ip         | 192.168.1.2                                              |
    | management_end_ip           | 192.168.1.50                                             |
    | management_gateway_ip       | 192.168.1.1                                              |
    | systemcontroller_gateway_ip | 192.168.0.1                                              |
    | group_id                    | 1                                                        |
    | created_at                  | 2023-07-04 12:50:01.337635                               |
    | updated_at                  | 2023-07-04 13:16:32.232211                               |
    | backup_status               | None                                                     |
    | backup_datetime             | None                                                     |
    +-----------------------------+----------------------------------------------------------+

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Renaming a subcloud while rehoming
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

It may be required to change the name of a subcloud during the rehoming
process. For example, if you are rehoming an existing subcloud whose region
name is the same as the subcloud name, the dcmanager will try to query the
region name as long as the subcloud is operational for the rehoming process.
The dcmanager then uses the name of the queried region to create it on the
destination |DC|. If the region name already exists on the destination |DC|,
the dcmanager will throw an error.

To avoid this scenario, you can rename a subcloud while rehoming by using the following command:

.. code-block:: none

    ~(keystone_admin)]$ dcmanager subcloud add --migrate --name [NEW_SUBCLOUD_NAME] --bootstrap-address [BOOTSTRAP_ADDR] --bootstrap-values [BOOTSTRAP_VALUES] --deploy-config [DEPLOY_CONFIG] --install-values [INSTALL_VALUES]

    +-----------------------------+----------------------------------------------------------+
    | Field                       | Value                                                    |
    +-----------------------------+----------------------------------------------------------+
    | id                          | 1                                                        |
    | name                        | [NEW_SUBCLOUD_NAME]                                      |
    | description                 | VBOX DC 1 subcloud 1                                     |
    | location                    | VBOX workstation: workstation_central address: 127.0.0.1 |
    | software_version            | 23.09                                                    |
    | management                  | unmanaged                                                |
    | availability                | offline                                                  |
    | deploy_status               | not-deployed                                             |
    | management_subnet           | 192.168.1.0/26                                           |
    | management_start_ip         | 192.168.1.2                                              |
    | management_end_ip           | 192.168.1.50                                             |
    | management_gateway_ip       | 192.168.1.1                                              |
    | systemcontroller_gateway_ip | 192.168.0.1                                              |
    | group_id                    | 1                                                        |
    | created_at                  | 2023-06-08 07:10:05.026072                               |
    | updated_at                  | None                                                     |
    | backup_status               | None                                                     |
    | backup_datetime             | None                                                     |
    +-----------------------------+----------------------------------------------------------+

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Show subcloud detailed information
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

To determine the region name of a given subcloud, you can run the following command:

.. code-block:: none

    ~(keystone_admin)]$ dcmanager subcloud show subcloud1 --detail

    +-----------------------------+----------------------------------------------------------+
    | Field                       | Value                                                    |
    +-----------------------------+----------------------------------------------------------+
    | id                          | 1                                                        |
    | name                        | subcloud1                                                |
    | description                 | VBOX DC 1 subcloud 1                                     |
    | location                    | VBOX workstation: workstation_central address: 127.0.0.1 |
    | software_version            | 23.09                                                    |
    | management                  | managed                                                  |
    | availability                | online                                                   |
    | deploy_status               | complete                                                 |
    | management_subnet           | 192.168.1.0/26                                           |
    | management_start_ip         | 192.168.1.2                                              |
    | management_end_ip           | 192.168.1.50                                             |
    | management_gateway_ip       | 192.168.1.1                                              |
    | systemcontroller_gateway_ip | 192.168.0.1                                              |
    | group_id                    | 1                                                        |
    | created_at                  | 2023-07-04 12:50:01.337635                               |
    | updated_at                  | 2023-07-04 13:16:32.232211                               |
    | backup_status               | None                                                     |
    | backup_datetime             | None                                                     |
    | dc-cert_sync_status         | in-sync                                                  |
    | firmware_sync_status        | in-sync                                                  |
    | identity_sync_status        | in-sync                                                  |
    | kubernetes_sync_status      | in-sync                                                  |
    | kube-rootca_sync_status     | in-sync                                                  |
    | load_sync_status            | in-sync                                                  |
    | patching_sync_status        | in-sync                                                  |
    | platform_sync_status        | in-sync                                                  |
    | oam_floating_ip             | 10.41.1.3                                                |
    | deploy_config_sync_status   | Deployment: configurations up-to-date                    |
    | region_name                 | 889a9b126af8481287b9c36286c1f275                         |
    +-----------------------------+----------------------------------------------------------+

-------------------------------
Rename a Subcloud Using Horizon
-------------------------------

You can rename a subcloud from the System Controller.

.. rubric:: |proc|

#. From the System Controller, go to the subcloud list.

#. From the list of subclouds, go to the **Actions** menu of the subcloud whose
   name you want to change and select **Edit Subcloud**.

   .. image:: figures/renamesubcloud_GUI.png
       :width: 800

#. In the **Edit Subcloud** page, change the name of the subcloud in the
   **Name** field and click **Submit**.

   .. image:: figures/renamesubcloud_GUI2.png
       :width: 800

.. rubric:: |postreq|

Remember to return the subcloud to **managed** after renaming  the subcloud so
that the subcloud is actively monitored and in sync.

.. note::

    -  After renaming a subcloud, the alarms of the subcloud will be cleared and
       the system will generate new alarms using the new subcloud name.
    -  All the files (ansible files, logs files) linked to the subcloud name will
       also be renamed if the subcloud is renamed.
    -  If a subcloud is renamed, the logs will show the new name of the subcloud.
    -  For the subclouds whose region name is same as subcloud name, the region
       name would remain same as used at the time of bootstrapping.

---------------------
Errors and Exceptions
---------------------

You may encounter the following error scenarios while attempting to rename a subcloud:

- Error while trying to rename a subcloud with the same name as the existing subcloud you are trying to rename.

  .. code-block:: none

      Provided subcloud name SUBCLOUD_NAME is the same as the current subcloud SUBCLOUD_NAME. A different name is required to rename the subcloud

- Error while trying to rename a subcloud with the name of other existing subcloud

  .. code-block:: none

      Subcloud with name or region name SUCLOUD_NAME already exist.

- Error while trying to rename a subcloud with a non-standard naming convention

  .. code-block:: none

      new name must contain alphabetic characters

- Error while trying to create a subcloud using the ``--name`` option

  .. code-block:: none

      The --name option can only be used with --migrate option.

- Error while trying to migrate a subcloud using the ``--name`` parameter with a value different from
  the subcloud name defined in the bootstrap file

  .. code-block:: none

      subcloud name does not match the name defined in bootstrap file

- Generic error of rename operation

  .. code-block:: none

      Unable to rename subcloud SUBCLOUD_NAME with their region REGION_NAME to NEW_SUBCLOUD_NAME

- Generic error of region creation

  .. code-block:: none

      Unable to generate subcloud region


