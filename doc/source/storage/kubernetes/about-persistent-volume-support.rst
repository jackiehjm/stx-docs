
.. rhb1561120463240
.. _about-persistent-volume-support:

===============================
About Persistent Volume Support
===============================

Persistent Volume Claims (PVCs) are requests for storage resources in your
cluster. By default, container images have an ephemeral file system. In order
for containers to persist files beyond the lifetime of the container, a
|PVC| can be created to obtain a persistent volume which the
container can mount and read/write files. In |prod-long|, |PVCs| are backed by
Ceph.

Management and customization tasks for Kubernetes |PVCs|
can be accomplished by using StorageClasses set up by two Helm charts;
``rbd-provisioner`` and ``cephfs-provisioner``. The ``rbd-provisioner``,
and ``cephfs-provisioner`` Helm charts are included in the
``platform-integ-apps`` system application, which is automatically loaded and
applied when Ceph is configured.

If ``platform-integ-apps`` is not applied, then enable Ceph. Enabling Ceph
would automatically apply the ``platform-integ-apps`` application. For
information on how to enable Ceph, see :ref:`Ceph Cluster on a Controller Host
<ceph-cluster-on-a-controller-host>`.

|PVCs| are supported with the following options:

-   with accessMode of ReadWriteOnce backed by Ceph |RBD|

    -   only one container can attach to these |PVCs|
    -   management and customization tasks related to these PVCs are done
        through the ``rbd-provisioner`` Helm chart provided by
        ``platform-integ-apps``

-   with accessMode of ReadWriteMany backed by CephFS

    -   multiple containers can attach to these PVCs
    -   management and customization tasks related to these |PVCs| are done
        through the ``cephfs-provisioner`` Helm chart provided by
        ``platform-integ-apps``

After ``platform-integ-apps`` is applied the following system configurations are
created:

-   **Ceph Pools**

    .. code-block:: none

        ~(keystone_admin)]$ ceph osd lspools
        kube-rbd
        kube-cephfs-data
        kube-cephfs-metadata

-   **CephFS**

    .. code-block:: none

        ~(keystone_admin)]$ ceph fs ls
        name: kube-cephfs, metadata pool: kube-cephfs-metadata, data pools: [kube-cephfs-data ]

-   **Kubernetes StorageClasses**

    .. code-block:: none

        ~(keystone_admin)]$ kubectl get sc
        NAME               PROVISIONER         RECLAIMPOLICY VOLUMEBINDINGMODE   ALLOWVOLUMEEXPANSION
        cephfs             cephfs.csi.ceph.com Delete        Immediate           true
        general (default)  rbd.csi.ceph.com    Delete        Immediate           true



