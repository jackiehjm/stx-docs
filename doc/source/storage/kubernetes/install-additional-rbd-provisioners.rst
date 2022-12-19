
.. vgr1561030583228
.. _install-additional-rbd-provisioners:

===================================
Install Additional RBD Provisioners
===================================

You can launch additional dedicated |RBD| provisioners to support specific
applications using dedicated pools, storage classes, and namespaces.

.. rubric:: |context|

This can be useful if, for example, to allow an application to have control
over its own persistent volume provisioner, that is, managing the Ceph
pool, storage tier, allowed namespaces, and so on, without requiring the
kubernetes admin to modify the default |RBD| provisioner service in the
kube-system namespace.

This procedure uses standard Helm mechanisms to install a second
|RBD| provisioner.

.. rubric:: |proc|

#.  Capture a list of monitors and cluster ID.

    This will be stored in the environment variable ``<MON_LIST>`` and used in
    the following step.

    .. code-block:: none

        ~(keystone_admin)]$ MON_LIST=$(ceph mon dump 2>&1 | awk /^[0-2]:/'{print $2}' | grep -oP '(?<=v1:).*(?=/)' | awk -F' ' '{print "  - "$1}')

    This will be stored in the environment variable ``<CLUSTER_ID>`` and used
    in the following step.

    .. code-block:: none

        ~(keystone_admin)]$ CLUSTER_ID=$(ceph fsid)

#.  Create an overrides yaml file defining the new provisioner.

    In this example we will create the file
    ``/home/sysadmin/my-second-provisioner-overrides.yaml``.

    .. code-block:: none

        ~(keystone_admin)]$ cat <<EOF > ~/my-second-provisioner-overrides.yaml
        classdefaults:
          monitors:
        ${MON_LIST}
        classes:
        - additionalNamespaces:
          - default
          - kube-public
          chunk_size: 64
          clusterID: ${CLUSTER_ID}
          crush_rule_name: storage_tier_ruleset
          name: 2nd-provisioner
          pool_name: another-pool
          replication: 1
          userId: 2nd-user-secret
          userSecretName: 2nd-user-secret
        csiConfig:
        - clusterID: ${CLUSTER_ID}
          monitors:
        ${MON_LIST}
        nodeplugin:
          fullnameOverride: 2nd-nodeplugin
        provisioner:
          fullnameOverride: 2nd-provisioner
          replicaCount: 1
        driverName: cool-rbd-provisioner.csi.ceph.com
        EOF

    .. note::

        The ``replicaCount`` parameter has the value 1 for SX and 2 for others.

#.  Gets the directory where the rbd-provisioner static overrides file is
    located.

    This will be stored in the environment variable ``<RBD_STATIC_OVERRIDES>`` and
    used in the following step.

    .. code-block:: none

        ~(keystone_admin)]$ SW_VERSION=$(system show | awk /software_version/'{print $4}')
        ~(keystone_admin)]$ INTEG_APPS_VERSION=$(system application-show platform-integ-apps | awk /app_version/'{print $4}')
        ~(keystone_admin)]$ RBD_STATIC_OVERRIDES=/opt/platform/fluxcd/$SW_VERSION/platform-integ-apps/$INTEG_APPS_VERSION/platform-integ-apps-fluxcd-manifests/rbd-provisioner/rbd-provisioner-static-overrides.yaml

#.  Install the chart.

    .. code-block:: none

        ~(keystone_admin)]$ helm upgrade --install my-2nd-provisioner stx-platform/ceph-csi-rbd --namespace=isolated-app --create-namespace --values=$RBD_STATIC_OVERRIDES --values=/home/sysadmin/my-second-provisioner-overrides.yaml
        Release "my-2nd-provisioner" does not exist. Installing it now.
        NAME: my-2nd-provisioner
        LAST DEPLOYED: Wed Dec 14 04:20:00 2022
        NAMESPACE: isolated-app
        STATUS: deployed
        ...

    .. note::
        Helm automatically created the namespace **isolated-app** while
        installing the chart.

#.  Confirm that ``my-2nd-provisioner`` has been deployed.

    .. code-block:: none

        ~(keystone_admin)]$ helm list -n isolated-app
        NAME              	NAMESPACE   	REVISION	UPDATED                                	STATUS  	CHART             	APP VERSION
        my-2nd-provisioner	isolated-app	1       	2022-12-14 04:20:00.345212618 +0000 UTC	deployed	ceph-csi-rbd-3.6.2	3.6.2

#.  Confirm that the ``2nd-storage`` storage class was created.

    .. code-block:: none

        ~(keystone_admin)]$ kubectl get sc -A
        NAME                PROVISIONER                         RECLAIMPOLICY   VOLUMEBINDINGMODE   ALLOWVOLUMEEXPANSION   AGE
        2nd-provisioner     cool-rbd-provisioner.csi.ceph.com   Delete          Immediate           true                   6m4s
        cephfs              cephfs.csi.ceph.com                 Delete          Immediate           true                   10m
        general (default)   rbd.csi.ceph.com                    Delete          Immediate           true                   10m

    You can now create and mount PVCs from the new |RBD| provisioner's
    ``2nd-storage`` storage class, from within the ``isolated-app``
    namespace.
