=============================
Uninstall StarlingX OpenStack
=============================

This section provides additional commands for uninstalling and deleting the
StarlingX OpenStack application.

.. warning::

   Uninstalling the OpenStack application will terminate all OpenStack services.

-----------------------------
Bring down OpenStack services
-----------------------------

Use the system CLI to uninstall the OpenStack application:

.. parsed-literal::

      system application-remove |prefix|-openstack
      system application-list

---------------------------------------
Delete OpenStack application definition
---------------------------------------

Use the system CLI to delete the OpenStack application definition:

.. parsed-literal::

      system application-delete |prefix|-openstack
      system application-list

