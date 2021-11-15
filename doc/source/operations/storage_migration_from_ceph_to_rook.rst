=================
Storage Migration
=================

From R5 release, StarlingX provides two storage solution, host-based ceph and
rook-ceph. The second storage solution is containerized ceph solution. For an
already deployed starlingx system with host-based ceph, after an upgrade to a
starlingx release supporting rook-ceph, one could migrate from host-based ceph
storage to rook-ceph storage to container-based ceph storage.

The migration procedure maintains CEPH OSDs and data on OSDs.  Although the
procedure does result in hosted applications experiencing several minutes of
service outage due to temporary loss of access to PVCs or virtual disks, due
to the temporary loss of the ceph service.

The step-by-step migration guides for the different configuration options are
listed at the end of this page. The following provides an overall summary of
the migration procedures.

#.  Enable authentication for all ceph daemons

    Rook-ceph must deploy with authentication, so before migration, config all
    ceph daemons with cephx.

#.  Create secret and configmap for rook deployment

    For migration, create configmap "rook-ceph-mon-endpoints" and secret
    "rook-ceph-mon" to save client.admin keyring and fsid.

#.  Remove application platform-integ-apps

#.  Disable HA for ceph daemon

    Disable pmon and service manager's monitoring for ceph daemons.

#.  Create configmap to save OSD disk mount path

    Because original ceph osd(s) are deployed with filestore, must create configmap
    to save osd disk info. Rook will lookup configmap "rook-ceph-osd-<hostname>-config"
    to get every host's osd info. In this configmap 'osd-dirs: '{"<path>":<osd-id>}''
    means, osd with this id, mount to this folder <path>/osd<id>.

#.  Exit all ceph daemon

#.  Assign label for rook-ceph

    Assign label "ceph-mon-placement=enabled" and "ceph-mgr-placement=enabled"
    to controller-0.

#.  Copy mon data to /var/lib/ceph/mon-a/data folder on controller-0

    Rook-ceph will launch mon pod on host with label
    "ceph-mon-placement=enabled". And the mon pod will use folder
    /var/lib/ceph/mon-<id>/data, so use ceph-monstore-tool copy mon-data to
    this folder. As rook launch mon with id a,b,c..., the first mon pod must
    use folder /var/lib/ceph/mon-a/data.

#.  Edit monmap

    Get monmap for /var/lib/ceph/mon-a/data, edit to update mon item with
    mon.a and controller-0 ip, and inject to mon-a data folder.

#.  Apply application rook-ceph-apps

    Rook-ceph will register CRD CephCluster and launch a containerized ceph
    cluster. By read above setting, this containerized ceph cluster will use
    original mon data and OSD data.

#.  Launch more mon pods

    After containerized ceph cluster launch, for duplex and multi, assign label
    to other 2 hosts, and change mon count to 3, with "kubectl edit CephCluster".

#.  Edit pv and pvc provisioner

    For already created pv and pvc in openstack, if |prefix|-openstack
    application is applied before migration, change the provsioner to
    kube-system.rbd.csi.ceph.com from rbd/ceph.com, as csi pod will provide csi
    service to K8s.

#.  Update keyring and conf file on controller-0, controler-1

    For k8s pv, it will use host /etc/ceph/keyring for ceph cluster access,
    update folder /etc/ceph/ with containerized ceph cluster.

#.  Update helm override value for application |prefix|-openstack

    Update helm override value for cinder, to change provisoner from
    rbd/ceph.com to kube-system.rbd.csi.ceph.com.

#.  Edit secret ceph-admin to update keyring

    Update keyring in ceph-admin

#.  Re-apply application |prefix|-openstack

------------------
Guide Step by Step
------------------

.. toctree::
   :maxdepth: 1

   ceph_cluster_aio_duplex_migration
   ceph_cluster_aio_simplex_migration
   ceph_cluster_migration
