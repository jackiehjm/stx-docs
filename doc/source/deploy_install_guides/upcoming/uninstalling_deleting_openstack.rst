.. toctree::
   :hidden:

   uninstalling_deleting_openstack

.. _incl-uninstalling-deleting-openstack:

-------------------------------
Uninstalling/Deleting OpenStack
-------------------------------

This section provides additional commands for uninstalling and deleting the
OpenStack application.

*****************************
Bring down OpenStack Services
*****************************

Use the system CLI to uninstall the OpenStack application. OpenStack services
will be terminated.

::

   system application-remove stx-openstack
   system application-list

***************************************
Delete OpenStack application definition
***************************************

Use the system CLI to delete the OpenStack application definition.

::

   system application-delete stx-openstack
   system application-list

.. _incl-uninstalling-deleting-openstack-end:
