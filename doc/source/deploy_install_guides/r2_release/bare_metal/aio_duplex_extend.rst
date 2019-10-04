================================================
Extend Capacity with Worker and/or Compute Nodes
================================================

This section describes the steps to extend capacity with worker and/or compute
nodes on a **StarlingX R2.0 bare metal All-in-one Duplex** deployment
configuration.

.. contents::
   :local:
   :depth: 1

---------------------------------
Install software on compute nodes
---------------------------------

#. Power on the compute servers and force them to network boot with the
   appropriate BIOS boot options for your particular server.

#. As the compute servers boot, a message appears on their console instructing
   you to configure the personality of the node.

#. On the console of controller-0, list hosts to see newly discovered compute
   hosts (hostname=None):

   ::

      system host-list
      +----+--------------+-------------+----------------+-------------+--------------+
      | id | hostname     | personality | administrative | operational | availability |
      +----+--------------+-------------+----------------+-------------+--------------+
      | 1  | controller-0 | controller  | unlocked       | enabled     | available    |
      | 2  | controller-0 | controller  | unlocked       | enabled     | available    |
      | 3  | None         | None        | locked         | disabled    | offline      |
      | 4  | None         | None        | locked         | disabled    | offline      |
      +----+--------------+-------------+----------------+-------------+--------------+

#. Using the host id, set the personality of this host to 'controller':

   ::

      system host-update 3 personality=worker hostname=compute-0
      system host-update 4 personality=worker hostname=compute-1

   This initiates the install of software on compute nodes.
   This can take 5-10 minutes, depending on the performance of the host machine.

#. Wait for the install of software on the computes to complete, the computes to
   reboot and to both show as locked/disabled/online in 'system host-list'.

   ::

      system host-list
      +----+--------------+-------------+----------------+-------------+--------------+
      | id | hostname     | personality | administrative | operational | availability |
      +----+--------------+-------------+----------------+-------------+--------------+
      | 1  | controller-0 | controller  | unlocked       | enabled     | available    |
      | 2  | controller-1 | controller  | unlocked       | enabled     | available    |
      | 3  | compute-0    | compute     | locked         | disabled    | online       |
      | 4  | compute-1    | compute     | locked         | disabled    | online       |
      +----+--------------+-------------+----------------+-------------+--------------+

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

   * Configure SRIOV device plug in:

     ::

         system host-label-assign controller-1 sriovdp=enabled

   * If planning on running DPDK in containers on this host, configure the number
     of 1G Huge pages required on both NUMA nodes:

     ::

           system host-memory-modify controller-1 0 -1G 100
           system host-memory-modify controller-1 1 -1G 100

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

#. **For OpenStack only:** Setup disk partition for nova-local volume group,
   needed for stx-openstack nova ephemeral disks.

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

The compute nodes will reboot to apply configuration changes and come into
service. This can take 5-10 minutes, depending on the performance of the host
machine.

