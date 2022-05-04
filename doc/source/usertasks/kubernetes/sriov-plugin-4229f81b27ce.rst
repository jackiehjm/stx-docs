.. uen1559067854074
.. _sriov-plugin-4229f81b27ce:


=============
SR-IOV plugin
=============


.. contents:: |minitoc|
   :local:
   :depth: 1


.. _creating-network-attachment-definitions:

-------------------------------------
Create Network Attachment Definitions
-------------------------------------

Network attachment definition specifications must be created in order to
reference / request an |SRIOV| interface in a container specification.

.. rubric:: |context|

The sample network attachments shown in this procedure can be used in a
container as shown in :ref:`Use Network Attachment Definitions in a Container
<using-network-attachment-definitions-in-a-container>`.

.. xreflink For information about PCI-SRIOV Interface Support, see the |datanet-doc|:
   :ref:`<data-network-management-data-networks>` guide.

.. rubric:: |prereq|

You must have configured at least one |SRIOV| interface on a host with the
target datanetwork \(``datanet-a`` or ``datanet-b`` in the example below\)
assigned to it before creating a ``NetworkAttachmentDefinition`` referencing
this data network.

.. note::

    The configuration for this |SRIOV| interface with either a ``netdevice`` or
    a user space network device such as a |DPDK| poll mode drive.

.. note::

   Mellanox-based interfaces should be bound to the ``netdevice`` vf-driver for
   both kernel and user space usage.

After |SRIOV| interfaces have been provisioned and the hosts labeled and
unlocked, available |SRIOV| |VF| resources are automatically advertised.

They can be referenced in subsequent |prod| operations using the appropriate
``NetworkAttachmentDefinition`` name and the following extended resource name:

.. code-block:: none

    intel.com/pci_sriov_net_${DATANETWORK_NAME}

For example, with a network called ``datanet-a`` the extended resource name
would be:

.. xreflink as shown in |node-doc|:
   :ref:`Provisioning SR-IOV Interfaces using the CLI
   <provisioning-sr-iov-interfaces-using-the-cli>`,

.. code-block:: none

    intel.com/pci_sriov_net_datanet_a

.. _creating-network-attachment-definitions-ul-qjr-vnb-xhb:

-   The extended resource name will convert all dashes \('-'\) in the data
    network name into underscores \('\_'\).

-   |SRIOV| enabled interfaces using the netdevice VF driver must be
    administratively and operationally up to be advertised by the |SRIOV|
    device plugin.

-   If multiple data networks are assigned to an interface, the |VFs|
    resources will be shared between pools.


.. rubric:: |proc|

.. _creating-network-attachment-definitions-steps-unordered-tbf-53z-hjb:

#.  Create a simple |SRIOV| network attachment definition file called
    ``net1.yaml`` associated with the data network ``datanet-a``.

    .. code-block:: yaml

        ~(keystone_admin)]$ cat <<EOF > net1.yaml
        apiVersion: "k8s.cni.cncf.io/v1"
        kind: NetworkAttachmentDefinition
        metadata:
          name: net1
          annotations:
            k8s.v1.cni.cncf.io/resourceName: intel.com/pci_sriov_net_datanet_a
        spec:
          config: '{
              "cniVersion": "0.3.0",
              "type": "sriov"
            }'
        EOF



    This ``NetworkAttachmentDefinition`` is valid for both a kernel-based and
    a |DPDK| \(vfio\) based device.

#.  Create an |SRIOV| network attachment with a VLAN ID or with IP Address information.

    -   The following example creates an |SRIOV| network attachment definition
        configured for a |VLAN| with an ID of 2000.

        .. code-block:: none

            ~(keystone_admin)]$ cat <<EOF > net2.yaml
            apiVersion: "k8s.cni.cncf.io/v1"
            kind: NetworkAttachmentDefinition
            metadata:
              name: net2
              annotations:
                k8s.v1.cni.cncf.io/resourceName: intel.com/pci_sriov_net_datanet_b
            spec:
              config: '{
                  "cniVersion": "0.3.0",
                  "type": "sriov",
                  "vlan": 2000
                }'
            EOF

    -   The following example creates an |SRIOV| network attachment definition
        configured with IP Address information.

        .. code-block:: none

            ~(keystone_admin)]$ cat <<EOF > net3.yaml
            apiVersion: crd.projectcalico.org/v1
            kind: IPPool
            metadata:
              name: mypool
            spec:
              cidr: "10.56.219.0/24"
              ipipMode: "Never"
              natOutgoing: True
            ---
            apiVersion: "k8s.cni.cncf.io/v1"
            kind: NetworkAttachmentDefinition
            metadata:
              name: net3
              annotations:
                k8s.v1.cni.cncf.io/resourceName: intel.com/pci_sriov_net_datanet_b
            spec:
              config: '{
                  "cniVersion": "0.3.0",
                  "type": "sriov",
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
            EOF



.. ulm1559068249625
.. _using-network-attachment-definitions-in-a-container:

-------------------------------------------------
Use Network Attachment Definitions in a Container
-------------------------------------------------

Network attachment definitions can be referenced by name when creating a
container. The extended resource name of the |SRIOV| pool should also be
referenced in the resource requests.

.. rubric:: |context|

The following examples use network attachment definitions ``net2`` and ``net3``
created in :ref:`Creating Network Attachment Definitions
<creating-network-attachment-definitions>`.

As shown in these examples, it is important that you request the same number of
devices as you have network annotations.

.. only:: partner

    .. include:: /_includes/using-network-attachment-definitions-in-a-container.rest

.. xreflink For information about PCI-SRIOV Interface Support, see the :ref:`|datanet-doc|
   <data-network-management-data-networks>` guide.

.. rubric:: |proc|

.. _using-network-attachment-definitions-in-a-container-steps-j2n-zqz-hjb:

#.  Create a container with one additional |SRIOV| interface using the ``net2``
    network attachment definition.

    #.  Populate the configuration file ``pod1.yaml`` with the following
        contents.

        .. code-block:: yaml

            apiVersion: v1
            kind: Pod
            metadata:
              name: pod1
              annotations:
                k8s.v1.cni.cncf.io/networks: '[
                    { "name": "net2", "interface": "sriov0" }
                ]'
            spec:
              containers:
              - name: pod1
                image: centos/tools
                imagePullPolicy: IfNotPresent
                command: [ "/bin/bash", "-c", "--" ]
                args: [ "while true; do sleep 300000; done;" ]
                resources:
                  requests:
                    intel.com/pci_sriov_net_datanet_b: '1'
                  limits:
                    intel.com/pci_sriov_net_datanet_b: '1'

    #.  Apply the configuration to create the container.

        .. code-block:: none

            ~(keystone_admin)]$  kubectl create -f pod1.yaml
            pod/pod1 created

    After creating the container, an extra network device interface, ``net2``,
    which uses one |SRIOV| |VF|, will appear in the associated container\(s\).

    After creating the container, the interface ``sriov0``, which uses one
    |SRIOV| |VF| will appear.

    At this point you can execute commands and review links on the container.
    For example:

    .. code-block::

       $ kubectl exec -n default -it pod1 -- ip link show

#.  Create a container with two additional |SRIOV| interfaces using the ``net2``
    network attachment definition.

    #.  Populate the configuration file ``pod2.yaml`` with the following
        contents.

        .. code-block:: yaml

            apiVersion: v1
            kind: Pod
            metadata:
              name: pod2
              annotations:
                k8s.v1.cni.cncf.io/networks: '[
                    { "name": "net2", "interface": "sriov0" },
                    { "name": "net2", "interface": "sriov1" }
                ]'
            spec:
              containers:
              - name: pod2
                image: centos/tools
                imagePullPolicy: IfNotPresent
                command: [ "/bin/bash", "-c", "--" ]
                args: [ "while true; do sleep 300000; done;" ]
                resources:
                  requests:
                    intel.com/pci_sriov_net_datanet_b: '2'
                  limits:
                    intel.com/pci_sriov_net_datanet_b: '2'

    #.  Apply the configuration to create the container.

        .. code-block:: none

            ~(keystone_admin)$ kubectl create -f pod2.yaml
            pod/pod2 created

    After creating the container, two ``net2`` network device interfaces, which
    each use one |SRIOV| |VF|, will appear in the associated container\(s\).

    After creating the container, the network device interfaces ``sriov0`` and
    ``sriov0``, which uses one |SRIOV| |VF|, will appear in the associated
    container\(s\).

    At this point you can execute commands and review links on the container.
    For example:

    .. code-block::

       $ kubectl exec -n default -it pod2 -- ip link show

#.  Create a container with two additional |SRIOV| interfaces using the
    ``net2`` and ``net3`` network attachment definitions.

    #.  Populate the configuration file ``pod3.yaml`` with the following
        contents.

        .. code-block:: yaml

            apiVersion: v1
            kind: Pod
            metadata:
               name: pod3
               annotations:
                  k8s.v1.cni.cncf.io/networks: '[
                        { "name": "net2", "interface": "sriov0" }
                        { "name": "net3", "interface": "sriov0" }
                     ]'
            spec:
              containers:
              - name: pod3
                image: centos/tools
                imagePullPolicy: IfNotPresent
                command: [ "/bin/bash", "-c", "--" ]
                args: [ "while true; do sleep 300000; done;" ]
                resources:
                  requests:
                     intel.com/pci_sriov_net_datanet_b: '2'
                  limits:
                     intel.com/pci_sriov_net_datanet_b: '2'

    #.  Apply the configuration to create the container.

        .. code-block:: none

            ~(keystone_admin)$  kubectl create -f pod3.yaml

    ``net2`` and ``net3`` will each take a device from the
    ``pci_sriov_net_datanet_b`` pool and be configured on the
    container/host based on the their respective
    ``NetworkAttachmentDefinition`` specifications \(see :ref:`Creating Network
    Attachment Definitions <creating-network-attachment-definitions>`\).

    After creating the pod, the network device interface ``sriov0``, which uses
    one |SRIOV| |VF|, will appear in the associated container\(s\).

    After creating the container, network device interfaces ``net2`` and
    ``net3``, which each use one |SRIOV| |VF|, will appear in the associated
    container\(s\).

    At this point you can execute commands and review links on the container.
    For example:

    .. code-block::

       $ kubectl exec -n default -it pod3 -- ip link show

    .. note::

        In the above examples, the |PCI| addresses allocated to the container
        are exported via an environment variable. For example:

        .. code-block:: none

            ~(keystone_admin)$  kubectl exec -n default -it pod3 -- printenv
                                PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
                                HOSTNAME=pod3
                                TERM=xterm
                                PCIDEVICE_INTEL_COM_PCI_SRIOV_NET_DATANET_B=0000:81:0e.4,0000:81:0e.0
                                KUBERNETES_PORT_443_TCP_PROTO=tcp
                                KUBERNETES_PORT_443_TCP_PORT=443
                                KUBERNETES_PORT_443_TCP_ADDR=10.96.0.1
                                KUBERNETES_SERVICE_HOST=10.96.0.1
                                KUBERNETES_SERVICE_PORT=443
                                KUBERNETES_SERVICE_PORT_HTTPS=443
                                KUBERNETES_PORT=tcp://10.96.0.1:443
                                KUBERNETES_PORT_443_TCP=tcp://10.96.0.1:443
                                container=docker
                                HOME=/root

#.  Create a container with two additional |SRIOV| interfaces using the ``net1``
    network attachment definition for a |DPDK| based application.

    The configuration of the |SRIOV| host interface to which the datanetwork is
    assigned determines whether the network attachment in the container will be
    kernel or |DPDK|-based. The |SRIOV| host interface needs to be created with
    a vfio ``vf-driver`` for the network attachment in the container to be
    |DPDK|-based, otherwise it will be kernel-based.

    .. note::

       Mellanox based NICs should be bound to a netdevice (default)
       ``vf-driver``.

    #.  Populate the configuration file ``pod4.yaml`` with the following
        contents.

        .. code-block:: yaml

            apiVersion: v1
            kind: Pod
            metadata:
              name: testpmd
              annotations:
                k8s.v1.cni.cncf.io/networks: '[
                        { "name": "net1" },
                        { "name": "net1" }
                ]'
            spec:
              restartPolicy: Never
              containers:
              - name: testpmd
                image: "amirzei/mlnx_docker_dpdk:ubuntu16.04"
                volumeMounts:
                - mountPath: /mnt/huge-1048576kB
                  name: hugepage
                stdin: true
                tty: true
                securityContext:
                  privileged: false
                  capabilities:
                    add: ["IPC_LOCK", "NET_ADMIN", "NET_RAW"]
                resources:
                  requests:
                    memory: 10Gi
                    intel.com/pci_sriov_net_datanet_a: '2'
                  limits:
                    hugepages-1Gi: 4Gi
                    memory: 10Gi
                    intel.com/pci_sriov_net_datanet_a: '2'
              volumes:
              - name: hugepage
                emptyDir:
                  medium: HugePages

        .. note::
            You must convert any dashes \(-\) in the datanetwork name used in
            the ``NetworkAttachmentDefinition`` to underscores \(\_\).

    #.  Apply the configuration to create the container.

        .. code-block:: none

            ~(keystone_admin)$  kubectl create -f pod4.yaml
            pod/testpmd created

.. note::
    For applications backed by Mellanox NICs, privileged mode is required in
    the pod's security context. For Intel i40e based NICs bound to vfio,
    privileged mode is not required.
