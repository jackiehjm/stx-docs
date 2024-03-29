
.. svs1552672428539
.. _verified-commercial-hardware:

=======================================
Kubernetes Verified Commercial Hardware
=======================================

Supported hardware components for use with |prod| are listed here.

.. .. only:: starlingx
..
..    For more information on the supported hardware platforms and server
..    configurations validated for |prod-long|, please refer to
..    :ref:`Self-Validated and Certified Servers <cert-hw-details>`.

.. only:: partner

   For more information on the verified and certified hardware components for
   hardware platforms and server configurations validated for |prod-long|,
   please refer to
   https://www.windriver.com/studio/operator/self-validated-and-certified-hosts

.. _verified-commercial-hardware-verified-components:

.. table:: Table 1. Verified Components
    :widths: auto

    +--------------------------------------------------------------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
    | Component                                                                      | Approved Hardware                                                                                                                                                                  |
    +================================================================================+====================================================================================================================================================================================+
    | Disk Controllers                                                               | -   Dell PowerEdge RAID Controllers (PERC).                                                                                                                                        |
    |                                                                                |                                                                                                                                                                                    |
    |                                                                                | -   Generalize to HPE Smart Array Controllers                                                                                                                                      |
    |                                                                                |                                                                                                                                                                                    |
    |                                                                                | -   LSI 2308                                                                                                                                                                       |
    |                                                                                |                                                                                                                                                                                    |
    |                                                                                | -   LSI 3008                                                                                                                                                                       |
    +--------------------------------------------------------------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
    | NICs Verified for PXE Boot, Management, and OAM Networks                       | -   Intel I210 1G                                                                                                                                                                  |
    |                                                                                |                                                                                                                                                                                    |
    |                                                                                | -   Intel I350 1G                                                                                                                                                                  |
    |                                                                                |                                                                                                                                                                                    |
    |                                                                                | -   Intel 82599 10G                                                                                                                                                                |
    |                                                                                |                                                                                                                                                                                    |
    |                                                                                | -   Intel X540 10G                                                                                                                                                                 |
    |                                                                                |                                                                                                                                                                                    |
    |                                                                                | -   Intel X710/XL710/X722 10G                                                                                                                                                      |
    |                                                                                |                                                                                                                                                                                    |
    |                                                                                | -   Intel XXV710 25G                                                                                                                                                               |
    |                                                                                |                                                                                                                                                                                    |
    |                                                                                | -   Intel E810 25G/100G                                                                                                                                                            |
    |                                                                                |                                                                                                                                                                                    |
    |                                                                                | -   Emulex XE102 10G                                                                                                                                                               |
    |                                                                                |                                                                                                                                                                                    |
    |                                                                                | -   Broadcom BCM5719 1G                                                                                                                                                            |
    |                                                                                |                                                                                                                                                                                    |
    |                                                                                | -   Broadcom BCM57810 10G                                                                                                                                                          |
    |                                                                                |                                                                                                                                                                                    |
    |                                                                                | -   Broadcom 57504 100G                                                                                                                                                            |
    |                                                                                |                                                                                                                                                                                    |
    |                                                                                | -   NVIDIA Mellanox MCX4121A-ACAT (ConnectX-4) Lx 10G/25G                                                                                                                          |
    |                                                                                |                                                                                                                                                                                    |
    |                                                                                | -   Silicom TimeSync STS2                                                                                                                                                          |
    |                                                                                |                                                                                                                                                                                    |
    +--------------------------------------------------------------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
    | NICs Verified for SR-IOV                                                       | -   Intel 82599 10G                                                                                                                                                                |
    |                                                                                |                                                                                                                                                                                    |
    |                                                                                | -   Intel X710/XL710/X722 10G                                                                                                                                                      |
    |                                                                                |                                                                                                                                                                                    |
    |                                                                                | -   Intel XXV710 25G                                                                                                                                                               |
    |                                                                                |                                                                                                                                                                                    |
    |                                                                                | -   Intel E810 25G/100G                                                                                                                                                            |
    |                                                                                |                                                                                                                                                                                    |
    |                                                                                | -   NVIDIA Mellanox MCX4121A-ACAT (ConnectX-4) 10G/25G                                                                                                                             |
    |                                                                                |                                                                                                                                                                                    |
    |                                                                                | -   NVIDIA Mellanox MCX512A-ACAT (ConnectX-5) 100G                                                                                                                                 |
    |                                                                                |                                                                                                                                                                                    |
    |                                                                                | -   NVIDIA Mellanox MCX623106AC-CDAT, MCX623106AN-CDAT (ConnectX-6) 100G                                                                                                           |
    |                                                                                |                                                                                                                                                                                    |
    |                                                                                | -   Broadcom 57504                                                                                                                                                                 |
    |                                                                                |                                                                                                                                                                                    |
    |                                                                                | -   Silicom TimeSync STS2                                                                                                                                                          |
    |                                                                                |                                                                                                                                                                                    |
    |                                                                                | .. note::                                                                                                                                                                          |
    |                                                                                |     For Mellanox NICs, SR-IOV must be enabled in the NIC firmware.                                                                                                                 |
    |                                                                                |                                                                                                                                                                                    |
    +--------------------------------------------------------------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
    | NIC for High-precision timing synchronization with IEEE 1588 PTP               | -   Intel X710                                                                                                                                                                     |
    |                                                                                |                                                                                                                                                                                    |
    |                                                                                | -   Intel E810-XXVDA4                                                                                                                                                              |
    |                                                                                |                                                                                                                                                                                    |
    |                                                                                | -   Broadcom 57504 100G                                                                                                                                                            |
    |                                                                                |                                                                                                                                                                                    |
    |                                                                                | -   NVIDIA Mellanox MCX512A-ACAT (ConnectX-5) 100G                                                                                                                                 |
    |                                                                                |                                                                                                                                                                                    |
    |                                                                                | -   NVIDIA Mellanox MCX623106AC-CDAT, MCX623106AN-CDAT (ConnectX-6) 100G                                                                                                           |
    |                                                                                |                                                                                                                                                                                    |
    |                                                                                | -   Silicom TimeSync STS2                                                                                                                                                          |
    |                                                                                |                                                                                                                                                                                    |
    |                                                                                | .. note::                                                                                                                                                                          |
    |                                                                                |     It is recommended to configure systems to use the realtime kernel when using IEEE 1588 PTP with Intel E810 series NICs using the ice driver.                                   |
    |                                                                                |                                                                                                                                                                                    |
    |                                                                                |     The standard kernel cannot provide any guarantees for ice driver thread priority and scheduling which can result in degraded PTP timing accuracy.                              |
    |                                                                                |                                                                                                                                                                                    |
    +--------------------------------------------------------------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
    | NIC for High-precision timing synchronization with IEEE                        | -   Intel E810-XXVDA4T 25G                                                                                                                                                         |
    | 1588 PTP, SyncE and GNSS                                                       |                                                                                                                                                                                    |
    |                                                                                |                                                                                                                                                                                    |
    |                                                                                | -   Intel E810-CQDA2T 100G                                                                                                                                                         |
    |                                                                                |                                                                                                                                                                                    |
    |                                                                                | .. note::                                                                                                                                                                          |
    |                                                                                |     It is recommended to configure systems to use the realtime kernel when using IEEE 1588 PTP with Intel E810 series NICs using the ice driver.                                   |
    |                                                                                |                                                                                                                                                                                    |
    |                                                                                |     The standard kernel cannot provide any guarantees for ice driver thread priority and scheduling which can result in degraded PTP timing accuracy.                              |
    |                                                                                |                                                                                                                                                                                    |
    +--------------------------------------------------------------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
    | Hardware Accelerator Devices Verified for PCI SR-IOV Access                    | -   ACC100 Adapter - SRIOV only                                                                                                                                                    |
    |                                                                                |                                                                                                                                                                                    |
    |                                                                                | -   Intel ACC200 Integrated Adapter of 4th Gen Intel Xeon Scalable Processor.                                                                                                      |
    |                                                                                |                                                                                                                                                                                    |
    |                                                                                | -   Maclaren Summit Intel® vRAN Accelerator ACC100 ; see `<https://networkbuilders.intel.com/solutionslibrary/virtual-ran-vran-with-hardware-acceleration?wapkw=acc100>`__         |
    |                                                                                |                                                                                                                                                                                    |
    +--------------------------------------------------------------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
    | GPUs Verified for PCI Passthrough                                              | -   NVIDIA Corporation: VGA compatible controller - GM204GL (Tesla M60 rev a1)                                                                                                     |
    |                                                                                |                                                                                                                                                                                    |
    +--------------------------------------------------------------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
    | Board Management Controllers                                                   | -   HPE iLO4                                                                                                                                                                       |
    |                                                                                |                                                                                                                                                                                    |
    |                                                                                | -   HPE iLO5                                                                                                                                                                       |
    |                                                                                |                                                                                                                                                                                    |
    |                                                                                | -   Quanta                                                                                                                                                                         |
    |                                                                                |                                                                                                                                                                                    |
    |                                                                                | -   Dell iDRAC 9                                                                                                                                                                   |
    |                                                                                |                                                                                                                                                                                    |
    |                                                                                | -   MegaRAC SP-x 0.26.0                                                                                                                                                            |
    |                                                                                |                                                                                                                                                                                    |
    +--------------------------------------------------------------------------------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

.. only:: partner

   **FlexRAN 23.07: Verified CPU / NICs / Accelerators**

   -  Intel® vRAN Accelerator ACC100

      -  3rd Generation Intel® Xeon® Scalable Processor; Intel E810-XXVDA4T

   -  Intel® ACC200 Integrated Adapter of 4th Gen Intel Xeon Scalable Processor

      -  4th Generation Intel® Xeon® Scalable Processor; Intel E810-XXVDA4

   .. note::                                                                                                                                                                   |

       FlexRAN 23.07 has been validated and tested with |prod-long| for lab usage
       only.

.. _cert-hw-details:

.. .. only:: starlingx
..
..    The following table provides additional information about currently tested
..    and supported hardware. Click the icon in the **Certified** column to see
..    additional details.
..
..    **Table 2. Self-Validated and Certified Servers**
..
..    .. raw:: html
..       :url: https://www.windriver.com/studio/operator/self-validated-and-certified-hosts

..   .. raw:: html
..
..      <script>
..            document.getElementById("body").style.margin-left = -50px;
..      </script>
