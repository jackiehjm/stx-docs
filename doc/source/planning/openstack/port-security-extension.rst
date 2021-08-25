
.. hjx1519399837056
.. _port-security-extension:

=======================
Port Security Extension
=======================

|prod-os| supports the Neutron port security extension for disabling IP address
filtering at the project network or |VM| port level.

By default, IP address filtering is enabled on all ports and networks, subject
to security group settings. You can override the default IP address filtering
rules that apply to a |VM| by enabling the Neutron port security extension
driver, and then disabling port security on individual project networks or
ports. For example, you can configure a |VM| to allow packet routing by
enabling the port security extension driver, and then disabling port security
on the |VM| port used for routing.

Disabling port security on a network also disables |MAC| address filtering on the
network.

By default, the port security extension driver is disabled.

.. only:: partner

   .. include:: /_includes/port-security-extension.rest
