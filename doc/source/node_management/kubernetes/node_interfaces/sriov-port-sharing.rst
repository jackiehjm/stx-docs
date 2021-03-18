
.. yda1612785713877
.. _sriov-port-sharing:

====================
SRIOV Port Sharing
====================

With |SRIOV| port sharing, you can:


.. _sriov-port-sharing-ul-e32-kzy-44b:

-   Create an |SRIOV| interface on a |VF| capable port.

-   Create |VF| type sub-interfaces using the |SRIOV| interface, and attach
    these sub-interfaces to data networks..

-   Create |VLAN| type interfaces using the |SRIOV| interface, and attach them to
    |OAM|, internal management and cluster-host platform networks respectively.

-   Create ethernet type of sub-interfaces using an |SRIOV| interface, and
    attach this interface to pxeboot network, which has to be untagged network.


By doing so, all of the network planes can be carried by only one VF-capable
physical port according to following resource allocation:


.. _sriov-port-sharing-ul-fdh-wzy-44b:

-   Platform type networks: PF

    -   pxeboot

    -   oam

    -   cluster-host

    -   mgmt

-   Data type networks: |VFs|

    -   pci-sriov class, vf type


-   :ref:`Configuring Ethernet Interfaces on SR-IOV interface Using from Horizon
    <configuring-ethernet-interfaces-on-sriov-interface-from-horizon>`

-   :ref:`Configuring Ethernet Interfaces on SR-IOV interface Using the CLI
    <configuring-ethernet-interfaces-on-sriov-interface-using-cli>`
