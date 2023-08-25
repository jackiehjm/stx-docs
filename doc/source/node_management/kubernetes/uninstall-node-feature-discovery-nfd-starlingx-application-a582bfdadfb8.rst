.. _uninstall-node-feature-discovery-nfd-starlingx-application-a582bfdadfb8:

============================================
Uninstall Node Feature Discovery Application
============================================

Use the following procedure to uninstall the |NFD| application.

.. rubric:: |proc|

#. Remove the |NFD| pods and resources using the following command:

   .. code-block:: none

       ~(keystone_admin)]$ system application-remove node-feature-discovery


#. Remove the |NFD| helm chart and application using the following command:

   .. code-block:: none
    
       ~(keystone_admin)]$ system application-delete node-feature-discovery        


Once uninstallation is complete, all related pods, resources and configurations
will be removed from the system.

