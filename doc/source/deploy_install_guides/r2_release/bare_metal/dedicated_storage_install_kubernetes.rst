==========================================================================
Install StarlingX Kubernetes on Bare Metal Standard with Dedicated Storage
==========================================================================

This section describes the steps to install the StarlingX Kubernetes platform
on a **StarlingX R2.0 bare metal Standard with Dedicated Storage** deployment
configuration.

.. contents::
   :local:
   :depth: 1

--------------------------------------------
Create a bootable USB with the StarlingX ISO
--------------------------------------------

Refer to :doc:`/deploy_install_guides/bootable_usb` for instructions on how to
create a bootable USB on your system.

--------------------------------
Install software on controller-0
--------------------------------

.. include:: controller_storage_install_kubernetes.rst
   :start-after: incl-install-software-controller-0-standard-start:
   :end-before: incl-install-software-controller-0-standard-end:

--------------------------------
Bootstrap system on controller-0
--------------------------------

.. include:: controller_storage_install_kubernetes.rst
   :start-after: incl-bootstrap-sys-controller-0-standard-start:
   :end-before: incl-bootstrap-sys-controller-0-standard-end:

----------------------
Configure controller-0
----------------------

.. include:: controller_storage_install_kubernetes.rst
   :start-after: incl-config-controller-0-storage-start:
   :end-before: incl-config-controller-0-storage-end:

-------------------
Unlock controller-0
-------------------

Unlock controller-0 in order to bring it into service:

::

  system host-unlock controller-0

Controller-0 will reboot in order to apply configuration changes and come into
service. This can take 5-10 minutes, depending on the performance of the host machine.

------------------------------------------------------------------
Install software on controller-1, storage nodes, and compute nodes
------------------------------------------------------------------

#. Power on the controller-1 server and force it to network boot with the
   appropriate BIOS boot options for your particular server.

#. As controller-1 boots, a message appears on its console instructing you to
   configure the personality of the node.

#. On the console of controller-0, list hosts to see newly discovered controller-1
   host (hostname=None):

   ::

	system host-list
	+----+--------------+-------------+----------------+-------------+--------------+
	| id | hostname     | personality | administrative | operational | availability |
	+----+--------------+-------------+----------------+-------------+--------------+
	| 1  | controller-0 | controller  | unlocked       | enabled     | available    |
	| 2  | None         | None        | locked         | disabled    | offline      |
	+----+--------------+-------------+----------------+-------------+--------------+

#. Using the host id, set the personality of this host to 'controller':

   ::

     system host-update 2 personality=controller

   This initiates the install of software on controller-1.
   This can take 5-10 minutes, depending on the performance of the host machine.

#. While waiting for the previous step to complete, power on the storage-0 and
   storage-1 servers. Set the personality to 'storage' and assign a unique
   hostname for each.

   For example, power on storage-0 and wait for the new host (hostname=None) to
   be discovered by checking 'system host-list':

   ::

   		system host-update 3 personality=storage

   Repeat for storage-1. Power on storage-1 and wait for the new host
   (hostname=None) to be discovered by checking 'system host-list':

   ::

   		system host-update 4 personality=storage

   This initiates the software installation on storage-0 and storage-1.
   This can take 5-10 minutes, depending on the performance of the host machine.

#. While waiting for the previous step to complete, power on the compute-0 and
   compute-1 servers. Set the personality to 'worker' and assign a unique
   hostname for each.

   For example, power on compute-0 and wait for the new host (hostname=None) to
   be discovered by checking 'system host-list':

   ::

     system host-update 5 personality=worker hostname=compute-0

   Repeat for compute-1. Power on compute-1 and wait for the new host
   (hostname=None) to be discovered by checking 'system host-list':

   ::

	 system host-update 6 personality=worker hostname=compute-1

   This initiates the install of software on compute-0 and compute-1.

#. Wait for the software installation on controller-1, storage-0, storage-1,
   compute-0, and compute-1 to complete, for all servers to reboot, and for all to
   show as locked/disabled/online in 'system host-list'.

   ::

	 system host-list
	 +----+--------------+-------------+----------------+-------------+--------------+
	 | id | hostname     | personality | administrative | operational | availability |
	 +----+--------------+-------------+----------------+-------------+--------------+
	 | 1  | controller-0 | controller  | unlocked       | enabled     | available    |
	 | 2  | controller-1 | controller  | locked         | disabled    | online       |
	 | 3  | storage-0    | storage     | locked         | disabled    | online       |
	 | 4  | storage-1    | storage     | locked         | disabled    | online       |
	 | 5  | compute-0    | compute     | locked         | disabled    | online       |
	 | 6  | compute-1    | compute     | locked         | disabled    | online       |
	 +----+--------------+-------------+----------------+-------------+--------------+

----------------------
Configure controller-1
----------------------

.. include:: controller_storage_install_kubernetes.rst
   :start-after: incl-config-controller-1-start:
   :end-before: incl-config-controller-1-end:

-------------------
Unlock controller-1
-------------------

.. include:: controller_storage_install_kubernetes.rst
   :start-after: incl-unlock-controller-1-start:
   :end-before: incl-unlock-controller-1-end:

-----------------------
Configure storage nodes
-----------------------

#. Assign the cluster-host network to the MGMT interface for the storage nodes:

   (Note that the MGMT interfaces are partially set up automatically by the
   network install procedure.)

   ::

	for COMPUTE in storage-0 storage-1; do
	   system interface-network-assign $COMPUTE mgmt0 cluster-host
	done

#. Add OSDs to storage-0:

   ::

	HOST=storage-0
	DISKS=$(system host-disk-list ${HOST})
	TIERS=$(system storage-tier-list ceph_cluster)
	OSDs="/dev/sdb"
	for OSD in $OSDs; do
	   system host-stor-add ${HOST} $(echo "$DISKS" | grep "$OSD" | awk '{print $2}') --tier-uuid $(echo "$TIERS" | grep storage | awk '{print $2}')
	   while true; do system host-stor-list ${HOST} | grep ${OSD} | grep configuring; if [ $? -ne 0 ]; then break; fi; sleep 1; done
	done

	system host-stor-list $HOST

#. Add OSDs to storage-1:

   ::

	HOST=storage-1
	DISKS=$(system host-disk-list ${HOST})
	TIERS=$(system storage-tier-list ceph_cluster)
	OSDs="/dev/sdb"
	for OSD in $OSDs; do
	    system host-stor-add ${HOST} $(echo "$DISKS" | grep "$OSD" | awk '{print $2}') --tier-uuid $(echo "$TIERS" | grep storage | awk '{print $2}')
	    while true; do system host-stor-list ${HOST} | grep ${OSD} | grep configuring; if [ $? -ne 0 ]; then break; fi; sleep 1; done
	done

	system host-stor-list $HOST

--------------------
Unlock storage nodes
--------------------

Unlock storage nodes in order to bring them into service:

::

	for STORAGE in storage-0 storage-1; do
	   system host-unlock $STORAGE
	done

The storage nodes will reboot in order to apply configuration changes and come
into service. This can take 5-10 minutes, depending on the performance of the
host machine.

-----------------------
Configure compute nodes
-----------------------

#. Assign the cluster-host network to the MGMT interface for the compute nodes:

   (Note that the MGMT interfaces are partially set up automatically by the
   network install procedure.)

   ::

	for COMPUTE in compute-0 compute-1; do
	   system interface-network-assign $COMPUTE mgmt0 cluster-host
	done

#. Configure data interfaces for compute nodes. Use the DATA port names, for
   example eth0, that are applicable to your deployment environment.

   .. important::

      This step is **required** for OpenStack.

      This step is optional for Kubernetes: Do this step if using SRIOV network
      attachments in hosted application containers.

   For Kubernetes SRIOV network attachments:

   * Configure the SRIOV device plug in:

     ::

		for COMPUTE in compute-0 compute-1; do
		   system host-label-assign ${COMPUTE} sriovdp=enabled
		done

   * If planning on running DPDK in containers on this host, configure the number
     of 1G Huge pages required on both NUMA nodes:

     ::

		for COMPUTE in compute-0 compute-1; do
		   system host-memory-modify ${COMPUTE} 0 -1G 100
		   system host-memory-modify ${COMPUTE} 1 -1G 100
		done

   For both Kubernetes and OpenStack:

   ::

	 	DATA0IF=<DATA-0-PORT>
		DATA1IF=<DATA-1-PORT>
		PHYSNET0='physnet0'
		PHYSNET1='physnet1'
		SPL=/tmp/tmp-system-port-list
		SPIL=/tmp/tmp-system-host-if-list

		# configure the datanetworks in sysinv, prior to referencing it
		# in the ``system host-if-modify`` command'.
		system datanetwork-add ${PHYSNET0} vlan
		system datanetwork-add ${PHYSNET1} vlan

		for COMPUTE in compute-0 compute-1; do
		  echo "Configuring interface for: $COMPUTE"
		  set -ex
		  system host-port-list ${COMPUTE} --nowrap > ${SPL}
		  system host-if-list -a ${COMPUTE} --nowrap > ${SPIL}
		  DATA0PCIADDR=$(cat $SPL | grep $DATA0IF |awk '{print $8}')
		  DATA1PCIADDR=$(cat $SPL | grep $DATA1IF |awk '{print $8}')
		  DATA0PORTUUID=$(cat $SPL | grep ${DATA0PCIADDR} | awk '{print $2}')
		  DATA1PORTUUID=$(cat $SPL | grep ${DATA1PCIADDR} | awk '{print $2}')
		  DATA0PORTNAME=$(cat $SPL | grep ${DATA0PCIADDR} | awk '{print $4}')
		  DATA1PORTNAME=$(cat $SPL | grep ${DATA1PCIADDR} | awk '{print $4}')
		  DATA0IFUUID=$(cat $SPIL | awk -v DATA0PORTNAME=$DATA0PORTNAME '($12 ~ DATA0PORTNAME) {print $2}')
		  DATA1IFUUID=$(cat $SPIL | awk -v DATA1PORTNAME=$DATA1PORTNAME '($12 ~ DATA1PORTNAME) {print $2}')
		  system host-if-modify -m 1500 -n data0 -c data ${COMPUTE} ${DATA0IFUUID}
		  system host-if-modify -m 1500 -n data1 -c data ${COMPUTE} ${DATA1IFUUID}
		  system interface-datanetwork-assign ${COMPUTE} ${DATA0IFUUID} ${PHYSNET0}
		  system interface-datanetwork-assign ${COMPUTE} ${DATA1IFUUID} ${PHYSNET1}
		  set +ex
		done

*************************************
OpenStack-specific host configuration
*************************************

.. important::

   **This step is required only if the StarlingX OpenStack application
   (stx-openstack) will be installed.**

#. **For OpenStack only:** Assign OpenStack host labels to the compute nodes in
   support of installing the stx-openstack manifest and helm-charts later.

   ::

	for NODE in compute-0 compute-1; do
	  system host-label-assign $NODE  openstack-compute-node=enabled
	  system host-label-assign $NODE  openvswitch=enabled
	  system host-label-assign $NODE  sriov=enabled
	done

#. **For OpenStack only:** Set up disk partition for nova-local volume group,
   which is needed for stx-openstack nova ephemeral disks.

   ::

	for COMPUTE in compute-0 compute-1; do
	  echo "Configuring Nova local for: $COMPUTE"
	  ROOT_DISK=$(system host-show ${COMPUTE} | grep rootfs | awk '{print $4}')
	  ROOT_DISK_UUID=$(system host-disk-list ${COMPUTE} --nowrap | grep ${ROOT_DISK} | awk '{print $2}')
	  PARTITION_SIZE=10
	  NOVA_PARTITION=$(system host-disk-partition-add -t lvm_phys_vol ${COMPUTE} ${ROOT_DISK_UUID} ${PARTITION_SIZE})
	  NOVA_PARTITION_UUID=$(echo ${NOVA_PARTITION} | grep -ow "| uuid | [a-z0-9\-]* |" | awk '{print $4}')
	  system host-lvg-add ${COMPUTE} nova-local
	  system host-pv-add ${COMPUTE} nova-local ${NOVA_PARTITION_UUID}
	done

--------------------
Unlock compute nodes
--------------------

Unlock compute nodes in order to bring them into service:

::

	for COMPUTE in compute-0 compute-1; do
	   system host-unlock $COMPUTE
	done

The compute nodes will reboot in order to apply configuration changes and come
into service. This can take 5-10 minutes, depending on the performance of the
host machine.

----------
Next steps
----------

.. include:: ../kubernetes_install_next.txt
