

.. Greg updates required for -High Security Vulnerability Document Updates

.. _reinstalling-a-subcloud-with-redfish-platform-management-service:

=============================================================
Reinstall a Subcloud with Redfish Platform Management Service
=============================================================

For subclouds with servers that support Redfish Virtual Media Service
\(version 1.2 or higher), you can use the Central cloud's CLI to reinstall
the ISO and bootstrap subclouds from the Central cloud.

.. caution::

   All application and data on the subcloud will be lost after reinstallation.

   Any records of |FPGA| device image updates on the subcloud will be lost.
   You will need to reapply the |FPGA| device image update orchestration
   procedure. For more information, see :ref:`Device Image Update Orchestration
   <device-image-update-orchestration>`.

.. rubric:: |context|

The subcloud reinstallation has these phases:

Executing the dcmanager subcloud reinstall command in the Central Cloud:

- Uses Redfish Virtual Media Service to remote install the ISO on controller-0
  in the subcloud.

- Uses Ansible to bootstrap |prod| on controller-0.

.. only:: partner

    .. include:: /_includes/reinstalling-a-subcloud-with-redfish-platform-management-service.rest
       :start-after: begin-ref-1
       :end-before: end-ref-1

.. rubric:: |prereq|

- The install values are required for subcloud reinstallation. By default,
  install values are stored in database after a subcloud installation or
  upgrade, and the reinstallation will re-use these values. You can use the
  following CLI command in the Central cloud to update them if necessary:

  .. code-block:: none

      ~(keystone_admin)]$ dcmanager subcloud update subcloud1 --install-values\ install-values.yml --bmc-password <password>

  For more information on install-values.yml file, see :ref:`Install a
  Subcloud Using Redfish Platform Management Service
  <installing-a-subcloud-using-redfish-platform-management-service>`.

  You can only reinstall the same software version with the Central cloud on
  the subcloud. If the software version of the subcloud is not same as the
  System Controller, the reinstall command will update the software version of
  the subcloud and install the correct version afterwards.


- Check the subcloud's availability in the Central cloud.

  For example:

  .. code-block:: none

      ~(keystone_admin)]$ dcmanager subcloud list

       +----+----------+------------+--------------+---------------+---------+
       | id | name     | management | availability | deploy status | sync    |
       +----+----------+------------+--------------+---------------+---------+
       | 1  | subcloud1| unmanaged  | offline      | complete      | unknown |
       +----+----------+------------+--------------+---------------+---------+

  As the reinstall will cause data and application loss, it is not necessary
  and not recommended to reinstall a healthy subcloud. Reinstallation request
  of a managed or online subcloud will therefore be rejected.

.. rubric:: |proc|

#.  Create the subcloud bootstrap-values.yml file if it is not available
    already. This file contains the configuration parameters used to bootstrap
    the controller-0 of the subcloud that differ from the default bootstrap
    values.

    For more information on bootstrap-values.yml file, see :ref:`Install a
    Subcloud Using Redfish Platform Management Service
    <installing-a-subcloud-using-redfish-platform-management-service>`.

    .. only:: partner

        .. include:: /_includes/reinstalling-a-subcloud-with-redfish-platform-management-service.rest
            :start-after: begin-ref-2
            :end-before: end-ref-2

#.  Execute the reinstall CLI.

    For example:

    .. code-block:: none

        ~(keystone_admin)]$ dcmanager subcloud reinstall subcloud1 --bootstrap-values /home/sysadmin/subcloud1-bootstrap-values.yml –sysadmin-password <sysadmin_password>

    .. only:: partner

        .. include:: /_includes/reinstalling-a-subcloud-with-redfish-platform-management-service.rest
            :start-after: begin-ref-3
            :end-before: end-ref-3

#.  Confirm the reinstall of the subcloud.

    You are prompted to enter ``reinstall`` to confirm the reinstallation.

    .. warning::

       This will reinstall the subcloud. All applications and data on the
       subcloud will be lost.

       Any records of |FPGA| device image updates on the subcloud will be lost.
       You will need to reapply the |FPGA| device image update orchestration
       procedure. For more information, see :ref:`Device Image Update Orchestration
       <device-image-update-orchestration>`.

    Please type ``reinstall`` to confirm: reinstall

    Any other input will abort the reinstallation.

#.  In the Central cloud, monitor the progress of the subcloud installation
    and bootstrapping by viewing the deploy status field of the dcmanager
    subcloud list command.

    For example:

    .. code-block:: none

        ~(keystone_admin)]$ dcmanager subcloud list

         +----+-----------+------------+--------------+---------------+---------+
         | id | name      | management | availability | deploy status | sync    |
         +----+-----------+------------+--------------+---------------+---------+
         | 1  | subcloud1 | unmanaged  | offline      | installing    | unknown |
         +----+-----------+------------+--------------+---------------+---------+

    For more information on the deploy status filed, see :ref:`Install a Subcloud Using Redfish Platform Management Service
    <installing-a-subcloud-using-redfish-platform-management-service>`.

    You can also monitor detailed logging of the subcloud installation and
    bootstrapping by monitoring the following log file on the active
    controller in the Central cloud:

    -   ``/var/log/dcmanager/ansible/subcloud1_playbook_output.log``

#.  After the subcloud is successfully reinstalled and bootstrapped, run the
    subcloud reconfig command to complete the process. The subcloud
    availability status will change from offline to online when the
    reconfiguration is complete. For more information, see :ref:`Manage
    Subclouds Using the CLI <managing-subclouds-using-the-cli>`.

.. only:: partner

    .. include:: /_includes/reinstalling-a-subcloud-with-redfish-platform-management-service.rest
        :start-after: begin-ref-4
        :end-before: end-ref-4

.. important::

    **Limitation**: When you perform a touchless subcloud install with Redfish
    using the :command:`dcmanager subcloud add` command for all servers with
    iDRAC 9 firmware installed, the subcloud install fails due to an ISO image
    insertion mount failure over an IPv6 network |prod-dc| system.

    **Workaround**: For all Dell servers with iDRAC 9 firmware installed with
    version 5.10.00.00 or below, System administrators must perform the
    following steps:

    .. rubric:: |proc|

    #.  Log in to the iDRAC 9 web interface and select, **Configuration \>
        Virtual Console** from the drop-down menu.

    #.  Select **HTML5** (or any other option except eHTML5) from the
        **Plug-in Type** drop-down menu.

    #.  Click **Apply** to apply the change.

