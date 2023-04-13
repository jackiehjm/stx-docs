
.. ulm1559068249625
.. _using-network-attachment-definitions-in-a-container:

=================================================
Use Network Attachment Definitions in a Container
=================================================

Network attachment definitions can be referenced by name when creating a
container. The extended resource name of the SR-IOV pool should also be
referenced in the resource requests.

.. rubric:: |context|

The following examples use network attachment definitions **net2** and **net3**
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

#.  Create a container with one additional SR-IOV interface using the **net2**
    network attachment definition.

    #.  Populate the configuration file pod1.yaml with the following contents.

        .. code-block:: yaml

            apiVersion: v1
            kind: Pod
            metadata:
              name: pod1
              annotations:
                k8s.v1.cni.cncf.io/networks: '[
                    { "name": "net2" },
                    { "name": "net2" }
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

    After creating the container, an extra network device interface, **net2**,
    which uses one SR-IOV VF, will appear in the associated container\(s\).

#.  Create a container with two additional SR-IOV interfaces using the **net2**
    network attachment definition.

    #.  Populate the configuration file pod2.yaml with the following contents.

        .. code-block:: yaml

            apiVersion: v1
            kind: Pod
            metadata:
              name: pod2
              annotations:
                k8s.v1.cni.cncf.io/networks: '[
                    { "name": "net2" }
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

    After creating the container, network device interfaces **net2** and
    **net3**, which each use one SR-IOV VF, will appear in the associated
    container\(s\).

#.  Create a container with two additional SR-IOV interfaces using the **net2**
    and **net3** network attachment definitions.

    #.  Populate the configuration file pod3.yaml with the following contents.

        .. code-block:: yaml

            apiVersion: v1
            kind: Pod
            metadata:
               name: pod3
               annotations:
                  k8s.v1.cni.cncf.io/networks: '[
                        { "name": "net2" },
                        { "name": "net3" }
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

    **net2** and **net3** will each take a device from the
    **pci\_sriov\_net\_datanet\_b** pool and be configured on the
    container/host based on the their respective
    **NetworkAttachmentDefinition** specifications \(see :ref:`Creating Network
    Attachment Definitions <creating-network-attachment-definitions>`\).

    After creating the container, network device interfaces **net2** and
    **net3**, which each use one SR-IOV VF, will appear in the associated
    container\(s\).

    .. note::
        In the above examples, the PCI addresses allocated to the container are
        exported via an environment variable. For example:

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

#.  Create a container with two additional SR-IOV interfaces using the **net1**
    network attachment definition for a DPDK based application.

    The configuration of the SR-IOV host interface to which the datanetwork is
    assigned determines whether the network attachment in the container will be
    kernel or userspace-based. The |SRIOV| host interface needs to be created with a
    vfio **vf-driver** for the network attachment in the container to be
    userspace-based, otherwise it will be kernel-based (``netdevice``).

    Only ``netdevice`` is supported for Mellanox NICs.

    #.  Populate the configuration file pod4.yaml with the following contents.

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
            the NetworkAttachmentDefinition to underscores \(\_\).

    #.  Apply the configuration to create the container.

        .. code-block:: none

            ~(keystone_admin)$  kubectl create -f pod4.yaml
            pod/testpmd created

