
.. qly1582054834918
.. _kubernetes-user-tutorials-authentication-and-authorization:

======================================================
Local Docker Registry Authentication and Authorization
======================================================

Authentication is enabled for the local docker registry. When logging in, users
are authenticated using their platform keystone credentials.

For example:

.. code-block:: none

    $ docker login registry.local:9001 -u <keystoneUserName> -p <keystonePassword>

An authorized administrator can perform any docker action, while regular users
can only interact with their own repositories \(i.e.
``registry.local:9001/<keystoneUserName>/``\). For example, only **admin** and
**testuser** accounts can push to or pull from:

.. code-block:: none

    registry.local:9001/testuser/busybox:latest

.. _kubernetes-user-tutorials-authentication-and-authorization-d315e59:

---------------------------------
Username and Docker Compatibility
---------------------------------

Repository names in Docker registry paths must be lower case. For this reason,
a keystone user must exist that consists of all lower case characters. For
example, the user **testuser** is correct in the following URL, while
**testUser** would result in an error:

.. code-block:: none

    registry.local:9001/testuser/busybox:latest

.. seealso::
    `https://docs.docker.com/engine/reference/commandline/docker/
    <https://docs.docker.com/engine/reference/commandline/docker/>`__ for more
    information about docker commands.
