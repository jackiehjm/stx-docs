.. _installation-66477d7646db:

============
Installation
============

.. rubric:: |proc|

Complete the following steps to install KubeVirt.

#. Upload the KubeVirt system application tarball and check the KubeVirt
   application status:

   .. only:: starlingx

      .. code-block:: none

          ~(keystone_admin)$ system application-upload /usr/local/share/applications/helm/kubevirt-app-<version>.tgz

          ~(keystone_admin)$ system application-list

   .. only:: partner

      .. include:: /_includes/installation-66477d7646db.rest
         :start-after: kubevirt-app-version
         :end-before: kubevirt-app-version

#. Apply the KubeVirt system application and check the KubeVirt and |CDI|
   status:

   .. code-block:: none

      ~(keystone_admin)$ system application-apply kubevirt-app

   Wait for kubevirt-app status to complete.

   .. code-block:: bash

      $ watch -n 5 system application-list

      # Wait for all pods in kubevirt namespace to be Running
      $ watch -n 5 kubectl get pods -n kubevirt

      # Wait for all pods in cdi namespace to be Running
      $ watch -n 5 kubectl get pods -n cdi

#. Setup 'virtctl' client executable to be accessible from sysadmin's PATH

   .. code-block:: bash

      # Create /home/sysadmin/bin directory, if it doesn't exist already
      $ mkdir -p /home/sysadmin/bin

      # Create symbolic link in /home/sysadmin/bin to virtctl client executable installed on host in step 2)
      $ cd /home/sysadmin/bin
      $ ln -s /var/opt/kubevirt/virtctl-v0.53.1-linux-amd64 virtctl

      # Logout and log back in to ensure that /home/sysadmin/bin gets added to your PATH variable.
      $ exit

      login: sysadmin
      password:

      $ which virtctl
      /home/sysadmin/bin/virtctl


.. rubric:: |result|

KubeVirt has been installed on the system.
