
.. _migrate-an-aiosx-subcloud-to-an-aiodx-subcloud:

---------------------------------------
Migrate an AIO-SX to an AIO-DX Subcloud
---------------------------------------

.. rubric:: |context|

You can migrate an |AIO-SX| subcloud to an |AIO-DX| subcloud without
reinstallation. This operation involves updating the system mode, adding the
|OAM| unit IP addresses of each controller, and installing the second controller.

.. rubric:: |prereq|

A distributed cloud system is setup with at least a system controller and an
|AIO-SX| subcloud. The subcloud must be online and managed by dcmanager.
Both the management network and cluster-host network need to be configured and
cannot be on the loopback interface.

======================================
Reconfigure the Cluster-Host Interface
======================================

If the cluster-host interface is on the loopback interface, use the following
procedure to reconfigure the cluster-host interface on to a physical interface.

.. rubric:: |proc|

#.  Lock the active controller.

    .. code-block:: none

        ~(keystone_admin)$ system host-lock controller-0

#.  Change the class attribute to 'none' for the loopback interface.

    .. code-block:: none

        ~(keystone_admin)$ system host-if-modify controller-0 lo -c none

#.  Delete the current cluster-host interface-network configuration

    .. code-block:: none

        ~(keystone_admin)$ IFNET_UUID=$(system interface-network-list controller-0 | awk '{if ($8 =="cluster-host") print $4;}')
        ~(keystone_admin)$ system interface-network-remove $IFNET_UUID

#.  Assign the cluster-host network to the new interface. This example assumes
    the interface name is mgmt0.

    .. code-block:: none

        ~(keystone_admin)$ system interface-network-assign controller-0 mgmt0 cluster-host

.. rubric:: |postreq|

Continue with the |AIO-SX| to |AIO-DX| subcloud migration, using one of the
following procedures:

Use Ansible Playbook to Migrate a Subcloud from AIO-SX to AIO-DX, or
Manually Migrate a Subcloud from AIO-SX to AIO-DX.


.. _use-ansible-playbook-to-migrate-a-subcloud-from-AIO-SX-to-AIO-DX:

================================================================
Use Ansible Playbook to Migrate a Subcloud from AIO-SX to AIO-DX
================================================================

Use the following procedure to migrate a subcloud from |AIO-SX| to |AIO-DX|
using the ansible playbook.

.. rubric:: |prereq|

-  the subcloud must be online and managed from the System Controller
-  the subcloud's controller-0 may be locked or unlocked; the ansible playbook
   will lock the subcloud controller-0 as part of migrating the subcloud


.. rubric:: |proc|

#.  Use the :command:`ansible-vault create migrate-subcloud1-overrides-EXAMPLE.yml`
    command to securely specify the |OAM| unit IP addresses and the ansible
    ssh password. The existing |OAM| IP address of the |AIO-SX| system will be
    used as the |OAM| floating IP address of the new |AIO-DX| system.

    In the following example, 10.10.10.13 and 10.10.10.14 are the new |OAM| unit
    IP addresses for controller-0 and controller-1 respectively.

    .. code-block:: none

         {
          "ansible_ssh_pass": "St8rlingX*",
          "external_oam_node_0_address": "10.10.10.13",
          "external_oam_node_1_address": "10.10.10.14",
          }

    Use the :command:`ansible-vault edit migrate-subcloud1-overrides-EXAMPLE.yml`
    command if the file needs to be edited after it is created.

#.  On the system controller, run the ansible playbook to migrate the |AIO-SX|
    subcloud to an |AIO-DX|.

    For example, if the subcloud name is 'subcloud1', enter:

    .. code-block:: none

        ~(keystone_admin)$ ansible-playbook --ask-vault-pass /usr/share/ansible/stx-ansible/playbooks/migrate_sx_to_dx.yml -e @migrate-subcloud1-overrides-EXAMPLE.yml -i subcloud1, -v

    The ansible playbook will lock the subcloud's controller-0, if it not
    already locked, apply the configuration changes to convert the subcloud to
    an |AIO-DX| system with a single controller, and unlock controller-0.
    Wait for the controller to reset and come back up to an operational state.

#.  Software install and configure the second controller for the subcloud.

    From the System Controller, reconfigure the subcloud, using dcmanager.
    Specify the sysadmin password and the deployment configuration file, using
    the :command:`dcmanager subcloud reconfig` command.

    .. code-block:: none

        ~(keystone_admin)$ dcmanager subcloud reconfig --sysadmin-password <sysadmin_password> --deploy-config deployment-config-subcloud1-duplex.yaml <subcloud1>

    where *<sysadmin_password>* is assumed to be the login password and
    *<subcloud1>* is the name of the subcloud

    .. note::

        ``--deploy-config`` must reference a deployment configuration file for
        a |AIO-DX| subcloud.

        For example, **deployment-config-subcloud1-duplex.yaml** should only
        include changes for controller-1 as changing fields for other nodes/
        resources may cause them to go out of sync.

.. only:: partner

    .. include:: /_includes/migrate-an-aiosx-subcloud-to-an-aiodx-subcloud.rest


.. _manually-migrate-a-subcloud-from-AIO-SX-to-AIO-DX:

=================================================
Manually Migrate a Subcloud from AIO-SX to AIO-DX
=================================================

As an alternative to using the Ansible playbook, use the following procedure
to manually migrate a subcloud from |AIO-SX| to |AIO-DX|. Perform the following
commands on the |AIO-SX| subcloud.

.. rubric:: |proc|

#.  If not already locked, lock the active controller.

    .. code-block:: none

        ~(keystone_admin)$ system host-lock controller-0

#.  Change the system mode to 'duplex'.

    .. code-block:: none

        ~(keystone_admin)$ system modify --system_mode=duplex

#.  Add the |OAM| unit IP addresses of controller-0 and controller-1.

    For example, the |OAM| subnet is 10.10.10.0/24 and uses 10.10.10.13 and
    10.10.10.14 for the unit IP addresses of controller-0 and controller-1
    respectively. The existing |OAM| IP address of the |AIO-SX| system will be
    used as the OAM floating IP address of the new |AIO-DX| system.

    .. note::

        Only specifying oam_c0_ip and oam_c1_ip is necessary to configure the
        OAM unit IPs to transition to Duplex. However, oam_c0_ip and oam_c1_ip
        cannot equal the current or specified value for oam_floating_ip.

    .. code-block:: none

        ~(keystone_admin)$ system oam-modify oam_subnet=10.10.10.0/24 oam_gateway_ip=10.10.10.1 oam_floating_ip=10.10.10.12 oam_c0_ip=10.10.10.13 oam_c1_ip=10.10.10.14

#.  Unlock the controller.

    .. code-block:: none

        ~(keystone_admin)$ system host-unlock controller-0

    Wait for the controller to reset and come back up to an operational state.

#.  Software install and configure the second controller for the subcloud.

    For instructions on installing and configuring controller-1 in an
    |AIO-DX| setup to continue with the migration, see |inst-doc|.


