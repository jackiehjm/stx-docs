
.. wib1463582694200
.. _network-planning-the-internal-management-network:

===============================
The Internal Management Network
===============================

The internal management network must be implemented as a single, dedicated,
Layer 2 broadcast domain for the exclusive use of each |prod-os| cluster.
Sharing of this network by more than one |prod-os| cluster is not supported.

The internal management network is also used for disk IO traffic to and from
the Ceph storage cluster.

If required, the internal management network can be configured as a
|VLAN|-tagged network. In this case, a separate IPv4 |PXE| boot network must be
implemented as the untagged network on the same physical interface. This
configuration must also be used if the management network must support IPv6.

During the |prod-os| software installation process, several network services
such as |BOOTP|, |DHCP|, and |PXE|, are expected to run over the internal
management network. These services are used to bring up the different hosts to
an operational state. It is therefore mandatory that this network be
operational and available in advance, to ensure a successful installation.

On each host, the internal management network can be implemented using a 1 Gb
or 10 Gb Ethernet port. Requirements for this port are that:

.. _network-planning-the-internal-management-network-ul-uh1-pqs-hp:

-   it must be capable of |PXE|-booting

-   it can be used by the motherboard as a primary boot device

.. note::
    This network is not used with Simplex systems.

.. note::
    |OSDs| bind to all addresses but communicate on the same network as
    monitors \(monitors and |OSDs| need to communicate, if monitors are on
    management networks, then |OSDs| source address will also be on mgmt0\).

See :ref:`Kubernetes Internal Management Network
<internal-management-network-planning>` for details.

