.. _storage-kubernetes-index:

.. include:: /_includes/toc-title-storage-kub.rest

.. only:: partner

   .. include:: /storage/index.rst
      :start-after: kub-begin
      :end-before: kub-end

--------
Overview
--------

.. toctree::
   :maxdepth: 1

   storage-configuration-storage-resources
   disk-naming-conventions

---------------------------------------------
Disks, Partitions, Volumes, and Volume Groups
---------------------------------------------

*************************
Work with Disk Partitions
*************************

.. toctree::
   :maxdepth: 1

   work-with-disk-partitions
   identify-space-available-for-partitions
   list-partitions
   view-details-for-a-partition
   add-a-partition
   increase-the-size-of-a-partition
   delete-a-partition

*****************************
Work with Local Volume Groups
*****************************

.. toctree::
   :maxdepth: 1

   work-with-local-volume-groups
   local-volume-groups-cli-commands
   increase-the-size-for-lvm-local-volumes-on-controller-filesystems

**************************
Work with Physical Volumes
**************************

.. toctree::
   :maxdepth: 1

   work-with-physical-volumes
   add-a-physical-volume
   list-physical-volumes
   view-details-for-a-physical-volume
   delete-a-physical-volume

----------------
Storage Backends
----------------

.. toctree::
   :maxdepth: 1

   storage-backends
   configure-the-internal-ceph-storage-backend
   configure-an-external-netapp-deployment-as-the-storage-backend
   uninstall-the-netapp-backend

----------------
Controller Hosts
----------------

.. toctree::
   :maxdepth: 1

   controller-hosts-storage-on-controller-hosts
   ceph-cluster-on-a-controller-host
   increase-controller-filesystem-storage-allotments-using-horizon
   increase-controller-filesystem-storage-allotments-using-the-cli

------------
Worker Hosts
------------

.. toctree::
   :maxdepth: 1

   storage-configuration-storage-on-worker-hosts

-------------
Storage Hosts
-------------

.. toctree::
   :maxdepth: 1

   storage-hosts-storage-on-storage-hosts
   replication-groups

.. _configure-ceph-osds-on-a-host:

-----------------------------
Configure Ceph OSDs on a Host
-----------------------------

.. toctree::
   :maxdepth: 1

   ceph-storage-pools
   osd-replication-factors-journal-functions-and-storage-tiers
   storage-functions-osds-and-ssd-backed-journals
   add-ssd-backed-journals-using-horizon
   add-ssd-backed-journals-using-the-cli
   add-a-storage-tier-using-the-cli
   replace-osds-and-journal-disks
   provision-storage-on-a-controller-or-storage-host-using-horizon
   provision-storage-on-a-storage-host-using-the-cli

-------------------------
Persistent Volume Support
-------------------------

.. toctree::
   :maxdepth: 1

   about-persistent-volume-support

***************
RBD Provisioner
***************

.. toctree::
   :maxdepth: 1

   default-behavior-of-the-rbd-provisioner
   storage-configuration-create-readwriteonce-persistent-volume-claims
   storage-configuration-mount-readwriteonce-persistent-volumes-in-containers
   enable-readwriteonce-pvc-support-in-additional-namespaces
   enable-rbd-readwriteonly-additional-storage-classes
   install-additional-rbd-provisioners

****************************
Ceph File System Provisioner
****************************

.. toctree::
   :maxdepth: 1

   default-behavior-of-the-cephfs-provisioner
   create-readwritemany-persistent-volume-claims
   mount-readwritemany-persistent-volumes-in-containers
   enable-readwritemany-pvc-support-in-additional-namespaces

----------------------------
Storage-Related CLI Commands
----------------------------

.. toctree::
   :maxdepth: 1

   storage-configuration-storage-related-cli-commands

---------------------
Storage Usage Details
---------------------

.. toctree::
   :maxdepth: 1

   storage-usage-details-storage-utilization-display
   view-storage-utilization-using-horizon
