
.. thj1582049068370
.. _configure-kubernetes-for-oidc-token-validation-while-bootstrapping-the-system:

=============================================================================
Configure Kubernetes for OIDC Token Validation while Bootstrapping the System
=============================================================================

You must configure the Kubernetes cluster's **kube-apiserver** to use the
**oidc-auth-apps** |OIDC| identity provider for validation of tokens in
Kubernetes API requests, which use |OIDC| authentication.

.. rubric:: |context|

Complete these steps to configure Kubernetes for |OIDC| token validation
during bootstrapping and deployment.

The values set in this procedure can be changed at any time using service
parameters as described in :ref:`Configure Kubernetes for OIDC Token
Validation after Bootstrapping the System
<configure-kubernetes-for-oidc-token-validation-after-bootstrapping-the-system>`.

.. rubric:: |proc|

-   Configure the Kubernetes cluster **kube-apiserver** by adding the
    following parameters to the localhost.yml file, during bootstrap:

    .. code-block:: none

        # cd ~
        # cat <<EOF > /home/sysadmin/localhost.yml
        apiserver_oidc:
          client_id: <stx-oidc-client-app>
          issuer_url: https://<oam-floating-ip>:<oidc-auth-apps-dex-service-NodePort>/dex
          username_claim: <email>
          groups_claim: <groups>
        EOF

    where:

    **<oidc-auth-apps-dex-service-NodePort>**

    is the port to be configured for the NodePort service for dex in
    **oidc-auth-apps**. The default is 30556.

    The values of the **username\_claim**, and **groups\_claim** parameters
    could vary for different user and groups configurations in your Windows
    Active Directory server.

    .. note::
        For IPv6 deployments, ensure that the IPv6 OAM floating address in
        the **issuer\_url** is, https://\[<oam-floating-ip>\]:30556/dex
        \(that is, in lower case, and wrapped in square brackets\).


.. rubric:: |result|

For more information on |OIDC| Authentication for subclouds, see
:ref:`Centralized OIDC Authentication Setup for Distributed Cloud
<centralized-oidc-authentication-setup-for-distributed-cloud>`.

