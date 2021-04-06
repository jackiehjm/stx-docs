
.. tfe1552681897084
.. _remote-access-for-linux-accounts:

================================
Remote Access for Linux Accounts
================================

You can log in remotely as a Linux user\(either sysadmin or a local |LDAP|
user\) using :command:`ssh`.

.. note::
    For security reasons, it is recommended that ONLY admin level users be
    allowed to |SSH| to the nodes of the |prod|. Non-admin level users should
    strictly use remote |CLIs| or remote web GUIs.

Specifying the |OAM| floating IP address as the target establishes a
connection to the currently active controller; however, if the |OAM| floating
IP address moves from one controller node to another, the ssh session is
blocked. To ensure access to a particular controller regardless of its
current role, specify the controller physical address instead.

.. note::
    Password-based access to the **root** account is not permitted over
    remote connections.

