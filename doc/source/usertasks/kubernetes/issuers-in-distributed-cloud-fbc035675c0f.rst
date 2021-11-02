.. _issuers-in-distributed-cloud-fbc035675c0f:

============================
Issuers in Distributed Cloud
============================

In a Distributed Cloud environment, end-user’s applications have a number of
options for the cert-manager ISSUERs they use:

-   (Recommended) As part of your application deployment on each subcloud,
    create a cert-manager ISSUER for the External |CA| that you wish to use for
    signing your certificates.

    -   The External |CA|-type ISSUER is configured exactly the same way for
        each of your application deployments on each subcloud, and

    -   Your external clients need only trust a single External |CA|’s public
        certificate.

-   As part of your application deployment on each subcloud, create a local
    internal RootCA ``ca`` ISSUER for signing your certificates.

    -   The local internal RootCA ``ca`` ISSUER should ideally be slightly
        different (e.g. a unique subject) on each deployment, and

    -   Your external clients need to trust each application deployment’s (on
        each subcloud) local internal RootCA public certificate.

    -   This option is not ideal since this could mean 100s of RootCA
        Certificates.

.. -    As part of your application deployment on each subcloud, use the
        |prod|’s Intermediate |CA| ISSUER for that subcloud

        -   In a Distributed Cloud environment, |prod| manages a
            hierarchy of |CAs|, anchored by a single RootCA at the
            System Controller.

            See below:

            .. figure:: /usertasks/kubernetes/figures/figure_3_issuers_dist_cloud.png

            The RootCA Certificate and Intermediate |CA| Certificates are
            created/renewed automatically by |prod|.

        -   Your end-user’s application deployment on a subcloud can simply
            create/sign CERTIFICATEs using the |prod|’s
            DC-AdminEp-Intermediate-CA on the subcloud.

        -   Your external clients need only trust the single |prod|
            DC-AdminEp-Root-|CA|’s public certificate on the system Controller.

