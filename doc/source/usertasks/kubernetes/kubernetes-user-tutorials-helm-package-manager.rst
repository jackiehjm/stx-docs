
.. tnr1582059022065
.. _kubernetes-user-tutorials-helm-package-manager:

====================
Helm Package Manager
====================

|prod-long| supports Helm v3 package manager for Kubernetes that can
be used to securely manage the lifecycle of applications within the Kubernetes cluster.

.. rubric:: |context|

Helm packages are defined by Helm charts with container information sufficient
for managing a Kubernetes application. You can configure, install, and upgrade
your Kubernetes applications using Helm charts. Helm charts are defined with a
default set of values that describe the behavior of the service installed
within the Kubernetes cluster.

|prod| recommends a non-admin end-user to install a Helm v3 client on a remote
workstation to enable management of their Kubernetes applications.

For more information on Helm, see the documentation at `https://helm.sh/docs/
<https://helm.sh/docs/>`__.

For more information on how to configure and use Helm both locally and remotely, see :ref:`Configure Local CLI Access <configure-local-cli-access>`,
and :ref:`Configure Remote CLI Access <configure-remote-cli-access>`.

