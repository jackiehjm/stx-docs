
.. rqy1582055871598
.. _kubernetes-user-tutorials-creating-persistent-volume-claims:

===============================
Create Persistent Volume Claims
===============================

Container images have an ephemeral file system by default. For data to survive
beyond the lifetime of a container, it can read and write files to a persistent
volume obtained with a :abbr:`PVC (Persistent Volume Claim)` created to provide
persistent storage.

.. rubric:: |context|

The following steps create two 1Gb persistent volume claims.

.. rubric:: |proc|

.. _kubernetes-user-tutorials-creating-persistent-volume-claims-d385e32:

#.  Create the **test-claim1** persistent volume claim.


    #.  Create a yaml file defining the claim and its attributes.

        For example:

        .. code-block:: yaml

            ~(keystone_admin)$ cat <<EOF > claim1.yaml
            kind: PersistentVolumeClaim
            apiVersion: v1
            metadata:
              name: test-claim1
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

            ~(keystone_admin)$ kubectl apply -f claim1.yaml
            persistentvolumeclaim/test-claim1 created

#.  Create the **test-claim2** persistent volume claim.

    #.  Create a yaml file defining the claim and its attributes.

        For example:

        .. code-block:: yaml

            ~(keystone_admin)$ cat <<EOF > claim2.yaml
            kind: PersistentVolumeClaim
            apiVersion: v1
            metadata:
              name: test-claim2
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

            ~(keystone_admin)$ kubectl apply -f claim2.yaml
            persistentvolumeclaim/test-claim2 created

.. rubric:: |result|

Two 1Gb persistent volume claims have been created. You can view them with the
following command.

.. code-block:: none

    ~(keystone_admin)$ kubectl get persistentvolumeclaims
    NAME          STATUS   VOLUME      CAPACITY   ACCESS MODES   STORAGECLASS   AGE
    test-claim1   Bound    pvc-aaca..  1Gi        RWO            general        2m56s
    test-claim2   Bound    pvc-e93f..  1Gi        RWO            general        68s
