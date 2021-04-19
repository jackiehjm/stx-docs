
.. mgt1616518429546
.. _default-behavior-of-the-cephfs-provisioner:

==========================================
Default Behavior of the CephFS Provisioner
==========================================

The default Ceph Cluster configuration set up during |prod| installation
contains a single storage tier, storage, containing all the OSDs.

The default CephFS provisioner service runs within the kube-system namespace
and has a single storage class, '**cephfs**', which is configured to:

.. _mgt1616518429546-ul-g3n-qdb-bpb:

-   use the default 'storage' Ceph storage tier
-   use a **kube-cephfs-data** and **kube-cephfs-metadata** Ceph pool, and
-   only support |PVC| requests from the following namespaces: kube-system,
    default and kube-public.

The full details of the **cephfs-provisioner** configuration can be viewed
using the following commands:

.. code-block:: none

    ~(keystone_admin)]$ system helm-override-list platform-integ-apps

The following command provides the chart names and the overrides namespaces.

.. code-block:: none

    ~(keystone_admin)]$ system helm-override-show platform-integ-apps cephfs-provisioner kube-system

See :ref:`Create ReadWriteMany Persistent Volume Claims <create-readwritemany-persistent-volume-claims>`
and :ref:`Mount ReadWriteMany Persistent Volumes in Containers <mount-readwritemany-persistent-volumes-in-containers>`
for an example of how to create and mount a ReadWriteMany PVC from the **cephfs**
storage class.
