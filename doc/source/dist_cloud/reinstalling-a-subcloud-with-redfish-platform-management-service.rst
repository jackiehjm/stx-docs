

.. _reinstalling-a-subcloud-with-redfish-platform-management-service:

=============================================================
Reinstall a Subcloud with Redfish Platform Management Service
=============================================================

For subclouds with servers that support Redfish Virtual Media Service
\(version 1.2 or higher\), you can use the Central Cloud's CLI to re-install
the ISO and bootstrap subclouds from the Central Cloud.

.. caution::

   All application and data on the subcloud will be lost after re-installation.

.. rubric:: |context|

The subcloud reinstallation has two phases:

Executing the dcmanager subcloud reinstall command in the Central Cloud:

- Uses Redfish Virtual Media Service to remote install the ISO on controller-0
  in the subcloud.

- Uses Ansible to bootstrap |prod| on controller-0.

.. rubric:: |prereq|

- The install values are required for subcloud reinstallation. By default,
  install values are stored in the database after a subcloud installation or
  upgrade, and the reinstallation will re-use the install values. If you want
  to update the install values, use the following CLI command in the Central
  Cloud.

  .. code-block:: none

      ~(keystone_admin)]$ dcmanager subcloud update subcloud1 --install-values install-values.yaml --bmc-password <password>

  For more information on install-values.yaml file, see :ref:`Installing a Subcloud Using Redfish Platform Management Service
  <installing-a-subcloud-using-redfish-platform-management-service>`.

  You can only reinstall the same software version with the Central Cloud on
  the subcloud.

- Check the subcloud's availability in the Central Cloud, for example,

  .. code-block:: none

      ~(keystone_admin)]$ dcmanager subcloud list

       +----+----------+------------+--------------+---------------+---------+
       | id | name     | management | availability | deploy status | sync    |
       +----+----------+------------+--------------+---------------+---------+
       | 1  | subcloud1| unmanaged  | offline      | complete      | unknown |
       +----+----------+------------+--------------+---------------+---------+

  As the reinstall will cause data and application loss, it is not necessary
  and not recommended to reinstall a healthy subcloud. The dcmanager rejects
  the reinstallation of a managed or online subcloud.

.. rubric:: |proc|

#.  Execute the reinstall using the CLI. For example,

    .. code-block:: none

        ~(keystone_admin)]$ dcmanager subcloud reinstall subcloud1

#.  Confirm the reinstall of the subcloud.

    You are prompted to enter ``reinstall`` to confirm the reinstallation.

    .. warning::

       This will reinstall the subcloud. All applications and data on the
       subcloud will be lost.

    Please type ``reinstall`` to confirm: reinstall

    Any other input will abort the reinstallation.

#.  At the Central Cloud, monitor the progress of the subcloud installation
    and bootstrapping by using the deploy status field of the dcmanager
    subcloud list command, for example,

    .. code-block:: none

        ~(keystone_admin)]$ dcmanager subcloud list

         +----+-----------+------------+--------------+---------------+---------+
         | id | name      | management | availability | deploy status | sync    |
         +----+-----------+------------+--------------+---------------+---------+
         | 1  | subcloud1 | unmanaged  | offline      | installing    | unknown |
         +----+-----------+------------+--------------+---------------+---------+

    For more information on the deploy status filed, see :ref:`Installing a Subcloud Using Redfish Platform Management Service
    <installing-a-subcloud-using-redfish-platform-management-service>`.

    You can also monitor detailed logging of the subcloud installation,
    bootstrapping by monitoring the following log files on the active
    controller in the Central Cloud.

    -  /var/log/dcmanager/subcloud_name_install_date_stamp.log
    -  /var/log/dcmanager/subcloud_name_bootstrap_date_stamp.log

#.  After the subcloud is successfully reinstalled and bootstrapped, use the
    following command to reconfigure the subcloud, **subcloud reconfig**.
    For more information, see :ref:`Managing Subclouds Using the CLI
    <managing-subclouds-using-the-cli>`.

