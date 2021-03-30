
.. yvw1582058782861
.. _kubernetes-admin-tutorials-helm-package-manager:

====================
Helm Package Manager
====================

|prod-long| supports Helm v3 package manager for Kubernetes that can be used to
securely manage the lifecycle of applications within the Kubernetes cluster.

.. rubric:: |context|

Helm packages are defined by Helm charts with container information sufficient
for managing a Kubernetes application. You can configure, install, and upgrade
your Kubernetes applications using Helm charts. Helm charts are defined with a
default set of values that describe the behavior of the service installed
within the Kubernetes cluster.

A Helm v3 client is installed on controllers for local use by admins to manage
end-users' Kubernetes applications.  |prod| recommends to install a Helm v3
client on a remote workstation, so that non-admin (and admin) end-users can
manage their Kubernetes applications remotely.

Upon system installation, local Helm repositories \(containing |prod-long|
packages\) are created and added to the Helm repo list.

Use the following command to list these local Helm repositories:

.. code-block:: none

    ~(keystone_admin)]$ helm repo list
    NAME            URL
    starlingx       `http://127.0.0.1:8080/helm_charts/starlingx`
    stx-platform    `http://127.0.0.1:8080/helm_charts/stx-platform`

Where the `stx-platform` repo holds helm charts of StarlingX Applications \(see
next section\) of the |prod| platform itself, while the `starlingx` repo holds
helm charts of optional StarlingX applications, such as Openstack. The admin
user can add charts to these local repos and regenerate the index to use these
charts, and add new remote repositories to the list of known repos.

For more information on Helm v3, see the documentation at `https://helm.sh/docs/ <https://helm.sh/docs/>`__.

For more information on how to configure and use Helm both locally and remotely, see :ref:`Configure Local CLI Access <configure-local-cli-access>`,
and :ref:`Configure Remote CLI Access <configure-remote-cli-access>`.
