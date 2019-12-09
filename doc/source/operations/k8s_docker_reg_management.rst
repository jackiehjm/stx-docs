=============================================
Kubernetes Docker Registry Management (Local)
=============================================

This guide describes how to use and manage the local Docker registry.

.. contents::
   :local:
   :depth: 1

--------
Overview
--------

A local Docker registry is deployed by default on the controller/master nodes,
as part of the StarlingX Kubernetes deployment. It can be accessed at
`registry.local:9001`.

StarlingX stores container images in the local Docker registry, which is also
available for end users to store hosted application container images.

For more information about Docker Registry, refer to the upstream
`Docker Registry documentation <https://docs.docker.com/registry/>`_.

----------------------------
Configure custom certificate
----------------------------

By default, the local Docker registry uses a self-signed certificate. It is
highly recommended to replace the self-signed certificate with a CA-signed
certificate.

Use the :command:`system certificate-install` command and the :command:`docker_registry`
option to update the certificate used by all Docker registry communication, as
shown below:

::

   $ system certificate-install -m/--mode docker_registry path_to_cert

---------------------------------
Authentication and authentication
---------------------------------

Authentication is enabled for the local Docker registry. When logging in, users
are authenticated using platform keystone credentials.

For example, if using the local Docker to log in, use the following command:

::

  docker login registry.local:9001 -u <keystoneUserName> -p <keystonePassword>

The `admin` platform keystone user is authorized to perform all actions on all
repositories. Any other platform keystone user can perform all actions but only
on their own repositories.

For example, the non-admin keystone user `testuser` can only push or pull images
located under `registry.local:9001/testuser/...`.

.. note::

   A keystone user name must be all lowercase, because the Docker registry does
   not allow repository names to use capital letters. For example, the following
   repository is invalid: `registry.local:9001/TESTUSER/busybox:latest`.

-------------------------------------------------------------
Use local Docker registry images in Kubernetes container spec
-------------------------------------------------------------

When creating a pod spec or deployment spec that uses an image from the local
Docker registry you must:

* Use the full image name, including the registry.
* Specify an imagePullSecret with your keystone credentials.

This example procedure assumes that the `testuser/busybox:latest` container
image has been pushed to the local Docker registry.

Example procedure:

#. Create a secret with platform keystone credentials for the local Docker registry:

   ::

     kubectl create secret docker-registry testuser-registry-secret \
     --docker-server=registry.local:9001 --docker-username=testuser \
     --docker-password=<testuserPassword> --docker-email=noreply@windriver.com

#. Create a Kubernetes deployment YAML file using the busybox container image
   stored in the local Docker registry. Note that `imagePullSecret` must be
   specified in the YAML file, providing the secret created in the previous step.

   ::

     cat <<EOF > busybox.yaml apiVersion: apps/v1
     kind: Deployment metadata:
       name: busybox
       namespace: default
     spec:
       progressDeadlineSeconds: 600
       replicas: 1
       selector:
         matchLabels:
           run: busybox
       template:
         metadata:
           labels:
             run: busybox
         spec:
           containers:
           - args:
             - sh
             image: registry.local:9001/testuser/busybox:latest
             imagePullPolicy: Always
             name: busybox
             stdin: true
             tty: true
           restartPolicy: Always
           imagePullSecrets:
           - name: testuser-registry-secret
     EOF

#. Apply the ``busybox.yaml`` manifest that will pull the image from the
   authenticated local Docker registry using the keystone credentials in the
   `imagePullSecret`.

   ::

     kubectl apply -f busybox.yaml

----------------------------
Free space in local registry
----------------------------

.. include:: /cli_ref/system.rst
   :start-after: incl-cli-local-docker-reg-start:
   :end-before: incl-cli-local-docker-reg-end:
