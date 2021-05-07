
.. yam1561029988526
.. _default-behavior-of-the-rbd-provisioner:

=======================================
Default Behavior of the RBD Provisioner
=======================================

The default Ceph Cluster configuration set up during |prod| installation
contains a single storage tier, storage, containing all the |OSDs|.

The default |RBD| provisioner service runs within the kube-system namespace and
has a single storage class, 'general', which is configured to:

.. _default-behavior-of-the-rbd-provisioner-ul-zg2-r2q-43b:

-   use the default 'storage' ceph storage tier

-   use a **kube-rbd** ceph pool, and

-   only support PVC requests from the following namespaces: kube-system,
    default and kube-public.


The full details of the rbd-provisioner configuration can be viewed with
the following commands:

.. code-block:: none

    ~(keystone_admin)$ system helm-override-list platform-integ-apps

This command provides the chart names and the overrides namespaces.

.. code-block:: none

    ~(keystone_admin)$ system helm-override-show platform-integ-apps rbd-provisioner kube-system

See :ref:`Creating ReadWriteOnce Persistent Volume Claims <storage-configuration-create-readwriteonce-persistent-volume-claims>` and
:ref:`Mounting ReadWriteOnce Persistent Volumes in Containers <storage-configuration-mount-readwriteonce-persistent-volumes-in-containers>`
for an example of how to create and mount a ReadWriteOnce |PVC| from the
'general' storage class.