.. _install-node-feature-discovery-nfd-starlingx-application-70f6f940bb4a:

======================================================================
Install Node Feature Discovery (NFD) |prod| Application
======================================================================

Node Feature Discovery (NFD) detects hardware features available on each node
in a kubernetes cluster and advertises those features using Kubernetes node
labels. This procedure walks you through the process of installing the |NFD|
|prod| Application.

.. rubric:: |prereq|

Before attempting to install the |NFD| |prod| application, ensure that your
system meets the following requirements:

#. Ensure that you have Kubernetes version v1.24.4 installed. If not, follow
   the steps to upgrade the Kubernetes components. For detailed instructions on
   how to upgrade, see :ref:`manual-kubernetes-components-upgrade`.


#. If you have previously installed the |NFD| Helm Chart, you need to uninstall
   it before proceeding with the new installation. To uninstall, use the
   following command:

   .. code-block:: none

       helm uninstall node-feature-discovery -n <namespace>

    Replace <namespace> with the namespace where you have the |NFD| Helm Chart
    installed.
       

.. rubric:: |proc|

Follow these steps to install the |NFD| |prod| Application:

#. Locate the |NFD| |prod| App tarball in the
   ``/usr/local/share/applications/helm`` directory.

   For example:

   .. code-block:: none

       /usr/local/share/applications/helm/node-feature-discovery-<version>.tgz

   Replace <version> with the latest version number.

#. Upload the application using the following command.

   .. code-block:: none

       ~(keystone_admin)]$ system application-upload /usr/local/share/applications/helm/node-feature-discovery-<version>.tgz

   Replace <version> with the latest version number.

#. Verify that the |NFD| |prod| application has been uploaded successfully.

   .. code-block:: none

       ~(keystone_admin)]$ system application-list

#. Apply the application using the following command.

   .. code-block:: none

       ~(keystone_admin)]$ system application-apply node-feature-discovery

#. Monitor the status of the installation using one of the following commands.

   .. code-block:: none

       ~(keystone_admin)]$ watch system application-list
        
      OR

       ~(keystone_admin)]$ watch kubectl get pods -n node-feature-discovery


.. rubric:: |result|

After a successful installation, the |NFD| |prod| deploys as the follows:

- A worker pod is created for each node in the Kubernetes cluster. These worker
  pods gather information about node features periodically and update the
  labels associated with the nodes based on the detected features.

- Additionally, there is one master pod that gathers all the updated data from
  worker pods and reporting it to Kubernetes for efficient feature management.

The |NFD| |prod| application is now installed on your system, and the hardware
features available on each node in the Kubernetes cluster will be detected and
advertised using Kubernetes node labels. You can check the labels using the
following command for any configuration:

.. code-block:: none
    
    kubectl label node/<node's name> --list | grep "feature.node.kubernetes.io"

Replace <node's name> with the specific node name such as controller-0,
controller-1, and so on.
