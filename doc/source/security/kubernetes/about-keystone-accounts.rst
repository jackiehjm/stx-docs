
.. ibp1552572465781
.. _about-keystone-accounts:

=======================
About Keystone Accounts
=======================

|prod| uses tenant accounts and user accounts to identify and manage access to
StarlingX resources, and images in the Local Docker Registry.

You can create and manage Keystone projects and users from the web management
interface, the CLI, or the |prod|'s Keystone REST API.

In |prod|, the default authentication backend for Keystone users is the local
SQL Database Identity Service.

.. note::
    All Kubernetes accounts are subject to system password rules. For
    complete details on password rules, see :ref:`System Account Password
    Rules <starlingx-system-accounts-system-account-password-rules>`.

