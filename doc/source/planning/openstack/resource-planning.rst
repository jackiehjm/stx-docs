
.. jow1454003783557
.. _resource-planning:

==================
Resource Placement
==================

.. only:: starlingx

    For |VMs| requiring maximum determinism and throughput, the |VM| must be
    placed in the same NUMA node as all of its resources, including |VM|
    memory, |NICs|, and any other resource such as |SRIOV| or |PCI|-Passthrough
    devices.

    VNF 1 and VNF 2 in the example figure are examples of |VMs| deployed for
    maximum throughput with |SRIOV|.

.. only:: starlingx

    A |VM| such as VNF 6 in NUMA-REF will not have the same performance as VNF
    1 and VNF 2. There are multiple ways to maximize performance for VNF 6 in
    this case:

.. From NUMA-REF
.. xbooklink :ref:`VM scheduling and placement - NUMA
   architecture <vm-scheduling-and-placement-numa-architecture>`

.. only:: partner

    .. include:: /_includes/resource-planning.rest
        :start-after: avs-text-1-begin
        :end-before:  avs-text-2-end

.. only:: partner

    .. include:: /_includes/resource-planning.rest
        :start-after: avs-text-2-begin
        :end-before:  avs-text-2-end


.. _resource-planning-ul-tcb-ssz-55:

.. only:: partner

    .. include:: /_includes/resource-planning.rest
        :start-after: avs-text-1-end


If accessing |PCIe| devices directly from a |VM| using |PCI|-Passthrough or
|SRIOV|, maximum performance can only be achieved by pinning the |VM| cores
to the same NUMA node as the |PCIe| device. For example, VNF1 and VNF2
will have optimum SR-IOV performance if deployed on NUMA node 0 and VNF6
will have maximum |PCI|-Passthrough performance if deployed in NUMA node 1.
Options for controlling access to |PCIe| devices are:


.. _resource-planning-ul-ogh-xsz-55:

-   Use pci_numa_affinity flavor extra specs to force VNF6 to be scheduled on
    NUMA nodes where the |PCI| device is running. This is the recommended option
    because it does not require prior knowledge of which socket a |PCI| device
    resides on. The affinity may be **strict** or **prefer**:


-   **Strict** affinity guarantees scheduling on the same NUMA node as a
    |PCIe| Device or the VM will not be scheduled.

-   **Prefer** affinity uses best effort so it will only schedule the VM on
    a NUMA node if no NUMA nodes with that |PCIe| device are available. Note
    that prefer mode does not provide the same performance or determinism
    guarantees as strict, but may be good enough for some applications.


-   Pin the VM to the NUMA node 0 with the |PCI| device using flavor extra
    specs or image properties. This will force the scheduler to schedule the VM
    on NUMA node 0. However, this requires knowledge of which cores the
    applicable |PCIe| devices run on and does not work well unless all nodes
    have that type of |PCIe| node attached to the same socket.


