
.. cas1596543672415
.. _portieris-overview:

==================
Portieris Overview
==================

.. warning::

    The Portieris application is not supported with k8s 1.22 and 1.23.
    If you apply Portieris on a system running k8s 1.22 or 1.23 this will
    result in failure of the **Apply** operation.

    **Workaround**: It is recommended to only apply the Portieris application on
    systems running k8s 1.21.8.

You can enforce |prod| image security policies using the Portieris admission
controller.

Portieris allows you to configure trust policies for an individual namespace
or cluster-wide, and checks the image against a signed image list on a
specified notary server to enforce the configured image policies. Portieris
first checks that the image's registry/repository is trusted according to
the image policies, and, if trust enforcement is enabled for that
registry/repository, Portieris verifies that a signed version of the image
exists in the specified registry / notary server.

When a workload is deployed, the |prod| kube-apiserver sends a workload
admission request to Portieris, which attempts to find matching security
policies for each image in the workload. If any image in your workload does
not satisfy the policy, then the workload is blocked from being deployed.

The |prod| implementation of Portieris is integrated with cert-manager and
can use custom registries.

Configuring a trust server \(for an image or cluster-wide\) requires network
access upon pod creation. Therefore, if a cluster has no external network
connectivity, pod creation will be blocked.

It is required to pull from a registry using a docker-registry secret.
Enforcing trust for anonymous image pulls is not supported.

|prod| integration with Portieris has been verified against the Harbor
registry and notary server \(`https://goharbor.io/
<https://goharbor.io/>`__\).

