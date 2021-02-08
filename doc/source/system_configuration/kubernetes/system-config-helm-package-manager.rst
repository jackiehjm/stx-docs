
.. emk1568230814240
.. _system-config-helm-package-manager:

====================
Helm Package Manager
====================

|prod-long| supports Helm v2 with Tiller, the Kubernetes package manager
that can be used to manage the lifecycle of end-user hosted applications
within the Kubernetes cluster.

Helm packages are defined by Helm charts with container information sufficient
for managing a Kubernetes application. You can configure, install, and
upgrade your Kubernetes applications using Helm charts. Helm charts are
defined with a default set of values that describe the behavior of the
service installed within the Kubernetes cluster.

Upon system installation, the official curated helm chart repository is added
to the local helm repo list, in addition, a number of local repositories
\(containing optional |prod-long| packages\) are created and added to the
helm repo list. For more information,
see `https://github.com/helm/charts <https://github.com/helm/charts>`__.

Use the following command to list the helm repositories:

.. parsed-literal::

    ~(keystone_admin)$ helm repo list
    NAME            URL
    stable          https://kubernetes-charts.storage.googleapis.com
    local           http://127.0.0.1:8879/charts
    starlingx       http://127.0.0.1:8080/helm_charts/starlingx
    |prefix|-platform |s|   http://127.0.0.1:8080/helm_charts/|prefix|-platform

For more information on Helm, see the documentation
at `https://helm.sh/docs/ <https://helm.sh/docs/>`__.

**Tiller** is a component of Helm. Tiller interacts directly with the
Kubernetes API server to install, upgrade, query, and remove Kubernetes
resources.
