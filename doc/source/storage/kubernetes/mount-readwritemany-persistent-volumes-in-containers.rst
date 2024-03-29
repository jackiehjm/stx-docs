
.. fkk1616520068837
.. _mount-readwritemany-persistent-volumes-in-containers:

====================================================
Mount ReadWriteMany Persistent Volumes in Containers
====================================================

You can attach a ReadWriteMany PVC to multiple containers, and that |PVC| can
be written to, by all containers.

.. rubric:: |context|

This example shows how a volume is claimed and mounted by each container
replica of a deployment with 2 replicas, and each container replica can read
and write to the |PVC|. It is the responsibility of an individual micro-service
within an application to make a volume claim, mount it, and use it.

.. rubric:: |prereq|

You must have created the |PVCs|. This procedure uses |PVCs| with names and
configurations created in |prod| |stor-doc|: :ref:`Create ReadWriteMany Persistent Volume Claims <create-readwritemany-persistent-volume-claims>` .

.. rubric:: |proc|
.. _fkk1616520068837-steps-fqj-flr-tkb:

#.  Create the busybox container with the persistent volumes created from the PVCs mounted. This deployment will create two replicas mounting the same persistent volume.

    #.  Create a yaml file definition for the busybox container.

        .. code-block:: none

            ~(keystone_admin)]$ cat <<EOF > wrx-busybox.yaml
            apiVersion: apps/v1
            kind: Deployment
            metadata:
              name: wrx-busybox
              namespace: default
            spec:
              progressDeadlineSeconds: 600
              replicas: 2
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
                  restartPolicy: Always
                  volumes:
                  - name: pvc1
                    persistentVolumeClaim:
                      claimName: rwx-test-claim
            EOF

    #.  Apply the busybox configuration.

        .. code-block:: none

            ~(keystone_admin)]$ kubectl apply -f wrx-busybox.yaml
            deployment.apps/wrx-busybox created

#.  Attach to the busybox and create files on the Persistent Volumes.


    #.  List the available pods.

        .. code-block:: none

            ~(keystone_admin)]$ kubectl get pods
            NAME                           READY   STATUS    RESTARTS   AGE
            wrx-busybox-767564b9cf-g8ln8   1/1     Running   0          49s
            wrx-busybox-767564b9cf-jrk5z   1/1     Running   0          49s

    #.  Connect to the pod shell for CLI access.

        .. code-block:: none

            kubectl attach wrx-busybox-767564b9cf-g8ln8 -c busybox -i -t

    #.  From the container's console, list the disks to verify that the Persistent Volume is attached.

        .. code-block:: none

            % df
            Filesystem           1K-blocks      Used Available Use% Mounted on
            overlay               31441920   9695488  21746432  31% /
            tmpfs                    65536         0     65536   0% /dev
            tmpfs                 12295352         0  12295352   0% /sys/fs/cgroup
            192.168.204.2:6789:/volumes/csi/pvc-volumes-565a1160-7b6c-11ed-84b8-0e99d59ed96d/cf39026c-06fc-413a-bce9-b13fb66254a3
                                   1048576         0   1048576   0% /mnt1

        The PVC is mounted as /mnt1.


#.  Create files in the mount.

    .. code-block:: none

        # cd /mnt1
        # touch i-was-here-${HOSTNAME}
        # ls /mnt1
        i-was-here-wrx-busybox-767564b9cf-g8ln8

#.  End the container session.

    .. code-block:: none

        % exit
        Session ended, resume using 'kubectl attach wrx-busybox-767564b9cf-g8ln8 -c busybox -i -t' command when the pod is running

#.  Connect to the other busybox container

    .. code-block:: none

        ~(keystone_admin)]$ kubectl attach wrx-busybox-767564b9cf-jrk5z -i -t

#.  Optional: From the container's console list the disks to verify that the PVC is attached.

    .. code-block:: none

        % df
        Filesystem           1K-blocks      Used Available Use% Mounted on
        overlay               31441920   9695512  21746408  31% /
        tmpfs                    65536         0     65536   0% /dev
        tmpfs                 12295352         0  12295352   0% /sys/fs/cgroup
        192.168.204.2:6789:/volumes/csi/pvc-volumes-565a1160-7b6c-11ed-84b8-0e99d59ed96d/cf39026c-06fc-413a-bce9-b13fb66254a3
                               1048576         0   1048576   0% /mnt1


#.  Verify that the file created from the other container exists and that this container can also write to the Persistent Volume.

    .. code-block:: none

        # cd /mnt1
        # ls
        i-was-here-wrx-busybox-767564b9cf-g8ln8
        # echo ${HOSTNAME}
        wrx-busybox-767564b9cf-jrk5z
        # touch i-was-here-${HOSTNAME}
        # ls
        i-was-here-wrx-busybox-767564b9cf-g8ln8  i-was-here-wrx-busybox-767564b9cf-jrk5z

#.  End the container session.

    .. code-block:: none

        % exit
        Session ended, resume using 'kubectl attach wrx-busybox-767564b9cf-jrk5z -c busybox -i -t' command when the pod is running

#.  Terminate the busybox container.

    .. code-block:: none

        ~(keystone_admin)]$ kubectl delete -f wrx-busybox.yaml

    For more information on Persistent Volume Support, see, :ref:`About Persistent Volume Support <about-persistent-volume-support>`.
