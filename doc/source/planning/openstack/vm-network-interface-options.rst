
.. jow1411482049845
.. _vm-network-interface-options:

============================
VM Network Interface Options
============================

|prod-os| supports a variety of standard and performance-optimized network
interface drivers in addition to the standard OpenStack choices.

.. _vm-network-interface-options-ul-mgc-xnp-nn:

-   Unmodified guests can use Linux networking and virtio drivers. This
    provides a mechanism to bring existing applications into the production
    environment immediately.

    .. only:: partner

       .. include:: ../../_includes/vm-network-interface-options.rest
          :start-after: unmodified-guests-virtio-begin
          :end-before: highest-performance-begin

    .. note::
        The virtio devices on a |VM| cannot use vhost-user for enhanced
        performance if any of the following is true:

        -   The |VM| is not backed by huge pages.

        -   The |VM| is backed by 4k huge pages.

        -   The |VM| is live-migrated from an older platform that does not
            support vhost-user.

.. only:: partner

   .. include:: ../../_includes/vm-network-interface-options.rest
   :start-after: highest-performance-begin

.. xbooklink For more information about |AVP| drivers, see OpenStack VNF Integration: :ref:`Accelerated Virtual Interfaces <accelerated-virtual-interfaces>`.

.. seealso::

   :ref:`Port Security Extension <port-security-extension>`

   :ref:`PCI Passthrough Ethernet Interfaces
   <pci-passthrough-ethernet-interfaces>`

   :ref:`SR-IOV Ethernet Interfaces <sr-iov-ethernet-interfaces>`

.. xpartnerlink   :ref:`MAC Address Filtering on Virtual Interfaces
   <mac-address-filtering-on-virtual-interfaces>`
