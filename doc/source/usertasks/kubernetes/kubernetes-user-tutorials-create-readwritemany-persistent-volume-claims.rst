
.. xms1617036308112
.. _kubernetes-user-tutorials-create-readwritemany-persistent-volume-claims:

=============================================
Create ReadWriteMany Persistent Volume Claims
=============================================

Container images have an ephemeral file system by default. For data to survive
beyond the lifetime of a container, it can read and write files to a
volume obtained with a Persistent Volume Claim \(PVC\) created to provide
persistent storage.

.. rubric:: |context|

For multiple containers to mount the same PVC, create a PVC with accessMode of
ReadWriteMany \(RWX\).

The following steps show an example of creating a 1GB |PVC|
with ReadWriteMany accessMode.

.. rubric:: |proc|

.. _xms1617036308112-steps-bdr-qnm-tkb:

#.  Create the **rwx-test-claim** Persistent Volume Claim.

    #.  Create a yaml file defining the claim and its attributes. For example:

        .. code-block:: none

            ~(keystone_admin)]$ cat <<EOF > rwx-claim.yaml
            kind: PersistentVolumeClaim
            apiVersion: v1
            metadata:
              name: rwx-test-claim
            spec:
              accessModes:
              - ReadWriteMany
              resources:
                requests:
                  storage: 1Gi
              storageClassName: cephfs
            EOF

    #.  Apply the settings created above.

        .. code-block:: none

            ~(keystone_admin)]$ kubectl apply -f rwx-claim.yaml
            persistentvolumeclaim/rwx-test-claim created

1GB PVC has been created. You can view the PVCs using the following command.

.. code-block:: none

    ~(keystone_admin)]$ kubectl get persistentvolumeclaims

    NAME              STATUS   VOLUME       CAPACITY   ACCESS MODES   STORAGECLASS
    rwx-test-claim    Bound    pvc-df9f..   1Gi        RWX            cephfs


.. code-block:: none

    ~(keystone_admin)]$ kubectl get persistentvolume
    NAME       CAPACITY ACCESS.. RECLAIM.. STATUS CLAIM                   STORAGECLASS
    pvc-df9f.. 1Gi      RWX       Delete    Bound  default/rwx-test-claim  cephfs

For more information on using CephFS for internal Ceph backends, see,
|stor-doc| :ref:`About Persistent Volume Support <about-persistent-volume-support>`.
