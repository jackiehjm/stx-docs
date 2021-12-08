========================================
Host Interface and Network Configuration
========================================

.. note::

   This guide was replaced by: :doc:`Node Management Guide </node_management/index>`

This guide describes the following:

.. contents::
   :local:
   :depth: 1

-----------------------------
Interface class configuration
-----------------------------

The interface class to which the logical network interface is connected. Valid
classes are:

``platform``
    Can be one of the following:

    * ``mgmt``: For the internal management network.
    * ``cluster-host``: For the Kubernetes cluster network.
    * ``oam``: For the OAM network.
    * ``pxeboot``: For the PXE boot platform network.

``data``
    Applicable only for StarlingX OpenStack. Used to indicate that the interface
    attaches to a data network providing the underlying network for OpenStack
    Neutron tenant networks.

``pci-sriov``
    For a PCI SR-IOV interface or for an interface that can be used in either
    configuration (dual use).

``pci-passthrough``
    For a PCI passthrough interface or for an interface that can be used in
    either configuration (dual use).

-----------------------
Interface configuration
-----------------------

When a host is added to StarlingX and initialized, Ethernet interfaces are
created automatically for each detected physical port.  Use
:command:`system host-if-modify` to configure an Ethernet interface.

LAG (Aggregated Ethernet) and VLAN interfaces must be created and configured
using :command:`system host-if-add`.

********************************
Ethernet interface configuration
********************************

Configure an Ethernet interface to a network using the following commands:

::

  system host-if-modify -n IF_NAME -m MTU -c IF_CLASS HOST_NAME ETH_NAME [--ipv4-mode=IP4_MODE [ipv4-pool ADDR_POOL]] [--ipv6-mode=IP6_MODE [ipv6-pool ADDR_POOL]]

Replace parameters with values suitable to your installation. Parameters are:

``IF_NAME``
    A name for the interface.

``MTU``
    The MTU for the interface.

``IF_CLASS``
    The class of the interface. Valid classes are platform, data, pci-sriov,
    and pci-passthrough.

``HOST_NAME``
    The name or UUID of the host.

``ETH_NAME``
    The name or UUID of the Ethernet interface to use.

``IP4_MODE``
    The mode for assigning IPv4 addresses to a data interface (static or pool).

``IP6_MODE``
    The mode for assigning IPv6 addresses to a data interface (static or pool).

``ADDR_POOL``
    The name of an IPv4 or IPv6 address pool, for use with the pool mode of IP
    address assignment for data interfaces.


****************************
VLAN interface configuration
****************************

Create a VLAN interface with the :command:`system host-if-add` command:

::

  system host-if-add HOST_NAME -V VLAN_ID  -c IF_CLASS IF_NAME vlan ETH_NAME

Replace parameters with values suitable to your installation. Parameters are:

``ETH_NAME``
    The name or UUID of the Ethernet interface to use.

``HOST_NAME``
    The name or UUID of the host.

``IF_CLASS``
    The class of the interface. Valid classes are platform, data, pci-sriov,
    and pci-passthrough.

``IF_NAME``
    A name or UUID for the interface (required).

``VLAN_ID``
    The VLAN identifier for the network.

***************************
LAG interface configuration
***************************

Create an aggregated Ethernet interface with the :command:`system host-if-add`
command:

::

  system host-if-add HOST_NAME -m MTU  -a AEMODE -x TX_HASH_POLICY IF_NAME  ae ETH_NAME_1 ETH_NAME_2

Replace parameters with values suitable to your installation. Parameters are:

``AEMODE``
    The link aggregation mode (active_standby, balanced, 802.3ad).

``ETH_NAME_1``, ``ETH_NAME_2``
    The names or UUIDs of the member Ethernet interfaces.

``HOST_NAME``
    The name or UUID of the host.

``IF_NAME``
    A name for the interface.

``MTU``
    The MTU for the interface.

``TX_HASH_POLICY``
    The balanced tx distribution hash policy (layer2, layer2+3, layer3+4).

------------------------------------
Network configuration and assignment
------------------------------------

*****************
Platform networks
*****************

The internal management network (`mgmt`) is required by all nodes in all
deployment configurations for internal communication. In the AIO-Simplex
configuration, the `mgmt` network is assigned to the loopback interface.

The `pxeboot` network is an optional network required in scenarios where the
`mgmt` network cannot be used for PXE booting of hosts. For example, use the
`pxeboot` network when the `mgmt` network needs to be IPv6 (not currently
supported for PXE booting). In these scenarios, the PXE boot network uses a
dedicated VLAN (port-based), and the `mgmt` network uses a separate dedicated
VLAN (tagged) on the same port.

The cluster host network is required by all deployment configurations to support
a Kubernetes cluster. It is used for private container-to-container networking
within a cluster. It can be used for external connectivity of container
workloads. If the cluster host network is not used for external connectivity of
container workloads, then either the OAM port or other configured ports on both
the controller and worker nodes can be used for connectivity to external
networks.

The OAM network is required for external control and board management access. It
can be used for container payload external connectivity, depending on
container payload application network requirements.

Assign an interface to a platform network with the command:

::

  system interface-network-assign HOST_NAME IF_NAME NETWORK

Replace parameters with values suitable to your installation. Parameters are:

``HOST_NAME``
    The name or UUID of the host.

``IF_NAME``
    A name for the interface.

``NETWORK``
    The name or ID of the platform network to which the interface will
    be assigned.

*************
Data networks
*************

StarlingX allows you to model L2 networks that are attached to `data`,
`pci-sriov`, and `pci-passthrough` class interfaces.

A data network represents a Layer 2 physical or virtual network, or a set of
virtual networks used to provide the underlying network connectivity needed to
support the application networks. Multiple data networks may be configured as
required and realized over the same or different physical networks. Access to
external networks is typically (although not always) granted to worker nodes
using a data network. The extent of this connectivity, including access to the
open Internet, is application-dependent.

Data networks are created by the administrator to make use of an underlying set
of resources on a physical network.

Three types of data networks may be implemented in StarlingX:

#. **Flat network:** A data network mapped entirely over the physical network.

#. **VLAN network:** A data network implemented on a physical network using a
   VLAN identifier. This allows multiple data networks over the same physical
   network.

#. **VXLAN network:** A data network implemented across non-contiguous physical
   networks connected by Layer 3 routers, using a VNI identifier. This allows
   multiple data networks over physically separated Layer 2 networks.

List the names of the data networks with the command:

::

  system datanetwork-list

View details of a data network with the command:

::

  system datanetwork-show DATA_NETWORK

Replace parameters with values suitable to your installation. Parameters are:

``DATA_NETWORK``
    The name or UUID of the data network.

Add a data network with the command:

::

  system datanetwork-add -d DESCRIPTION -m MTU -p PORT -g GROUP -t TTL -M MODE NAME TYPE

Replace parameters with values suitable to your installation. Parameters are:

``DESCRIPTION``
    A description of the data network.

``MTU``
    The MTU of the data network.

    .. note::

            To attach to the data network, data interfaces must be configured
            with an equal or larger MTU.

``PORT``
    The port of the data network.

``GROUP``
    The multicast group of the data network.

``TTL``
    The time-to-live of the data network.

``MODE``
    For networks of type vxlan only, mode can be either dynamic or static. If
    set to dynamic, group must also be specified.

``NAME``
    The name assigned to the data network.

``TYPE``
    The type of data network to be created (flat, vlan, or vxlan).

Assign an interface to a data network with the command:

::

  system interface-datanetwork-assign HOST_NAME IF_NAME DATA_NETWORK

Replace parameters with values suitable to your installation. Parameters are:

``HOST_NAME``
    The name or UUID of the host.

``IF_NAME``
    A name for the interface.

``DATA_NETWORK``
    The name or ID of the data network to which the interface will be assigned.

