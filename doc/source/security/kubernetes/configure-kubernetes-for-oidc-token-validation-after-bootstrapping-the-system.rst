
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
    service-parameter-add kubernetes kube_apiserver` command.

    For example:

    .. code-block:: none

        ~(keystone_admin)]$ system service-parameter-add kubernetes kube_apiserver oidc-client-id=stx-oidc-client-app


    -   oidc-client-id=<client>

        The value of this parameter may vary for different group
        configurations in your Windows Active Directory server.

    -   oidc-groups-claim=<groups>

    -   oidc-issuer-url=https://<oam-floating-ip>:<oidc-auth-apps-dex-service-NodePort>/dex

        .. note::
            For IPv6 deployments, ensure that the IPv6 OAM floating address
            is, https://\[<oam-floating-ip>\]:30556/dex (that is, in lower
            case, and wrapped in square brackets).

    -   oidc-username-claim=<email>

        The values of this parameter may vary for different user
        configurations in your Windows Active Directory server.


    The valid combinations of these service parameters are:


    -   none of the parameters

    -   oidc-issuer-url, oidc-client-id, and oidc-username-claim

    -   oidc-issuer-url, oidc-client-id, oidc-username-claim, and oidc-groups-claim

        .. note::
            Historical service parameters for |OIDC| with underscores are still
            accepted: oidc_client_id, oidc_issuer_url, oidc_username_claim and
            oidc_groups_claim. These are equivalent to: oidc-client-id, oidc-issuer-url,
            oidc-username-claim and oidc-groups-claim.

#.  Apply the service parameters.

    .. code-block:: none

        ~(keystone_admin)]$ system service-parameter-apply kubernetes

    For more information on |OIDC| Authentication for subclouds, see
    :ref:`Centralized OIDC Authentication Setup for Distributed Cloud
    <centralized-oidc-authentication-setup-for-distributed-cloud>`.


