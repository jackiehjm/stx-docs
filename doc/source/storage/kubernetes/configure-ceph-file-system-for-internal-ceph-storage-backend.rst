
.. clb1615317605723
.. _configure-ceph-file-system-for-internal-ceph-storage-backend:

============================================================
Configure Ceph File System for Internal Ceph Storage Backend
============================================================

CephFS \(Ceph File System\) is a highly available, mutli-use, performant file
store for a variety of applications, built on top of Ceph's Distributed Object
Store \(RADOS\).

.. rubric:: |context|

CephFS provides the following functionality:


.. _configure-ceph-file-system-for-internal-ceph-storage-backend-ul-h2b-h1k-x4b:

-   Enabled by default \(along with existing Ceph RDB\)

-   Highly available, multi-use, performant file storage

-   Scalability using a separate RADOS pool for the file's metadata

-   Metadata using Metadata Servers \(MDS\) that provide high availability and
    scalability

-   Deployed in HA configurations for all |prod| deployment options

-   Integrates **cephfs-provisioner** supporting Kubernetes **StorageClass**

-   Enables configuration of:


    -   **PersistentVolumeClaim** \(|PVC|\) using **StorageClass** and
        ReadWriteMany accessmode

    -   Two or more application pods mounting |PVC| and reading/writing data to it

CephFS is configured automatically when a Ceph backend is enabled and provides
a Kubernetes **StorageClass**. Once enabled, every node in the cluster that
serves as a Ceph monitor will also be configured as a CephFS Metadata Server
\(MDS\). Creation of the CephFS pools, filesystem initialization, and creation
of Kubernetes resource is done by the **platform-integ-apps** application,
using **cephfs-provisioner** Helm chart.

When applied, **platform-integ-apps** creates two Ceph pools for each storage
backend configured, one for CephFS data and a second pool for metadata:


.. _configure-ceph-file-system-for-internal-ceph-storage-backend-ul-jp2-yn2-x4b:

-   **CephFS data pool**: The pool name for the default storage backend is
    **kube-cephfs-data**

-   **Metadata pool**: The pool name is **kube-cephfs-metadata**

    When a new storage backend is created, a new CephFS data pool will be
    created with the name **kube-cephfs-data-** \<storage\_backend\_name\>, and
    the metadata pool will be created with the name
    **kube-cephfs-metadata-** \<storage\_backend\_name\>. The default
    filesystem name is **kube-cephfs**.

    When a new storage backend is created, a new filesystem will be created
    with the name **kube-cephfs-** \<storage\_backend\_name\>.


For example, if the user adds a storage backend named, 'test',
**cephfs-provisioner** will create the following pools:


.. _configure-ceph-file-system-for-internal-ceph-storage-backend-ul-i3w-h1f-x4b:

-   kube-cephfs-data-test

-   kube-cephfs-metadata-test


Also, the application **platform-integ-apps** will create a filesystem **kube
cephfs-test**.

If you list all the pools in a cluster with 'test' storage backend, you should
see four pools created by **cephfs-provisioner** using **platform-integ-apps**.
Use the following command to list the CephFS |OSD| pools created.

.. code-block:: none

    $ ceph osd lspools


.. _configure-ceph-file-system-for-internal-ceph-storage-backend-ul-nnv-lr2-x4b:

-   kube-rbd

-   kube-rbd-test

-   **kube-cephfs-data**

-   **kube-cephfs-data-test**

-   **kube-cephfs-metadata**

-   **kube-cephfs-metadata-test**


Use the following command to list Ceph File Systems:

.. code-block:: none

    $ ceph fs ls
    name: kube-cephfs, metadata pool: kube-cephfs-metadata, data pools: [kube-cephfs-data ]
    name: kube-cephfs-silver, metadata pool: kube-cephfs-metadata-silver, data pools: [kube-cephfs-data-silver ]

:command:`cephfs-provisioner` creates in a Kubernetes cluster, a
**StorageClass** for each storage backend present.

These **StorageClass** resources should be used to create
**PersistentVolumeClaim** resources in order to allow pods to use CephFS. The
default **StorageClass** resource is named **cephfs**, and additional resources
are created with the name \<storage\_backend\_name\> **-cephfs** for each
additional storage backend created.

For example, when listing **StorageClass** resources in a cluster that is
configured with a storage backend named 'test', the following storage classes
are created:

.. code-block:: none

    $ kubectl get sc
    NAME              PROVISIONER     RECLAIM.. VOLUME..  ALLOWVOLUME.. AGE
    cephfs            ceph.com/cephfs Delete    Immediate false         65m
    general (default) ceph.com/rbd    Delete    Immediate false         66m
    test-cephfs       ceph.com/cephfs Delete    Immediate false         65m
    test-general      ceph.com/rbd    Delete    Immediate false         66m

All Kubernetes resources \(pods, StorageClasses, PersistentVolumeClaims,
configmaps, etc.\) used by the provisioner are created in the **kube-system
namespace.**

.. note::
    Multiple Ceph file systems are not enabled by default in the cluster. You
    can enable it manually, for example, using the command; :command:`ceph fs
    flag set enable\_multiple true --yes-i-really-mean-it`.


.. _configure-ceph-file-system-for-internal-ceph-storage-backend-section-dq5-wgk-x4b:

-------------------------------
Persistent Volume Claim \(PVC\)
-------------------------------

.. rubric:: |context|

If you need to create a Persistent Volume Claim, you can create it using
**kubectl**. For example:


.. _configure-ceph-file-system-for-internal-ceph-storage-backend-ol-lrh-pdf-x4b:

#.  Create a file named **my\_pvc.yaml**, and add the following content:

    .. code-block:: none

        kind: PersistentVolumeClaim
        apiVersion: v1
        metadata:
          name: claim1
          namespace: kube-system
        spec:
          storageClassName: cephfs
          accessModes:
          - ReadWriteMany
          resources:
           requests:
            storage: 1Gi

#.  To apply the updates, use the following command:

    .. code-block:: none

        $ kubectl apply -f my_pvc.yaml

#.  After the |PVC| is created, use the following command to see the |PVC|
    bound to the existing **StorageClass**.

    .. code-block:: none

        $ kubectl get pvc -n kube-system
        
        NAME STATUS  VOLUME      CAPACITY   ACCESS MODES   STORAGECLASS   AGE
        claim1       Boundpvc..  1Gi        RWX            cephfs  

#.  The |PVC| is automatically provisioned by the **StorageClass**, and a |PVC|
    is created. Use the following command to list the |PVC|.

    .. code-block:: none

        $ kubectl get pv -n kube-system
        
        NAME    CAPACITY ACCESS..RECLAIM.. STATUS CLAIM             STORAGE.. REASON AGE
        pvc-5.. 1Gi      RWX     Delete    Bound  kube-system/claim1 cephfs          26s
        

#.  Create Pods to use the |PVC|. Create a file my\_pod.yaml:

    .. code-block:: none

        kind: Pod
        apiVersion: v1
        metadata:
          name: test-pod
          namespace: kube-system
        spec:
          containers:
          - name: test-pod
            image: gcr.io/google_containers/busybox:1.24
            command:
              - "/bin/sh"
            args:
              - "-c"
              - "touch /mnt/SUCCESS && exit 0 || exit 1"
            volumeMounts:
              - name: pvc
                mountPath: "/mnt"
          restartPolicy: "Never"
          volumes:
            - name: pvc
              persistentVolumeClaim:
                claimName: claim1 

#.  Apply the inputs to the **pod.yaml** file, using the following command.

    .. code-block:: none

        $ kubectl apply -f my_pod.yaml


For more information on Persistent Volume Support, see, :ref:`About Persistent
Volume Support <about-persistent-volume-support>`, and, 
|usertasks-doc|: :ref:`Creating Persistent Volume Claims
<kubernetes-user-tutorials-creating-persistent-volume-claims>`.

