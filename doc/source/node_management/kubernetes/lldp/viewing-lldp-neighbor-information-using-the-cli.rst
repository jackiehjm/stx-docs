
.. ndz1552675759449
.. _viewing-lldp-neighbor-information-using-the-cli:

============================================
View LLDP Neighbor Information Using the CLI
============================================

You can use CLI commands to view information about |LLDP| neighbors.

The following commands are available for viewing |LLDP| neighbors:

.. _viewing-lldp-neighbor-information-using-the-cli-section-N10038-N1002C-N10001:

-  To see the |LLDP| neighbors of a host:

   .. code-block:: none

      $ system host-lldp-neighbor-list <host name|id>

.. _viewing-lldp-neighbor-information-using-the-cli-section-N1004F-N1002C-N10001:

-  To view |LLDP| neighbor information:

   .. code-block:: none

      $ system lldp-neighbor-show <neighbor uuid>

.. _viewing-lldp-neighbor-information-using-the-cli-section-N10066-N1002C-N10001:

.. rubric:: |eg|

The following example show the usage for these commands.

#.  Use :command:`system host-lldp-neighbor-list` to get the neighbor IDs.

    .. code-block:: none

        $ system host-lldp-neighbor-list controller-0
        +------------+------------+----------+----------+-------------------+--------------------------------------+--------------------+
        | uuid       | local_port | remote_p | chassis_ | system_name       | system_description                   | management_address |
        |            |            | ort      | id       |                   |                                      |                    |
        +------------+------------+----------+----------+-------------------+--------------------------------------+--------------------+
        | d74d9648.. | enp11s0f0  | Gi1/0/18 | 18:33:9d | yow-cisco-c5u44.  | Cisco IOS Software, C2960S Software  | 128.224.148.226    |
        |            |            |          | :b1:91:  | wrs.com           | (C2960S-UNIVERSALK9-M), Version 15.  |                    |
        |            |            |          | 80       |                   | 0(2)SE10a, RELEASE SOFTWARE (fc3).   |                    |
        |            |            |          |          |                   | Technical Support: http://www.cisco. |                    |
        |            |            |          |          |                   | com/techsupport. Copyright (c)       |                    |
        |            |            |          |          |                   | 1986-2016 by Cisco Systems, Inc..    |                    |
        |            |            |          |          |                   | Compiled Thu 03-Nov-16 13:52 by      |                    |
        |            |            |          |          |                   | prod_rel_team                        |                    |
        |            |            |          |          |                   |                                      |                    |
        | 472500a0.. | ens4f0     | xe7      | 00:08:a2 | yow-cgcs-quanta-1 | yow-cgcs-quanta-1                    | 10.1.1.1           |
        |            |            |          | :08:fc:  |                   | ...                                  | ...                |
        |            |            |          | 5b       |                   |                                      |                    |
        |            |            |          |          |                   |                                      |                    |
        +------------+------------+----------+----------+-------------------+--------------------------------------+--------------------+

#.  Use the IDs with the :command:`system lldp-neighbor-show` command to get
    details for a specific |LLDP| neighbor.

    .. code-block:: none

        $ system lldp-neighbor-show d74d9648-e878-47e7-918e-80f5f6ec6146

        +---------------------+------------------------------------------------------+
        | Property            | Value                                                |
        +---------------------+------------------------------------------------------+
        | uuid                | d74d9648-e878-47e7-918e-80f5f6ec6146                 |
        | host_uuid           | 60748903-9b35-4424-abad-89d0a1acb8ed                 |
        | created_at          | 2019-10-21T19:22:34.812462+00:00                     |
        | updated_at          | None                                                 |
        | uuid                | d74d9648-e878-47e7-918e-80f5f6ec6146                 |
        | local_port          | enp11s0f0                                            |
        | chassis_id          | 18:33:9d:b1:91:80                                    |
        | port_identifier     | Gi1/0/18                                             |
        | ttl                 | 120                                                  |
        | msap                | 18:33:9d:b1:91:80,Gi1/0/18                           |
        | system_description  | Cisco IOS Software, C2960S Software                  |
        |                     |(C2960S-UNIVERSALK9-M), Version 15.0(2)SE10a,         |
        |                     | RELEASE SOFTWARE (fc3)                               |
        |                     | Technical Support: http://www.cisco.com/techsupport  |
        |                     | Copyright (c) 1986-2016 by Cisco Systems, Inc.       |
        |                     | Compiled Thu 03-Nov-16 13:52 by prod_rel_team        |
        | system_name         | yow-cisco-c5u44.wrs.com                              |
        | system_capabilities | bridge                                               |
        | management_address  | 128.224.148.226                                      |
        | port_description    | GigabitEthernet1/0/18                                |
        | dot1_lag            | capable=y,enabled=n                                  |
        | dot1_port_vid       | 103                                                  |
        | dot1_vlan_names     |                                                      |
        | dot1_proto_vids     | None                                                 |
        | dot1_proto_ids      | None                                                 |
        | dot3_mac_status     | auto-negotiation-capable=y,auto-negotiation-enabled=y|
        |                     | ,10base-tfd, 100base-txfd, 1000base-tfd              |
        | dot3_max_frame      | None                                                 |
        +---------------------+------------------------------------------------------+
