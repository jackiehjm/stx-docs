=======================================================================
Install StarlingX Kubernetes on Virtual Standard with Dedicated Storage
=======================================================================

This section describes the steps to install the StarlingX Kubernetes platform
on a StarlingX |this-ver| virtual Standard with Dedicated Storage deployment
configuration.

.. contents::
   :local:
   :depth: 1

--------------------------------
Install software on controller-0
--------------------------------

In the last step of :doc:`dedicated_storage_environ`, the controller-0 virtual
server 'dedicatedstorage-controller-0' was started by the
:command:`setup_configuration.sh` command.

On the host, attach to the console of virtual controller-0 and select the
appropriate installer menu options to start the non-interactive install of
StarlingX software on controller-0.

.. note::

   When entering the console, it is very easy to miss the first installer menu
   selection. Use ESC to navigate to previous menus, to ensure you are at the
   first installer menu.

::

  virsh console dedicatedstorage-controller-0

Make the following menu selections in the installer:

#. First menu: Select 'Standard Controller Configuration'
#. Second menu: Select 'Serial Console'

Wait for the non-interactive install of software to complete and for the server
to reboot. This can take 5-10 minutes depending on the performance of the host
machine.

--------------------------------
Bootstrap system on controller-0
--------------------------------

.. include:: controller_storage_install_kubernetes.rst
   :start-after: incl-bootstrap-controller-0-virt-controller-storage-start:
   :end-before: incl-bootstrap-controller-0-virt-controller-storage-end:

----------------------
Configure controller-0
----------------------

.. include:: controller_storage_install_kubernetes.rst
   :start-after: incl-config-controller-0-virt-controller-storage-start:
   :end-before: incl-config-controller-0-virt-controller-storage-end:

-------------------
Unlock controller-0
-------------------

.. important::

   Make sure the Ceph storage backend is configured. If it is
   not configured, you will not be able to configure storage
   nodes.

Unlock virtual controller-0 in order to bring it into service:

::

  system host-unlock controller-0

Controller-0 will reboot in order to apply configuration changes and come into
service. This can take 5-10 minutes, depending on the performance of the host machine.

-----------------------------------------------------------------
Install software on controller-1, storage nodes, and worker nodes
-----------------------------------------------------------------

#. On the host, power on the controller-1 virtual server,
   'dedicatedstorage-controller-1'. It will automatically attempt to network
   boot over the management network:

   ::

      virsh start dedicatedstorage-controller-1

#. Attach to the console of virtual controller-1:

   ::

      virsh console dedicatedstorage-controller-1

#. As controller-1 VM boots, a message appears on its console instructing you to
   configure the personality of the node.

#. On the console of controller-0, list hosts to see newly discovered
   controller-1 host (hostname=None):

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

   This initiates software installation on controller-1.
   This can take 5-10 minutes, depending on the performance of the host machine.

#. While waiting on the previous step to complete, start up and set the personality
   for 'dedicatedstorage-storage-0' and 'dedicatedstorage-storage-1'. Set the
   personality to 'storage' and assign a unique hostname for each.

   For example, start 'dedicatedstorage-storage-0' from the host:

   ::

      virsh start dedicatedstorage-storage-0

   Wait for new host (hostname=None) to be discovered by checking
   ‘system host-list’ on virtual controller-0:

   ::

      system host-update 3 personality=storage

   Repeat for 'dedicatedstorage-storage-1'. On the host:

   ::

      virsh start dedicatedstorage-storage-1

   And wait for new host (hostname=None) to be discovered by checking
   ‘system host-list’ on virtual controller-0:

   ::

      system host-update 4 personality=storage

   This initiates software installation on storage-0 and storage-1.
   This can take 5-10 minutes, depending on the performance of the host machine.

#. While waiting on the previous step to complete, start up and set the personality
   for 'dedicatedstorage-worker-0' and 'dedicatedstorage-worker-1'. Set the
   personality to 'worker' and assign a unique hostname for each.

   For example, start 'dedicatedstorage-worker-0' from the host:

   ::

      virsh start dedicatedstorage-worker-0

   Wait for new host (hostname=None) to be discovered by checking
   ‘system host-list’ on virtual controller-0:

   ::

      system host-update 5 personality=worker hostname=worker-0

   Repeat for 'dedicatedstorage-worker-1'. On the host:

   ::

      virsh start dedicatedstorage-worker-1

   And wait for new host (hostname=None) to be discovered by checking
   ‘system host-list’ on virtual controller-0:

   ::

      system host-update 6 personality=worker hostname=worker-1

   This initiates software installation on worker-0 and worker-1.

   .. only:: starlingx

     .. Note::

        A node with Edgeworker personality is also available. See
        :ref:`deploy-edgeworker-nodes` for details.

#. Wait for the software installation on controller-1, storage-0, storage-1,
   worker-0, and worker-1 to complete, for all virtual servers to reboot, and for all
   to show as locked/disabled/online in 'system host-list'.

   ::

      system host-list
      +----+--------------+-------------+----------------+-------------+--------------+
      | id | hostname     | personality | administrative | operational | availability |
      +----+--------------+-------------+----------------+-------------+--------------+
      | 1  | controller-0 | controller  | unlocked       | enabled     | available    |
      | 2  | controller-1 | controller  | locked         | disabled    | online       |
      | 3  | storage-0    | storage     | locked         | disabled    | online       |
      | 4  | storage-1    | storage     | locked         | disabled    | online       |
      | 5  | worker-0     | worker      | locked         | disabled    | online       |
      | 6  | worker-1     | worker      | locked         | disabled    | online       |
      +----+--------------+-------------+----------------+-------------+--------------+

----------------------
Configure controller-1
----------------------

.. include:: controller_storage_install_kubernetes.rst
   :start-after: incl-config-controller-1-virt-controller-storage-start:
   :end-before: incl-config-controller-1-virt-controller-storage-end:

-------------------
Unlock controller-1
-------------------

.. include:: controller_storage_install_kubernetes.rst
   :start-after: incl-unlock-controller-1-virt-controller-storage-start:
   :end-before: incl-unlock-controller-1-virt-controller-storage-end:

-----------------------
Configure storage nodes
-----------------------

On virtual controller-0:

#. Assign the cluster-host network to the MGMT interface for the storage nodes.

   Note that the MGMT interfaces are partially set up by the network install procedure.

   ::

      for NODE in storage-0 storage-1; do
         system interface-network-assign $NODE mgmt0 cluster-host
      done

#. Add OSDs to storage-0:

   ::

    HOST=storage-0
    DISKS=$(system host-disk-list ${HOST})
    TIERS=$(system storage-tier-list ceph_cluster)
    OSDs="/dev/sdb"
    for OSD in $OSDs; do
       system host-stor-add ${HOST} $(echo "$DISKS" | grep "$OSD" | awk '{print $2}') --tier-uuid $(echo "$TIERS" | grep storage | awk '{print $2}')
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
      done

      system host-stor-list $HOST

--------------------
Unlock storage nodes
--------------------

Unlock virtual storage nodes in order to bring them into service:

::

  for STORAGE in storage-0 storage-1; do
     system host-unlock $STORAGE
  done

The storage nodes will reboot in order to apply configuration changes and come
into service. This can take 5-10 minutes, depending on the performance of the host machine.

----------------------
Configure worker nodes
----------------------

On virtual controller-0:

#. Assign the cluster-host network to the MGMT interface for the worker nodes.

   Note that the MGMT interfaces are partially set up automatically by the
   network install procedure.

   ::

      for NODE in worker-0 worker-1; do
         system interface-network-assign $NODE mgmt0 cluster-host
      done

#. Configure data interfaces for worker nodes.

   .. important::

      This step is required only if the StarlingX OpenStack application
      (|prefix|-openstack) will be installed.

      1G Huge Pages are not supported in the virtual environment and there is no
      virtual NIC supporting SRIOV. For that reason, data interfaces are not
      applicable in the virtual environment for the Kubernetes-only scenario.

   For OpenStack only:

   ::

      DATA0IF=eth1000
      DATA1IF=eth1001
      PHYSNET0='physnet0'
      PHYSNET1='physnet1'
      SPL=/tmp/tmp-system-port-list
      SPIL=/tmp/tmp-system-host-if-list

   Configure the datanetworks in sysinv, prior to referencing it in the
   :command:`system host-if-modify` command.

   ::

        system datanetwork-add ${PHYSNET0} vlan
        system datanetwork-add ${PHYSNET1} vlan

        for NODE in worker-0 worker-1; do
          echo "Configuring interface for: $NODE"
          set -ex
          system host-port-list ${NODE} --nowrap > ${SPL}
          system host-if-list -a ${NODE} --nowrap > ${SPIL}
          DATA0PCIADDR=$(cat $SPL | grep $DATA0IF |awk '{print $8}')
          DATA1PCIADDR=$(cat $SPL | grep $DATA1IF |awk '{print $8}')
          DATA0PORTUUID=$(cat $SPL | grep ${DATA0PCIADDR} | awk '{print $2}')
          DATA1PORTUUID=$(cat $SPL | grep ${DATA1PCIADDR} | awk '{print $2}')
          DATA0PORTNAME=$(cat $SPL | grep ${DATA0PCIADDR} | awk '{print $4}')
          DATA1PORTNAME=$(cat $SPL | grep ${DATA1PCIADDR} | awk '{print $4}')
          DATA0IFUUID=$(cat $SPIL | awk -v DATA0PORTNAME=$DATA0PORTNAME '($12 ~ DATA0PORTNAME) {print $2}')
          DATA1IFUUID=$(cat $SPIL | awk -v DATA1PORTNAME=$DATA1PORTNAME '($12 ~ DATA1PORTNAME) {print $2}')
          system host-if-modify -m 1500 -n data0 -c data ${NODE} ${DATA0IFUUID}
          system host-if-modify -m 1500 -n data1 -c data ${NODE} ${DATA1IFUUID}
          system interface-datanetwork-assign ${NODE} ${DATA0IFUUID} ${PHYSNET0}
          system interface-datanetwork-assign ${NODE} ${DATA1IFUUID} ${PHYSNET1}
          set +ex
        done

*************************************
OpenStack-specific host configuration
*************************************

.. important::

   This step is required only if the StarlingX OpenStack application
   (|prefix|-openstack) will be installed.

#. **For OpenStack only:** Assign OpenStack host labels to the worker nodes in
   support of installing the |prefix|-openstack manifest/helm-charts later:

   .. parsed-literal::

      for NODE in worker-0 worker-1; do
        system host-label-assign $NODE  openstack-compute-node=enabled
        kubectl taint nodes $NODE openstack-compute-node:NoSchedule
        system host-label-assign $NODE  |vswitch-label|
        system host-label-assign $NODE  sriov=enabled
      done

#. **For OpenStack only:** Set up a 'instances' filesystem,
   which is needed for |prefix|-openstack nova ephemeral disks.

   ::

     for NODE in worker-0 worker-1; do
       echo "Configuring 'instances' for Nova ephemeral storage: $NODE"
       system host-fs-add ${NODE} instances=10
     done

-------------------
Unlock worker nodes
-------------------

.. include:: controller_storage_install_kubernetes.rst
   :start-after: incl-unlock-compute-nodes-virt-controller-storage-start:
   :end-before: incl-unlock-compute-nodes-virt-controller-storage-end:

----------
Next steps
----------

.. include:: /_includes/kubernetes_install_next.txt
