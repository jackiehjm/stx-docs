
.. _uninstall_delete-r5:

===================
Uninstall OpenStack
===================

This section provides commands for uninstalling and deleting the
|prod-os| application.

.. warning::

   Uninstalling the OpenStack application will terminate all OpenStack services.

------------------------------
Remove all OpenStack resources
------------------------------

In order to ensure that all resources are properly released, use the OpenStack
|CLI| to remove all resources created in the OpenStack environment. This
includes:

-   Terminating/Deleting all servers/instances/|VMs|
-   Removing all volumes, volume backups, volume snapshots
-   Removing all Glance images
-   Removing all network trunks, floating IP addresses, manual ports,
    application ports, tenant routers, tenant networks, and shared networks.

-----------------------------
Bring down OpenStack services
-----------------------------

Use the system |CLI| to uninstall the OpenStack application:

.. parsed-literal::

      system application-remove |prefix|-openstack
      system application-list

---------------------------------------
Delete OpenStack application definition
---------------------------------------

Use the system |CLI| to delete the OpenStack application definition:

.. parsed-literal::

      system application-delete |prefix|-openstack
      system application-list
