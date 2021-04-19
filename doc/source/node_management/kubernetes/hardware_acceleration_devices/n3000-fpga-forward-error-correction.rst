
.. edm1592498866757
.. _n3000-fpga-forward-error-correction:

===================================
N3000 FPGA Forward Error Correction
===================================

The Intel N3000 |FPGA| also supports |FEC| capabilities.

The Intel N3000 |FPGA| |FEC| capabilities are exposed as a |PCI| device that
may be used by a |DPDK| enabled container application to perform accelerated 5G
|LDPC| encoding, and decoding operations.

Once the |FPGA| device is programmed, the |FEC| with device ID 0xd8f is
displayed in the list of host devices by running the following command:

.. code-block:: none

    ~(keystone_admin)$ system host-device-list worker-0
    +-------+----------+--------+--------+--------+------------+-------------+----------------------+-----------+---------+
    | name  | address  | class  | vendor | device | class name | vendor name | device name          | numa_node | enabled |
    |       |          | id     | id     | id     |            |             |                      |           |         |
    +-------+----------+--------+--------+--------+------------+-------------+----------------------+-----------+---------+
    | pci_0 | 0000:0c: | 030000 | 102b   | 0522   | VGA        | Matrox      | MGA G200e [Pilot]    | 0         | True    |
    | 000_0 | 00.0     |        |        |        | compatible | Electronics | ServerEngines (SEP1) |           |         |
    | c_00_ |          |        |        |        | controller | Systems Ltd |                      |           |         |
    | 0     |          |        |        |        |            |             |                      |           |         |
    |       |          |        |        |        |            |             |                      |           |         |
    |pci_0  | 0000:b7: | 120000 | 8086   | 0d8f   | Processing |Intel        | Device 0d8f          | 1         | True    |
    |000_b7 | 00.0     |        |        |        |accelerators|Corporation  |                      |           |         |
    |_00_0  |          |        |        |        |            |             |                      |           |         |
    +-------+----------+--------+--------+--------+------------+-------------+----------------------+-----------+---------|

To enable the |FEC| device for |SRIOV| interfaces, it must be modified in order
to set the number of virtual functions \(VF\), and the appropriate userspace
drivers for the physical function \(PF\), and VFs.

The following PF and VF drivers are supported:

.. _n3000-fpga-forward-error-correction-ul-klj-2zh-bmb:

-   PF driver: igb\_uio

-   VF driver: igb\_uio, vfio

For example, run the following commands:

.. _n3000-fpga-forward-error-correction-ol-eks-ld3-bmb:

.. code-block:: none

    ~(keystone_admin)$ system host-lock worker-0
    ~(keystone_admin)$ system host-device-modify <worker> <name> --driver <vf driver> --vf-driver <vf driver> -N <number_of_vfs>
    ~(keystone_admin)$ system host-unlock worker-0

To pass the |FEC| device to a container, the following requests/limits must be
entered into the pod specification:

.. code-block:: none

    intel.com/intel_fpga_fec: <number_of_vfs>

For example:

.. code-block:: yaml

    apiVersion: v1
    kind: Pod
    metadata:
      name: 5gnr
      annotations:
        k8s.v1.cni.cncf.io/networks: '[
                { "name": "sriov1" }
        ]'
    spec:
      restartPolicy: Never
      containers:
      - name: 5gnr
        image: "5gnr-image"
        volumeMounts:
        - mountPath: /mnt/huge-1048576kB
          name: hugepage
        stdin: true
        tty: true
        resources:
          requests:
            memory: 4Gi
            intel.com/intel_fpga_fec: '1'
            intel.com/pci_sriov_net_datanetwork_a: '1'
          limits:
            hugepages-1Gi: 4Gi
            memory: 4Gi
            intel.com/intel_fpga_fec: '1'
            intel.com/pci_sriov_net_datanetwork_a: '1'
      volumes:
      - name: hugepage
        emptyDir:
          medium: HugePages
