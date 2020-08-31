
.. uby1596554290953
.. _portieris-clusterimagepolicy-and-imagepolicy-configuration:

==========================================================
Portieris ClusterImagePolicy and ImagePolicy Configuration
==========================================================

Portieris supports cluster-wide and namespace-specific image policies.


.. _portieris-clusterimagepolicy-and-imagepolicy-configuration-section-cv5-2wk-4mb:

-----------
ImagePolicy
-----------

You can define Portieris' behavior in a namespace using an ImagePolicy. In
namespaces where ImagePolicies exist, they are used exclusively. If they do
not contain a match for the workload image being launched, then
ClusterImagePolicies are not referenced. For deployed workloads, images are
wildcard-matched against defined policies. If a policy matching the workload
image is not found then deployment is denied. If there are multiple matches
the most specific match is used.


.. _portieris-clusterimagepolicy-and-imagepolicy-configuration-section-vmd-fwk-4mb:

------------------
ClusterImagePolicy
------------------

You configure a ClusterImagePolicies at the cluster level. It will be used
if no ImagePolicy resource is defined in the namespace in which the workload
will be deployed. These resources have the same structure as namespace
ImagePolicies. Again, for deployed workloads, images are wildcard-matched
against defined policies and deployment will be denied if no matching policy
is found for an image. If there are multiple matches the most specific match
is used.


.. _portieris-clusterimagepolicy-and-imagepolicy-configuration-section-avq-x4r-4mb:

--------------
Trust Policies
--------------

You can specify a \[Cluster\]ImagePolicy to allow any image from a trusted
repository\(s\) or only allow images with trust data from a repository in a
registry+notary server


.. _portieris-clusterimagepolicy-and-imagepolicy-configuration-ul-bjc-hpr-4mb:

-   This example allows any image from a trusted icr.io registry; i.e. an empty policy:

    .. code-block:: none

        apiVersion: securityenforcement.admission.cloud.ibm.com/v1beta1
        kind: ImagePolicy
        metadata:
          name: allow-all-icrio
        spec:
           repositories:
            - name: "icr.io/*"
              policy:

-   This example allows only images with valid trust data \(policy.trust.enabled=true\) from the icr.io registry + notary \(policy.trust.trustServer\) server.

    .. code-block:: none

        apiVersion: securityenforcement.admission.cloud.ibm.com/v1beta1
        kind: ImagePolicy
        metadata:
          name: allow-custom
        spec:
           repositories:
            - name: "icr.io/*"
              policy:
                trust:
                  enabled: true
                  trustServer: "https://icr.io:4443"



For additional details about policies, see
`https://github.com/IBM/portieris/blob/master/POLICIES.md
<https://github.com/IBM/portieris/blob/master/POLICIES.md>`__.

