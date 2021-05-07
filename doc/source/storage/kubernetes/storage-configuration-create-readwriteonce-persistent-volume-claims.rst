
.. xco1564696647432
.. _storage-configuration-create-readwriteonce-persistent-volume-claims:

=============================================
Create ReadWriteOnce Persistent Volume Claims
=============================================

Container images have an ephemeral file system by default. For data to
survive beyond the lifetime of a container, it can read and write files to
a persistent volume obtained with a |PVC| created to provide persistent
storage.

.. rubric:: |context|

The following steps show an example of creating two 1GB |PVCs| with
ReadWriteOnce accessMode.

.. rubric:: |proc|


.. _storage-configuration-create-readwriteonce-persistent-volume-claims-d891e32:

#.  Create the **rwo-test-claim1** Persistent Volume Claim.


    #.  Create a yaml file defining the claim and its attributes.

        For example:

        .. code-block:: none

            ~(keystone_admin)]$ cat <<EOF > rwo-claim1.yaml
            kind: PersistentVolumeClaim
            apiVersion: v1
            metadata:
              name: rwo-test-claim1
            spec:
              accessModes:
                - ReadWriteOnce
              resources:
                requests:
                  storage: 1Gi
              storageClassName: general
            EOF

    #.  Apply the settings created above.

        .. code-block:: none

            ~(keystone_admin)]$ kubectl apply -f rwo-claim1.yaml

            persistentvolumeclaim/rwo-test-claim1 created

#.  Create the **rwo-test-claim2** Persistent Volume Claim.


    #.  Create a yaml file defining the claim and its attributes.

        For example:

        .. code-block:: none

            ~(keystone_admin)]$ cat <<EOF > rwo-claim2.yaml
            kind: PersistentVolumeClaim
            apiVersion: v1
            metadata:
              name: rwo-test-claim2
            spec:
              accessModes:
                - ReadWriteOnce
              resources:
                requests:
                  storage: 1Gi
              storageClassName: general
            EOF

    #.  Apply the settings created above.

        .. code-block:: none

            ~(keystone_admin)]$ kubectl apply -f rwo-claim2.yaml
            persistentvolumeclaim/rwo-test-claim2 created

.. rubric:: |result|

Two 1Gb |PVCs| have been created. You can view the |PVCs| using
the following command.

.. code-block:: none

    ~(keystone_admin)]$ kubectl get persistentvolumeclaims

    NAME              STATUS   VOLUME      CAPACITY   ACCESS MODES   STORAGECLASS
    rwo-test-claim1   Bound    pvc-aaca..  1Gi        RWO            general
    rwo-test-claim2   Bound    pvc-e93f..  1Gi        RWO            general


.. code-block:: none

    ~(keystone_admin)]$ kubectl get persistentvolume

    NAME      CAPACITY ACCESS.. RECLAIM.. STATUS CLAIM                   STORAGECLASS
    pvc-08d8.. 1Gi      RWO     Delete    Bound  default/rwo-test-claim1 general
    pvc-af10.. 1Gi      RWO     Delete    Bound  default/rwo-test-claim2 general
