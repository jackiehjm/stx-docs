
.. pyc1552675782952
.. _viewing-lldp-information-using-horizon:

===================================
View LLDP Information Using Horizon
===================================

You can view |LLDP| information on
the **LLDP** tab in the Host Details window.

.. rubric:: |proc|

#.  Select **Admin** \> **Platform** \> **Host Inventory**.

#.  Select the **Hosts** tab.

#.  Click the name of the host for which you want to view
    |LLDP| information in
    the **Host Name** column.

    The Host Details screen appears.

#.  Select the **LLDP** tab to view the
    |LLDP| information for this host.

    The **LLDP** tab provides the following information about each
    |LLDP|-enabled neighbor device:


    .. table:: Table 1. LLDP Details
        :widths: auto

        +------------------+------------------------------------------------------------------------------------------------+
        | Field            | Description                                                                                    |
        +==================+================================================================================================+
        | Name             | The name of the local port connected to the |LLDP| neighbor.                                   |
        +------------------+------------------------------------------------------------------------------------------------+
        | Neighbor         | The port identifier of the |LLDP| neighbor port.                                               |
        +------------------+------------------------------------------------------------------------------------------------+
        | Port Description | The port description of the |LLDP| neighbor port.                                              |
        +------------------+------------------------------------------------------------------------------------------------+
        | Time To Live     | The time until the neighbor is timed out (if no further |LLDP| frames are received from it).   |
        +------------------+------------------------------------------------------------------------------------------------+
        | System Name      | The system name of the neighbor.                                                               |
        +------------------+------------------------------------------------------------------------------------------------+
        | Max Frame Size   | The maximum frame size supported by the neighbor port.                                         |
        +------------------+------------------------------------------------------------------------------------------------+

    If the neighbor is sending additional information, the information is
    shown when you click on the port to which the neighbor is connected. The
    extra information can include zero or more of the following items:

    .. table:: Table 2. LLDP Port Details
        :widths: auto

        +--------------------------+-------------------------------------------------------------------------------------------------------------------------------+
        | Field                    | Description                                                                                                                   |
        +==========================+===============================================================================================================================+
        | Chassis                  | The chassis identifier of the neighbor. Usually a MAC address, IP address, or locally assigned name identifying the neighbor. |
        +--------------------------+-------------------------------------------------------------------------------------------------------------------------------+
        | MAC Service Access Point | A concatenation of the chassis identifier and port identifier, uniquely identifying the particular neighbor device/port.      |
        +--------------------------+-------------------------------------------------------------------------------------------------------------------------------+
        | System Capabilities      | The system capabilities of the neighbor. For example, bridging, routing enabled.                                              |
        +--------------------------+-------------------------------------------------------------------------------------------------------------------------------+
        | Management Address       | The management address of the neighbor device.                                                                                |
        +--------------------------+-------------------------------------------------------------------------------------------------------------------------------+
        | Dot1 Link Aggregation    | The 802.1 link aggregation status of the neighbor.                                                                            |
        +--------------------------+-------------------------------------------------------------------------------------------------------------------------------+
        | Dot1 Proto Ids           | The 802.1 protocol identifiers supported by the neighbor.                                                                     |
        +--------------------------+-------------------------------------------------------------------------------------------------------------------------------+
        | Dot1 Proto Vids          | The 802.1 port and protocol VLAN identifiers supported by the neighbor.                                                       |
        +--------------------------+-------------------------------------------------------------------------------------------------------------------------------+
        | Dot1 Vid Digest          | The 802.1 VLAN identifier digest of the neighbor.                                                                             |
        +--------------------------+-------------------------------------------------------------------------------------------------------------------------------+
        | Dot1 Management Vid      | The 802.1 management VLAN identifier of the neighbor.                                                                         |
        +--------------------------+-------------------------------------------------------------------------------------------------------------------------------+
        | Dot1 Vlan Names          | The 802.1 VLAN names of the neighbor port.                                                                                    |
        +--------------------------+-------------------------------------------------------------------------------------------------------------------------------+
        | Dot3 Power MDI           | The 802.3 power MDI status of the neighbor.                                                                                   |
        +--------------------------+-------------------------------------------------------------------------------------------------------------------------------+
        | Dot3 MAC status          | The 802.3 MAC status of the neighbor port.                                                                                    |
        +--------------------------+-------------------------------------------------------------------------------------------------------------------------------+
