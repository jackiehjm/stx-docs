
.. hsq1558095273229
.. _freeing-space-in-the-local-docker-registry:

=======================================
Free Space in the Local Docker Registry
=======================================

You can delete images and perform garbage collection to free unused registry
space on the docker-distribution file system of the controllers.

.. rubric:: |context|

Simply deleting an image from the local Docker registry does not free the
associated space from the file system. To do so, you must also run the
:command:`registry-garbage-collect` command.

.. rubric:: |proc|

#.  Identify the name of the image you want to delete.

    .. code-block:: none

        ~(keystone_admin)$ system registry-image-list
        +------------------------------------------------------+
        | Image Name                                           |
        +------------------------------------------------------+
        | docker.io/starlingx/k8s-cni-sriov                    |
        | docker.io/starlingx/k8s-plugins-sriov-network-device |
        | docker.io/starlingx/multus                           |
        | gcr.io/kubernetes-helm/tiller                        |
        | k8s.gcr.io/coredns                                   |
        | k8s.gcr.io/etcd                                      |
        | k8s.gcr.io/kube-apiserver                            |
        | k8s.gcr.io/kube-controller-manager                   |
        | k8s.gcr.io/kube-proxy                                |
        | k8s.gcr.io/kube-scheduler                            |
        | k8s.gcr.io/pause                                     |
        | quay.io/airshipit/armada                             |
        | quay.io/calico/cni                                   |
        | quay.io/calico/kube-controllers                      |
        | quay.io/calico/node                                  |
        +------------------------------------------------------+

#.  Find tags associated with the image.

    .. code-block:: none

        ~(keystone_admin)$ system registry-image-tags <imageName>

#.  Free file system space.

    .. code-block:: none

        ~(keystone_admin)$ system registry-image-delete <imageName>:<tagName>

    This step only removes the registry's reference to the **image:tag**.

    .. warning::
        Do not delete **image:tags** that are currently being used by the
        system. Deleting both the local Docker registry's **image:tags** and
        the **image:tags** from the Docker cache will prevent failed deployment
        pods from recovering. If this happens, you will need to manually
        download the deleted image from the same source and push it back into
        the local Docker registry under the same name and tag.

        If you need to free space consumed by **stx-openstack** images, you can
        delete older tagged versions.

#.  Free up file system space associated with the deleted/unreferenced images.

    The :command:`registry-garbage-collect` command removes unreferenced
    **image:tags** from the file system and frees the file system spaces
    allocated to deleted/unreferenced images.

    .. code-block:: none

        ~(keystone_admin)$ system registry-garbage-collect
        Running docker registry garbage collect

    .. note::
        In rare cases the system may trigger a swact during garbage collection,
        and the registry may be left in read-only mode. If this happens, run
        :command:`registry-garbage-collect` again to take the registry out of
        read-only mode.


