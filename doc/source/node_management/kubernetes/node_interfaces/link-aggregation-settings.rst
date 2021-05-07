
.. rwr1551799513598
.. _link-aggregation-settings:

=========================
Link Aggregation Settings
=========================

|prod| supports several link aggregation
\(|LAG|\) operational modes.

If you select link aggregation \(also known as aggregated Ethernet\) when
configuring the management, cluster-host, or
|OAM| networks, you can choose from the
following operational modes. For more information, refer to the Linux
kernel Ethernet Bonding Driver documentation available online
\(`https://www.kernel.org/doc/Documentation/networking/bonding.txt <https://www.kernel.org/doc/Documentation/networking/bonding.txt>`__\).

.. note::
    Ensure that the |LAG| mode on the corresponding |ToR| switch ports is
    configured to match your selection.

.. _link-aggregation-settings-section-N10050-N10029-N10001:

.. _link-aggregation-settings-table-kb5-rwb-ln:

.. list-table:: Table 1. Supported Link Aggregation Operational Modes
    :widths: 100, 300, 200
    :header-rows: 1

    * - Mode
      - Description
      - Supported Interface Types
    * - Active-backup
        
        \(default value\)
      - Provides fault tolerance. Only one slave interface at a time is
        available. The backup slave interface becomes active only when the
        active slave interface fails.
        
        For platform interfaces \(such as, |OAM|, cluster-host, and management
        interfaces\), the system will select the interface with the lowest
        |MAC| address as the primary interface when all slave interfaces are
        enabled. 
      - Management, |OAM|, cluster-host, and data interface
    * - Balanced XOR
      - Provides aggregated bandwidth and fault tolerance. The same
        slave interface is used for each destination |MAC| address.

        This mode uses the default transmit policy, where the target slave
        interface is determined by calculating the source |MAC| address XOR'd
        with the destination |MAC| address, modulo 2.

        You can modify the transmit policy using the xmit-hash-policy option.
        For details, see :ref:`Table 2
        <link-aggregation-settings-xmit-hash-policy>`. 
      - |OAM|, cluster-host, and data interfaces
    * - 802.3ad
      - Provides aggregated bandwidth and fault tolerance. Implements dynamic 
        link aggregation as per the IEEE 802.3ad |LACP| specification.
        
        You can modify the transmit policy using the xmit-hash-policy option.
        For details, see :ref:`Table 2
        <link-aggregation-settings-xmit-hash-policy>`.

        In order to support |PXE| booting over an aggregated management
        interface, the far-end switch ports must be configured in passive
        |LACP| mode. This is required because the BIOS on the host does not
        support |LACP| and cannot establish a |LAG|, and therefore can use only
        one of the aggregated interfaces during |PXE| boot. If the far-end
        switch is configured to use active |LACP|, it can establish a |LAG| and
        use either interface, potentially resulting in a communication failure
        during the boot process. 
      - Management, |OAM|, cluster-host, and data interface  

.. _link-aggregation-settings-xmit-hash-policy:

.. list-table:: Table 2. xmit-hash-policy Options
    :widths: auto
    :header-rows: 1

    * - Options
      - Description
      - Supported Interface Types 
    * - Layer 2

        \(default value\)
      - Hashes on source and destination |MAC| addresses.
      - |OAM|, internal management, cluster-host, and data interfaces \(worker
        nodes\).  
    * - Layer 2 + 3
      - Hashes on source and destination |MAC| addresses, and on source and
        destination IP addresses.
      - |OAM|, internal management, and cluster-host 
    * - Layer 3 + 4
      - Hashes on source and destination IP addresses, and on source and
        destination ports.
      - |OAM|, internal management, and cluster-host 
  

.. list-table:: Table 3. primary_reselect Options
    :widths: auto
    :header-rows: 1

    * - Options
      - Description
      - Supported Interface Types 
    * - Always

        \(default value\)
      - The primary slave becomes an active slave whenever it comes back up.
      - |OAM|, internal management, and cluster-host  
    * - Better
      - The primary slave becomes active slave whenever it comes back up, if the
        speed and the duplex of the primary slave is better than the speed duplex of the current active slave.
      - |OAM|, internal management, and cluster-host 
    * - Failure
      - The primary slave becomes the active slave only if the current active
        slave fails and the primary slave is up. 
      - |OAM|, internal management, and cluster-host 

-----------------------------------------
LAG Configurations for AIO Duplex Systems
-----------------------------------------
      
For a duplex-direct system set-up, use a |LAG| mode with active-backup for the
management interface when attaching cables between the active and standby
controller nodes. When both interfaces are enabled, the system automatically
selects the primary interface within the |LAG| with the lowest |MAC| address on
the active controller to connect to the primary interface within the |LAG| with
the lowest |MAC| address on the standby controller.
      
The controllers act independently of each other when selecting the primary
interface. Therefore, it is critical that the inter-node cabling is completed
to ensure that both nodes select a primary interface that is attached to the
primary interface of the opposite node. The inter-node management cabling
attachments must be from the lowest |MAC| address to the lowest |MAC| address
for the first cable, and the next lowest |MAC| address to the next lowest |MAC|
address for the second cable. Failure to follow these cabling requirements
will result in a loss of communication between the two nodes.
      
In addition to the special cabling requirements, the node BIOS settings may
need to be configured to ensure that the node attempts to network boot from
the lowest |MAC| address interface within the |LAG|. This may be required only on
systems that enable all hardware interfaces during network booting rather than
only enabling the interface that is currently selected for booting.
      
Configure the cables associated with the management |LAG| so that the primary
interface within the |LAG| with the lowest |MAC| address on the active
controller connects to the primary interface within the |LAG| with the lowest
|MAC| address on standby controller.
      