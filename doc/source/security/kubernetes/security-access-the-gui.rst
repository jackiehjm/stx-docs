
.. cee1581955119217
.. _security-access-the-gui:

==============
Access the GUI
==============

You can access either the Horizon Web interface or the Kubernetes Dashboard
from a browser.

.. rubric:: |proc|

.. _security-access-the-gui-steps-zdy-rxd-tkb:

*   Do one of the following:

    * **For the StarlingX Horizon Web interface**

      Access the Horizon in your browser at the address:

      http://<oam-floating-ip-address>:8080

      Use the username **admin** and the sysadmin password to log in.

    * **For the Kubernetes Dashboard**

      Access the Kubernetes Dashboard GUI in your browser at the address:

      http://<oam-floating-ip-address>:<kube-dashboard-port>

      Where <kube-dashboard-port> is the port that the dashboard was installed
      on.

      Login using credentials in kubectl config on your remote workstation
      running the browser; see :ref:`Install Kubectl and Helm Clients Directly
      on a Host <security-install-kubectl-and-helm-clients-directly-on-a-host>`
      as an example for setting up kubectl config credentials for an admin
      user.

      .. note::
          The Kubernetes Dashboard is not installed by default. See |prod|
          System Configuration: :ref:`Install the Kubernetes Dashboard
          <install-the-kubernetes-dashboard>` for information on how to install
          the Kubernetes Dashboard and create a Kubernetes service account for
          the admin user to use the dashboard.
