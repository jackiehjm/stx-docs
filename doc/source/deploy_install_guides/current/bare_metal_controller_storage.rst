================================================
Bare metal Standard with Controller Storage R2.0
================================================

.. contents::
   :local:
   :depth: 1

-----------
Description
-----------

.. include:: virtual_controller_storage.rst
   :start-after: incl-controller-storage-intro-start:
   :end-before: incl-controller-storage-intro-end:

.. include:: virtual_aio_simplex.rst
   :start-after: incl-ipv6-note-start:
   :end-before: incl-ipv6-note-end:

---------------------
Hardware requirements
---------------------

The recommended minimum requirements for the bare metal servers for the various
host types are:

+-------------------------+-----------------------------+-----------------------------+
| Minimum Requirement     | Controller Node             | Compute Node                |
+=========================+=============================+=============================+
| Number of Servers       | 2                           | 2-10                        |
+-------------------------+-----------------------------+-----------------------------+
| Minimum Processor Class | - Dual-CPU Intel® Xeon® E5 26xx family (SandyBridge)      |
|                         |   8 cores/socket                                          |
+-------------------------+-----------------------------+-----------------------------+
| Minimum Memory          | 64 GB                       | 32 GB                       |
+-------------------------+-----------------------------+-----------------------------+
| Primary Disk            | 500 GB SDD or NVMe          | 120 GB (Minimum 10k RPM)    |
+-------------------------+-----------------------------+-----------------------------+
| Additional Disks        | - 1 or more 500 GB (min.    | - For OpenStack, recommend  |
|                         |   10K RPM) for Ceph OSD     |   1 or more 500 GB (min.    |
|                         | - Recommended, but not      |   10K RPM) for VM local     |
|                         |   required: 1 or more SSDs  |   ephemeral storage         |
|                         |   or NVMe drives for Ceph   |                             |
|                         |   journals (min. 1024 MiB   |                             |
|                         |   per OSD journal)          |                             |
+-------------------------+-----------------------------+-----------------------------+
| Minimum Network Ports   | - Mgmt/Cluster: 1x10GE      | - Mgmt/Cluster: 1x10GE      |
|                         | - OAM: 1x1GE                | - Data: 1 or more x 10GE    |
+-------------------------+-----------------------------+-----------------------------+
| BIOS Settings           | - Hyper-Threading technology enabled                      |
|                         | - Virtualization technology enabled                       |
|                         | - VT for directed I/O enabled                             |
|                         | - CPU power and performance policy set to performance     |
|                         | - CPU C state control disabled                            |
|                         | - Plug & play BMC detection disabled                      |
+-------------------------+-----------------------------+-----------------------------+

---------------
Prepare Servers
---------------

.. include:: bare_metal_aio_simplex.rst
   :start-after: incl-prepare-servers-start:
   :end-before: incl-prepare-servers-end:

--------------------
StarlingX Kubernetes
--------------------

*******************************
Installing StarlingX Kubernetes
*******************************

^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Create a bootable USB with the StarlingX ISO
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Create a bootable USB with the StarlingX ISO.

Refer to :doc:`/deploy_install_guides/bootable_usb` for instructions on how to
create a bootable USB on your system.

^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Install software on controller-0
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. include:: bare_metal_aio_simplex.rst
   :start-after: incl-install-software-controller-0-start:
   :end-before: incl-install-software-controller-0-end:

^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Bootstrap system on controller-0
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. include:: bare_metal_aio_simplex.rst
   :start-after: incl-bootstrap-sys-controller-0-start:
   :end-before: incl-bootstrap-sys-controller-0-end:

^^^^^^^^^^^^^^^^^^^^^^
Configure controller-0
^^^^^^^^^^^^^^^^^^^^^^

#. Acquire admin credentials:

   ::

	source /etc/platform/openrc

#. Configure the OAM and MGMT interfaces of controller-0 and specify the
   attached networks. Use the OAM and MGMT port names, e.g. eth0, applicable to
   your deployment environment.

   ::

	 OAM_IF=<OAM-PORT>
	 MGMT_IF=<MGMT-PORT>
	 system host-if-modify controller-0 lo -c none
	 IFNET_UUIDS=$(system interface-network-list controller-0 | awk '{if ($6=="lo") print $4;}')
	 for UUID in $IFNET_UUIDS; do
	     system interface-network-remove ${UUID}
	 done
	 system host-if-modify controller-0 $OAM_IF -c platform
	 system interface-network-assign controller-0 $OAM_IF oam
	 system host-if-modify controller-0 $MGMT_IF -c platform
	 system interface-network-assign controller-0 $MGMT_IF mgmt
	 system interface-network-assign controller-0 $MGMT_IF cluster-host

#. Configure NTP Servers for network time synchronization:

   ::

   	 system ntp-modify ntpservers=0.pool.ntp.org,1.pool.ntp.org

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
OpenStack-specific host configuration
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. warning::

   The following configuration is required only if the StarlingX OpenStack
   application (stx-openstack) will be installed.

#. **For OpenStack only:** Assign OpenStack host labels to controller-0 in
   support of installing the stx-openstack manifest and helm-charts later.

   ::

     system host-label-assign controller-0 openstack-control-plane=enabled

#. **For OpenStack only:** Configure the system setting for the vSwitch.

   StarlingX has OVS (kernel-based) vSwitch configured as default:

   * Runs in a container; defined within the helm charts of stx-openstack
     manifest.
   * Shares the core(s) assigned to the platform.

   If you require better performance, OVS-DPDK should be used:

   * Runs directly on the host (it is NOT containerized).
   * Requires that at least 1 core be assigned/dedicated to the vSwitch function.

   To deploy the default containerized OVS:

   ::

     system modify --vswitch_type none

   Do not run any vSwitch directly on the host, instead, use the containerized
   OVS defined in the helm charts of stx-openstack manifest.

   To deploy OVS-DPDK (OVS with the Data Plane Development Kit, which is
   supported only on bare metal hardware), run the following command:

   ::

     system modify --vswitch_type ovs-dpdk
	 system host-cpu-modify -f vswitch -p0 1 controller-0

   Once vswitch_type is set to OVS-DPDK, any subsequent nodes created will
   default to automatically assigning 1 vSwitch core for AIO controllers and 2
   vSwitch cores for computes.

   When using OVS-DPDK, Virtual Machines must be configured to use a flavor with
   property: hw:mem_page_size=large.

   .. note::

   	  After controller-0 is unlocked, changing vswitch_type requires
   	  locking and unlocking all computes (and/or AIO controllers) to
   	  apply the change.

^^^^^^^^^^^^^^^^^^^
Unlock controller-0
^^^^^^^^^^^^^^^^^^^

.. include:: bare_metal_aio_duplex.rst
   :start-after: incl-unlock-controller-0-start:
   :end-before: incl-unlock-controller-0-end:

^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Install software on controller-1 and compute nodes
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

#. Power on the controller-1 server and force it to network boot with the
   appropriate BIOS boot options for your particular server.

#. As controller-1 boots, a message appears on its console instructing you to
   configure the personality of the node.

#. On the console of controller-0, list hosts to see newly discovered controller-1
   host, that is, host with hostname of None:

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

#. While waiting, repeat the same procedure for compute-0 server and
   compute-1 server, except for setting the personality to 'worker' and
   assigning a unique hostname, as shown below:

   ::

     system host-update 3 personality=worker hostname=compute-0
     system host-update 4 personality=worker hostname=compute-1

#. Wait for the software installation on controller-1, compute-0, and compute-1 to
   complete, for all servers to reboot, and for to all show as locked/disabled/online in
   'system host-list'.

   ::

	 system host-list

 	 +----+--------------+-------------+----------------+-------------+--------------+
	 | id | hostname     | personality | administrative | operational | availability |
	 +----+--------------+-------------+----------------+-------------+--------------+
	 | 1  | controller-0 | controller  | unlocked       | enabled     | available    |
	 | 2  | controller-1 | controller  | locked         | disabled    | online       |
	 | 3  | compute-0    | compute     | locked         | disabled    | online       |
	 | 4  | compute-1    | compute     | locked         | disabled    | online       |
	 +----+--------------+-------------+----------------+-------------+--------------+

^^^^^^^^^^^^^^^^^^^^^^
Configure controller-1
^^^^^^^^^^^^^^^^^^^^^^

.. incl-config-controller-1-start:

Configure the OAM and MGMT interfaces of controller-0 and specify the attached
networks. Use the OAM and MGMT port names, e.g. eth0, applicable to your
deployment environment.

(Note that the MGMT interface is partially set up automatically by the network
install procedure.)

::

	OAM_IF=<OAM-PORT>
	MGMT_IF=<MGMT-PORT>
	system host-if-modify controller-1 $OAM_IF -c platform
	system interface-network-assign controller-1 $OAM_IF oam
	system interface-network-assign controller-1 $MGMT_IF cluster-host

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
OpenStack-specific host configuration
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. warning::

   The following configuration is required only if the StarlingX OpenStack
   application (stx-openstack) will be installed.

**For OpenStack only:** Assign OpenStack host labels to controller-1 in support
of installing the stx-openstack manifest and helm-charts later.

::

	system host-label-assign controller-1 openstack-control-plane=enabled

.. incl-config-controller-1-end:

^^^^^^^^^^^^^^^^^^^
Unlock controller-1
^^^^^^^^^^^^^^^^^^^

.. incl-unlock-controller-1-start:

Unlock controller-1 in order to bring it into service:

::

	system host-unlock controller-1

Controller-1 will reboot in order to apply configuration changes and come into
service. This can take 5-10 minutes, depending on the performance of the host machine.

.. incl-unlock-controller-1-end:

^^^^^^^^^^^^^^^^^^^^^^^
Configure compute nodes
^^^^^^^^^^^^^^^^^^^^^^^

#. Add the third Ceph monitor to compute-0:

   (The first two Ceph monitors are automatically assigned to controller-0 and
   controller-1.)

   ::

   	 system ceph-mon-add compute-0

#. Wait for the compute node monitor to complete configuration:

   ::

	 system ceph-mon-list
	 +--------------------------------------+-------+--------------+------------+------+
	 | uuid                                 | ceph_ | hostname     | state      | task |
	 |                                      | mon_g |              |            |      |
	 |                                      | ib    |              |            |      |
	 +--------------------------------------+-------+--------------+------------+------+
	 | 64176b6c-e284-4485-bb2a-115dee215279 | 20    | controller-1 | configured | None |
	 | a9ca151b-7f2c-4551-8167-035d49e2df8c | 20    | controller-0 | configured | None |
	 | f76bc385-190c-4d9a-aa0f-107346a9907b | 20    | compute-0    | configured | None |
	 +--------------------------------------+-------+--------------+------------+------+

#. Assign the cluster-host network to the MGMT interface for the compute nodes:

   (Note that the MGMT interfaces are partially set up automatically by the
   network install procedure.)

   ::

	 for COMPUTE in compute-0 compute-1; do
	    system interface-network-assign $COMPUTE mgmt0 cluster-host
	 done

#. Configure data interfaces for compute nodes. Use the DATA port names, e.g.
   eth0, applicable to your deployment environment.

   .. note::

   	  This step is required for OpenStack and optional for Kubernetes. For
   	  example, do this step if using SRIOV network attachments in application
   	  containers.

   For Kubernetes SRIOV network attachments:

   * Configure SRIOV device plugin:

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

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
OpenStack-specific host configuration
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. warning::

   The following configuration is required only if the StarlingX OpenStack
   application (stx-openstack) will be installed.

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

	 for COMPUTE in compute-0 compute-1; do
	   echo ">>> Wait for partition $NOVA_PARTITION_UUID to be ready."
	   while true; do system host-disk-partition-list $COMPUTE --nowrap | grep $NOVA_PARTITION_UUID | grep Ready; if [ $? -eq 0 ]; then break; fi; sleep 1; done
	 done

^^^^^^^^^^^^^^^^^^^^
Unlock compute nodes
^^^^^^^^^^^^^^^^^^^^

Unlock compute nodes in order to bring them into service:

::

	for COMPUTE in compute-0 compute-1; do
	   system host-unlock $COMPUTE
	done

The compute nodes will reboot in order to apply configuration changes and come into
service. This can take 5-10 minutes, depending on the performance of the host machine.

^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Add Ceph OSDs to controllers
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

#. Add OSDs to controller-0:

   ::

	 HOST=controller-0
	 DISKS=$(system host-disk-list ${HOST})
	 TIERS=$(system storage-tier-list ceph_cluster)
	 OSDs="/dev/sdb"
	 for OSD in $OSDs; do
	    system host-stor-add ${HOST} $(echo "$DISKS" | grep "$OSD" | awk '{print $2}') --tier-uuid $(echo "$TIERS" | grep storage | awk '{print $2}')
	    while true; do system host-stor-list ${HOST} | grep ${OSD} | grep configuring; if [ $? -ne 0 ]; then break; fi; sleep 1; done
	 done

	 system host-stor-list $HOST

#. Add OSDs to controller-1:

   ::

	 HOST=controller-1
	 DISKS=$(system host-disk-list ${HOST})
	 TIERS=$(system storage-tier-list ceph_cluster)
	 OSDs="/dev/sdb"
	 for OSD in $OSDs; do
	     system host-stor-add ${HOST} $(echo "$DISKS" | grep "$OSD" | awk '{print $2}') --tier-uuid $(echo "$TIERS" | grep storage | awk '{print $2}')
	     while true; do system host-stor-list ${HOST} | grep ${OSD} | grep configuring; if [ $? -ne 0 ]; then break; fi; sleep 1; done
	 done

	 system host-stor-list $HOST

Your Kubernetes cluster is up and running.

***************************
Access StarlingX Kubernetes
***************************

.. include:: virtual_aio_simplex.rst
   :start-after: incl-access-starlingx-kubernetes-start:
   :end-before: incl-access-starlingx-kubernetes-end:

-------------------
StarlingX OpenStack
-------------------

***************************
Install StarlingX OpenStack
***************************

.. include:: virtual_aio_simplex.rst
   :start-after: incl-install-starlingx-openstack-start:
   :end-before: incl-install-starlingx-openstack-end:

**************************
Access StarlingX OpenStack
**************************

.. include:: virtual_aio_simplex.rst
   :start-after: incl-access-starlingx-openstack-start:
   :end-before: incl-access-starlingx-openstack-end:

*****************************
Uninstall StarlingX OpenStack
*****************************

.. include:: virtual_aio_simplex.rst
   :start-after: incl-uninstall-starlingx-openstack-start:
   :end-before: incl-uninstall-starlingx-openstack-end:
