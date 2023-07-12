
.. Greg updates required for -High Security Vulnerability Document Updates

.. _rehoming-a-subcloud:

=================
Rehome a Subcloud
=================

When you need to reinstall the system controller, or when the subclouds from
multiple system controllers are being consolidated into a single system
controller, you can add already deployed subclouds to a different system
controller using the rehoming playbook.

.. note::

    The rehoming playbook does not work with freshly installed/bootstrapped
    subclouds.

.. note::

    The system time should be accurately configured on the system controllers
    and the subcloud's controllers before rehoming the subcloud.

.. warning::

    Do not rehome a subcloud if the RECONCILED status on the system resource or
    any host resource of the subcloud is FALSE. To check the RECONCILED status,
    run the :command:`kubectl -n deployment get system` and :command:`kubectl -n deployment get hosts` commands.
    
Use the following procedure to enable subcloud rehoming and to update the new
subcloud configuration (networking parameters, passwords, etc.) to be
compatible with the new system controller.

.. rubric:: |context|

There are six phases for Rehoming a subcloud:


#.  Unmanage the subcloud from the previous system controller.

    .. note::

        You can skip this step if the previous system controller is no longer
        running or is unable to connect to the subcloud.

#.  Update the admin password on the subcloud to match the new System
    Controller, if required.

#.  Run the :command:`subcloud add` command with the ``--migrate`` option on
    the new system controller. This will update the system controller and
    connect to the subcloud to update the appropriate configuration parameters.

#.  Use the :command:`dcmanager subcloud list` command to check the status
    of the subcloud, ensure the subcloud is online and complete before managing
    the subcloud.

#.  Delete the subcloud from the previous system controller after the subcloud
    is offline.

    .. note::

        You can skip this phase if the previous system controller is no longer
        running or is unable to connect to the subcloud.

#.  On the new system controller, set the subcloud to "managed" and wait for it
    to sync.

.. rubric:: |prereq|

-   Ensure that the subcloud management or admin subnet, oam_floating_address,
    oam_node_0_address and oam_node_1_address (if applicable) does not overlap
    addresses already being used by the new system controller or any of its
    subclouds.

-   Ensure that the subcloud has been backed up, in case something goes wrong
    and a subcloud system recovery is required.

-   Ensure that the system time between new system controllers and the subclouds
    are accurately configured.

    .. code-block:: none

        ~(keystone_admin)]$ date -u

    If the time is not correct either on the system controllers or the subclouds,
    check the system's ``clock_synchronization`` config on the system.

    .. code-block:: none

        ~(keystone_admin)]$ system host-show controller-0

    Check the |NTP| server configuration or |PTP| server configuration sections
    to correct the system time based on the system's ``clock_synchronization``
    config (|NTP| or |PTP|).

-   Transfer the yaml file that was used to bootstrap the subcloud prior to
    rehoming, to the new system controller. This data is required for rehoming.

-   If the subcloud can be remotely installed via Redfish Virtual Media service,
    transfer the yaml file that contains the install data for this subcloud,
    and use this install data in the new system controller, via the
    ``--install-values`` option, when running the remote subcloud reinstall,
    upgrade or restore commands.


.. note::

    These prerequisites apply if the old system controller is still available.

.. rubric:: |proc|

#.  If the previous system controller is running, use the following command to
    ensure that it does not try to change subcloud configuration while you are
    modifying it to be compatible with the new system controller.

    .. code-block:: none

        ~(keystone_admin)]$ dcmanager subcloud unmanage <subcloud_name>

#.  Ensure that the subcloud's bootstrap values file is available on the new
    system controller. If required, in the subcloud's bootstrap values file
    update the ``systemcontroller_gateway_address`` entry to point to the
    appropriate network gateway for the new system controller to communicate
    with the subcloud.

#.  If the admin password of the subcloud does not match the admin password of
    the new system controller, use the following command to change the subcloud
    admin password. This step is done on the subcloud that is being migrated.

    .. code-block:: none

        ~(keystone_admin)]$ openstack user password set

    .. note::

        You will need to specify the old and the new password.

#.  For an |AIO-DX| subcloud, ensure that the active controller is
    controller-0. Perform a host-swact of the active controller (controller-1)
    to make controller-0 active.

    .. code-block:: none

        ~(keystone_admin)]$ system host-swact controller-1

#.  Ensure that all the subcloud controllers are online and available by the
    :command:`system host-list` command, and free of "250.001 config out-of-date"
    alarm by the :command:`fm alarm-list` command. If there's "250.001 config
    out-of-date" alarm, a lock/unlock is required to clear that alarm on the node
    before the next step.

#.  On the new system controller, use the following command to start the
    rehoming process.

    .. code-block:: none

        ~(keystone_admin)]$ dcmanager subcloud add --migrate --bootstrap-address <subcloud-controller-0-oam-address> --bootstrap-values <bootstrap_values_file> [--install-values <install_values_file>]

    .. note::

        You will need to update the ``systemcontroller_gateway_address``
        variable in the bootstrap values file before you perform the migration.
        This field is the gateway address to the new system controller.

    The subcloud deploy status will change to "pre-rehome" and if the
    preliminary steps complete successfully it will change to "rehoming".
    At this point an Ansible playbook will run and update the appropriate
    configuration data in the subcloud. You can query the status by running
    :command:`dcmanager subcloud show` command. Once the subcloud has been
    updated, the subcloud deploy status will change to "complete".

    .. note::

        The ``--install-values`` parameter is optional and is not mandatory
        for subcloud rehoming. However, you can opt to save these values on the
        new system controller as part of the rehoming process so that future
        operations that involve remote reinstallation of the subcloud (e.g.
        reinstall, upgrade, restore) can be performed for the rehomed subcloud.

        The subcloud install values can also be added to or updated on the new
        system controller using the :command:`dcmanager subcloud update --install-values`
        command after rehoming the subcloud.

        **Delete the "image:" line from the install-values file, if it exists, so
        that the image is correctly located based on the new system controller
        configuration**.

#.  If the previous system controller is still running, delete the subcloud
    after it goes offline, using the following command.

    .. code-block:: none

        ~(keystone_admin)]$ dcmanager subcloud delete <subcloud-name>

#.  Use the :command:`dcmanager subcloud list` command to display the status of
    the subcloud, and ensure the subcloud is online and complete before
    managing the subcloud.

    .. code-block:: none

        ~(keystone_admin)]$ dcmanager subcloud list

        +----+-----------+------------+--------------+---------------+---------+
        | id | name      | management | availability | deploy status | sync    |
        +----+-----------+------------+--------------+---------------+---------+
        |  1 | subcloud1 | unmanaged  | online       | complete      | unknown |
        +----+-----------+------------+--------------+---------------+---------+

#.  Use the following command to "manage" the subcloud. This is executed on the
    system controller.

    .. code-block:: none

        ~(keystone_admin)]$ dcmanager subcloud manage <subcloud-name>

#.  The new system controller will audit the subcloud and determine whether it
    is in-sync with the system controller.

.. only:: partner

    .. include:: /_includes/rehoming-a-subcloud.rest
       :start-after: rehoming-begin
       :end-before: rehoming-end

.. rubric:: Error Recovery

If the subcloud rehoming process begins successfully, (status changes to
"rehoming") but there is a transient fault that prevents step 5 from completing
successfully, then manual error recovery is required.

The first stage of error recovery is to delete the subcloud from
the new system controller and re-attempt rehoming using the following commands:

.. code-block:: none

    ~(keystone_admin)]$ dcmanager subcloud delete <subcloud-name>
    ~(keystone_admin)]$ dcmanager subcloud add --migrate --bootstrap-address <subcloud-controller-0-oam-address> --bootstrap-values <bootstrap_values_file> [--install-values <install_values_file>]

.. only:: partner

    .. include:: /_includes/rehoming-a-subcloud.rest
       :start-after: rehoming-supportbegin
       :end-before: rehoming-supportend

If all attempts fail, restore the subcloud from backups, that will revert the
subcloud to the original state prior to rehoming.

.. only:: partner

    .. include:: /_includes/dm-credentials-on-keystone-pwds.rest

