
.. jow1404333731990
.. _ethernet-interfaces:

===================
Ethernet Interfaces
===================

Ethernet interfaces, both physical and virtual, play a key role in the overall
performance of the virtualized network. Therefore, it is important to
understand the available interface types, their configuration options, and
their impact on network design.

.. _ethernet-interfaces-section-N1006F-N1001A-N10001:

-----------------------
About LAG/AE Interfaces
-----------------------

You can use |LAG| for Ethernet interfaces. |prod-os| supports up to four ports
in a |LAG| group.

Ethernet interfaces in a |LAG| group can be attached either to the same L2
switch, or to multiple switches in a redundant configuration. For more
information about L2 switch configurations, see :ref:`L2 Access Switches
<network-planning-l2-access-switches>`. For information about the different
|LAG| modes, see |node-doc|: :ref:`Link Aggregation Settings
<link-aggregation-settings>`.

.. seealso::

   :ref:`Ethernet Interface Configuration <ethernet-interface-configuration>`

   :ref:`The Ethernet MTU <the-ethernet-mtu>`

   :ref:`Shared (VLAN or Multi-Netted) Ethernet Interfaces
   <network-planning-shared-vlan-or-multi-netted-ethernet-interfaces>`
