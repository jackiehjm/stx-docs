
.. khe1563458421728
.. _kubernetes-admin-tutorials-authentication-and-authorization:

================================
Authentication and Authorization
================================

Authentication is enabled for the local Docker registry. When logging in,
users are authenticated using their platform keystone credentials.

For example:

.. code-block:: none

    $ docker login registry.local:9001 -u <keystoneUserName> -p <keystonePassword>

An authorized administrator can perform any Docker action, while regular users
can only interact with their own repositories
\(i.e. registry.local:9001/<keystoneUserName>/\). For example, only
**admin** and **testuser** accounts can push to or pull from
**registry.local:9001/testuser/busybox:latest**

---------------------------------
Username and Docker compatibility
---------------------------------

Repository names in Docker registry paths must be lower case. For this reason,
a keystone user must exist that consists of all lower case characters. For
example, the user **testuser** is correct in the following URL, while
**testUser** would result in an error:

**registry.local:9001/testuser/busybox:latest**

For more information about Docker commands, see
`https://docs.docker.com/engine/reference/commandline/docker/ <https://docs.docker.com/engine/reference/commandline/docker/>`__.

