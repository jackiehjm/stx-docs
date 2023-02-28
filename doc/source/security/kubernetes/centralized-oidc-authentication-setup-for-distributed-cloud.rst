
.. afi1590692698424
.. _centralized-oidc-authentication-setup-for-distributed-cloud:

===========================================================
Centralized OIDC Authentication Setup for Distributed Cloud
===========================================================

In a |prod-dc| configuration, you can configure |OIDC| authentication
in a distributed or centralized setup.


.. _centralized-oidc-authentication-setup-for-distributed-cloud-section-ugc-xr5-wlb:

-----------------
Distributed Setup
-----------------

For a distributed setup, configure the **kube-apiserver**, and
**oidc-auth-apps** independently for each cloud, System Controller, and all
subclouds. For more information, see:


.. _centralized-oidc-authentication-setup-for-distributed-cloud-ul-gjs-ds5-wlb:

-   Configure Kubernetes for |OIDC| Token Validation


    -   :ref:`Configure Kubernetes for OIDC Token Validation while
        Bootstrapping the System
        <configure-kubernetes-for-oidc-token-validation-while-bootstrapping-the-system>`

        **or**

    -   :ref:`Configure Kubernetes for OIDC Token Validation after
        Bootstrapping the System
        <configure-kubernetes-for-oidc-token-validation-after-bootstrapping-the-system>`


-   :ref:`Configure OIDC Auth Applications <configure-oidc-auth-applications>`


All clouds **oidc-auth-apps** can be configured to communicate to the same
or different remote Windows Active Directory servers, however, each cloud
manages |OIDC| tokens individually. A user must login, authenticate, and get
an |OIDC| token for each cloud independently.


.. _centralized-oidc-authentication-setup-for-distributed-cloud-section-yqz-yr5-wlb:

-----------------
Centralized Setup
-----------------

For a centralized setup, the **oidc-auth-apps** is configured '**only**' on
the System Controller. The **kube-apiserver** must be configured on all
clouds, System Controller, and all subclouds, to point to the centralized
**oidc-auth-apps** running on the System Controller. In the centralized
setup, a user logs in, authenticates, and gets an |OIDC| token from the
Central System Controller's |OIDC| identity provider, and uses the |OIDC| token
with '**any**' of the subclouds as well as the System Controller cloud.

For a centralized |OIDC| authentication setup, use the following procedure:

.. rubric:: |proc|

#.  Configure the **kube-apiserver** parameters on the System Controller and
    each subcloud during bootstrapping, or by using the **system
    service-parameter-add kubernetes kube_apiserver** command after
    bootstrapping the system, using the System Controller's floating OAM IP
    address as the oidc-issuer-url for all clouds.
    address as the oidc-issuer-url for all clouds.

    For example,
    oidc-issuer-url=https://<central-cloud-floating-ip>:<oidc-auth-apps-dex
    -service-NodePort>/dex on the subcloud.

    For more information, see:


    -   :ref:`Configure Kubernetes for OIDC Token Validation while
        Bootstrapping the System
        <configure-kubernetes-for-oidc-token-validation-while-bootstrapping-the-system>`

        **or**

    -   :ref:`Configure Kubernetes for OIDC Token Validation after
        Bootstrapping the System
        <configure-kubernetes-for-oidc-token-validation-after-bootstrapping-the-system>`


#.  On the System Controller only configure the **oidc-auth-apps**. For more information, see:

    :ref:`Configure OIDC Auth Applications <configure-oidc-auth-applications>`

    .. note::
        For IPv6 deployments, ensure that the IPv6 OAM floating address is,
        https://\[<central-cloud-floating-ip>\]:30556/dex (that is, in
        lower case, and wrapped in square brackets).


.. rubric:: |postreq|

For more information on configuring Users, Groups, Authorization, and
**kubectl** for the user and retrieving the token on subclouds, see:


.. _centralized-oidc-authentication-setup-for-distributed-cloud-ul-vf3-jnl-vlb:

-   :ref:`Configure Users, Groups, and Authorization <configure-users-groups-and-authorization>`

-   :ref:`Configure Kubectl with a Context for the User <configure-kubectl-with-a-context-for-the-user>`


For more information on Obtaining the Authentication Token, see:


.. _centralized-oidc-authentication-setup-for-distributed-cloud-ul-wf3-jnl-vlb:

-   :ref:`Obtain the Authentication Token Using the oidc-auth Shell Script
    <obtain-the-authentication-token-using-the-oidc-auth-shell-script>`

-   :ref:`Obtain the Authentication Token Using the Browser
    <obtain-the-authentication-token-using-the-browser>`


