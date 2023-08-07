.. _uninstall-node-feature-discovery-nfd-starlingx-application-a582bfdadfb8:

======================================================================
Uninstall Node Feature Discovery (NFD) |prod| Application
======================================================================

Follow these steps to remove the Node Feature Discovery (NFD) |prod|
Application.

.. rubric:: |proc|

#. Remove |NFD| pods and resources using the following command:

   .. code-block:: none

       ~(keystone_admin)]$ system application-remove node-feature-discovery


#. Remove |NFD| helm chart and application using the following command:

   .. code-block:: none
    
       ~(keystone_admin)]$ system application-delete node-feature-discovery        


After completion of the uninstallation process, the |NFD| application will be
completely removed from your system. All related pods, resources, and
configurations associated with |NFD| will no longer be present, ensuring a
clean removal of the application.

