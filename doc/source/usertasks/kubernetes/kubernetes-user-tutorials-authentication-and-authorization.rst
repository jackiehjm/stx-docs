
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

An authorized administrator ('admin' and 'sysinv') can perform any docker
action. Regular users can only interact with their own repositories (i.e.
``registry.local:9001/<keystoneUserName>/``). Any authenticated user can pull
from the following list of public images:

.. _kubernetes-user-tutorials-authentication-and-authorization-d315e50:

-   registry.local:9001:/public/\*

-   registry.local:9001:/k8s.gcr.io/pause

-   registry.local:9001:/quay.io/jetstack/cert-manager-acmesolver


The **mtce** user can only pull public images, but cannot push any images.

For example, only **admin** and **testuser** accounts can push to or pull from:

.. code-block:: none

    registry.local:9001/testuser/busybox:latest

.. _kubernetes-user-tutorials-authentication-and-authorization-d315e87:

---------------------------------
Username and Docker Compatibility
---------------------------------

Repository names in Docker registry paths must be lower case. For this reason,
a keystone user must exist that consists of all lower case characters. For
example, the user **testuser** is correct in the following URL, while
**testUser** would result in an error:

.. code-block:: none

    registry.local:9001/testuser/busybox:latest

.. note::
    Use of the auto-generated self-signed certificate for the registry
    certificate is not recommended. If you must do so, then from the central
    cloud/systemController, access to the local registry can only be done using
    registry.local:9001. registry.central:9001 will be inaccessible. Installing
    a CA-signed certificate for the registry and the certificate of the CA as
    an 'ssl_ca' certificate will remove this restriction.

.. seealso::
    `https://docs.docker.com/engine/reference/commandline/docker/
    <https://docs.docker.com/engine/reference/commandline/docker/>`__ for more
    information about docker commands.
