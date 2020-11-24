
.. uxm1568850135371
.. _using-an-image-from-the-local-docker-registry-in-a-container-spec:

===============================================================
Use an Image from the Local Docker Registry in a Container Spec
===============================================================

When creating a pod spec or a deployment spec that uses an image from the local
docker registry, you must use the full image name, including the registry, and
specify an **imagePullSecret** with your keystone credentials.

.. rubric:: |context|

This example procedure assumes that testuser/busybox:latest container image has
been pushed to the local docker registry.

.. rubric:: |proc|

#.  Create a secret with credentials for the local docker registry.

    .. code-block:: none

        % kubectl create secret docker-registry testuser-registry-secret --docker-server=registry.local:9001 --docker-username=testuser --docker-password=<testuserPassword> --docker-email=noreply@windriver.com

#.  Create a configuration for the busybox container.

    .. code-block:: none

        % cat <<EOF > busybox.yaml
        apiVersion: apps/v1
        kind: Deployment
        metadata:
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

#.  Apply the configuration created in the busybox.yaml file.

    .. code-block:: none

        % kubectl apply -f busybox.yaml

    This will launch the busybox deployment using the image in the local docker
    registry and specifying the ``testuser-registry-secret`` for authentication
    and authorization with the registry.
