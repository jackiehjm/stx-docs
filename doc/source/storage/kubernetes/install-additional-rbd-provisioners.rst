
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

#.  Capture a list of monitors.

    This will be stored in the environment variable ``<MON_LIST>`` and
    used in the following step.

    .. code-block:: none

        ~(keystone_admin)$ MON_LIST=$(ceph mon dump 2>&1 | awk /^[0-2]:/'{print $2}' | awk -F'/' '{print "  - "$1}')

#.  Create an overrides yaml file defining the new provisioner.

    In this example we will create the file
    /home/sysadmin/my-second-provisioner-overrides.yaml.

    .. code-block:: none

        ~(keystone_admin)$ cat <<EOF > /home/sysadmin/my-second-provisioner-overrides.yaml
        global:
          adminId: admin
          adminSecretName: ceph-admin
          name: 2nd-provisioner
          provisioner_name: "ceph.com/2nd-rbd"
        classdefaults:
          monitors:
        ${MON_LIST}
        classes:
        - name: 2nd-storage
          pool_name: another-pool
          chunk_size: 64
          crush_rule_name: storage_tier_ruleset
          replication: 1
          userId: 2nd-user-secret
          userSecretName: 2nd-user-secret
        rbac:
          clusterRole: 2nd-provisioner
          clusterRoleBinding: 2nd-provisioner
          role: 2nd-provisioner
          roleBinding: 2nd-provisioner
          serviceAccount: 2nd-provisioner
        EOF

#.  Install the chart.

    .. code-block:: none

        ~(keystone_admin)$ helm upgrade --install my-2nd-provisioner stx-platform/rbd-provisioner --namespace=isolated-app --values=/home/sysadmin/my-second-provisioner-overrides.yaml
        Release "my-2nd-provisioner" does not exist. Installing it now.
        NAME:   my-2nd-provisioner
        LAST DEPLOYED: Mon May 27 05:04:51 2019
        NAMESPACE: isolated-app
        STATUS: DEPLOYED
        ...

    .. note::
        Helm automatically created the namespace **isolated-app** while
        installing the chart.

#.  Confirm that **my-2nd-provisioner** has been deployed.

    .. code-block:: none

        ~(keystone_admin)$ helm list -a
        NAME                    REVISION   UPDATED                     STATUS      CHART                   APP VERSION     NAMESPACE
        my-2nd-provisioner      1          Mon May 27 05:04:51 2019    DEPLOYED    rbd-provisioner-0.1.0                   isolated-app
        my-app3                 1          Sun May 26 22:52:16 2019    DEPLOYED    mysql-1.1.1             5.7.14          new-app3
        my-new-sc-app           1          Sun May 26 23:11:37 2019    DEPLOYED    mysql-1.1.1             5.7.14          new-sc-app
        my-release              1          Sun May 26 22:31:08 2019    DEPLOYED    mysql-1.1.1             5.7.14          default
        ...

#.  Confirm that the **2nd-storage** storage class was created.

    .. code-block:: none

        ~(keystone_admin)$ kubectl get sc --all-namespaces
        NAME                    PROVISIONER        AGE
        2nd-storage             ceph.com/2nd-rbd   61s
        general (default)       ceph.com/rbd       6h39m
        special-storage-class   ceph.com/rbd       5h58m

    You can now create and mount PVCs from the new |RBD| provisioner's
    **2nd-storage** storage class, from within the **isolated-app**
    namespace.
