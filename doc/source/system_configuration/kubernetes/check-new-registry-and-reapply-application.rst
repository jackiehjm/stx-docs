
..
.. _check-new-registry-and-reapply-application:

==========================================
Check New Registry and Reapply Application
==========================================

Perform these steps on both controllers. Use controller-0 first and then swact
to controller-1 and perform the same steps.

.. note::
    The private docker registry name must not end with ".local" to ensure that
    the domain name is properly resolved using external DNS.

.. rubric:: |proc|

#. Run this command to login:

   .. code-block:: none

       $ sudo docker login new-registry.domain.com:9001

#. Run this command to do a test pull of the image:

   .. code-block:: none

       $ sudo docker image pull new-registry.domain.com:9001/product-abc/starlingx/docker.io/alpine:latest
       $ crictl pull --creds docker:****** new-registry.domain.com:9001/product-abc/starlingx/docker.io/alpine:latest

       $ sudo docker image rm new-registry.domain.com:9001/product-abc/starlingx/docker.io/alpine:latest
       $ crictl rmi new-registry.domain.com:9001/product-abc/starlingx/docker.io/alpine:latest

#. Check if an application re-apply will now properly pull from the registries.
   First, remove the images for an application, such as
   nginx-ingress-controller, from the registry.local and the local image cache
   for all nodes \(assuming AIO-SX\), in order to force the next re-apply of
   the application to re-pull these images.

   .. code-block:: none

       ~(keystone_admin)]$ system registry-image-tags quay.io/kubernetes-ingress-controller/nginx-ingress-controller
       +-----------+
       | Image Tag |
       +-----------+
       | 0.23.0    |
       +-----------+

       system registry-image-delete quay.io/kubernetes-ingress-controller/nginx-ingress-controller:0.23.0
       system registry-garbage-collect
       crictl images ls | grep  quay.io/kubernetes-ingress-controller/nginx-ingress-controller
       registry.local:9001/quay.io/kubernetes-ingress-controller/nginx-ingress-controller   0.23.0                                                   42d47fe0c78f5       242MB

       crictl rmi registry.local:9001/quay.io/kubernetes-ingress-controller/nginx-ingress-controller:0.23.0
       # Note an error on this step means there is no image in the cache

       # SSH to controller-1 (or the standby controller)
       crictl rmi registry.local:9001/quay.io/kubernetes-ingress-controller/nginx-ingress-controller:0.23.0

#. To reapply the application run the following command:

   .. code-block:: none

       ~(keystone_admin)]$ system application-apply nginx-ingress-controller

#. Then, debug tail ``-f /var/log/sysinv.log`` and look for the following information:

   .. code-block:: none

       sysinv 2020-09-09 23:42:23.476 14930 INFO sysinv.conductor.kube_app [-] Image registry.local:9001/quay.io/kubernetes-ingress-controller/nginx-ingress-controller:0.23.0 is not available in local registry, download started from public/private registry
       sysinv 2020-09-09 23:42:23.526 14930 INFO sysinv.conductor.kube_app [-] Image registry.local:9001/k8s.gcr.io/defaultbackend:1.4 download succeeded in 0 seconds
       sysinv 2020-09-09 23:43:10.226 14930 INFO sysinv.conductor.kube_app [-] Remove image <hostname>:5001/<quay.io path>/quay.io/kubernetes-ingress-controller/nginx-ingress-controller:0.23.0 after push to local registry.
       sysinv 2020-09-09 23:43:10.595 14930 INFO sysinv.conductor.kube_app [-] Image registry.local:9001/quay.io/kubernetes-ingress-controller/nginx-ingress-controller:0.23.0 download succeeded in 47 seconds
       sysinv 2020-09-09 23:43:10.596 14930 INFO sysinv.conductor.kube_app [-] All docker images for application nginx-ingress-controller were successfully downloaded in 50 seconds

#. Validate that the application is running:

   .. code-block:: none

       ~(keystone_admin)]$ system application-list
       +--------------------------+---------+-------------------------------------------+------------------+----------+----------------------+
       | application              | version | manifest name                             | manifest file    | status   | progress             |
       +--------------------------+---------+-------------------------------------------+------------------+----------+----------------------+
       | cert-manager             | 1.0-34  | cert-manager-fluxcd-manifests             | fluxcd-manifests | applied  | completed            |
       | nginx-ingress-controller | 1.1-35  | nginx-ingress-controller-fluxcd-manifests | fluxcd-manifests | applied  | completed            |
       | oidc-auth-apps           | 1.0-68  | oidc-auth-apps-fluxcd-manifests           | fluxcd-manifests | uploaded | completed            |
       | platform-integ-apps      | 1.0-52  | platform-integ-apps-fluxcd-manifests      | fluxcd-manifests | applied  | completed            |
       | rook-ceph-apps           | 1.0-17  | rook-ceph-manifest                        | manifest.yaml    | uploaded | completed            |
       +--------------------------+---------+-------------------------------------------+------------------+----------+----------------------+

#. Validate that the image is in the local registry:

   .. code-block:: none

       ~(keystone_admin)]$ system registry-image-tags quay.io/kubernetes-ingress-controller/nginx-ingress-controller
        +-----------+
        | Image Tag |
        +-----------+
        | 0.23.0    |
        +-----------+


