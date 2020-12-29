
.. buu1552671069267
.. _about-ethernet-interfaces:

=========================
About Ethernet Interfaces
=========================

Ethernet interfaces, both physical and virtual, play a key role in the overall
performance of the virtualized network. It is important to understand the
available interface types, their configuration options, and their impact on
network design.

.. _about-ethernet-interfaces-section-N1006F-N1001A-N10001:

-----------------------
About LAG/AE interfaces
-----------------------

You can use |LAG| for Ethernet interfaces. |prod| supports up to four ports in
a |LAG| group.

Ethernet interfaces in a |LAG| group can be attached either to the same L2
switch, or to multiple switches in a redundant configuration. For more
information about L2 switch configurations, see |planning-doc|: :ref:`L2 Access
Switches <l2-access-switches>`.

.. xbooklink For information about the different |LAG| modes, see |node-doc|: :ref:`Link Aggregation Settings <link-aggregation-settings>`.
