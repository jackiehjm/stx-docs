
.. pis1592390220404
.. _n3000-overview:

===================
N3000 FPGA Overview
===================

The N3000 |FPGA| |PAC| has two Intel XL710 |NICs|, memory and an Intel |FPGA|.

|prod-long| discovers and inventories the device as a |NIC|, with the XL710
ports available in the host port list and host interface list. Containers
wanting to leverage the |FPGA| bind to an |SRIOV| VF interface of the N3000
|NIC| port by creating and requesting an |SRIOV|
**NetworkAttachmentDefinition** resource for a Data Network attached
to the N3000 |NIC|. See the post-requisites at the end of this procedure for
more information.

The |NICs| on-board the N3000 |PAC| will have |PCI| device ID 0x0d58 for 25G
configurations or 0x0cf8 for 10G configurations.

Use the Intel N3000 |PAC| to take advantage of the hardware acceleration
provided by |FPGA| hardware from within containers to improve container
performance across a cluster.

The Intel N3000 |FPGA| also supports |FEC| capabilities that are exposed as a
|PCI| device that may be used by a |DPDK| enabled container application to
perform accelerated 5G |LDPC| encoding and decoding operations.

.. seealso::
   :ref:`N3000 FPGA Forward Error Correction
   <n3000-fpga-forward-error-correction>`
