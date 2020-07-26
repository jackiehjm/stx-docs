======================
Ceph Cluster Migration
======================

This guide contains step by step instructions for manually migrating a StarlingX
deployment with a standard dedicated storage Ceph Cluster to a containerized Ceph
cluster deployed by Rook.

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

This guide describes a method to migrate the Ceph cluster deployed with StarlingX
early releses to the newly containerized Ceph clusters using an upcoming StarlingX
release, while maintaining user data in :abbr:`OSDs (Object Store Devices)`.

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

Disable monitoring and recovering for Ceph service by pmon and service manager.

#. Disable pmon monitoring for Ceph mon and Ceph osd on every host.

   ::

    sudo rm -f /etc/pmon.d/ceph.conf
    sudo /usr/local/sbin/pmon-restart pmon_cmd_port

#. Disable service manager's monitoring of Ceph manager on controller host.

   ::

    sudo sm-unmanage service  mgr-restful-plugin
    Service (mgr-restful-plugin) is no longer being managed.
    sudo sm-unmanage service  ceph-manager
    Service (ceph-manager) is no longer being managed.
    sudo sm-deprovision  service-group-member storage-monitoring-services ceph-manager
    sudo sm-deprovision  service-group-member storage-services mgr-restful-plugin

**********************************
Enable Ceph service authentication
**********************************

StarlingX disables Ceph authentication, but authentication is required for Rook.
Before migration, enable authentication for each daemon.

#. Enable authentication for Ceph mon and osd service.

   ::

    ceph config set mon.storage-0 auth_cluster_required cephx
    ceph config set mon.storage-0 auth_supported cephx
    ceph config set mon.storage-0 auth_service_required cephx
    ceph config set mon.storage-0 auth_client_required cephx
    ceph config set mon.controller-0 auth_cluster_required cephx
    ceph config set mon.controller-0 auth_supported cephx
    ceph config set mon.controller-0 auth_service_required cephx
    ceph config set mon.controller-0 auth_client_required cephx
    ceph config set mon.controller-1 auth_cluster_required cephx
    ceph config set mon.controller-1 auth_supported cephx
    ceph config set mon.controller-1 auth_service_required cephx
    ceph config set mon.controller-1 auth_client_required cephx
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

************************************************************************
Disable ceph osd on all storage hosts and create configmap for migration
************************************************************************

#. Login to controller host and run ``ceph-preshutdown.sh`` firstly.

  ::

   sudo ceph-preshutdown.sh

#. Login to the storage host with provisioned OSD, disable the Ceph osd service,
and create a journal file.

#. Disable the Ceph osd service.

   ::

    sudo service ceph -a stop osd.1
    === osd.1 ===
    Stopping Ceph osd.1 on storage-0...kill  213077...
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

    system host-stor-list storage-0
    +--------------------------------------+----------+-------+------------+--------------------------------------+-----------------------------+------------+--------------+-----------+
    | uuid                                 | function | osdid | state      | idisk_uuid                           | journal_path                | journal_no | journal_size | tier_name |
    |                                      |          |       |            |                                      |                             | de         | _gib         |           |
    +--------------------------------------+----------+-------+------------+--------------------------------------+-----------------------------+------------+--------------+-----------+
    | 21a90d60-2f1e-4f46-badc-afa7d9117622 | osd      | 1     | configured | a13c6ac9-9d59-4063-88dc-2847e8aded85 | /dev/disk/by-path/pci-0000: | /dev/sdc2  | 1            | storage   |
    |                                      |          |       |            |                                      | 00:03.0-ata-3.0-part2       |            |              |           |
    |                                      |          |       |            |                                      |                             |            |              |           |
    | d259a366-3633-4c03-9268-0cd35b2b274d | osd      | 0     | configured | 54b3cb9d-4527-448a-9051-62b250c2a03f | /dev/disk/by-path/pci-0000: | /dev/sdb2  | 1            | storage   |
    |                                      |          |       |            |                                      | 00:03.0-ata-2.0-part2       |            |              |           |
    |                                      |          |       |            |                                      |                             |            |              |           |
    +--------------------------------------+----------+-------+------------+--------------------------------------+-----------------------------+------------+--------------+-----------+

    system host-stor-list storage-1
    +--------------------------------------+----------+-------+------------+--------------------------------------+-----------------------------+------------+--------------+-----------+
    | uuid                                 | function | osdid | state      | idisk_uuid                           | journal_path                | journal_no | journal_size | tier_name |
    |                                      |          |       |            |                                      |                             | de         | _gib         |           |
    +--------------------------------------+----------+-------+------------+--------------------------------------+-----------------------------+------------+--------------+-----------+
    | 17f2db8e-c80e-4df7-9525-1f0cb5b54cd3 | osd      | 3     | configured | 89637c7d-f959-4c54-bfe1-626b5c630d96 | /dev/disk/by-path/pci-0000: | /dev/sdc2  | 1            | storage   |
    |                                      |          |       |            |                                      | 00:03.0-ata-3.0-part2       |            |              |           |
    |                                      |          |       |            |                                      |                             |            |              |           |
    | 64b9d56c-c384-4bd6-a437-89d6bfda4ec5 | osd      | 2     | configured | ad52345c-254c-48c1-9034-778738c7e23b | /dev/disk/by-path/pci-0000: | /dev/sdb2  | 1            | storage   |
    |                                      |          |       |            |                                      | 00:03.0-ata-2.0-part2       |            |              |           |
    |                                      |          |       |            |                                      |                             |            |              |           |
    +--------------------------------------+----------+-------+------------+--------------------------------------+-----------------------------+------------+--------------+-----------+


#. Sample ``osd-configmap.yaml`` file.
   ::

    apiVersion: v1
    kind: ConfigMap
    metadata:
      name: rook-ceph-osd-storage-0-config
      namespace: kube-system
    data:
      osd-dirs: '{"/var/lib/ceph/ceph-0":0,"/var/lib/ceph/ceph-1":1}'
    ---
    apiVersion: v1
    kind: ConfigMap
    metadata:
      name: rook-ceph-osd-storage-1-config
      namespace: kube-system
    data:
      osd-dirs: '{"/var/lib/ceph/ceph-2":2,"/var/lib/ceph/ceph-3":3}'

#. Apply yaml file for configmap.

   ::

    kubectl apply -f osd-configmap.yaml
    configmap/rook-ceph-osd-storage-0-config created
    configmap/rook-ceph-osd-storage-1-config created

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

#. Login to host controller-0 and disable service monitor.controller-0.

   ::

    sudo service ceph -a stop mon.controller-0
    === mon.controller-0 ===
    Stopping Ceph mon.controller-0 on controller-0...kill  291101...done

#. Login to host controller-1 and disable service monitor.controller-1.

   ::

    sudo service ceph -a stop mon.controller-1
    === mon.controller-1 ===
    Stopping Ceph mon.controller-1 on controller-1...kill  385107...
    done

#. Login to host storage-0 and disable service monitor.storage-0.

   ::

    sudo service ceph -a stop mon.storage-0
    === mon.storage-0 ===
    Stopping Ceph mon.storage-0 on storage-0...kill  31394...
    done

#. Copy mon data to the ``/var/lib/ceph/mon-a/data`` folder.

   ::

    sudo mkdir -p /var/lib/ceph/mon-a/data/
    sudo ceph-monstore-tool /var/lib/ceph/mon/ceph-controller-0/ store-copy /var/lib/ceph/mon-a/data/

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
    0: 192.188.204.3:6789/0 mon.controller-0
    1: 192.188.204.4:6789/0 mon.controller-1
    2: 192.188.204.41:6789/0 mon.storage-0

    sudo monmaptool --rm controller-0 monmap
    monmaptool: monmap file monmap
    monmaptool: removing controller-0
    monmaptool: writing epoch 2 to monmap (2 monitors)

    sudo monmaptool --rm controller-1 monmap
    monmaptool: monmap file monmap
    monmaptool: removing controller-1
    monmaptool: writing epoch 2 to monmap (1 monitors)

    sudo monmaptool --rm storage-0 monmap
    monmaptool: monmap file monmap
    monmaptool: removing storage-0
    monmaptool: writing epoch 2 to monmap (0 monitors)

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

----------------------
Deploy Rook helm chart
----------------------

StarlingX creates a application for Rook deployment. After finishing the
preparation steps above, run the application to deploy Rook. To complete live
migration and keep Ceph services ready, you should migrate Ceph services in the
following order:

*   Exit the first Ceph monitor, ``mon.a``, and launch the Rook cluster with one
    monitor pod. At this time, 2 monitor daemons and 1 monitor pod are running.
*   Migrate OSD pods one by one.
*   Finally, migrate 2 monitor daemons to complete the migration.

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

Also disable Ceph manager on host controller-1.

***************************
Apply rook-ceph application
***************************

Exit Ceph mon.a and Ceph manager, then deploy Rook.

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

   ::

    system  helm-override-update  rook-ceph-apps rook-ceph kube-system --set cluster.mon.count=1
    +----------------+----------------+
    | Property       | Value          |
    +----------------+----------------+
    | name           | rook-ceph      |
    | namespace      | kube-system    |
    | user_overrides | cluster:       |
    |                |   mon:         |
    |                |     count: "1" |
    |                |                |
    +----------------+----------------+

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

#. Edit CephCluster to add osd directories config and increase mon count to 3.

   ::

    storage:
      nodes:
      - config:
          storeType: filestore
        directories:
        - path: /var/lib/ceph/ceph-0
        - path: /var/lib/ceph/ceph-1
        name: storage-0
        resources: {}
      - config:
          storeType: filestore
        directories:
        - path: /var/lib/ceph/ceph-2
        - path: /var/lib/ceph/ceph-3
        name: storage-1
        resources: {}

#. Wait for Rook pods to launch.

   ::

    rook-ceph-mgr-a-d98dd9559-ltlr7                1/1     Running     0          3m13s
    rook-ceph-mon-a-659d8857cc-plbkt               1/1     Running     0          3m27s
    rook-ceph-operator-6fc8cfb68b-km445            1/1     Running     0          6m22s
    rook-ceph-osd-0-74f69cf96-h6qsj                1/1     Running     0          54s
    rook-ceph-osd-1-6777967c99-g48vz               1/1     Running     0          55s
    rook-ceph-osd-2-6b868774d6-vqf7f               1/1     Running     0          55s
    rook-ceph-osd-3-d648b6745-c5cnz                1/1     Running     0          55s
    rook-ceph-osd-prepare-storage-0-pgb6l          0/1     Completed   0          67s
    rook-ceph-osd-prepare-storage-1-fms4c          0/1     Completed   0          67s
    rook-ceph-tools-84c7fff88c-px74q               1/1     Running     0          5m34s
    rook-discover-cmfw7                            1/1     Running     0          5m37s
    rook-discover-hpz4q                            1/1     Running     0          5m37s
    rook-discover-n8j72                            1/1     Running     0          5m37s
    rook-discover-njxsd                            1/1     Running     0          5m37s
    rook-discover-wkhgq                            1/1     Running     0          5m37s
    rook-discover-xm54j                            1/1     Running     0          5m37s
    storage-init-rbd-provisioner-c9j5w             0/1     Completed   0          10h
    storage-init-rook-ceph-provisioner-zjzcq       1/1     Running     0          47s

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

    [sysadmin@controller-0 ~(keystone_admin)]$ system host-label-assign storage-0 ceph-mon-placement=enabled
    +-------------+--------------------------------------+
    | Property    | Value                                |
    +-------------+--------------------------------------+
    | uuid        | 44b47f2a-4a00-4800-ab60-9a14c4c2ba24 |
    | host_uuid   | 0eeb4f94-1eec-4493-83ae-f08f069e06ce |
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

#. Edit CephCluster and change mon number to 3.

   ::

    mgr: {}
    mon:
      count: 3

#. Wait for two other monitor pods to launch.

   ::

    rook-ceph-mgr-a-5b47f4f5cc-cskxc               1/1     Running     0          10m
    rook-ceph-mon-a-7fc5cfc949-q4hrb               1/1     Running     0          10m
    rook-ceph-mon-b-698bf594d7-82js8               1/1     Running     0          20s
    rook-ceph-operator-6fc8cfb68b-kfpz4            1/1     Running     2          15m
    rook-ceph-osd-0-796c4b8d86-6v9js               1/1     Running     0          2m33s
    rook-ceph-osd-1-5d5c445c69-hsmfv               1/1     Running     0          2m33s
    rook-ceph-osd-2-5595c46f48-txv9d               1/1     Running     0          2m20s
    rook-ceph-osd-3-7569d8b6b7-7x7pp               1/1     Running     0          2m20s
    rook-ceph-osd-prepare-storage-0-lb4rd          0/1     Completed   0          2m35s
    rook-ceph-osd-prepare-storage-1-d6rht          0/1     Completed   0          2m35s
    rook-ceph-tools-84c7fff88c-shf4m               1/1     Running     0          14m
    rook-discover-7rqfs                            1/1     Running     0          14m
    rook-discover-bp5rb                            1/1     Running     0          14m
    rook-discover-bz4pj                            1/1     Running     0          14m
    rook-discover-pd7tg                            1/1     Running     0          14m
    rook-discover-ppw8q                            1/1     Running     0          14m
    rook-discover-thpfh                            1/1     Running     0          14m
    storage-init-rbd-provisioner-fbnnh             0/1     Completed   0          143m
    storage-init-rook-ceph-provisioner-66jzn       0/1     Completed   0          2m24s

#. Check the cluster status in the pod rook-tool.

   ::

    kubectl exec -it rook-ceph-tools-84c7fff88c-shf4m bash  -n kube-system
    kubectl exec [POD] [COMMAND] is DEPRECATED and will be removed in a future version. Use kubectl kubectl exec [POD] -- [COMMAND] instead.
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
        osd: 4 osds: 4 up, 4 in

      data:
        pools:   1 pools, 64 pgs
        objects: 0  objects, 0 B
        usage:   4.4 GiB used, 391 GiB / 396 GiB avail
        pgs:     64 active+clean

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

Remove script ceph.sh on all hosts.

::

    sudo rm -rf /etc/services.d/controller/ceph.sh
    sudo rm -rf /etc/services.d/worker/ceph.sh
    sudo rm -rf /etc/services.d/storage/ceph.sh

Reboot controller-0 and controller-1. And after the controller reboot sucessfully,
lock and unlock storage-0 and storage-1, wait for node to be available.

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
  mon_host = 192.188.204.4:6789,192.188.204.3:6789,192.188.204.49:6789

  [client.admin]
  keyring = /etc/ceph/keyring
  [root@storage-1 /]# cat /etc/ceph/keyring
  [client.admin]
  key = AQDabgVf7CFhFxAAqY1L4X9XnUONzMWWJnxBFA==
  [root@storage-1 /]# exit

On host controller-0 and controller-1 replace /etc/ceph/ceph.conf and /etc/ceph/keyring
with content got from pod rook-ceph-tools.

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

Update override for cinder helm chart.

::

  $ system helm-override-update stx-openstack cinder openstack --reuse-value --values cinder_override.yaml

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

Apply application stx-openstack again

::

  [sysadmin@controller-0 script(keystone_admin)]$ system application-apply stx-openstack
  +---------------+----------------------------------+
  | Property      | Value                            |
  +---------------+----------------------------------+
  | active        | True                             |
  | app_version   | 1.0-45                           |
  | created_at    | 2020-07-08T05:47:24.019723+00:00 |
  | manifest_file | stx-openstack.yaml               |
  | manifest_name | armada-manifest                  |
  | name          | stx-openstack                    |
  | progress      | None                             |
  | status        | applying                         |
  | updated_at    | 2020-07-08T06:27:08.836258+00:00 |
  +---------------+----------------------------------+
  Please use 'system application-list' or 'system application-show stx-openstack' to view the current progress.
  [sysadmin@controller-0 script(keystone_admin)]$

Check application apply successfully and all pods work well without error.
