
.. ydd1583939542169
.. _configure-kubernetes-for-oidc-token-validation-after-bootstrapping-the-system:

=============================================================================
Configure Kubernetes for OIDC Token Validation after Bootstrapping the System
=============================================================================

You must configure the Kubernetes cluster's **kube-apiserver** to use the
**oidc-auth-apps** |OIDC| identity provider for validation of tokens in
Kubernetes API requests, which use |OIDC| authentication.

.. rubric:: |context|

As an alternative to performing this configuration at bootstrap time as
described in :ref:`Configure Kubernetes for OIDC Token Validation while
Bootstrapping the System
<configure-kubernetes-for-oidc-token-validation-while-bootstrapping-the-system>`,
you can do so at any time using service parameters.

.. rubric:: |proc|


.. _configure-kubernetes-for-oidc-token-validation-after-bootstrapping-the-system-steps-vlw-k2p-zkb:

#.  Set the following service parameters using the :command:`system
    service-parameter-add kubernetes kube\_apiserver` command.

    For example:

    .. code-block:: none

        ~(keystone_admin)$ system service-parameter-add kubernetes kube_apiserver oidc_client_id=stx-oidc-client-app


    -   oidc\_client\_id=<client>

        The value of this parameter may vary for different group
        configurations in your Windows Active Directory server.

    -   oidc\_groups\_claim=<groups>

    -   oidc\_issuer\_url=https://<oam-floating-ip>:<oidc-auth-apps-dex-service-NodePort>/dex

        .. note::
            For IPv6 deployments, ensure that the IPv6 OAM floating address
            is, https://\[<oam-floating-ip>\]:30556/dex \(that is, in lower
            case, and wrapped in square brackets\).

    -   oidc\_username\_claim=<email>

        The values of this parameter may vary for different user
        configurations in your Windows Active Directory server.


    The valid combinations of these service parameters are:


    -   none of the parameters

    -   oidc\_issuer\_url, oidc\_client\_id, and oidc\_username\_claim

    -   oidc\_issuer\_url, oidc\_client\_id, oidc\_username\_claim, and oidc\_groups\_claim


#.  Apply the service parameters.

    .. code-block:: none

        ~(keystone_admin)$ system service-parameter-apply kubernetes

    For more information on |OIDC| Authentication for subclouds, see
    :ref:`Centralized OIDC Authentication Setup for Distributed Cloud
    <centralized-oidc-authentication-setup-for-distributed-cloud>`.


