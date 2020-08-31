
.. feb1588344952218
.. _enable-the-use-of-cert-manager-apis-by-an-arbitrary-user:

========================================================
Enable the Use of cert-manager APIs by an Arbitrary User
========================================================

If you are currently binding fairly restrictive |RBAC| rules to non-admin
users, for these users to use cert-manager, you need to ensure they have
access to the cert-manager apiGroups, cert-manager.io and acme.cert-manager.io.

For more information, see :ref:`Private Namespace and Restricted RBAC
<private-namespace-and-restricted-rbac>`.

