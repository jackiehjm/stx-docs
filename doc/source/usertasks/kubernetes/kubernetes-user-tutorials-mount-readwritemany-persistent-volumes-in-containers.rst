
.. iqs1617036367453
.. _kubernetes-user-tutorials-mount-readwritemany-persistent-volumes-in-containers:

====================================================
Mount ReadWriteMany Persistent Volumes in Containers
====================================================

You can attach a ReadWriteMany PVC to multiple containers, and that PVC can be
written to, by all containers.

.. rubric:: |context|

This example shows how a volume is claimed and mounted by each container
replica of a deployment with 2 replicas, and each container replica can read
and write to the PVC. It is the responsibility of an individual micro-service
within an application to make a volume claim, mount it, and use it.

.. rubric:: |prereq|

You should refer to the Volume Claim examples. For more information,
see :ref:`Create ReadWriteMany Persistent Volume Claims <kubernetes-user-tutorials-create-readwritemany-persistent-volume-claims>`.

.. rubric:: |proc|

.. _iqs1617036367453-steps-fqj-flr-tkb:

#.  Create the busybox container with the persistent volumes created from the
    |PVCs| mounted. This deployment will create two replicas mounting the same
    persistent volume.

    #.  Create a yaml file definition for the busybox container.

        .. code-block:: none

            % cat <<EOF > wrx-busybox.yaml
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

            % kubectl apply -f wrx-busybox.yaml
            deployment.apps/wrx-busybox created


#.  Attach to the busybox and create files on the Persistent Volumes.

    #.  List the available pods.

        .. code-block:: none

            % kubectl get pods
            NAME                           READY   STATUS    RESTARTS   AGE
            wrx-busybox-6455997c76-4kg8v   1/1     Running   0          108s
            wrx-busybox-6455997c76-crmw6   1/1     Running   0          108s

    #.  Connect to the pod shell for CLI access.

        .. code-block:: none

            % kubectl attach wrx-busybox-6455997c76-4kg8v -c busybox -i -t

    #.  From the container's console, list the disks to verify that the
        Persistent Volume is attached.

        .. code-block:: none

            % df
            Filesystem           1K-blocks      Used Available Use% Mounted on
            overlay               31441920   1783748  29658172   6% /
            tmpfs                    65536         0     65536   0% /dev
            tmpfs                  5033188         0   5033188   0% /sys/fs/cgroup
            ceph-fuse            516542464    643072 515899392   0% /mnt1

        The PVC is mounted as /mnt1.


#.  Create files in the mount.

    .. code-block:: none

        # cd /mnt1
        # touch i-was-here-${HOSTNAME}
        # ls /mnt1
        i-was-here-wrx-busybox-6455997c76-4kg8vi

#.  End the container session.

    .. code-block:: none

        % exit
        wrx-busybox-6455997c76-4kg8v -c busybox -i -t' command when the pod is running

#.  Connect to the other busybox container

    .. code-block:: none

        % kubectl attach wrx-busybox-6455997c76-crmw6 -c busybox -i -t

#.  (Optional): From the container's console list the disks to verify that
    the |PVC| is attached.

    .. code-block:: none

        % df
        Filesystem           1K-blocks      Used Available Use% Mounted on
        overlay               31441920   1783888  29658032   6% /
        tmpfs                    65536         0     65536   0% /dev
        tmpfs                  5033188         0   5033188   0% /sys/fs/cgroup
        ceph-fuse            516542464    643072 515899392   0% /mnt1


#.  Verify that the file created from the other container exists and that this
    container can also write to the Persistent Volume.

    .. code-block:: none

        # cd /mnt1
        # ls /mnt1
        i-was-here-wrx-busybox-6455997c76-4kg8v
        # echo ${HOSTNAME}
        wrx-busybox-6455997c76-crmw6
        # touch i-was-here-${HOSTNAME}
        # ls /mnt1
        i-was-here-wrx-busybox-6455997c76-4kg8v i-was-here-wrx-busybox-6455997c76-crmw6

#.  End the container session.

    .. code-block:: none

        % exit
        Session ended, resume using
        :command:`kubectl attach wrx-busybox-6455997c76-crmw6 -c busybox -i -t`
        command when the pod is running

#.  Terminate the busybox container.

    .. code-block:: none

        % kubectl delete -f wrx-busybox.yaml

    For more information on Persistent Volume Support, see, |prod| |stor-doc|
    :ref:`About Persistent Volume Support <about-persistent-volume-support>`.


