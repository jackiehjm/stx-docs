
.. jow1404333739174
.. _project-networks:

================
Project Networks
================

Project networks are logical networking entities visible to project users, and
around which working network topologies are built.

Project networks need support from the physical layers to work as intended.
This means that the access L2 switches, data networks, and data interface
definitions on the compute nodes, must all be properly configured. In
particular, careful |prod-os| project network management planning
is required to achieve the proper configuration when using data networks of the
|VLAN| or |VXLAN| type.

For data networks of the |VLAN| type, consider the following guidelines:

.. _project-networks-ul-hqm-n2s-4n:

-   All ports on the access L2 switches must be statically configured to
    support all the |VLANs| defined on the data networks they provide access
    to. The dynamic nature of the cloud might force the set of |VLANs| in use
    by a particular L2 switch to change at any moment.

.. only:: partner

   .. include:: /_includes/project-networks.rest
   :start-after: vlan-begin
   :end-before: vxlan-begin

-   Configuring a project network to have access to external networks \(not
    just providing local networking\) requires the following elements:

    -   A physical router, and the data network's access L2 switch, must be
        part of the same Layer-2 network. Because this Layer 2 network uses a
        unique |VLAN| ID, this means also that the router's port used in the
        connection must be statically configured to support the corresponding
        |VLAN| ID.

    -   The router must be configured to be part of the same IP subnet that the
        project network is intending to use.

    -   When configuring the IP subnet, the project must use the router's port
        IP address as its external gateway.

    -   The project network must have the external flag set. Only the **admin**
        user can set this flag when the project network is created.

For data networks of the |VXLAN| type, consider the following guidelines:

.. _project-networks-ul-gwl-5fh-hr:

-   Layer 3 routers used to interconnect compute nodes must be
    multicast-enabled, as required by the |VXLAN| protocol.

.. include:: /_includes/project-networks.rest
   :start-after: vxlan-begin

-   To support |IGMP| and |MLD| snooping, Layer 3 routers must be configured
    for |IGMP| and |MLD| querying.

-   To accommodate |VXLAN| encapsulation, the |MTU| values for Layer 2 switches
    and compute node data interfaces must allow for additional headers. For
    more information, see :ref:`The Ethernet MTU <the-ethernet-mtu>`.

-   To participate in a |VXLAN| network, the data interfaces on the compute
    nodes must be configured with IP addresses, and with route table entries
    for the destination subnets or the local gateway. For more information, see
    :ref:`Manage Data Interface Static IP Addresses Using the CLI
    <managing-data-interface-static-ip-addresses-using-the-cli>`, and :ref:`Add
    and Maintain Routes for a VXLAN Network
    <adding-and-maintaining-routes-for-a-vxlan-network>`.

In some circumstances, project networks can be configured to use |VLAN|
Transparent mode, in which |VLAN| tagged packets from the guest are
encapsulated within a data network segment \(|VLAN|\) without removing or
modifying the guest |VLAN| tag.

Alternatively, guest |VLAN|-tagged traffic can be implemented using |prod-os|
support for OpenStack |VLAN| Aware |VMs|.

For more information about |VLAN| Aware |VMs|, see :ref:`VLAN Aware VMs
<vlan-aware-vms>` or consult the public OpenStack documentation at,
`http://specs.openstack.org/openstack/neutron-specs/specs/newton/vlan-aware-vms.html
<http://specs.openstack.org/openstack/neutron-specs/specs/newton/vlan-aware-vms.html>`__.
