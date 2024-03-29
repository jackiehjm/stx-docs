
.. dlq1473346713772
.. _creating-interfaces:

=================
Create interfaces
=================

You can create logical interfaces for use in aggregated Ethernet or
|VLAN|-tagged configurations.

Ethernet network interfaces on hosts are created automatically in |prod|
based on detected hardware. You do not need to create them manually.

However, you can create new ethernet type logical interfaces on top of |SRIOV|
interfaces, which does require manual configuration as described in
:ref:`SR-IOV Port Sharing <sriov-port-sharing>`.

For aggregated Ethernet, where multiple physical interfaces are used to
form a logical interface, or |VLAN| tagging, where a single physical interface
is used for multiple logical interfaces, you can create and assign the
logical interfaces.

To create aggregated Ethernet interfaces,
see :ref:`Configure Aggregated Ethernet Interfaces Using Horizon
<configuring-aggregated-ethernet-interfaces-using-horizon>`.

To create |VLAN| interfaces, see :ref:`Configure VLAN Interfaces Using Horizon
<configuring-vlan-interfaces-using-horizon>`.
