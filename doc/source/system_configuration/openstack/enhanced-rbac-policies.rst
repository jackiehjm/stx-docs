
.. _enhanced-rbac-policies:

======================
Enhanced RBAC Policies
======================

.. rubric:: |context|

The standard OpenStack RBAC roles and policies can be enhanced by updating
policy configuration in individual OpenStack Services' Helm charts.  |prod|
provides an optional set of updated policy configurations for Nova, Neutron,
Glance, Cinder, Keystone and Horizon services that introduce two new roles
('project_admin' and 'project_readonly') and modify the capabilities of the
default 'member' role.  A high-level summary of the new roles' capabilities and
the modified 'default' role capabilities are in the following table; a detailed
description is provided at end of page.

.. table::
    :widths: auto

    +------------------+------------------+---------------------------------------------------------------------------------------------------------------------------------------------+
    | Design           | Roles            | Permissions summary                                                                                                                         |
    +==================+==================+=============================================================================================================================================+
    | Default Role:    | member           | Users with role 'member' may have a limited management of project resources                                                                 |
    +------------------+------------------+---------------------------------------------------------------------------------------------------------------------------------------------+
    | New Role to add: | project_admin    | Users with role 'project_admin' can fully manage all resources of the project                                                               |
    +------------------+------------------+---------------------------------------------------------------------------------------------------------------------------------------------+
    | New Role to add: | project_readonly | Users with role 'project_readonly' can only list and display details of resources of the project, and shared resources of other projects    |
    +------------------+------------------+---------------------------------------------------------------------------------------------------------------------------------------------+

Make sure you have access to the |prod-os| |CLI| and follow the instructions in
this document.

.. rubric:: |proc|

#.  Log into your active controller.

#.  Set up admin credentials for the containerized OpenStack application:

    .. code-block:: none

        $ source /etc/platform/openrc
        $ OS_AUTH_URL=http://keystone.openstack.svc.cluster.local/v3

#.  Transfer the enhanced policies yml files to the active controller:

    .. only:: partner

        .. include:: /_includes/enhanced-rbac-policies.rest
            :start-after: tar-xvf-begin
            :end-before: tar-xvf-end

    .. only:: starlingx

        .. include:: /_includes/enhanced-rbac-policies.rest
            :start-after: r1_begin
            :end-before: r1_end

#.  Create the custom roles:

    .. code-block:: none

        ~(keystone_admin)]$ openstack role list
        ~(keystone_admin)]$ openstack role create project_admin
        ~(keystone_admin)]$ openstack role create project_readonly

#.  In order to enable the extensions required for some of the neutron tests,
    include the following configuration to the neutron Helm override yml file:

    .. parsed-literal::

        cat <<EOF >neutron-extensions.yml
        conf:
        neutron:

            DEFAULT:
                service_plugins:
                - router
                - network_segment_range
                - qos
                - segments
                - port_forwarding
                - trunk
        plugins:
            ml2_conf:
                ml2:
                    extension_drivers:
                    - port_security
                    - qos
        openvswitch_agent:
            agent:
                extensions:
                - qos
                - port_forwarding
        EOF

        system helm-override-update --reuse-values --values=./neutron-extensions.yml |prefix|-openstack neutron openstack

#.  Apply the policy overrides for each service to your cloud:

    .. parsed-literal::

        $ source /etc/platform/openrc

        ~(keystone_admin)]$ system helm-override-update --reuse-values --values=/home/sysadmin/openstack-enhanced-policies-0.1.0/keystone-policy-overrides.yml |prefix|-openstack keystone openstack
        ~(keystone_admin)]$ system helm-override-update --reuse-values --values=/home/sysadmin/openstack-enhanced-policies-0.1.0/cinder-policy-overrides.yml |prefix|-openstack cinder openstack
        ~(keystone_admin)]$ system helm-override-update --reuse-values --values=/home/sysadmin/openstack-enhanced-policies-0.1.0/nova-policy-overrides.yml |prefix|-openstack nova openstack
        ~(keystone_admin)]$ system helm-override-update --reuse-values --values=/home/sysadmin/openstack-enhanced-policies-0.1.0/neutron-policy-overrides.yml |prefix|-openstack neutron openstack
        ~(keystone_admin)]$ system helm-override-update --reuse-values --values=/home/sysadmin/openstack-enhanced-policies-0.1.0/glance-policy-overrides.yml |prefix|-openstack glance openstack
        ~(keystone_admin)]$ system helm-override-update --reuse-values --values=/home/sysadmin/openstack-enhanced-policies-0.1.0/horizon-policy-overrides.yml |prefix|-openstack horizon openstack

        ~(keystone_admin)]$ system application-apply |prefix|-openstack

#.  Watch for application overrides to finish applying:

    .. parsed-literal::

        $ watch system application-show |prefix|-openstack

-------------
Running Tests
-------------

Please follow the instructions below to test the enhanced policies on your
system. We assume that the new roles were created on your system and the
overrides were successfully applied.

.. rubric:: |proc|

#.  Change directory to the openstack-enhanced-policies-0.1.0 you transferred
    to your controller node:

    .. code-block:: none

        $ cd /home/sysadmin/openstack-enhanced-policies-0.1.0

#.  IMPORTANT: Create a venv and install the test dependencies:

    .. code-block:: none

        if [ ! -d .venv ]; then
        python3 -m venv .venv
        fi

        $ source .venv/bin/activate
        $ pip install --upgrade pip
        $ pip install -r test-requirements.txt

#.  Download CirrOS image (dependency for nova and cinder tests):

    .. code-block:: none

        $ wget http://download.cirros-cloud.net/0.3.4/cirros-0.3.4-x86_64-disk.img

#.  Execute the tests on |prod|:

    .. code-block:: none

        $ source /etc/platform/openrc
        $ OS_AUTH_URL=http://keystone.openstack.svc.cluster.local/v3
        $ pytest tests/

------------------------
To cleanup after testing
------------------------

You can use the ``run-cleanup-all.sh`` script to remove any leftovers from the
test on the environment:

.. code-block:: none

    $ source /etc/platform/openrc
    $ OS_AUTH_URL=http://keystone.openstack.svc.cluster.local/v3
    $ bash tests/run-cleanup-all.sh

-----------------------
Role Permission Details
-----------------------

.. table::
    :widths: auto

    +-------------------+---------------------------------------------------+-------------------------------------------------------+--------------------------------------------------------------------------------------------------+-------------------------------------------------------+----------------------------------------------------------------+
    | Role Permissions  | identity(keystone)                                |  compute(nova)                                        | networking(neutron)                                                                              | image(glance)                                         | volume(cinder)                                                 |
    +===================+===================================================+=======================================================+==================================================================================================+=======================================================+================================================================+
    |    member         | All operations that legacy role 'member' can do   | - Can get list and detail of instances                | - Can only create/update/delete port                                                             | - Can create and update image, upload image content   | - Can create volume                                            |
    |                   |                                                   | - Can create instance/Can open console of instance    | - Can get list and detail of resources: subnetpool, address scope, networks, subnets, etc.       |                                                       | - Can create volume from image                                 |
    |                   |                                                   | - Can access log of instance                          |                                                                                                  |                                                       | - Can create volume snapshot                                   |
    |                   |                                                   | - Can manage keypairs of his/her own                  |                                                                                                  |                                                       | - Can create volume-backup                                     |
    |                   |                                                   |                                                       |                                                                                                  |                                                       |                                                                |
    +-------------------+---------------------------------------------------+-------------------------------------------------------+--------------------------------------------------------------------------------------------------+-------------------------------------------------------+----------------------------------------------------------------+
    | project_admin     | All operations that legacy role 'member' can do   | All operations that legacy role 'member' can do       | - All operations that legacy role 'member' can do                                                | - All operations that legacy role 'member' can do     | - All operations that legacy role 'member' can do              |
    |                   |                                                   |                                                       | - Can create/update/delete 'shared' subnetpool                                                   | - Can publicize image                                 |                                                                |
    |                   |                                                   |                                                       | - Can create/update/delete address scope                                                         | - Can communitize image                               |                                                                |
    |                   |                                                   |                                                       | - Can create/update/delete shared network                                                        |                                                       |                                                                |
    +-------------------+---------------------------------------------------+-------------------------------------------------------+--------------------------------------------------------------------------------------------------+-------------------------------------------------------+----------------------------------------------------------------+
    | project_readonly  | All operations that legacy role 'member' can do   | - Can only get list and detail of instances           | - Can only get list and detail of resources: subnetpool, address scopes, networks, subnets,etc.  | - Can only get list and detail of images              | - Can only get list and detail of volumes, backups, snapshots  |
    |                   |                                                   | - Can manage key-pairs of his/her own                 |                                                                                                  |                                                       |                                                                |
    +-------------------+---------------------------------------------------+-------------------------------------------------------+--------------------------------------------------------------------------------------------------+-------------------------------------------------------+----------------------------------------------------------------+
