
.. vqr1569420650576
.. _bootstrapping-from-a-private-docker-registry-r7:

============================================
Bootstrapping from a Private Docker Registry
============================================

You can bootstrap controller-0 from a private Docker registry in the event that
your server is isolated from the public Internet.

.. rubric:: |proc|

#.  Update your /home/sysadmin/localhost.yml bootstrap overrides file with the
    following lines to use a Private Docker Registry pre-populated from the
    |org| Docker Registry:

    .. code-block:: none

        docker_registries:
          k8s.gcr.io:
            url: <my-registry.io>/k8s.gcr.io
          gcr.io:
            url: <my-registry.io>/gcr.io
          ghcr.io:
            url: <my-registry.io>/ghcr.io
          quay.io:
            url: <my-registry.io>/quay.io
          docker.io:
            url: <my-registry.io>/docker.io
          docker.elastic.co:
            url: <my-registry.io>/docker.elastic.co
          registry.k8s.io:
            url: <my-registry.io>/registry.k8s.io
        defaults:
            type: docker
            username: <your_my-registry.io_username>
            password: <your_my-registry.io_password>

    Where ``<your_my-registry.io_username>`` and
    ``<your_my-registry.io_password>`` are your login credentials for the
    ``<my-registry.io>`` private Docker registry.

    .. note::
        ``<my-registry.io>`` must be a DNS name resolvable by the dns servers
        configured in the ``dns_servers:`` structure of the ansible bootstrap
        override file /home/sysadmin/localhost.yml.

#.  For any additional local registry images required, use the full image name
    as shown below.

    .. code-block:: none

        additional_local_registry_images:
            docker.io/wind-river/<imageName>:<tag>

