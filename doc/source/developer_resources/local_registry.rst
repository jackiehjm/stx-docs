
.. _virtual-create-and-bootstrap-from-a-private-docker-registry:

==================================================================
Create and Bootstrap from a Local External Private Docker Registry
==================================================================

You can bootstrap controller-0 from a private local external Docker registry.
This is useful in case you plan to perform multiple installations on your own
machine and do not want to be rate-limited by public registries.

This will also speed up the bootstrap process as images will be downloaded only
once. This guide assumes that you are installing this local external docker
registry on a Linux system with Docker installed and configured.

.. rubric:: |proc|

#.  Create folders to store your local registry images (``storage``) and to
    place setup files that will be used later on (``images``):

    .. code-block:: shell

        mkdir -p $HOME/docker-registry/storage
        mkdir -p $HOME/docker-registry/images

#.  Create a configuration file that will be used by Docker's official
    Registry image later on:

    .. code-block:: shell

        cat > $HOME/docker-registry/config.yml << EOF
        version: 0.1
        log:
          fields:
            service: registry
        storage:
          cache:
            blobdescriptor: inmemory
          filesystem:
            rootdirectory: /var/lib/registry
        http:
          addr: :5000
          headers:
            X-Content-Type-Options: [nosniff]
        health:
          storagedriver:
            enabled: true
            interval: 10s
            threshold: 3
        EOF

#.  Run the docker container registry:

    .. code-block:: shell

        export LOCAL_REG=$HOME/docker-registry
        docker run -d \
            --restart=always \
            --name registry \
            -v "$LOCAL_REG"/storage:/var/lib/registry \
            -v "$LOCAL_REG"/config.yml:/etc/docker/registry/config.yml \
            -e REGISTRY_HTTP_ADDR=0.0.0.0:5000 \
            -p 5000:5000 \
            registry:2

    .. note::
        *Optional*: the ``-p`` parameter configures a mapping between the host
        port and the container port. If you want to listen on another port on
        your host, say 9000, change from ``-p 5000:5000 \`` to
        ``-p 9000:5000 \``.

#.  Create the list of images that will populate the registry.

    Obtain the Kubernetes version your |prod| uses. This can be found in the
    ``fresh_install_k8s_version`` value of the `Kubernetes versions`_ file.
    Use the branches and tags to find the value for your version.

    With the Kubernetes version, you can find the corresponding folder in
    `system images`_ and locate the ``system-images.yml`` file. This file
    contains the list of images to be loaded into your registry.

    To make the list of images for |prod| 8.0, take the raw address of the
    corresponding ``system-images.yml`` file and set a variable with it:

    .. code-block:: shell

        export IMAGES_YAML_RAW_FILE="https://opendev.org/starlingx/ansible-playbooks/raw/branch/master/playbookconfig/src/playbooks/roles/common/load-images-information/vars/k8s-v1.24.4/system-images.yml"

    Use the command to generate a ``list.lst`` file:

    .. code-block:: shell

        curl -s ${IMAGES_YAML_RAW_FILE} | grep -v '\-\-\-' | grep -v '^#' | cut -d ':' -f2 | tr -d ' ' > $HOME/docker-registry/images/list.lst

    .. note:: *Optional*: If you have a running |prod| setup, you can run
        the following to create an Ansible Playbook to get the exact images
        you will need instead:

        .. code-block:: shell

            cat > list-images.yml << EOF
            ---
            - hosts: localhost
              gather_facts: true
              tasks:
                - name: Load image info
                  include_role:
                    name: /usr/share/ansible/stx-ansible/playbooks/roles/common/load-images-information

                - name: Print image list
                  debug:
                    msg: "{{ (kubernetes_images + networking_images + static_images + storage_images + security_images) }}"
            EOF

        Then, run the following to execute the Ansible Playbook:

        .. code-block:: shell

            K8S_VERSION=<version>
            ansible-playbook list-images.yml -e "kubernetes_version=${K8S_VERSION}"

        You will find the Kubernetes version to assign to the `K8S_VERSION`
        variable on the aforementioned `Kubernetes versions`_ file.

#.  Create and run a script that will populate the registry based on the list
    of images:

    .. code-block:: shell

        export REG_SCRIPT=$HOME/docker-registry/images/populate_registry.sh
        cat > $REG_SCRIPT <<'EOF'
        #!/bin/bash

        if [[ -z $1 ]]; then
                echo "Please provide a file with a list of Docker images."
            exit 1
        fi

        TAGS_FILE=$1
        LOCAL_REGISTRY=localhost:5000

        while read DOCKER_IMAGE;
        do
            echo ""
            echo -n "--- ${DOCKER_IMAGE}: ";

            IMAGE_ARRAY=($(echo $DOCKER_IMAGE | tr ":" " "))
            REPO=${IMAGE_ARRAY[0]}
            TAG=${IMAGE_ARRAY[1]}
            REPO_TAGS_URL="http://${LOCAL_REGISTRY}/v2/${REPO}/tags/list"
            if curl -s -X GET --insecure ${REPO_TAGS_URL} | jq | grep ${TAG} &>/dev/null; then
                echo -n "Skipping..."
                continue
            fi

            echo "Pulling..."

            set -x
            docker pull ${DOCKER_IMAGE};
            REGISTRY_IMAGE=${LOCAL_REGISTRY}/${DOCKER_IMAGE}
            docker tag ${DOCKER_IMAGE} ${REGISTRY_IMAGE};
            docker push ${REGISTRY_IMAGE};
            docker rmi ${DOCKER_IMAGE} ${REGISTRY_IMAGE};
            set +x

        done < $TAGS_FILE
        EOF
        chmod +x $REG_SCRIPT
        $REG_SCRIPT $HOME/docker-registry/images/list.lst

    .. note::
        The ``populate_registry.sh`` script checks if each image in the list is
        already present, which means you can update the list and re-run the script
        to get new images whenever necessary.

    .. note::
        The Docker CLI exclusively permits insecure (HTTP) registries when on
        the local host. When executing the provided script remotely, in
        addition to modifying the ``LOCAL_REGISTRY`` variable to match the IP
        address of the registry's location, it is necessary to insert an entry
        in the ``insecure-registries:`` section within the
        ``etc/docker/daemon.json`` file. Following this adjustment, you must
        restart the Docker service.

.. rubric:: |result|

Your registry is ready! On your next |prod| installation, update your
``/home/sysadmin/localhost.yml`` bootstrap overrides file with the
following lines to use it:

.. code-block:: yaml

    docker_registries:
      quay.io:
        url: <your IP address>:5000/quay.io
      gcr.io:
        url: <your IP address>:5000/gcr.io
      k8s.gcr.io:
        url: <your IP address>:5000/k8s.gcr.io
      docker.io:
        url: <your IP address>:5000/docker.io
      docker.elastic.co:
        url: <your IP address>:5000/docker.elastic.co
      ghcr.io:
        url: <your IP address>:5000/ghcr.io
      registry.k8s.io:
        url: <your IP address>:5000/registry.k8s.io
      icr.io:
        url: <your IP address>:5000/icr.io
      defaults:
        type: docker
        secure: false

.. note::
    This procedure configured |prod| to use an insecure registry via the
    ``docker_registries.defaults.secure`` parameter set to ``false`` in the
    excerpt above. Make sure you only use this on your own development
    environment.

.. _Kubernetes versions: https://opendev.org/starlingx/ansible-playbooks/src/branch/master/playbookconfig/src/playbooks/roles/bootstrap/validate-config/vars/main.yml
.. _system images: https://opendev.org/starlingx/ansible-playbooks/src/branch/master/playbookconfig/src/playbooks/roles/common/load-images-information/vars
