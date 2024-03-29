.. _index-storage-kub-e797132c87a8:

.. include:: /_includes/toc-title-storage-kub.rest

.. only:: partner

   .. include:: /storage/index-storage-6cd708f1ada9.rst
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
   upgrade-the-netapp-trident-software-c5ec64d213d3

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
   increase-worker-filesystem-storage-allotments-using-the-cli-da92e5d15a69

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
   provision-storage-on-a-controller-or-storage-host-using-horizon
   provision-storage-on-a-storage-host-using-the-cli
   optimization-with-a-large-number-of-osds-df2169096946
   replace-osds-and-journal-disks
   replace-osds-on-a-standard-system-f3b1e376304c
   replace-osds-on-an-aio-dx-system-319b0bc2f7e6
   replace-osds-on-an-aio-sx-multi-disk-system-b4ddd1c1257c
   replace-osds-on-an-aio-sx-single-disk-system-without-backup-951eefebd1f2
   replace-osds-on-an-aio-sx-single-disk-system-with-backup-770c9324f372

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
