
.. yfz1466026434733
.. _virtual-or-cloud-networks:

=========================
Virtual or Cloud Networks
=========================

In addition to the physical networks used to connect the |prod-os| hosts,
|prod-os| uses virtual networks to support |VMs|.

Virtual networks, which include data networks and project networks, are defined
and implemented internally. They are connected to system hosts and to the
outside world using data (physical) networks attached to data interfaces on
compute nodes.

Each data network supports one or more data networks, which may be implemented
as a flat, |VLAN|, or |VXLAN| network. The data networks in turn support
project networks, which are allocated for use by different projects and their
|VMs|, and which can be isolated from one another.

.. seealso::

   :ref:`Overview <data-networks-overview>`

   :ref:`Project Networks <project-networks>`

   :ref:`Project Network Planning <project-network-planning>`
