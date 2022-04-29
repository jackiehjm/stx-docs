
.. oiq1559818630326
.. _adding-data-networks-using-the-cli:

===============================
Add Data Networks Using the CLI
===============================

You can add data networks using the CLI. You can set up flat, VLAN and VXLAN
data networks over physical networks using the command-line interface. The data
networks model the L2 networks that are attached to node data, pci-sriov and
pci-passthrough interface.

.. rubric:: |proc|

.. _adding-data-networks-using-the-cli-steps-ek5-4fs-hkb:

-   To create a data network using the CLI, use the following command.

    .. code-block:: none

        ~(keystone_admin)$ system datanetwork-add -d <description> -m <mtu> -p <port> -g <group> -t <ttl> -M <mode> <name> <type>

    where

    **<description>**
        A description of the data network.

    **<mtu>**
        The |MTU| of the data network.

        .. note::

            To attach to the data network, data interfaces must be configured
            with an equal or larger |MTU|.

            This is not used by the Kubernetes |SRIOV| plugin. In order to
            address the |MTU| in Kubernetes, the network attached definiition
            needs to use the tuning plugin. For more details, see the examples
            in :ref:`Create Network Attachment Definitions
            <creating-network-attachment-definitions>`.

    **<port>**
        The port of the data network.

    **<group>**
        The multicast group of the data network.

    **<ttl>**
        The time-to-live of the data network.

    **<mode>**
        For networks of <type> vxlan only, mode can be either **dynamic** or
        **static**.

        If set to **dynamic**, <group> must also be specified.

    **<name>**
        The name assigned to the data network.

    **<type>**
        The type of data network to be created \(**flat**, **vlan**, or
        **vxlan**\)

        .. note::
            **vxlan** is only applicable to |prod-os|.

    For example, to add a VLAN data network named datanet-a:

    .. code-block:: none

        ~(keystone_admin)$ system datanetwork-add datanet-a vlan
        +--------------+--------------------------------------+
        | Property     | Value                                |
        +--------------+--------------------------------------+
        | id           | 2                                    |
        | uuid         | 104071a4-1c26-4383-ba07-72e05316d540 |
        | name         | datanet-a                            |
        | network_type | vlan                                 |
        | mtu          | 1500                                 |
        | description  | None                                 |
        +--------------+--------------------------------------+


.. rubric:: |postreq|

For the |prod-os| application, after creating a data network of the VLAN or
VXLAN type, you can assign one or more segmentation ranges consisting of a set
of consecutive VLAN IDs \(for VLANs\) or VNIs \(for VXLANs\) using the
:command:`openstack network segment range create` command. Segmentation ranges
are required in order to set up project networks.

.. note::
    Segmentation ranges are not required in order to attach interfaces and
    unlock openstack-compute labeled worker nodes.