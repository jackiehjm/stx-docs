========
Security
========

----------
Kubernetes
----------

|prod-long| security encompasses a broad number of features.


.. _overview-of-starlingx-security-ul-ezc-k5f-p3b:

-   |TLS| support on all external interfaces

-   Kubernetes service accounts and |RBAC| policies for authentication and
    authorization of Kubernetes API / CLI / GUI

-   Encryption of Kubernetes Secret Data at Rest

-   Keystone authentication and authorization of StarlingX API / CLI / GUI

-   Barbican is used to securely store secrets such as BMC user passwords

-   Networking policies / Firewalls on external APIs

-   |UEFI| secureboot

-   Signed software updates

.. toctree::
   :maxdepth: 2

   kubernetes/index

---------
OpenStack
---------

.. check what put here

.. toctree::
    :maxdepth: 2
 
    openstack/index