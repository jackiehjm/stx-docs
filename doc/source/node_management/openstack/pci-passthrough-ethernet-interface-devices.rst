
.. pqu1596720884619
.. _pci-passthrough-ethernet-interface-devices:

==========================================
PCI Passthrough Ethernet Interface Devices
==========================================

For all purposes, a |PCI| passthrough interface behaves as if it were physically
attached to the virtual machine.

Therefore, any potential throughput limitations coming from the virtualized
environment, such as the ones introduced by internal copying of data buffers,
are eliminated. However, by bypassing the virtualized environment, the use of
|PCI| passthrough Ethernet devices introduces several restrictions that must be
taken into consideration. They include:


.. _pci-passthrough-ethernet-interface-devices-ul-mjs-m52-tp:

-   no support for |LAG|, |QoS|, |ACL|, or host interface monitoring

-   no support for live migration

.. only:: partner

    .. include:: ../../_includes/pci-passthrough-ethernet-interface-devices.rest

    :start-after: avs-bullet-3-begin
    :end-before: avs-bullet-3-end

.. only:: starlingx

    A passthrough interface is attached directly to the provider network's
    access switch. Therefore, proper routing of traffic to connect the
    passthrough interface to a particular project network depends entirely on
    the |VLAN| tagging options configured on both the passthrough interface and
    the access port on the switch.

.. only:: partner

    .. include:: ../../_includes/pci-passthrough-ethernet-interface-devices.rest

    :start-after: avs-text-begin
    :end-before: avs-text-end


The access switch routes incoming traffic based on a |VLAN| ID, which ultimately
determines the project network to which the traffic belongs. The |VLAN| ID is
either explicit, as found in incoming tagged packets, or implicit, as defined
by the access port's default |VLAN| ID when the incoming packets are untagged. In
both cases the access switch must be configured to process the proper |VLAN| ID,
which therefore has to be known in advance.

.. caution::

    On cold migration, a |PCI| passthrough interface receives a new |MAC| address,
    and therefore a new **eth** x interface. The IP address is retained.

In the following example a new virtual machine is launched by user **user1** on
project **project1**, with a passthrough interface connected to the project
network **net0** identified with |VLAN| ID 10. See :ref:`Configure PCI
Passthrough ethernet Interfaces <configure-pci-passthrough-ethernet-interfaces>`

