
.. oud1564679022947
.. _kubernetes-service-accounts:

===========================
Kubernetes Service Accounts
===========================

|prod| uses Kubernetes service accounts and Kubernetes |RBAC| policies to
identify and manage remote access to Kubernetes resources using the
Kubernetes API, kubectl CLI or the Kubernetes Dashboard.

.. note::
    |prod| can also use user accounts defined in an external Windows Active
    Directory to authenticate Kubernetes API, :command:`kubectl` CLI or the
    Kubernetes Dashboard. For more information, see :ref:`Configure OIDC
    Auth Applications <configure-oidc-auth-applications>`.

You can create and manage Kubernetes service accounts using
:command:`kubectl` as shown below.

.. note::
    It is recommended that you create and manage service accounts within the
    kube-system namespace. See :ref:`Create an Admin Type Service
    Account <create-an-admin-type-service-account>`


