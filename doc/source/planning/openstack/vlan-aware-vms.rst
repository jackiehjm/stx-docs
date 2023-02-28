
.. psa1428328539397
.. _vlan-aware-vms:

==============
VLAN Aware VMs
==============

|prod-os| supports OpenStack |VLAN| Aware |VMs| (also known as port
trunking), which adds |VLAN| support for |VM| interfaces.

For more information about |VLAN| Aware |VMs|, consult the public OpenStack
documentation at,
`http://specs.openstack.org/openstack/neutron-specs/specs/newton/vlan-aware-vms.html
<http://specs.openstack.org/openstack/neutron-specs/specs/newton/vlan-aware-vms.html>`__.

Alternatively, project networks can be configured to use |VLAN| Transparent
mode, in which |VLAN| tagged guest packets are encapsulated within a data
network segment without removing or modifying the guest |VLAN| tag.
