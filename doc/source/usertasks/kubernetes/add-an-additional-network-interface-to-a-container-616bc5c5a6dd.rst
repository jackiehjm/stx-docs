.. _add-an-additional-network-interface-to-a-container-616bc5c5a6dd:

==================================================
Add an Additional Network Interface to a Container
==================================================

.. contents:: |minitoc|
   :local:
   :depth: 1

Network attachment definition specifications can be created in order to
reference / request additional interfaces or network configurations in a
container specification.

The type of network attachment definition corresponds to a container networking
plugin which performs the actions necessary to set up the interface in the
container.  Some plugins correspond directly to a new interface in the
container, while other "meta" plugins are typically chained with an
interface-plugin to perform additional network configuration.  Further,
``ipam`` plugins can be used to control the IP address allocation for the
interface.

---------------------------------
"interface-creating" plugin types
---------------------------------

:ref:`sriov <sriov-plugin-4229f81b27ce>`
    Adds an |SRIOV| |VF| interface to a container.

:ref:`host-device <host-device-plugin-714d4862a825>`
     Adds an already-existing device to a container.

:ref:`macvlan <macvlan-plugin-e631cca21ffb>`
    Creates an interface with a new |MAC| address, usually from a shared host
    interface.

:ref:`ipvlan <ipvlan-plugin-150be92d0538>`
    Creates an ``ipvlan`` interface in the container.

:ref:`bridge <bridge-plugin-7caa94024df4>`
    Creates a bridge on the host and adds a ``veth`` interface in the container
    to it.

:ref:`ptp <ptp-plugin-bc6ed0498f4c>`
    Creates a ``veth`` pair between the container and host.

:ref:`vlan <vlan-plugin-37938fe8578f>`
    Creates a ``vlan`` device in the container.

    See :ref:`bond <integrate-the-bond-cni-plugin-2c2f14733b46>` for more information.

``bond``
    Creates a bonded interface in the container.

:ref:`vrf <virtual-routing-and-forwarding-plugin-0e53f2c2de21>`
    Enables virtual routing and forwarding in the network namespace of the
    container.

-------------------
"meta" plugin types
-------------------

:ref:`tuning <tuning-plugin-08f8cdbf1763>`
    Allows some ``sysctl`` parameters of an existing interface to be modified.

``portmap``
    Maps ports from the host's address space to the container.

:ref:`bandwidth <bandwidth-plugin-3b8966c3fe47>`
    Applies bandwidth-limiting on a container interface through use of traffic
    control ``tbf``.

:ref:`sbr <source-based-routing-plugin-51648f2ddff1>`
    Enables source based routing for an interface.

-------------------
"ipam" plugin types
-------------------

``dhcp``
    Runs a daemon on the host which makes |DHCP| requests on behalf of the
    container.  Requires a |DHCP| server to be connected to the interface.

``host-local``
    Maintains a local database of allocated IP addresses.

``static``
    Allocate a static IPv4/IPv6 addresses to container.

``calico-ipam``
    Use Calico managed IP pools to allocate an address to the interface.
