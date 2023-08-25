.. _install-node-feature-discovery-nfd-starlingx-application-70f6f940bb4a:

==========================================
Install Node Feature Discovery Application
==========================================

Node Feature Discovery (NFD) detects hardware features available on each node
in a kubernetes cluster and advertises those features using kubernetes node
labels. Use the following procedure to install the |NFD| application.

.. rubric:: |prereq|

Before attempting to install the |NFD| application, ensure that your
system meets the following requirements:

#. Ensure that you have at least kubernetes version v1.24.4 installed. If
   kubernetes v1.24.4 is not installed, see
   :ref:`manual-kubernetes-components-upgrade` for more details.


#. If you have previously installed the |NFD| Helm chart, you need to uninstall
   it before proceeding with the new installation. To uninstall, use the
   following command:

   .. code-block:: none

       ~(keystone_admin)]$ helm uninstall node-feature-discovery -n <namespace>

   <namespace> is the location, where you installed the |NFD| Helm chart.
       

.. rubric:: |proc|

Use the following steps to install the |NFD| application:

#. Locate the |NFD| tarball in the ``/usr/local/share/applications/helm``
   directory.

   For example:

   .. code-block:: none

       /usr/local/share/applications/helm/node-feature-discovery-<version>.tgz

   Replace <version> with the latest version number.

#. Upload the application using the following command.

   .. code-block:: none

       ~(keystone_admin)]$ system application-upload /usr/local/share/applications/helm/node-feature-discovery-<version>.tgz

   Replace <version> with the latest version number.

#. Verify that the |NFD| application has been uploaded successfully.

   .. code-block:: none

       ~(keystone_admin)]$ system application-list

#. Apply the updates using the following command.

   .. code-block:: none

       ~(keystone_admin)]$ system application-apply node-feature-discovery

#. Monitor the status of the installation using one of the following commands.

   .. code-block:: none

       ~(keystone_admin)]$ watch system application-list
        
      or

       ~(keystone_admin)]$ watch kubectl get pods -n node-feature-discovery


.. rubric:: |result|

- A worker pod is created for each node in the kubernetes cluster. These worker
  pods gather information about node features periodically and updates the
  labels associated with the nodes.

- Additionally, there is one master pod that gathers all the updated data from
  worker pods and reports it for efficient feature management.

The |NFD| application is now installed on your system, and the hardware
features available on each node in the kubernetes cluster will be detected and
advertised using kubernetes node labels. To check the label for any
configuration, use the following command:

.. code-block:: none
    
    ~(keystone_admin)]$ kubectl label node/<node's name> --list | grep "feature.node.kubernetes.io"

Where <node's name> is name of the node.
