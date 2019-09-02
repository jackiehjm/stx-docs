===================
Uninstall OpenStack
===================

This section provides additional commands for uninstalling and deleting the
OpenStack application.

.. warning::

   Uninstalling the OpenStack application will terminate all OpenStack services.

-----------------------------
Bring down OpenStack services
-----------------------------

Use the system CLI to uninstall the OpenStack application:

::

   system application-remove stx-openstack
   system application-list

---------------------------------------
Delete OpenStack application definition
---------------------------------------

Use the system CLI to delete the OpenStack application definition:

::

   system application-delete stx-openstack
   system application-list

