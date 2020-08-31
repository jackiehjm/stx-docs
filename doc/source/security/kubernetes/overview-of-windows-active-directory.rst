
.. tvb1581377605743
.. _overview-of-windows-active-directory:

====================================
Overview of Windows Active Directory
====================================

|prod-long| can be configured to use a remote Windows Active Directory server
to authenticate users of the Kubernetes API, using the **oidc-auth-apps**
application.

The **oidc-auth-apps** application installs a proxy |OIDC| identity provider
that can be configured to proxy authentication requests to an LDAP \(s\)
identity provider, such as Windows Active Directory. For more information,
see, `https://github.com/dexidp/dex <https://github.com/dexidp/dex>`__. The
**oidc-auth-apps** application also provides an |OIDC| client for accessing
the username and password |OIDC| login page for user authentication and
retrieval of tokens. An **oidc-auth** CLI script, available on Wind Share, at
`https://windshare.windriver.com/ <https://windshare.windriver.com/>`__, can
also be used for |OIDC| user authentication and retrieval of tokens.

In addition to installing and configuring the **oidc-auth-apps**
application, the admin must also configure Kubernetes cluster's
**kube-apiserver** to use the **oidc-auth-apps** |OIDC| identity provider for
validation of tokens in Kubernetes API requests.

