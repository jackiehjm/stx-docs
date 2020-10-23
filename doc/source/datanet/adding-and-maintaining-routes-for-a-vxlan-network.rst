
.. jow1425584215069
.. _adding-and-maintaining-routes-for-a-vxlan-network:

===========================================
Add and Maintain Routes for a VXLAN Network
===========================================

You can add or delete routing table entries for hosts on a VXLAN network using
the CLI.

.. rubric:: |prereq|

The worker node must be locked.

.. rubric:: |proc|

To add routes, use the following command.

.. code-block:: none

    ~(keystone_admin)]$ system host-route-add <node> <ifname> <network> <prefix> <gateway> <metric>

where

**node**
    is the name or UUID of the worker node

**ifname**
    is the name of the interface

**network**
    is an IPv4 or IPv6 network address

**prefix**
    is the netmask length for the network address

**gateway**
    is the default gateway

**metric**
    is the cost of the route \(the number of hops\)

To delete routes, use the following command.

.. code-block:: none

    ~(keystone_admin)]$ system host-route-delete <uuid> <ifname> <network> <prefix> <gateway> <metric>

where **uuid** is the UUID of the route to be deleted.

To list existing routes, including their UUIDs, use the following command.

.. code-block:: none

    ~(keystone_admin)]$ system host-route-list worker-0