
.. drb1511538596277
.. _static-vxlan:

============
Static VXLAN
============

The static unicast mode relies on the mapping of neutron ports to compute nodes
to receive the packet in order to reach the |VM|.

.. only:: starlingx

    In this mode there is no multicast addressing and no multicast packets are
    sent from the compute nodes, neither is there any learning. In contrast to
    the dynamic |VXLAN| mode, any packets destined to unknown MAC addresses are
    dropped. To ensure that there are no unknown endpoints the system examines
    the neutron port DB and gathers the list of mappings between port |MAC|/IP
    addresses and the hostname on which they reside.

.. only:: partner

    .. include:: /_includes/static-vxlan.rest
        :start-after: vswitch-text-1-begin
        :end-before:  vswitch-text-1-end


Static |VXLAN| is limited to use on one data network. If configured, it must be
enabled on all OpenStack compute nodes.

.. figure:: /shared/figures/datanet/oeg1510005898965.png

    `Static Endpoint Distribution`

.. note::
    In the static mode there is no dynamic endpoint learning. This means that
    if a node does not have an entry for some destination |MAC| address it will
    not create an entry even if it receives a packet from that device.

.. _static-vxlan-section-N1006B-N1001F-N10001:

------------------------------------------------
Workflow to Configure Static VXLAN Data Networks
------------------------------------------------

Use the following workflow to create static VXLAN data networks and add
segmentation ranges using the |CLI|.

.. _static-vxlan-ol-bpj-dlb-1cb:

#.  Create a |VXLAN| data network, see :ref:`Adding Data Networks Using the CLI
    <adding-data-networks-using-the-cli>`.

#.  Add segmentation ranges to static |VXLAN| data networks, see :ref:`Adding
    Segmentation Ranges Using the CLI <adding-segmentation-ranges-using-the-cli>`.

#.  Establish routes between the hosts, see :ref:`Adding and Maintaining Routes
    for a VXLAN Network <adding-and-maintaining-routes-for-a-vxlan-network>`.

For more information on the differences between the dynamic and static |VXLAN|
modes, see :ref:`Differences Between Dynamic and Static VXLAN Modes
<differences-between-dynamic-and-static-vxlan-modes>`.
