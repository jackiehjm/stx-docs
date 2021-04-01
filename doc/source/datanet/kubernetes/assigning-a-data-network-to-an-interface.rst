
.. riw1559818822179
.. _assigning-a-data-network-to-an-interface:

=====================================
Assign a Data Network to an Interface
=====================================

In order to associate the L2 Network definition of a Data Network with a
physical network, the Data Network must be mapped to an Ethernet or Aggregated
Ethernet interface on a compute node.

The command for performing the mapping has the format:

:command:`system interface‐datanetwork‐assign` <compute> <interface\_uuid>
<datanetwork\_uuid>