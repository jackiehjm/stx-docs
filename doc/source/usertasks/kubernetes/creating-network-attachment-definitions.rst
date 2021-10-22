
.. uen1559067854074
.. _creating-network-attachment-definitions:

=====================================
Create Network Attachment Definitions
=====================================

Network attachment definition specifications must be created in order to
reference / request an SR-IOV interface in a container specification.

.. rubric:: |context|

The sample network attachments shown in this procedure can be used in a
container as shown in :ref:`Using Network Attachment Definitions in a Container
<using-network-attachment-definitions-in-a-container>`.

.. xreflink For information about PCI-SRIOV Interface Support, see the |datanet-doc|:
   :ref:`<data-network-management-data-networks>` guide.

.. rubric:: |prereq|

You must have configured at least one SR-IOV interface on a host with the
target datanetwork \(**datanet-a** or **datanet-b** in the example below\)
assigned to it before creating a **NetworkAttachmentDefinition** referencing
this data network.

.. note::
    The configuration for this SR-IOV interface with either a ``netdevice`` or
    ``vfio`` vf-driver determines whether the **NetworkAttachmentDefinition**
    will be a kernel network device or a DPDK network device.

.. rubric:: |proc|

.. _creating-network-attachment-definitions-steps-unordered-tbf-53z-hjb:

#.  Create a simple SR-IOV network attachment definition file called net1.yaml
    associated with the data network **datanet-a**.

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



    This **NetworkAttachmentDefinition** is valid for both a kernel-based and
    a DPDK \(vfio\) based device.

#.  Create an SR-IOV network attachment.

    -   The following example creates an SR-IOV network attachment definition
        configured for a VLAN with an ID of 2000.

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

    -   The following example creates an SR-IOV network attachment definition
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

.. rubric:: |result|

After SR-IOV interfaces have been provisioned and the hosts labeled and
unlocked, available SR-IOV VF resources are automatically advertised.

They can be referenced in subsequent |prod| operations using the appropriate
**NetworkAttachmentDefinition** name and the following extended resource name:

.. code-block:: none

    intel.com/pci_sriov_net_${DATANETWORK_NAME}

For example, with a network called **datanet-a** the extended resource name
would be:

.. xreflink as shown in |node-doc|:
   :ref:`Provisioning SR-IOV Interfaces using the CLI
   <provisioning-sr-iov-interfaces-using-the-cli>`,

.. code-block:: none

    intel.com/pci_sriov_net_datanet_a

.. _creating-network-attachment-definitions-ul-qjr-vnb-xhb:

-   The extended resource name will convert all dashes \('-'\) in the data
    network name into underscores \('\_'\).

-   SR-IOV enabled interfaces using the netdevice VF driver must be
    administratively and operationally up to be advertised by the SR-IOV
    device plugin.

-   If multiple data networks are assigned to an interface, the VFs
    resources will be shared between pools.

.. seealso::

    :ref:`Using Network Attachment Definitions in a Container
    <using-network-attachment-definitions-in-a-container>`