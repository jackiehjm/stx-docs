.. _container-security-df8a251ec03f:

===========================
Container Security Planning
===========================

The following container security best practices are recommended as part of your
network security planning. 

Restrict Direct (SSH) Access to Kubernetes Nodes
------------------------------------------------

To reduce the risk of unauthorized access to host resources, only system
administrators should be allowed SSH access to |prod| nodes. Non-system admin
users should be restricted to helm and kubectl for remote access.

Use Role-based Access Control (RBAC)
------------------------------------

Define RBAC policies to exercise strict control over permissions granted to
non-admin users. Restrict non-admin users to the minimum level of privileges. 

Use Namespaces
--------------

Use Namespaces to partition application resources into logical groups to allow
the creation of RBAC policies to managing access to these resources as a whole.

Use Network Policies
--------------------

Use network policies to restrict pod-to-pod traffic to approved profiles.

Segregate Sensitive Workloads
-----------------------------

Use a combination of node taints and pod toleration to ensure that pods do not
get scheduled onto inappropriate nodes.

For sole-tenant nodes, use node selectors to segregate applications from
tenants on different worker nodes to minimize container-escape scope to
applications of the sole-tenant.

Define Resource Quotas and Resource Limits Policies
---------------------------------------------------

Do not allow the configuration of resource-unbounded containers as this puts
the system at risk of Denial-of-Service or “noisy neighbor” scenarios.

Specify Minimal-Required Security Context for Pods
--------------------------------------------------

Explicitly specify the minimal-required security context for pods, containers
and volumes through pod security policies, for example: 

-   runAsNonRoot

-   Capabilities

-   readOnlyRootFilesystem

---------------
Kata Containers
---------------

Kata containers are an optional capability on |prod| that provide a secure
container runtime with lightweight virtual machines that feel and perform like
containers, but provide stronger workload isolation. For improved performance
wrt isolation, Kata containers leverages hardware-enforced isotation with
virtualization VT extensions.   

For more information, see :ref:`starlingx-kubernetes-user-tutorials-overview`.

---------------------
Pod Security Policies
---------------------

Pod security policies provide a cluster-level resource that controls the use
of security-sensitive aspects of Pod security. PodSecurityPolicies (PSP) define
different levels of access to security-sensitive aspects of the pod. RBAC
[Cluster]Roles can then be created for these PSPs, with RBAC
[Cluster]RoleBindings of these roles to a ‘subject’ (i.e. users, groups,
serviceaccounts, etc.). 

The following considerations apply to PodSecurityPolicies (PSPs): 

-   includes enabling or disabling options such as running as root, access to
    host filesystem, access to host networking, etc.

-   are disabled by default  

-   can be enable by the System Administor via **system service-parameter-add
    kubernetes kube_apiserver admission_plugins=PodSecurityPolicy**

|prod| provides default PSP and RBAC definitions to simplify initial
usage:

-   Define a ‘restrictive’ and ‘privileged’ PSP, and corresponding
    representative RBAC Roles

-   Define initial RBAC RoleBindings for these roles such that:

    -    cluster-admin can still perform anything / anywhere

    -    authenticated users can only perform a restricted set of
         security-sensitive options on Pods and only in namespaces the user
         is allowed to access
    
Administrator can then: 

-    create other custom PodSecurityPolicies and associated RBAC Roles

-    create [Cluster]RoleBindings to the appropriate ‘subjects’.


------------------------------------
Container Image Signature Validation 
------------------------------------

The Portieris admission controller allows you to enforce image security polices
to:

-   enforce trust pinning and blocks creation of resources that use untrusted
    images

-   access trusted data in Notary server corresponding to the image

For more information about Portieris, including installation instructions, see :ref:'portieris-overview'.
