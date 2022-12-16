
.. pjw1564749970685
.. _storage-configuration-mount-readwriteonce-persistent-volumes-in-containers:

====================================================
Mount ReadWriteOnce Persistent Volumes in Containers
====================================================

You can attach ReadWriteOnce |PVCs| to a container when launching a container,
and changes to those |PVCs| will persist even if that container gets terminated
and restarted.

.. rubric:: |context|

This example shows how a volume is claimed and mounted by a simple running
container, and the contents of the volume claim persists across restarts of
the container. It is the responsibility of an individual micro-service within
an application to make a volume claim, mount it, and use it.

.. rubric:: |prereq|

You should refer to the Volume Claim examples. For more information, see,
:ref:`Create ReadWriteOnce Persistent Volume Claims <storage-configuration-create-readwriteonce-persistent-volume-claims>`.

.. rubric:: |proc|


.. _storage-configuration-mount-persistent-volumes-in-containers-d583e55:

#.  Create the busybox container with the persistent volumes created from
    the |PVCs| mounted.


    #.  Create a yaml file definition for the busybox container.

        .. code-block:: none

            ~(keystone_admin)]$ cat <<EOF > rwo-busybox.yaml
            apiVersion: apps/v1
            kind: Deployment
            metadata:
              name: rwo-busybox
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
                      claimName: rwo-test-claim1
                  - name: pvc2
                    persistentVolumeClaim:
                      claimName: rwo-test-claim2
            EOF


    #.  Apply the busybox configuration.

        .. code-block:: none

            ~(keystone_admin)]$ kubectl apply -f rwo-busybox.yaml


#.  Attach to the busybox and create files on the Persistent Volumes.


    #.  List the available pods.

        .. code-block:: none

            ~(keystone_admin)]$ kubectl get pods
            NAME                           READY   STATUS    RESTARTS   AGE
            rwo-busybox-5c84dd4dcd-xxb2b   1/1     Running   0          25s

    #.  Connect to the pod shell for CLI access.

        .. code-block:: none

            ~(keystone_admin)]$ kubectl attach rwo-busybox-5c84dd4dcd-xxb2b -c busybox -i -t

    #.  From the container's console, list the disks to verify that the
        Persistent Volumes are attached.

        .. code-block:: none

            # df
            Filesystem     1K-blocks  Used     Available Use% Mounted on
            overlay        31441920   9694828  21747092  31% /
            tmpfs          65536         0     65536     0% /dev
            tmpfs          12295352      0     12295352  0% /sys/fs/cgroup
            /dev/rbd1      996780        24    980372    0% /mnt1
            /dev/rbd0      996780        24    980372    0% /mnt2


        The PVCs are mounted as /mnt1 and /mnt2.

    #.

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
        Session ended, resume using 'kubectl attach rwo-busybox-5c84dd4dcd-xxb2b -c busybox -i -t' command when the pod is running

#.  Terminate the busybox container.

    .. code-block:: none

        ~(keystone_admin)]$ kubectl delete -f rwo-busybox.yaml

#.  Recreate the busybox container, again attached to persistent volumes.

    #.  Apply the busybox configuration.

        .. code-block:: none

            ~(keystone_admin)]$ kubectl apply -f rwo-busybox.yaml

    #.  List the available pods.

        .. code-block:: none

            ~(keystone_admin)]$ kubectl get pods
            NAME                           READY   STATUS    RESTARTS   AGE
            rwo-busybox-5c84dd4dcd-pgcfw   1/1     Running   0          29s

    #.  Connect to the pod shell for CLI access.

        .. code-block:: none

            ~(keystone_admin)]$ kubectl attach rwo-busybox-5c84dd4dcd-pgcfw -c busybox -i -t

    #.  From the container's console, list the disks to verify that the PVCs
        are attached.

        .. code-block:: none

            # df
            Filesystem           1K-blocks      Used Available Use% Mounted on
            overlay               31441920   9694844  21747076  31% /
            tmpfs                    65536         0     65536   0% /dev
            tmpfs                 12295352         0  12295352   0% /sys/fs/cgroup
            /dev/rbd0               996780        24    980372   0% /mnt1
            /dev/rbd1               996780        24    980372   0% /mnt2


#.  Verify that the files created during the earlier container session
    still exist.

    .. code-block:: none

        # ls /mnt1
        i-was-here lost+found
        # ls /mnt2
        i-was-here-too lost+found
