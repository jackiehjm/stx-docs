=======
Storage
=======
----------
Kubernetes
----------

********
Overview
********

.. toctree::
   :maxdepth: 1
   
   kubernetes/storage-configuration-storage-resources
   kubernetes/disk-naming-conventions

*********************************************
Disks, Partitions, Volumes, and Volume Groups
*********************************************

.. toctree::
   :maxdepth: 1
   
   kubernetes/work-with-local-volume-groups
   kubernetes/local-volume-groups-cli-commands
   kubernetes/increase-the-size-for-lvm-local-volumes-on-controller-filesystems
   
Work with Disk Partitions
*************************

.. toctree::
   :maxdepth: 1
   
   kubernetes/work-with-disk-partitions
   kubernetes/identify-space-available-for-partitions
   kubernetes/list-partitions
   kubernetes/view-details-for-a-partition
   kubernetes/add-a-partition
   kubernetes/increase-the-size-of-a-partition
   kubernetes/delete-a-partition

Work with Physical Volumes
**************************

.. toctree::
   :maxdepth: 1
   
   kubernetes/work-with-physical-volumes
   kubernetes/add-a-physical-volume
   kubernetes/list-physical-volumes
   kubernetes/view-details-for-a-physical-volume
   kubernetes/delete-a-physical-volume
   
****************
Storage Backends
****************

.. toctree::
   :maxdepth: 1
   
   kubernetes/storage-backends
   kubernetes/configure-the-internal-ceph-storage-backend
   kubernetes/configure-an-external-netapp-deployment-as-the-storage-backend
   kubernetes/configure-netapps-using-a-private-docker-registry
   kubernetes/uninstall-the-netapp-backend
   
****************
Controller Hosts
****************

.. toctree::
   :maxdepth: 1
   
   kubernetes/controller-hosts-storage-on-controller-hosts
   kubernetes/ceph-cluster-on-a-controller-host
   kubernetes/increase-controller-filesystem-storage-allotments-using-horizon
   kubernetes/increase-controller-filesystem-storage-allotments-using-the-cli
   
************
Worker Hosts
************

.. toctree::
   :maxdepth: 1
   
   kubernetes/storage-configuration-storage-on-worker-hosts
   
*************
Storage Hosts
*************

.. toctree::
   :maxdepth: 1
   
   kubernetes/storage-hosts-storage-on-storage-hosts
   kubernetes/replication-groups
   
*****************************
Configure Ceph OSDs on a Host
*****************************

.. toctree::
   :maxdepth: 1
   
   kubernetes/ceph-storage-pools
   kubernetes/osd-replication-factors-journal-functions-and-storage-tiers
   kubernetes/storage-functions-osds-and-ssd-backed-journals
   kubernetes/add-ssd-backed-journals-using-horizon
   kubernetes/add-ssd-backed-journals-using-the-cli
   kubernetes/add-a-storage-tier-using-the-cli
   kubernetes/replace-osds-and-journal-disks
   kubernetes/provision-storage-on-a-controller-or-storage-host-using-horizon
   kubernetes/provision-storage-on-a-storage-host-using-the-cli

*************************
Persistent Volume Support
*************************

.. toctree::
   :maxdepth: 1
   
   kubernetes/about-persistent-volume-support
   kubernetes/default-behavior-of-the-rbd-provisioner
   kubernetes/storage-configuration-create-persistent-volume-claims
   kubernetes/storage-configuration-mount-persistent-volumes-in-containers
   kubernetes/enable-pvc-support-in-additional-namespaces
   kubernetes/enable-additional-storage-classes
   kubernetes/install-additional-rbd-provisioners

****************
Storage Profiles
****************

.. toctree::
   :maxdepth: 1
   
   kubernetes/storage-profiles

****************************
Storage-Related CLI Commands
****************************

.. toctree::
   :maxdepth: 1
   
   kubernetes/storage-configuration-storage-related-cli-commands
   
*********************
Storage Usage Details
*********************

.. toctree::
   :maxdepth: 1
   
   kubernetes/storage-usage-details-storage-utilization-display
   kubernetes/view-storage-utilization-using-horizon
   
---------
OpenStack
---------

Coming soon.