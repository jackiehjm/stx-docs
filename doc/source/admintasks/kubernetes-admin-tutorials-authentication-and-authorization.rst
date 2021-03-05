
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

An authorized administrator \('admin' and 'sysinv'\) can perform any Docker
action. Regular users can only interact with their own repositories \(i.e.
registry.local:9001/<keystoneUserName>/\). Any authenticated user can pull from
the following list of public images: 

.. _kubernetes-admin-tutorials-authentication-and-authorization-d383e50:

-   registry.local:9001:/public/\*

-   registry.local:9001:/k8s.gcr.io/pause

-   registry.local:9001:/quay.io/jetstack/cert-manager-acmesolver

The **mtce** user can only pull public images, but cannot push any images.

For example, only **admin** and **testuser** accounts can push to or pull from
**registry.local:9001/testuser/busybox:latest**

.. _kubernetes-admin-tutorials-authentication-and-authorization-d383e87:

---------------------------------
Username and Docker compatibility
---------------------------------

Repository names in Docker registry paths must be lower case. For this reason,
a keystone user must exist that consists of all lower case characters. For
example, the user **testuser** is correct in the following URL, while
**testUser** would result in an error:

**registry.local:9001/testuser/busybox:latest**

.. note::
    Use of the auto-generated self-signed certificate for the registry
    certificate is not recommended. If you must do so, then from the central
    cloud/systemController, access to the local registry can only be done using
    registry.local:9001. registry.central:9001 will be inaccessible. Installing
    a |CA|-signed certificate for the registry and the certificate of the |CA| as
    an 'ssl\_ca' certificate will remove this restriction.

For more information about Docker commands, see
`https://docs.docker.com/engine/reference/commandline/docker/ <https://docs.docker.com/engine/reference/commandline/docker/>`__.

