.. _integrate-the-bond-cni-plugin-2c2f14733b46:

=============================
Integrate the Bond CNI Plugin
=============================

The bond-cni plugin provides a method for aggregating multiple network
interfaces into a single logical "bonded" interface.

.. contents:: |minitoc|
   :local:
   :depth: 1

To add a bonded interface to a container, a network attachment definition of
type ``bond`` must be created and added as a network annotation in the pod
specification. The bonded interfaces can either be taken from the host or
container based on the value of the ``linksInContainer`` parameter in the
network attachment definition.

For more information on network attachment definitions and how to apply them,
see :ref:`add-sriov-interface-to-container`.

For more information on the Bond CNI plugin, see:

https://github.com/k8snetworkplumbingwg/bond-cni

The general bonding |CNI| configuration parameters are:

``name``
   (``string``, required): The name of the network.

``type``
   (``string``, required): ``bond``

``ifname``
   (``string``, optional): The name of the bond interface that will be created
   in the container.

``miimon``
   (``int``, required): Specifies the |ARP| link monitoring frequency in
   milliseconds.

``mode``
   (``string``, required): Specifies the mode of the bonding interface (one of
   ``active-backup``, ``balance-xor``, ``broadcast``, ``802.3ad``,
   ``balance-tlb``, ``balance-alb``).

``mtu``
   (``int``, optional): The |MTU| of the bond. The default is 1500.

``failOverMac``
   (``int``, optional): Specifies the ``failOverMac`` setting for the bond.
   Should be set to 1 for active-backup bond modes. Default is 0.

``linksInContainer``
   (``boolean``, optional): Specifies whether slave links are in the container
   to start. Default is ``false``, that is, look for interfaces on host before
   bonding.

``links``
   (``dictionary``, required): Master interface names.

``ipam``
   (``dictionary``, required): |IPAM| configuration to be used for this
   network, The mode can be one of: ``static``, ``host-local``, ``dhcp``,
   or ``calico-ipam``.

For more information on each mode, ``miimon``, and ``failOverMac`` behavior,
see:

https://www.kernel.org/doc/Documentation/networking/bonding.txt

----------------------------------------------------------------------------
Exampe: Launch a daemonset bonding two host interfaces in active-backup mode
----------------------------------------------------------------------------

The following example launches a daemonset bonding two host interfaces in
active-backup mode.  Since the ``linksInContainer`` value is not set (default),
the links list indicates the interfaces should be looked up on the host.

.. code-block:: yaml

   ---
   apiVersion: crd.projectcalico.org/v1
   kind: IPPool
   metadata:
     name: mypool
   spec:
     cidr: "10.10.20.0/24"
     ipipMode: "Never"
     natOutgoing: True
   ---
   apiVersion: "k8s.cni.cncf.io/v1"
   kind: NetworkAttachmentDefinition
   metadata:
     name: bond0
   spec:
     config: '{
       "cniVersion": "0.3.1",
       "name": "bond0",
       "type": "bond",
       "ifname": "net1",
       "mode": "active-backup",
       "miimon": "100",
       "failOverMac": 1,
       "links": [
         {
           "name": "eth1000"
         },
         {
           "name": "eth1001"
         }
       ],
       "ipam": {
         "type": "calico-ipam",
         "assign_ipv4": "true",
         "ipv4_pools": ["mypool"]
       },
       "kubernetes": {
         "kubeconfig": "/etc/cni/net.d/calico-kubeconfig"
       },
       "datastore_type": "kubernetes"
     }'
   ---
   apiVersion: apps/v1
   kind: DaemonSet
   metadata:
     name: bonding
     namespace: default
     labels:
       tier: node
   spec:
     selector:
       matchLabels:
         tier: node
     template:
       metadata:
         labels:
           tier: node
           app: bonding
         annotations:
           cni.projectcalico.org/ipv4pools: '["default-ipv4-ippool"]'
           k8s.v1.cni.cncf.io/networks: '[
                   { "name": "bond0" }
           ]'
       spec:
         containers:
         - name: bonding1
           image: centos/tools
           imagePullPolicy: IfNotPresent
           command: [ "/bin/bash", "-c", "--" ]
           args: [ "while true; do sleep 300000; done;" ]
           securityContext:
             capabilities:
               add:
                 - NET_ADMIN

---------------------------------------------------------------------------
Example: Launch a pod with a bonded SR-IOV interface in 802.3ad (LACP) mode
---------------------------------------------------------------------------

The following example launches a pod with a bonded |SRIOV| interface in
802.3ad (|LACP|) mode.  Since the ``linksInContainer`` value is ``true``, the
defined links are made up of the ``net1`` and ``net2`` interfaces representing
the individual |SRIOV| interfaces.

The addition of ``"spoofchk": "off"`` in the ``pci_sriov_net_group0_data0``
``config`` block ensures that applications within the container have 
permission to change the |MAC| address of the |VF|.

.. code-block:: yaml

   ---
   apiVersion: "k8s.cni.cncf.io/v1"
   kind: NetworkAttachmentDefinition
   metadata:
     name: sriov0
     annotations:
       k8s.v1.cni.cncf.io/resourceName: intel.com/pci_sriov_net_group0_data0
   spec:
     config: '{
       "cniVersion": "0.3.1",
       "type": "sriov",
       "vlan": 1350
       "spoofchk": "off"
     }'
   ---
   apiVersion: "k8s.cni.cncf.io/v1"
   kind: NetworkAttachmentDefinition
   metadata:
     name: sriov1
     annotations:
       k8s.v1.cni.cncf.io/resourceName: intel.com/pci_sriov_net_group0_data1
   spec:
     config: '{
       "cniVersion": "0.3.1",
       "type": "sriov",
       "vlan": 1350
       "spoofchk": "off"
     }'
   ---
   apiVersion: "k8s.cni.cncf.io/v1"
   kind: NetworkAttachmentDefinition
   metadata:
     name: bond0
   spec:
     config: '{
       "cniVersion": "0.3.1",
       "name": "bond0",
       "ifname": "bond0",
       "type": "bond",
       "mode": "802.3ad",
       "miimon": "100",
       "linksInContainer": true,
       "links": [
         {
           "name": "net1"
         },
         {
           "name": "net2"
         }
       ],
       "ipam": {
         "type": "static",
         "addresses": [{
           "address": "192.168.0.1/24"}]
       }
     }'
   ---
   apiVersion: v1
   kind: Pod
   metadata:
     name: bond0
     annotations:
       k8s.v1.cni.cncf.io/networks: '[
         { "name": "sriov0" },
         { "name": "sriov1" },
         { "name": "bond0" }
       ]'
   spec:
     restartPolicy: Never
     containers:
     - name: bond0
       image: centos/tools
       imagePullPolicy: IfNotPresent
       command: [ "/bin/bash", "-c", "--" ]
       args: [ "while true; do sleep 300000; done;" ]
       securityContext:
         capabilities:
           add:
             - NET_ADMIN
       resources:
         requests:
           intel.com/pci_sriov_net_group0_data0: '1'
           intel.com/pci_sriov_net_group0_data1: '1'
         limits:
           intel.com/pci_sriov_net_group0_data0: '1'
           intel.com/pci_sriov_net_group0_data1: '1'
