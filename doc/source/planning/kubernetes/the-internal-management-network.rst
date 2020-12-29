
.. yxu1552670544024
.. _the-internal-management-network:

====================================
Internal Management Network Overview
====================================

The internal management network must be implemented as a single, dedicated,
Layer 2 broadcast domain for the exclusive use of each |prod| cluster.
Sharing of this network by more than one |prod| cluster is not supported.

.. note::
    This network is not used with |prod| Simplex systems.

During the |prod| software installation process, several network services
such as |BOOTP|, |DHCP|, and |PXE|, are expected to run over the internal
management network. These services are used to bring up the different hosts
to an operational state. It is therefore mandatory that this network be
operational and available in advance, to ensure a successful installation.

On each host, the internal management network can be implemented using a 1
Gb or 10 Gb Ethernet port. Requirements for this port are that:

.. _the-internal-management-network-ul-uh1-pqs-hp:

-   It must be capable of |PXE|-booting.

-   It can be used by the motherboard as a primary boot device.

.. note::
    If required, the internal management network can be configured as a
    |VLAN|-tagged network. In this case, a separate IPv4 |PXE| boot
    network must be implemented as the untagged network on the same
    physical interface. This configuration must also be used if the
    management network must support IPv6.

.. seealso::

   :ref:`Internal Management Network Planning
   <internal-management-network-planning>`

   :ref:`Multicast Subnets for the Management Network
   <multicast-subnets-for-the-management-network>`
