========================================
Ceph Cluster Migration for duplex system
========================================

This guide contains step by step instructions for manually migrating a StarlingX
deployment with an all-in-one duplex Ceph Cluster to a containerized Ceph cluster
deployed by Rook.

.. contents::
   :local:
   :depth: 1

------------
Introduction
------------

In early releases of StarlingX, the backend storage cluster solution (Ceph) was
deployed directly on the host platform. In an upcoming release of StarlingX,
Ceph cluster will be containerized and managed by Rook, to improve operation
and maintenance efficiency.

This guide describes a method to migrate the host-based Ceph cluster deployed with
StarlingX early releases to the newly containerized Ceph clusters using an upcoming
StarlingX release, while maintaining user data in |OSDs|.

The migration procedure maintains CEPH OSDs and data on OSDs.  Although the procedure
does result in hosted applications experiencing several minutes of service outage due
to temporary loss of access to PVCs or virtual disks, due to the temporary loss of
the ceph service.

---------------------
Prepare for migration
---------------------

StarlingX uses some :abbr:`HA (High Availability)` mechanisms for critical
service monitoring and recovering. To migrate Ceph monitor(s) and Ceph OSD(s),
the first step is to disable monitoring and recovery for Ceph services. This
avoids interrupting the migration procedure with service restarts.

*************************************
Disable StarlingX HA for Ceph service
*************************************

#. Disable service manager's monitoring of Ceph related service on both two controllers.

   ::

    sudo sm-unmanage service mgr-restful-plugin
    Service (mgr-restful-plugin) is no longer being managed.
    sudo sm-unmanage service ceph-manager
    Service (ceph-manager) is no longer being managed.
    sudo sm-unmanage service ceph-mon
    Service (ceph-mon) is no longer being managed.
    sudo sm-unmanage service cephmon-fs
    Service (cephmon-fs) is no longer being managed.
    sudo sm-unmanage service drbd-cephmon
    Service (drbd-cephmon) is no longer being managed.
    sudo sm-unmanage service ceph-osd
    Service (ceph-osd) is no longer being managed.
    sudo sm-deprovision service-group-member storage-monitoring-services ceph-manager
    sudo sm-deprovision service-group-member storage-services mgr-restful-plugin
    sudo sm-deprovision service-group-member storage-services ceph-osd
    sudo sm-deprovision service-group-member controller-services ceph-mon
    sudo sm-deprovision service-group-member controller-services cephmon-fs
    sudo sm-deprovision service-group-member controller-services drbd-cephmon

**********************************
Enable Ceph service authentication
**********************************

StarlingX disables Ceph authentication, but authentication is required for Rook.
Before migration, enable authentication for each daemon.

#. Enable authentication for Ceph mon and osd service.

   ::

    ceph config set mon.controller auth_cluster_required cephx
    ceph config set mon.controller auth_supported cephx
    ceph config set mon.controller auth_service_required cephx
    ceph config set mon.controller auth_client_required cephx
    ceph config set mgr.controller-0 auth_supported cephx
    ceph config set mgr.controller-0 auth_cluster_required cephx
    ceph config set mgr.controller-0 auth_client_required cephx
    ceph config set mgr.controller-0 auth_service_required cephx
    ceph config set mgr.controller-1 auth_supported cephx
    ceph config set mgr.controller-1 auth_cluster_required cephx
    ceph config set mgr.controller-1 auth_client_required cephx
    ceph config set mgr.controller-1 auth_service_required cephx
    ceph config set osd.0 auth_supported cephx
    ceph config set osd.0 auth_cluster_required cephx
    ceph config set osd.0 auth_service_required cephx
    ceph config set osd.0 auth_client_required cephx
    ceph config set osd.1 auth_supported cephx
    ceph config set osd.1 auth_cluster_required cephx
    ceph config set osd.1 auth_service_required cephx
    ceph config set osd.1 auth_client_required cephx

#. Generate ``client.admin`` key.

   ::

    ADMIN_KEY=$(ceph auth get-or-create-key client.admin mon 'allow *' osd 'allow *' mgr 'allow *' mds 'allow *')
    echo $ADMIN_KEY
    AQDRGqFea0cYERAAwYdhhle5zEbLLkYHWF+sDw==
    MON_KEY=$(ceph auth get-or-create-key mon. mon 'allow *')
    echo $MON_KEY
    AQBbs79eM4/FMRAAbu4jwdBFVS1hOmlCdoCacQ==

***********************************************
Create configmap and secret for Rook deployment
***********************************************

Rook uses a configmap, ``rook-ceph-mon-endpoint``, and a secret,
``rook-ceph-mon``, to get cluster info. Create the configmap and secret with
the commands below.

::

    export NAMESPACE=kube-system
    export ROOK_EXTERNAL_CEPH_MON_DATA=a=192.188.204.3:6789
    export ROOK_EXTERNAL_FSID=$(ceph fsid)
    export ROOK_EXTERNAL_CLUSTER_NAME=$NAMESPACE
    export ROOK_EXTERNAL_MAX_MON_ID=0

    kubectl -n "$NAMESPACE"  create secret generic rook-ceph-mon \
    > --from-literal=cluster-name="$ROOK_EXTERNAL_CLUSTER_NAME" \
    > --from-literal=fsid="$ROOK_EXTERNAL_FSID" \
    > --from-literal=admin-secret="$ADMIN_KEY" \
    > --from-literal=mon-secret="$MON_KEY"
    secret/rook-ceph-mon created

    kubectl -n "$NAMESPACE" create configmap rook-ceph-mon-endpoints \
    > --from-literal=data="$ROOK_EXTERNAL_CEPH_MON_DATA" \
    > --from-literal=mapping="$ROOK_EXTERNAL_MAPPING" \
    > --from-literal=maxMonId="$ROOK_EXTERNAL_MAX_MON_ID"
    configmap/rook-ceph-mon-endpoint created

**********************
Remove rbd-provisioner
**********************

The ``platform-integ-apps`` application deploys the helm chart
``rbd-provisioner``. This chart is unnecessary after Rook is deployed, remove
it with the command below.

::

    sudo rm -rf /opt/platform/sysinv/20.01/.crushmap_applied
    source /etc/platform/openrc
    system application-remove platform-integ-apps

    +---------------+----------------------------------+
    | Property      | Value                            |
    +---------------+----------------------------------+
    | active        | True                             |
    | app_version   | 1.0-8                            |
    | created_at    | 2020-04-22T14:56:19.148562+00:00 |
    | manifest_file | manifest.yaml                    |
    | manifest_name | platform-integration-manifest    |
    | name          | platform-integ-apps              |
    | progress      | None                             |
    | status        | removing                         |
    | updated_at    | 2020-04-22T15:46:24.018090+00:00 |
    +---------------+----------------------------------+

----------------------------------------------
Remove storage backend ceph-store and clean up
----------------------------------------------

After migration, remove the default storage backend ceph-store.

::

    system storage-backend-list
    +--------------------------------------+------------+---------+------------+------+----------+------------------------------------------------------------------------+
    | uuid                                 | name       | backend | state      | task | services | capabilities                                                           |
    +--------------------------------------+------------+---------+------------+------+----------+------------------------------------------------------------------------+
    | 3fd0a407-dd8b-4a5c-9dec-8754d76956f4 | ceph-store | ceph    | configured | None | None     | min_replication: 1 replication: 2                                      |
    |                                      |            |         |            |      |          |                                                                        |
    +--------------------------------------+------------+---------+------------+------+----------+------------------------------------------------------------------------+
    system storage-backend-delete 3fd0a407-dd8b-4a5c-9dec-8754d76956f4 --force

Update puppet system config.

::

    sudo sysinv-puppet create-system-config

Remove script ceph.sh on both controllers.

::

    sudo rm -rf /etc/services.d/controller/ceph.sh
    sudo rm -rf /etc/services.d/worker/ceph.sh
    sudo rm -rf /etc/services.d/storage/ceph.sh

************************************************************************
Disable ceph osd on all storage hosts and create configmap for migration
************************************************************************

#. Login to controller host and run ``ceph-preshutdown.sh`` firstly.

   ::

    sudo ceph-preshutdown.sh

Login to the both controllers, disable the Ceph osd service, and create a
journal file.

#. Disable the Ceph osd service.

   ::

    sudo service ceph -a stop osd.1
    === osd.1 ===
    Stopping Ceph osd.1 on controller-1...kill  213077...
    done
    2020-04-26 23:36:56.988 7f1d647bb1c0 -1 journal do_read_entry(585007104): bad header magic
    2020-04-26 23:36:56.988 7f1d647bb1c0 -1 journal do_read_entry(585007104): bad header magic
    2020-04-26 23:36:56.994 7f1d647bb1c0 -1 flushed journal /var/lib/ceph/osd/ceph-1/journal for object store /var/lib/ceph/osd/ceph-1

#. Remove the journal link and create a blank journal file.

   ::

    sudo rm -f /var/lib/ceph/osd/ceph-1/journal
    sudo touch /var/lib/ceph/osd/ceph-1/journal
    sudo dd if=/dev/zero of=/var/lib/ceph/osd/ceph-1/journal bs=1M count=1024
    sudo ceph-osd --id 1  --mkjournal --no-mon-config
    sudo umount /dev/sdc1

#. Mount to host patch /var/lib/ceph/osd<n>, which can be accessed by the Rook
   osd pod.

   ::

    sudo mkdir -p /var/lib/ceph/ceph-1/osd1
    sudo mount /dev/sdc1 /var/lib/ceph/ceph-1/osd1
    sudo ls /var/lib/ceph/ceph-1/osd1 -l
    total 1048640
    -rw-r--r--   1 root root          3 Apr 26 12:57 active
    -rw-r--r--   1 root root         37 Apr 26 12:57 ceph_fsid
    drwxr-xr-x 388 root root      12288 Apr 27 00:01 current
    -rw-r--r--   1 root root         37 Apr 26 12:57 fsid
    -rw-r--r--   1 root root 1073741824 Apr 27 00:49 journal
    -rw-r--r--   1 root root         37 Apr 26 12:57 journal_uuid
    -rw-------   1 root root         56 Apr 26 12:57 keyring
    -rw-r--r--   1 root root         21 Apr 26 12:57 magic
    -rw-r--r--   1 root root          6 Apr 26 12:57 ready
    -rw-r--r--   1 root root          4 Apr 26 12:57 store_version
    -rw-r--r--   1 root root         53 Apr 26 12:57 superblock
    -rw-r--r--   1 root root          0 Apr 26 12:57 sysvinit
    -rw-r--r--   1 root root         10 Apr 26 12:57 type
    -rw-r--r--   1 root root          2 Apr 26 12:57 wanttobe
    -rw-r--r--   1 root root          2 Apr 26 12:57 whoami

For every host with an OSD device, create a configmap with the name
``rook-ceph-osd-<hostname>-config``. In the configmap, specify the OSD data
folder. In the example below, the Rook osd0 data path is ``/var/lib/ceph/osd0``.

::

    osd-dirs: '{"/var/lib/ceph/ceph-0/":0}'

    system host-stor-list controller-0
    +--------------------------------------+----------+-------+------------+--------------------------------------+-----------------------------+------------+--------------+-----------+
    | uuid                                 | function | osdid | state      | idisk_uuid                           | journal_path                | journal_no | journal_size | tier_name |
    |                                      |          |       |            |                                      |                             | de         | _gib         |           |
    +--------------------------------------+----------+-------+------------+--------------------------------------+-----------------------------+------------+--------------+-----------+
    | 21a90d60-2f1e-4f46-badc-afa7d9117622 | osd      | 0     | configured | a13c6ac9-9d59-4063-88dc-2847e8aded85 | /dev/disk/by-path/pci-0000: | /dev/sdc2  | 1            | storage   |
    |                                      |          |       |            |                                      | 00:03.0-ata-3.0-part2       |            |              |           |
    |                                      |          |       |            |                                      |                             |            |              |           |
    +--------------------------------------+----------+-------+------------+--------------------------------------+-----------------------------+------------+--------------+-----------+

    system host-stor-list controller-1
    +--------------------------------------+----------+-------+------------+--------------------------------------+-----------------------------+------------+--------------+-----------+
    | uuid                                 | function | osdid | state      | idisk_uuid                           | journal_path                | journal_no | journal_size | tier_name |
    |                                      |          |       |            |                                      |                             | de         | _gib         |           |
    +--------------------------------------+----------+-------+------------+--------------------------------------+-----------------------------+------------+--------------+-----------+
    | 17f2db8e-c80e-4df7-9525-1f0cb5b54cd3 | osd      | 1     | configured | 89637c7d-f959-4c54-bfe1-626b5c630d96 | /dev/disk/by-path/pci-0000: | /dev/sdc2  | 1            | storage   |
    |                                      |          |       |            |                                      | 00:03.0-ata-3.0-part2       |            |              |           |
    |                                      |          |       |            |                                      |                             |            |              |           |
    +--------------------------------------+----------+-------+------------+--------------------------------------+-----------------------------+------------+--------------+-----------+


#. Sample ``osd-configmap.yaml`` file.
   ::

    apiVersion: v1
    kind: ConfigMap
    metadata:
      name: rook-ceph-osd-controller-0-config
      namespace: kube-system
    data:
      osd-dirs: '{"/var/lib/ceph/ceph-0":0}'
    ---
    apiVersion: v1
    kind: ConfigMap
    metadata:
      name: rook-ceph-osd-controller-1-config
      namespace: kube-system
    data:
      osd-dirs: '{"/var/lib/ceph/ceph-1":1}'

#. Apply yaml file for configmap.

   ::

    kubectl apply -f osd-configmap.yaml
    configmap/rook-ceph-osd-controller-0-config created
    configmap/rook-ceph-osd-controller-1-config created

**************************
Ceph monitor data movement
**************************

For Ceph monitor migration, the Rook deployed monitor pod will read monitor data
for host path ``/var/lib/ceph/mon-<id>/data``. For example, if only one monitor
pod is deployed, a monitor process named ``mon.a`` in the monitor pod will be
created and monitor data will be in the host path ``/var/lib/ceph/mon-a/data``.

Before migration, disable one monitor service and launch another monitor
specified with the ``--mon-data /var/lib/ceph/mon-a/data`` parameter. This will
migrate the monitor data to ``/var/lib/ceph/mon-a/data``.

#. Login to host controller-0 and disable service monitor.controller.

   ::

    sudo service ceph -a stop mon.controller
    === mon.controller-0 ===
    Stopping Ceph mon.controller on controller-0...kill  291101...done

#. Copy mon data to the ``/var/lib/ceph/mon-a/data`` folder.

   ::

    sudo mkdir -p /var/lib/ceph/mon-a/data/
    sudo ceph-monstore-tool /var/lib/ceph/mon/ceph-controller/ store-copy /var/lib/ceph/mon-a/data/

#. Update monmap in this copy of monitor data and update monitor info.

   ::

    sudo ceph-mon --extract-monmap monmap --mon-data /var/lib/ceph/mon-a/data/
    2020-05-21 06:01:39.477 7f69d63b2140 -1 wrote monmap to monmap

    monmaptool --print monmap
    monmaptool: monmap file monmap
    epoch 2
    fsid 6c9e9e4b-599e-4a4f-931e-2c09bec74a2a
    last_changed 2020-05-21 04:29:59.164965
    created 2020-05-21 03:50:51.893155
    0: 192.188.204.3:6789/0 mon.controller

    sudo monmaptool --rm controller monmap
    monmaptool: monmap file monmap
    monmaptool: removing controller
    monmaptool: writing epoch 2 to monmap (2 monitors)

    sudo monmaptool --add a 192.188.204.3 monmap
    monmaptool: monmap file monmap
    monmaptool: writing epoch 2 to monmap (1 monitors)

    monmaptool --print monmap
    monmaptool: monmap file monmap
    epoch 2
    fsid 6c9e9e4b-599e-4a4f-931e-2c09bec74a2a
    last_changed 2020-05-21 04:29:59.164965
    created 2020-05-21 03:50:51.893155
    0: 192.188.204.3:6789/0 mon.a

    sudo ceph-mon --inject-monmap monmap  --mon-data /var/lib/ceph/mon-a/data/

**************************************
Disable Ceph monitors and Ceph manager
**************************************

Disable Ceph manager on host controller-0 and controller-1.

::

    ps -aux | grep mgr
    root       97971  0.0  0.0 241336 18488 ?        S<   03:54   0:02 /usr/bin/python /etc/init.d/mgr-restful-plugin start
    root       97990  0.5  0.0 241468 18916 ?        S<   03:54   0:38 /usr/bin/python /etc/init.d/mgr-restful-plugin start
    root      186145  1.2  0.3 716488 111328 ?       S<l  04:11   1:16 /usr/bin/ceph-mgr --cluster ceph --conf /etc/ceph/ceph.conf --id controller-0 -f
    sysadmin  643748  0.0  0.0 112712   976 pts/0    S+   05:51   0:00 grep --color=auto mgr

    sudo kill -9 97971  97990  186145

    ps -aux | grep ceph
    root       98044  0.2  0.1 352052 53556 ?        S<   03:54   0:15 python /usr/bin/ceph-manager --log-file=/var/log/ceph-manager.log --config-file=/etc/sysinv/sysinv.conf
    root      647566  0.0  0.0 112220   668 ?        S<   05:52   0:00 /usr/bin/timeout 30 /usr/bin/ceph fsid
    root      647567  1.0  0.0 810452 22320 ?        S<l  05:52   0:00 /usr/bin/python2.7 /usr/bin/ceph fsid
    sysadmin  648519  0.0  0.0 112712   976 pts/0    S+   05:52   0:00 grep --color=auto ceph

    sudo kill -9 98044

************************************
Reboot controller-0 and controller-1
************************************

Reboot both two controllers, and wait for host to be available.
After reboot, mount osd data partition on both controllers.

For example, on controller-0

::

    sudo mount /dev/sdc1 /var/lib/ceph/ceph-0/osd0

On controller-1

::

    sudo mount /dev/sdc1 /var/lib/ceph/ceph-1/osd1

----------------------
Deploy Rook helm chart
----------------------

StarlingX creates a application for Rook deployment. After finishing the
preparation steps above, run the application to deploy Rook.

***************************
Apply rook-ceph application
***************************

#. Assign a label for Ceph monitor and Ceph manager pod.

   ::

    source /etc/platform/openrc
    system host-label-assign controller-0 ceph-mon-placement=enabled
    +-------------+--------------------------------------+
    | Property    | Value                                |
    +-------------+--------------------------------------+
    | uuid        | ee117051-5422-4776-adc5-6c1e0a21e975 |
    | host_uuid   | 7271854b-551a-4bb3-a4d6-4351024dd649 |
    | label_key   | ceph-mon-placement                   |
    | label_value | enabled                              |
    +-------------+--------------------------------------+

    system host-label-assign controller-0 ceph-mgr-placement=enabled
    +-------------+--------------------------------------+
    | Property    | Value                                |
    +-------------+--------------------------------------+
    | uuid        | 948788ab-0d5a-43ff-ba35-1b767356dcfe |
    | host_uuid   | 7271854b-551a-4bb3-a4d6-4351024dd649 |
    | label_key   | ceph-mgr-placement                   |
    | label_value | enabled                              |
    +-------------+--------------------------------------+

#. Update override value for the ``rook-ceph-apps`` application with a created
   ``values.yaml`` file.

   values.yaml
   ::

    cluster:
      hostNetwork: true
      mon:
        allowMultiplePerNode: false
        count: 1

    system  helm-override-update  rook-ceph-apps rook-ceph kube-system --reuse-values --values value.yaml
    +----------------+---------------------------------+
    | Property       | Value                           |
    +----------------+---------------------------------+
    | name           | rook-ceph                       |
    | namespace      | kube-system                     |
    | user_overrides | cluster:                        |
    |                |   hostNetwork: true             |
    |                |   mon:                          |
    |                |     allowMultiplePerNode: false |
    |                |     count: 1                    |
    |                |                                 |
    +----------------+---------------------------------+

#. The application ``rook-ceph-apps`` is a sysinv-managed application.
   First upload it, then apply the application.

   ::

    system application-apply rook-ceph-apps
    +---------------+----------------------------------+
    | Property      | Value                            |
    +---------------+----------------------------------+
    | active        | False                            |
    | app_version   | 1.0-1                            |
    | created_at    | 2020-04-22T14:56:20.893255+00:00 |
    | manifest_file | manifest.yaml                    |
    | manifest_name | rook-ceph-manifest               |
    | name          | rook-ceph-apps                   |
    | progress      | None                             |
    | status        | applying                         |
    | updated_at    | 2020-04-22T14:56:26.643693+00:00 |
    +---------------+----------------------------------+

#. Use the command ``kubectl get pods -n kube-system`` and wait for mon pod to
   launch.

   ::

    rook-ceph-mgr-a-79cc758465-ltjwb               1/1     Running            4          3m11s
    rook-ceph-mon-a-64ccf46969-5k8kp               1/1     Running            5          3m13s
    rook-ceph-operator-6fc8cfb68b-dsqkt            1/1     Running            0          5m
    rook-ceph-tools-84c7fff88c-9g598               1/1     Running            0          4m12s

#. Edit CephCluster to add osd directories config.

   ::

    storage:
      nodes:
      - config:
          storeType: filestore
        directories:
        - path: /var/lib/ceph/ceph-0
        name: controller-0
        resources: {}
      - config:
          storeType: filestore
        directories:
        - path: /var/lib/ceph/ceph-1
        name: controller-1
        resources: {}

#. Wait for Rook pods to launch.

   ::

    rook-ceph-mgr-a-d98dd9559-ltlr7                1/1     Running     0          3m13s
    rook-ceph-mon-a-659d8857cc-plbkt               1/1     Running     0          3m27s
    rook-ceph-operator-6fc8cfb68b-km445            1/1     Running     0          6m22s
    rook-ceph-osd-0-74f69cf96-h6qsj                1/1     Running     0          54s
    rook-ceph-osd-1-6777967c99-g48vz               1/1     Running     0          55s
    rook-ceph-osd-prepare-controller-0-pgb6l       0/1     Completed   0          67s
    rook-ceph-osd-prepare-controller-1-fms4c       0/1     Completed   0          67s
    rook-ceph-tools-84c7fff88c-px74q               1/1     Running     0          5m34s
    rook-discover-cmfw7                            1/1     Running     0          5m37s
    rook-discover-hpz4q                            1/1     Running     0          5m37s
    rook-discover-n8j72                            1/1     Running     0          5m37s
    rook-discover-njxsd                            1/1     Running     0          5m37s
    rook-discover-wkhgq                            1/1     Running     0          5m37s
    rook-discover-xm54j                            1/1     Running     0          5m37s
    storage-init-rbd-provisioner-c9j5w             0/1     Completed   0          10h
    storage-init-rook-ceph-provisioner-zjzcq       1/1     Running     0          47s

#. Delete deployment rook-ceph-mon-a

   ::

    kubectl delete deployments.apps -n kube-system rook-ceph-mon-a
    deployment.apps "rook-ceph-mon-a" deleted


#. Apply service rook-ceph-mon-a, and get cluster ip, for example, 10.104.152.151.

   ::

    mon-a-svc.yaml
    apiVersion: v1
    kind: Service
    metadata:
      name: rook-ceph-mon-a
      namespace: kube-system
    spec:
      ports:
      - name: msgr1
        port: 6789
        protocol: TCP
        targetPort: 6789
      selector:
        app: rook-ceph-mon
        ceph_daemon_id: a
        mon: a
        mon_cluster: kube-system
        rook_cluster: kube-system
      sessionAffinity: None
      type: ClusterIP


    $ kubectl apply -f mon-a-svc.yaml
    service/rook-ceph-mon-a created

    $ kubectl get svc -n kube-system
    NAME                               TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)                  AGE
    csi-cephfsplugin-metrics           ClusterIP   10.107.231.162   <none>        8080/TCP,8081/TCP        4h23m
    csi-rbdplugin-metrics              ClusterIP   10.102.41.27     <none>        8080/TCP,8081/TCP        4h23m
    ic-nginx-ingress-controller        ClusterIP   10.111.161.197   <none>        80/TCP,443/TCP           21h
    ic-nginx-ingress-default-backend   ClusterIP   10.104.104.150   <none>        80/TCP                   21h
    kube-dns                           ClusterIP   10.96.0.10       <none>        53/UDP,53/TCP,9153/TCP   21h
    rook-ceph-mgr                      ClusterIP   10.108.43.251    <none>        9283/TCP                 4h14m
    rook-ceph-mgr-dashboard            ClusterIP   10.98.157.27     <none>        8443/TCP                 4h20m
    rook-ceph-mon-a                    ClusterIP   10.104.152.151   <none>        6789/TCP,3300/TCP        3h56m

#. Apply deployment mon-data-edit

   ::

    mon-data-edit.yaml
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: mon-data-edit
      namespace: kube-system
      labels:
        app: mon-data-edit
    spec:
      replicas: 1
      selector:
        matchLabels:
          app: mon-data-edit
      template:
        metadata:
          labels:
            app: mon-data-edit
        spec:
          dnsPolicy: ClusterFirstWithHostNet
          containers:
          - name: mon-data-edit
            image:  registry.local:9001/docker.io/rook/ceph:v1.2.7
            command: ["/tini"]
            args: ["-g", "--", "/usr/local/bin/toolbox.sh"]
            imagePullPolicy: IfNotPresent
            env:
              - name: ROOK_ADMIN_SECRET
                valueFrom:
                  secretKeyRef:
                    name: rook-ceph-mon
                    key: admin-secret
            volumeMounts:
              - mountPath: /etc/ceph
                name: ceph-config
              - name: mon-endpoint-volume
                mountPath: /etc/rook
              - name: rook-data
                mountPath: /var/lib/ceph
          volumes:
            - name: mon-endpoint-volume
              configMap:
                name: rook-ceph-mon-endpoints
                items:
                - key: data
                  path: mon-endpoints
            - name: ceph-config
              emptyDir: {}
            - name: rook-data
              hostPath:
                path: /var/lib/ceph
          tolerations:
            - key: "node.kubernetes.io/unreachable"
              operator: "Exists"
              effect: "NoExecute"
              tolerationSeconds: 5
          nodeName: controller-0

    $ kubectl apply -f mon-data-edit.yaml
    deployment.apps/mon-data-edit created

#. In mon-data-edit pod, edit monmap

   ::

    $ kubectl exec -it mon-data-edit-d65546cdb-b5vkr -n kube-system -- bash
    bash: warning: setlocale: LC_CTYPE: cannot change locale (en_US.UTF-8): No such file or directory
    bash: warning: setlocale: LC_COLLATE: cannot change locale (en_US.UTF-8): No such file or directory
    bash: warning: setlocale: LC_MESSAGES: cannot change locale (en_US.UTF-8): No such file or directory
    bash: warning: setlocale: LC_NUMERIC: cannot change locale (en_US.UTF-8): No such file or directory
    bash: warning: setlocale: LC_TIME: cannot change locale (en_US.UTF-8): No such file or directory
    [root@mon-data-edit-d65546cdb-b5vkr /]#

    [root@mon-data-edit-d65546cdb-b5vkr /]# ceph-mon --extract-monmap monmap --mon-data /var/lib/ceph/mon-a/data/
    2020-09-17 04:59:49.308 7f5b047d2040 -1 wrote monmap to monmap

    [root@mon-data-edit-d65546cdb-b5vkr /]# monmaptool --print monmap
    monmaptool: monmap file monmap
    epoch 2
    fsid ceface4e-9957-480e-96f4-f91fc1cb7fc9
    last_changed 2020-09-17 02:08:02.446136
    created 2020-09-16 07:58:20.615682
    min_mon_release 14 (nautilus)
    0: [v2:192.168.204.3:3300/0,v1:192.168.204.3:6789/0] mon.a

    [root@mon-data-edit-d65546cdb-b5vkr /]# monmaptool --rm a monmap
    monmaptool: monmap file monmap
    monmaptool: removing a
    monmaptool: writing epoch 2 to monmap (0 monitors)

    [root@mon-data-edit-d65546cdb-b5vkr /]# monmaptool --add a 10.104.152.151 monmap
    monmaptool: monmap file monmap
    monmaptool: writing epoch 2 to monmap (1 monitors)

    [root@mon-data-edit-d65546cdb-b5vkr /]# ceph-mon --inject-monmap monmap  --mon-data /var/lib/ceph/mon-a/data/
    [root@mon-data-edit-d65546cdb-b5vkr /]# exit

#. Edit CephCluster, change host network to false

   ::

    $ kubectl edit CephCluster -n kube-system

    network:
      hostNetwork: false

#. Delete deployment rook-ceph-mgr-a, rook-ceph-osd-0 and rook-ceph-osd-1 mon-data-edit

   ::

    $ kubectl delete deployments.apps -n kube-system rook-ceph-mgr-a rook-ceph-osd-0 rook-ceph-osd-1 mon-data-edit
    deployment.apps "rook-ceph-mgr-a" deleted
    deployment.apps "rook-ceph-osd-0" deleted
    deployment.apps "rook-ceph-osd-1" deleted
    deployment.apps "mon-data-edit" deleted

#. Delete configmap rook-ceph-mon-endpoints and rook-ceph-csi-config

   ::

    $ kubectl delete configmap -n kube-system rook-ceph-mon-endpoints  rook-ceph-csi-config
    configmap "rook-ceph-mon-endpoints" deleted
    configmap "rook-ceph-csi-config" deleted

#. Delete pod rook-ceph-operator and rook-ceph-tools

   ::

    $ kubectl delete po rook-ceph-operator-79fb8559-grgz8 -n kube-system
    pod "rook-ceph-operator-79fb8559-grgz8" deleted
    $ kubectl delete po rook-ceph-tools-5778d7f6c-cj947 -n kube-system
    pod "rook-ceph-tools-5778d7f6c-cj947" deleted


#. Wait for Ceph cluster launch.

   ::

    $ kubectl get pods -n kube-system
    NAME                                                     READY   STATUS      RESTARTS   AGE
    calico-kube-controllers-5cd4695574-q8dkc                 1/1     Running     0          14h
    calico-node-jwth4                                        1/1     Running     8          21h
    calico-node-pk4pp                                        1/1     Running     6          20h
    coredns-78d9fd7cb9-78kw7                                 1/1     Running     0          15h
    coredns-78d9fd7cb9-lsd2s                                 1/1     Running     0          14h
    csi-cephfsplugin-provisioner-55995dd4f6-6ts8x            5/5     Running     0          4h33m
    csi-cephfsplugin-provisioner-55995dd4f6-tn4cb            5/5     Running     0          4h33m
    csi-cephfsplugin-wx5fn                                   3/3     Running     0          4h33m
    csi-cephfsplugin-z8l22                                   3/3     Running     0          4h33m
    csi-rbdplugin-9m7dq                                      3/3     Running     0          4h33m
    csi-rbdplugin-hn6kx                                      3/3     Running     0          4h33m
    csi-rbdplugin-provisioner-57974d4b9c-k47nc               6/6     Running     0          4h33m
    csi-rbdplugin-provisioner-57974d4b9c-pvrxq               6/6     Running     0          4h33m
    ic-nginx-ingress-controller-7k6lq                        1/1     Running     0          14h
    ic-nginx-ingress-controller-cjdmw                        1/1     Running     0          14h
    ic-nginx-ingress-default-backend-5ffcfd7744-76dv2        1/1     Running     0          14h
    kube-apiserver-controller-0                              1/1     Running     10         21h
    kube-apiserver-controller-1                              1/1     Running     5          20h
    kube-controller-manager-controller-0                     1/1     Running     7          21h
    kube-controller-manager-controller-1                     1/1     Running     5          20h
    kube-multus-ds-amd64-6jcpj                               1/1     Running     0          14h
    kube-multus-ds-amd64-g5twh                               1/1     Running     0          14h
    kube-proxy-hrxpk                                         1/1     Running     3          21h
    kube-proxy-m8fs9                                         1/1     Running     3          20h
    kube-scheduler-controller-0                              1/1     Running     7          21h
    kube-scheduler-controller-1                              1/1     Running     5          20h
    kube-sriov-cni-ds-amd64-bdwfr                            1/1     Running     0          14h
    kube-sriov-cni-ds-amd64-r2rsf                            1/1     Running     0          14h
    rook-ceph-crashcollector-controller-0-57c5fdc6d6-72ftn   1/1     Running     0          173m
    rook-ceph-crashcollector-controller-1-67877489b7-4hvvq   1/1     Running     0          173m
    rook-ceph-mgr-a-8d656f86c-n67vg                          1/1     Running     0          179m
    rook-ceph-mon-a-85f9db5c6-mz4br                          1/1     Running     0          3h
    rook-ceph-operator-79fb8559-grgz8                        1/1     Running     0          3h1m
    rook-ceph-osd-0-64b9b74788-ws89m                         1/1     Running     0          173m
    rook-ceph-osd-1-5b789485c6-qt8xr                         1/1     Running     0          173m
    rook-ceph-osd-prepare-controller-0-7nhbj                 0/1     Completed   0          167m
    rook-ceph-osd-prepare-controller-1-qjmvj                 0/1     Completed   0          167m
    rook-ceph-tools-5778d7f6c-cj947                          1/1     Running     0          169m
    rook-discover-c8kbn                                      1/1     Running     0          4h33m
    rook-discover-rk2rp                                      1/1     Running     0          4h33m
    storage-init-rook-ceph-provisioner-n6zgj                 0/1     Completed   0          4h15m

#. Assign ``ceph-mon-placement`` and ``ceph-mgr-placement`` labels.

   ::

    system host-label-assign controller-1 ceph-mon-placement=enabled
    +-------------+--------------------------------------+
    | Property    | Value                                |
    +-------------+--------------------------------------+
    | uuid        | df9aff88-8863-49ca-aea8-85f8a0e1dc71 |
    | host_uuid   | 8cdb45bc-1fd7-4811-9459-bfd9301e93cf |
    | label_key   | ceph-mon-placement                   |
    | label_value | enabled                              |
    +-------------+--------------------------------------+

    [sysadmin@controller-0 ~(keystone_admin)]$ system host-label-assign controller-1 ceph-mgr-placement=enabled
    +-------------+--------------------------------------+
    | Property    | Value                                |
    +-------------+--------------------------------------+
    | uuid        | badde75f-4d4f-4c42-8cb8-7e9c69729935 |
    | host_uuid   | 8cdb45bc-1fd7-4811-9459-bfd9301e93cf |
    | label_key   | ceph-mgr-placement                   |
    | label_value | enabled                              |
    +-------------+--------------------------------------+

#. Edit CephCluster and change mon number to 3 and allowMultiplePerNode to true.

   ::

    mgr: {}
    mon:
      count: 3
      allowMultiplePerNode: true

#. Wait for two other monitor pods to launch.

   ::

    $ kubectl get pods -n kube-system
    NAME                                                     READY   STATUS      RESTARTS   AGE
    calico-kube-controllers-5cd4695574-q8dkc                 1/1     Running     0          14h
    calico-node-jwth4                                        1/1     Running     8          21h
    calico-node-pk4pp                                        1/1     Running     6          20h
    coredns-78d9fd7cb9-78kw7                                 1/1     Running     0          15h
    coredns-78d9fd7cb9-lsd2s                                 1/1     Running     0          14h
    csi-cephfsplugin-provisioner-55995dd4f6-6ts8x            5/5     Running     0          4h33m
    csi-cephfsplugin-provisioner-55995dd4f6-tn4cb            5/5     Running     0          4h33m
    csi-cephfsplugin-wx5fn                                   3/3     Running     0          4h33m
    csi-cephfsplugin-z8l22                                   3/3     Running     0          4h33m
    csi-rbdplugin-9m7dq                                      3/3     Running     0          4h33m
    csi-rbdplugin-hn6kx                                      3/3     Running     0          4h33m
    csi-rbdplugin-provisioner-57974d4b9c-k47nc               6/6     Running     0          4h33m
    csi-rbdplugin-provisioner-57974d4b9c-pvrxq               6/6     Running     0          4h33m
    ic-nginx-ingress-controller-7k6lq                        1/1     Running     0          14h
    ic-nginx-ingress-controller-cjdmw                        1/1     Running     0          14h
    ic-nginx-ingress-default-backend-5ffcfd7744-76dv2        1/1     Running     0          14h
    kube-apiserver-controller-0                              1/1     Running     10         21h
    kube-apiserver-controller-1                              1/1     Running     5          20h
    kube-controller-manager-controller-0                     1/1     Running     7          21h
    kube-controller-manager-controller-1                     1/1     Running     5          20h
    kube-multus-ds-amd64-6jcpj                               1/1     Running     0          14h
    kube-multus-ds-amd64-g5twh                               1/1     Running     0          14h
    kube-proxy-hrxpk                                         1/1     Running     3          21h
    kube-proxy-m8fs9                                         1/1     Running     3          20h
    kube-scheduler-controller-0                              1/1     Running     7          21h
    kube-scheduler-controller-1                              1/1     Running     5          20h
    kube-sriov-cni-ds-amd64-bdwfr                            1/1     Running     0          14h
    kube-sriov-cni-ds-amd64-r2rsf                            1/1     Running     0          14h
    rook-ceph-crashcollector-controller-0-57c5fdc6d6-72ftn   1/1     Running     0          173m
    rook-ceph-crashcollector-controller-1-67877489b7-4hvvq   1/1     Running     0          173m
    rook-ceph-mgr-a-8d656f86c-n67vg                          1/1     Running     0          179m
    rook-ceph-mon-a-85f9db5c6-mz4br                          1/1     Running     0          3h
    rook-ceph-mon-b-55f4bb467d-jm25b                         1/1     Running     0          169m
    rook-ceph-mon-c-84c75b988-jjq68                          1/1     Running     0          168m
    rook-ceph-operator-79fb8559-grgz8                        1/1     Running     0          3h1m
    rook-ceph-osd-0-64b9b74788-ws89m                         1/1     Running     0          173m
    rook-ceph-osd-1-5b789485c6-qt8xr                         1/1     Running     0          173m
    rook-ceph-osd-prepare-controller-0-7nhbj                 0/1     Completed   0          167m
    rook-ceph-osd-prepare-controller-1-qjmvj                 0/1     Completed   0          167m
    rook-ceph-tools-5778d7f6c-cj947                          1/1     Running     0          169m
    rook-discover-c8kbn                                      1/1     Running     0          4h33m
    rook-discover-rk2rp                                      1/1     Running     0          4h33m
    storage-init-rook-ceph-provisioner-n6zgj                 0/1     Completed   0          4h15m

#. Check the cluster status in the pod rook-tool.

   ::

    kubectl exec -it rook-ceph-tools-5778d7f6c-cj947 -- bash  -n kube-system
    bash: warning: setlocale: LC_CTYPE: cannot change locale (en_US.UTF-8): No such file or directory
    bash: warning: setlocale: LC_COLLATE: cannot change locale (en_US.UTF-8): No such file or directory
    bash: warning: setlocale: LC_MESSAGES: cannot change locale (en_US.UTF-8): No such file or directory
    bash: warning: setlocale: LC_NUMERIC: cannot change locale (en_US.UTF-8): No such file or directory
    bash: warning: setlocale: LC_TIME: cannot change locale (en_US.UTF-8): No such file or directory
    [root@compute-1 /]# ceph -s
      cluster:
        id:     6c9e9e4b-599e-4a4f-931e-2c09bec74a2a
        health: HEALTH_OK

      services:
        mon: 3 daemons, quorum a,b,c
        mgr: a(active)
        osd: 2 osds: 2 up, 2 in

      data:
        pools:   1 pools, 64 pgs
        objects: 0  objects, 0 B
        usage:   4.4 GiB used, 391 GiB / 396 GiB avail
        pgs:     64 active+clean

-----------------------------
Migrate openstack application
-----------------------------

Login to pod rook-ceph-tools, get generated key for client.admin and ceph.conf in container.

::

  [sysadmin@controller-0 script(keystone_admin)]$ kubectl exec -it rook-ceph-tools-84c7fff88c-kgwbn bash -n kube-system
  kubectl exec [POD] [COMMAND] is DEPRECATED and will be removed in a future version. Use kubectl kubectl exec [POD] -- [COMMAND] instead.
  bash: warning: setlocale: LC_CTYPE: cannot change locale (en_US.UTF-8): No such file or directory
  bash: warning: setlocale: LC_COLLATE: cannot change locale (en_US.UTF-8): No such file or directory
  bash: warning: setlocale: LC_MESSAGES: cannot change locale (en_US.UTF-8): No such file or directory
  bash: warning: setlocale: LC_NUMERIC: cannot change locale (en_US.UTF-8): No such file or directory
  bash: warning: setlocale: LC_TIME: cannot change locale (en_US.UTF-8): No such file or directory
  [root@storage-1 /]# ceph -s
    cluster:
      id:     d4c0400e-06ed-4f97-ab8e-ed1bef427039
      health: HEALTH_OK

    services:
      mon: 3 daemons, quorum a,b,d
      mgr: a(active)
      osd: 4 osds: 4 up, 4 in

    data:
      pools:   5 pools, 600 pgs
      objects: 252  objects, 743 MiB
      usage:   5.8 GiB used, 390 GiB / 396 GiB avail
      pgs:     600 active+clean

  [root@storage-1 /]# cat /etc/ceph/ceph.conf
  [global]
  mon_host = 10.109.143.37:6789,10.100.141.25:6789,10.106.83.145:6789

  [client.admin]
  keyring = /etc/ceph/keyring
  [root@storage-1 /]# cat /etc/ceph/keyring
  [client.admin]
  key = AQDabgVf7CFhFxAAqY1L4X9XnUONzMWWJnxBFA==
  [root@storage-1 /]# exit

On host controller-0 and controller-1 replace /etc/ceph/ceph.conf and /etc/ceph/keyring
with content got from pod rook-ceph-tools.

Update configmap ceph-etc, with data field, with new mon ip

::

  data:
    ceph.conf: |
      [global]
      mon_host = 10.109.143.37:6789,10.100.141.25:6789,10.106.83.145:6789

Calculate the base64 of key and write to secret ceph-admin.

::

  [sysadmin@controller-0 script(keystone_admin)]$ echo "AQDabgVf7CFhFxAAqY1L4X9XnUONzMWWJnxBFA==" | base64
  QVFEYWJnVmY3Q0ZoRnhBQXFZMUw0WDlYblVPTnpNV1dKbnhCRkE9PQo=

  [sysadmin@controller-0 script(keystone_admin)]$ kubectl edit secret ceph-admin -n kube-system
  secret/ceph-admin edited

  apiVersion: v1
  data:
    key: QVFEYWJnVmY3Q0ZoRnhBQXFZMUw0WDlYblVPTnpNV1dKbnhCRkE9PQo=
  kind: Secret

Create crush rule "kube-rbd" in pod rook-ceph-tools.

::

  [sysadmin@controller-0 script(keystone_admin)]$ kubectl exec -it rook-ceph-tools-84c7fff88c-kgwbn bash -n kube-system
  kubectl exec [POD] [COMMAND] is DEPRECATED and will be removed in a future version. Use kubectl kubectl exec [POD] -- [COMMAND] instead.
  bash: warning: setlocale: LC_CTYPE: cannot change locale (en_US.UTF-8): No such file or directory
  bash: warning: setlocale: LC_COLLATE: cannot change locale (en_US.UTF-8): No such file or directory
  bash: warning: setlocale: LC_MESSAGES: cannot change locale (en_US.UTF-8): No such file or directory
  bash: warning: setlocale: LC_NUMERIC: cannot change locale (en_US.UTF-8): No such file or directory
  bash: warning: setlocale: LC_TIME: cannot change locale (en_US.UTF-8): No such file or directory
  [root@storage-1 /]#
  [root@storage-1 /]#
  [root@storage-1 /]# ceph osd crush rule create-replicated kube-rbd storage-tier host

Update every mariadb and rabbitmq pv and pvc provisioner from ceph.com/rbd
to kube-system.rbd.csi.ceph.com in annotation.

::

  [sysadmin@controller-0 script(keystone_admin)]$ kubectl get pv
  NAME                                       CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                                                       STORAGECLASS   REASON   AGE
  pvc-0a5a97ba-b78c-4909-89c5-f3703e3a7b39   1Gi        RWO            Delete           Bound    openstack/rabbitmq-data-osh-openstack-rabbitmq-rabbitmq-1   general                 144m
  pvc-65adf629-a07f-46ab-a891-5e35a12413b8   5Gi        RWO            Delete           Bound    openstack/mysql-data-mariadb-server-1                       general                 147m
  pvc-7bec7ab2-793f-405b-96f9-a3d2b855de17   5Gi        RWO            Delete           Bound    openstack/mysql-data-mariadb-server-0                       general                 147m
  pvc-7c96fb7a-65dc-483f-94bc-aadefc685580   1Gi        RWO            Delete           Bound    openstack/rabbitmq-data-osh-openstack-rabbitmq-rabbitmq-0   general                 144m
  [sysadmin@controller-0 script(keystone_admin)]$ kubectl edit pv pvc-65adf629-a07f-46ab-a891-5e35a12413b8
  persistentvolume/pvc-65adf629-a07f-46ab-a891-5e35a12413b8 edited

  [sysadmin@controller-0 script(keystone_admin)]$ kubectl edit pv pvc-0a5a97ba-b78c-4909-89c5-f3703e3a7b39
  persistentvolume/pvc-0a5a97ba-b78c-4909-89c5-f3703e3a7b39 edited

  [sysadmin@controller-0 script(keystone_admin)]$ kubectl edit pv pvc-7bec7ab2-793f-405b-96f9-a3d2b855de17
  persistentvolume/pvc-7bec7ab2-793f-405b-96f9-a3d2b855de17 edited

  [sysadmin@controller-0 script(keystone_admin)]$ kubectl edit pv pvc-7c96fb7a-65dc-483f-94bc-aadefc685580
  persistentvolume/pvc-7c96fb7a-65dc-483f-94bc-aadefc685580 edited

  apiVersion: v1
  kind: PersistentVolume
  metadata:
    annotations:
      pv.kubernetes.io/provisioned-by: kube-system.rbd.csi.ceph.com
      rbdProvisionerIdentity: kube-system.rbd.csi.ceph.com

  [sysadmin@controller-0 script(keystone_admin)]$ kubectl get pvc -n openstack
  NAME                                              STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   AGE
  mysql-data-mariadb-server-0                       Bound    pvc-7bec7ab2-793f-405b-96f9-a3d2b855de17   5Gi        RWO            general        153m
  mysql-data-mariadb-server-1                       Bound    pvc-65adf629-a07f-46ab-a891-5e35a12413b8   5Gi        RWO            general        153m
  rabbitmq-data-osh-openstack-rabbitmq-rabbitmq-0   Bound    pvc-7c96fb7a-65dc-483f-94bc-aadefc685580   1Gi        RWO            general        150m
  rabbitmq-data-osh-openstack-rabbitmq-rabbitmq-1   Bound    pvc-0a5a97ba-b78c-4909-89c5-f3703e3a7b39   1Gi        RWO            general        150m

  [sysadmin@controller-0 script(keystone_admin)]$ kubectl edit pvc -n openstack mysql-data-mariadb-server-0
  persistentvolumeclaim/mysql-data-mariadb-server-0 edited

  [sysadmin@controller-0 script(keystone_admin)]$ kubectl edit pvc -n openstack mysql-data-mariadb-server-1
  persistentvolumeclaim/mysql-data-mariadb-server-1 edited

  [sysadmin@controller-0 script(keystone_admin)]$ kubectl edit pvc -n openstack rabbitmq-data-osh-openstack-rabbitmq-rabbitmq-0
  persistentvolumeclaim/rabbitmq-data-osh-openstack-rabbitmq-rabbitmq-0 edited

  [sysadmin@controller-0 script(keystone_admin)]$ kubectl edit pvc -n openstack rabbitmq-data-osh-openstack-rabbitmq-rabbitmq-1
  persistentvolumeclaim/rabbitmq-data-osh-openstack-rabbitmq-rabbitmq-1 edited

  apiVersion: v1
  kind: PersistentVolumeClaim
  metadata:
    annotations:
      pv.kubernetes.io/bind-completed: "yes"
      pv.kubernetes.io/bound-by-controller: "yes"
      volume.beta.kubernetes.io/storage-provisioner: kube-system.rbd.csi.ceph.com

Edit these PersistentVolume one by one for mariadb and rabbitmq

::

  $ kubectl get pv
  NAME                                       CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                                                       STORAGECLASS   REASON   AGE
  pvc-36fd174d-a058-45b6-99ba-a9e362cb72f1   1Gi        RWO            Delete           Bound    openstack/rabbitmq-data-osh-openstack-rabbitmq-rabbitmq-0   general                 43h
  pvc-933a4e66-3687-472f-be11-71befc7780e1   5Gi        RWO            Delete           Bound    openstack/mysql-data-mariadb-server-1                       general                 55m
  pvc-b2ba8ad2-fa26-475c-9287-14b1f0525ee5   1Gi        RWO            Delete           Bound    openstack/rabbitmq-data-osh-openstack-rabbitmq-rabbitmq-1   general                 43h
  pvc-f1ac8d8f-c718-4793-9165-8cbc01f0109c   5Gi        RWO            Delete           Bound    openstack/mysql-data-mariadb-server-0                       general                 176m

  $ kubectl get pv pvc-36fd174d-a058-45b6-99ba-a9e362cb72f1 -o yaml > rabbitmq0.yaml

Edit yaml to update monitor ip

::

  persistentVolumeReclaimPolicy: Delete
  rbd:
    image: kubernetes-dynamic-pvc-be1c74e7-ff0e-11ea-b88c-d24b7b64770e
    keyring: /etc/ceph/keyring
    monitors:
    - 10.98.241.108:6789
    - 10.99.168.50:6789
    - 10.96.65.38:6789
    pool: kube-rbd

  $ kubectl replace --cascade=false --force -f rabbitmq0.yaml &
  [1] 2500885
  $ persistentvolume "pvc-36fd174d-a058-45b6-99ba-a9e362cb72f1" deleted

Delete field "finalizers" in the persistentvolume

::

  $ kubectl patch  pv  pvc-b2ba8ad2-fa26-475c-9287-14b1f0525ee5  --type merge -p '{"metadata":{"finalizers": [null]}}'

You also can use "kubectl edit pv <pv id>" , to delete these two lines

::

  finalizers:
  - kubernetes.io/pv-protection

Delete pod mariadb-server-0 mariadb-server-1 osh-openstack-rabbitmq-rabbitmq-0 osh-openstack-rabbitmq-rabbitmq-1

::

  $ kubectl delete po mariadb-server-0 mariadb-server-1 osh-openstack-rabbitmq-rabbitmq-0 osh-openstack-rabbitmq-rabbitmq-1 -n openstack
  pod "mariadb-server-0" deleted
  pod "mariadb-server-1" deleted
  pod "osh-openstack-rabbitmq-rabbitmq-0" deleted
  pod "osh-openstack-rabbitmq-rabbitmq-1" deleted

Update override for cinder helm chart.

.. parsed-literal::

     $ system helm-override-update |prefix|-openstack cinder openstack --reuse-value --values cinder_override.yaml

     $ controller-0:~$ cat cinder_override.yaml
     conf:
       backends:
         ceph-store:
           image_volume_cache_enabled: "True"
           rbd_ceph_conf: /etc/ceph/ceph.conf
           rbd_pool: cinder-volumes
           rbd_user: cinder
           volume_backend_name: ceph-store
           volume_driver: cinder.volume.drivers.rbd.RBDDriver
         rbd1:
           volume_driver: ""

Apply application |prefix|-openstack again.

.. parsed-literal::

     [sysadmin@controller-0 script(keystone_admin)]$ system application-apply |prefix|-openstack
     +---------------+----------------------------------+
     | Property      | Value                            |
     +---------------+----------------------------------+
     | active        | True                             |
     | app_version   | 1.0-45                           |
     | created_at    | 2022-10-27T17:11:04.620160+00:00 |
     | manifest_file | |prefix|-openstack.yaml |s|              |
     | manifest_name | stx-openstack-fluxcd-manifests   |
     | name          | |prefix|-openstack     |s|               |
     | progress      | None                             |
     | status        | applying                         |
     | updated_at    | 2020-07-08T06:27:08.836258+00:00 |
     +---------------+----------------------------------+
     Please use 'system application-list' or 'system application-show |prefix|-openstack' to view the current progress.
     [sysadmin@controller-0 script(keystone_admin)]$

Check application apply successfully and all pods work well without error.

Reboot both of the controllers and wait for the host to be available.
