
.. _rehoming-a-subcloud:

=================
Rehome a Subcloud
=================

|release-caveat|

When the System Controller needs to be reinstalled, or when the subclouds from
multiple System Controllers are being consolidated into a single System
Controller, you can add already deployed subclouds to a different System
Controller using the rehoming playbook.

.. note::

    The rehoming playbook does not work with freshly installed/bootstrapped
    subclouds.

Use the following procedure to enable subcloud rehoming and to update the new
subcloud configuration \(networking parameters, passwords, etc.\) to be
compatible with the new System Controller.

.. rubric:: |context|

There are six phases for Rehoming a subcloud:


#.  Unmanage the subcloud from the previous System Controller.

    .. note::

        You can skip this phase if the previous System Controller is no longer
        running or is unable to connect to the subcloud.

#.  Update the admin password on the subcloud to match the new System
    Controller, if required.

#.  Run the :command:`subcloud add` command with the ``--migrate`` option on
    the new System Controller. This will update the System Controller and
    connect to the subcloud to update the appropriate configuration parameters.

#.  On the subcloud, lock/unlock the subcloud controller(s) to enable the new
    configuration.

#.  Use the :command:`dcmanager subcloud list` command to check the status
    of the subcloud, ensure the subcloud is online and complete before managing
    the subcloud.

#.  On the new System Controller, set the subcloud to "managed" and wait for it
    to sync.

.. rubric:: |prereq|

-   Ensure that the subcloud management subnet, oam_floating_address,
    oam_node_0_address and oam_node_1_address \(if applicable\) does not overlap
    addresses already being used by the new System Controller or any of its
    subclouds.

-   Ensure that the subcloud has been backed up, in case something goes wrong
    and a subcloud system recovery is required.

-   Transfer the yaml file that was used to bootstrap the subcloud prior to
    rehoming, to the new System Controller. This data is required for rehoming.

-   If the subcloud can be remotely installed via Redfish Virtual Media service,
    transfer the yaml file that contains the install data for this subcloud,
    and use this install data in the new System Controller, via the
    ``--install-values`` option, when running the remote subcloud reinstall,
    upgrade or restore commands.

.. warning::

    Do not rehome a subcloud if the RECONCILED status on the system host
    or any host resource of the subcloud is FALSE.

.. note::

    These prerequisites apply if the old System Controller is still available.

.. rubric:: |proc|

#.  If the previous System Controller is running, use the following command to
    ensure that it does not try to change subcloud configuration while you are
    modifying it to be compatible with the new System Controller.

    .. code-block:: none

        ~(keystone_admin)]$ dcmanager subcloud unmanage <subcloud_name>

#.  Ensure that the subcloud's bootstrap values file is available on the new
    System Controller. If required, in the subcloud's bootstrap values file
    update the **systemcontroller_gateway_address** entry to point to the
    appropriate network gateway for the new System Controller to communicate
    with the subcloud.

#.  If the admin password of the subcloud does not match the admin password of
    the new System Controller, use the following command to change the subcloud
    admin password. This step is done on the subcloud that is being migrated.

    .. code-block:: none

        ~(keystone_admin)]$ openstack user password set

    .. note::

        You will need to specify the old and the new password.

#.  For an |AIO-DX| subcloud, ensure that the active controller is
    controller-0. Perform a host-swact of the active controller \(controller-1\)
    to make controller-0 active.

    .. code-block:: none

        ~(keystone_admin)]$ system host-swact controller-1

#.  Lock controller-1 of the subcloud.

    .. code-block:: none

        ~(keystone_admin)]$ system host-lock controller-1


#.  On the new System Controller, use the following command to start the
    rehoming process.

    .. code-block:: none

        ~(keystone_admin)]$ dcmanager subcloud add --migrate --bootstrap-address <subcloud-controller-0-oam-address> --bootstrap-values <bootstrap_values_file> [--install-values <install_values_file>]

    .. note::

        You will need to update the ``systemcontroller_gateway_address``
        variable in the bootstrap values file before you perform the migration.
        This field is the gateway address to the new System Controller.

    The subcloud deploy status will change to "pre-rehome" and if the
    preliminary steps complete successfully it will change to "rehoming".
    At this point an Ansible playbook will run and update the appropriate
    configuration data in the subcloud. You can query the status by running
    :command:`dcmanager subcloud show` command. Once the subcloud has been
    updated, the subcloud deploy status will change to "complete".

    .. note::

        The ``--install-values`` is optional. It is not mandatory for subcloud
        rehoming. However, you can opt to save these values in the new System
        Controller as part of the rehoming process so that future operations
        that involve remote reinstallation of the subcloud (e.g. reinstall,
        upgrade, restore) can be performed for a rehomed subcloud similar to
        other existing Redfish capable subclouds in the Distributed Cloud.

        **Delete the "image:" line from the install-values file, if it exists, so
        that the image is correctly located based on the new System Controller
        configuration**.

#.  If the previous System Controller is still running, delete the subcloud
    after it goes offline, using the following command.

    .. code-block:: none

        ~(keystone_admin)]$ dcmanager subcloud delete <subcloud-name>

#.  For an |AIO-SX| subcloud, use the following commands to lock/unlock the
    controller \(wait for the lock to complete before unlocking the controller\).

    .. code-block:: none

        ~(keystone_admin)]$ system host-lock controller-0
        ~(keystone_admin)]$ system host-unlock controller-0

    For an |AIO-DX| subcloud, first, use the following command to unlock
    controller-1.

    .. code-block:: none

        ~(keystone_admin)]$ system host-unlock controller-1

    #.  Wait until controller-1 is unlocked/online/available, then use the
        following command to switch activity to controller-1.

        .. code-block:: none

            ~(keystone_admin)]$ system host-swact controller-0

    #.  After the swact is complete, use the following commands to lock/unlock
        controller-0.

        .. code-block:: none

            ~(keystone_admin)]$ system host-lock controller-0
            ~(keystone_admin)]$ system host-unlock controller-0

    #.  Wait until controller-0 is unlocked/online/available, then switch
        activity back to controller-0.

    #.  Perform a swact on controller-1.

        .. code-block:: none

            ~(keystone_admin)]$ system host-swact controller-1

        Wait until the swact is complete.

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
    System Controller.

    .. code-block:: none

        ~(keystone_admin)]$ dcmanager subcloud manage <subcloud-name>

#.  The new System Controller will audit the subcloud and determine whether it
    is in-sync with the System Controller.

.. only:: partner

    .. include:: /_includes/rehoming-a-subcloud.rest
       :start-after: rehoming-begin
       :end-before: rehoming-end

.. rubric:: |postreq|

After rehoming, please perform the procedure to :ref:`Update Docker Registry
Credentials on a Subcloud <updating-docker-registry-credentials-on-a-subcloud>`
to update registry credentials for the particular subcloud.

.. rubric:: Error Recovery

If the subcloud rehoming process begins successfully, (status changes to
"rehoming") but there is a transient fault that prevents step 5 from completing
successfully, then manual error recovery is required.

The first stage of error recovery is to delete the subcloud from
the new System Controller and re-attempt rehoming using the following commands:

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
