
.. nos1582114374670
.. _kubernetes-user-tutorials-mounting-persistent-volumes-in-containers:

======================================
Mount Persistent Volumes in Containers
======================================

You can launch, attach, and terminate a busybox container to mount :abbr:`PVCs
(Persistent Volume Claims)` in your cluster.

.. rubric:: |context|

This example shows how a volume is claimed and mounted by a simple running
container. It is the responsibility of an individual micro-service within an
application to make a volume claim, mount it, and use it. For example, the
stx-openstack application will make volume claims for **mariadb** and
**rabbitmq** via their helm charts to orchestrate this.

.. rubric:: |prereq|

You must have created the persistent volume claims.

.. xreflink This procedure uses PVCs
   with names and configurations created in |stor-doc|: :ref:`Creating Persistent
   Volume Claims <storage-configuration-creating-persistent-volume-claims>`.

.. rubric:: |proc|

.. _kubernetes-user-tutorials-mounting-persistent-volumes-in-containers-d18e55:

#.  Create the busybox container with the persistent volumes created from the
    PVCs mounted.

    #.  Create a yaml file definition for the busybox container.

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
                    image: busybox
                    imagePullPolicy: Always
                    name: busybox
                    stdin: true
                    tty: true
                    volumeMounts:
                    - name: pvc1
                      mountPath: "/mnt1"
                    - name: pvc2
                      mountPath: "/mnt2"
                  restartPolicy: Always
                  volumes:
                  - name: pvc1
                    persistentVolumeClaim:
                      claimName: test-claim1
                  - name: pvc2
                    persistentVolumeClaim:
                      claimName: test-claim2
            EOF

    #.  Apply the busybox configuration.

        .. code-block:: none

            % kubectl apply -f busybox.yaml

#.  Attach to the busybox and create files on the persistent volumes.

    #.  List the available pods.

        .. code-block:: none

            % kubectl get pods
            NAME                       READY   STATUS    RESTARTS   AGE
            busybox-5c4f877455-gkg2s   1/1     Running   0          19s


    #.  Connect to the pod shell for CLI access.

        .. code-block:: none

            % kubectl attach busybox-5c4f877455-gkg2s -c busybox -i -t

    #.  From the container's console, list the disks to verify that the
        persistent volumes are attached.

        .. code-block:: none

            # df
            Filesystem           1K-blocks      Used Available Use% Mounted on
            overlay               31441920   3239984  28201936  10% /
            tmpfs                    65536         0     65536   0% /dev
            tmpfs                 65900776         0  65900776   0% /sys/fs/cgroup
            /dev/rbd0               999320      2564    980372   0% /mnt1
            /dev/rbd1               999320      2564    980372   0% /mnt2
            /dev/sda4             20027216   4952208  14034624  26%
            ...

        The PVCs are mounted as /mnt1 and /mnt2.

#.  Create files in the mounted volumes.

    .. code-block:: none

        # cd /mnt1
        # touch i-was-here
        # ls /mnt1
        i-was-here lost+found
        #
        # cd /mnt2
        # touch i-was-here-too
        # ls /mnt2
        i-was-here-too lost+found

#.  End the container session.

    .. code-block:: none

        # exit
        Session ended, resume using 'kubectl attach busybox-5c4f877455-gkg2s -c busybox -i -t' command when the pod is running

#.  Terminate the busybox container.

    .. code-block:: none

        % kubectl delete -f busybox.yaml

#.  Re-create the busybox container, again attached to persistent volumes.

    #.  Apply the busybox configuration.

        .. code-block:: none

            % kubectl apply -f busybox.yaml

    #.  List the available pods.

        .. code-block:: none

            % kubectl get pods
            NAME                       READY   STATUS    RESTARTS   AGE
            busybox-5c4f877455-jgcc4   1/1     Running   0          19s

    #.  Connect to the pod shell for CLI access.

        .. code-block:: none

            % kubectl attach busybox-5c4f877455-jgcc4 -c busybox -i -t

    #.  From the container's console, list the disks to verify that the PVCs are
        attached.

        .. code-block:: none

            # df
            Filesystem           1K-blocks      Used Available Use% Mounted on
            overlay               31441920   3239984  28201936  10% /
            tmpfs                    65536         0     65536   0% /dev
            tmpfs                 65900776         0  65900776   0% /sys/fs/cgroup
            /dev/rbd0               999320      2564    980372   0% /mnt1
            /dev/rbd1               999320      2564    980372   0% /mnt2
            /dev/sda4             20027216   4952208  14034624  26%
            ...

#.  Verify that the files created during the earlier container session still
    exist.

    .. code-block:: none

        # ls /mnt1
        i-was-here lost+found
        # ls /mnt2
        i-was-here-too lost+found
