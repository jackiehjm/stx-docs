
.. ikn1516739312384
.. _installation-and-resource-planning-verified-commercial-hardware:

======================================
OpenStack Verified Commercial Hardware
======================================

Verified and approved hardware components for use with |prod-os| are listed
here.

For more information on the verified and certified hardware components for
hardware platforms and server configurations validated for |prod-os|,
please refer to
https://www.windriver.com/studio/operator/self-validated-and-certified-hosts.

.. _installation-and-resource-planning-verified-commercial-hardware-verified-components:


.. list-table::
    :widths: 6 25
    :header-rows: 1

    * - **Component**
      - **Approved Hardware**
    * - Hardware Platforms
      - -   Hewlett Packard Enterprise
            - HPE ProLiant DL360 Gen10 Server
            - HPE ProLiant DL380p Gen8 Server
        - Dell
          - Dell PowerEdge R720
    * - Supported Reference Platforms
      - - Intel Iron Pass
        - Intel Wildcat Pass
    * - NICs Verified for PXE Boot, Management, and OAM Networks
      - - Intel I350 (Powerville) 1G
        - Intel 82599 (Niantic) 10G
        - Intel X540 10G
        - Intel X710/XL710 (Fortville) 10G
        - Broadcom BCM5719 1G
        - Broadcom BCM5720 1G
        - Broadcom BCM57810 10G
    * - NICs Verified for Data Interfaces
      - The following NICs are supported:

        - Intel 82599 (Niantic) 10G

        - Intel X710/XL710 (Fortville) 10 G

        - Mellanox Technologies

          - MT27710 Family (ConnectX-4) 10G/25G

          - MT27700 Family (ConnectX-4) 40G

    * - PCI passthrough or PCI SR-IOV NICs
      - - Intel 82599 (Niantic) 10 G
        - Intel X710/XL710 (Fortville) 10G

        .. note::
            The maximum number of VFs per hosted application instance, across all PCI devices, is 32.

            For example, a hardware encryption hosted application can be
            launched with virtio interfaces and 32 QAT VFs. However, a hardware
            encryption hosted application with an SR-IOV network interface
            (with 1 VF) can only be launched with 31 VFs.

        .. note::
            Dual-use configuration (PCI passthrough or PCI SR-IOV on the same
            interface) is supported for Fortville NICs only.

    * - .. only:: partner

            .. include:: /_includes/installation-and-resource-planning-verified-commercial-hardware.rest
                :start-after: vgpu-content-1-begin
                :end-before: vgpu-content-1-end
      - .. only:: partner

            .. include:: /_includes/installation-and-resource-planning-verified-commercial-hardware.rest
                :start-after: vgpu-content-2-begin
                :end-before: vgpu-content-2-end

    * - .. only:: partner

            .. include:: /_includes/installation-and-resource-planning-verified-commercial-hardware.rest
                :start-after: vgpu-content-3-begin
                :end-before: vgpu-content-3-end

      - .. only:: partner

            .. include:: /_includes/installation-and-resource-planning-verified-commercial-hardware.rest
                :start-after: vgpu-content-4-begin
                :end-before: vgpu-content-4-end



.. seealso::

  :ref:`Kubernetes Verified Commercial Hardware <verified-commercial-hardware>`

.. include:: /_includes/installation-and-resource-planning-verified-commercial-hardware.rest
