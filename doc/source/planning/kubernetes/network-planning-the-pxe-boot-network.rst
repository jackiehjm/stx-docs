
.. bvi1552670521399
.. _network-planning-the-pxe-boot-network:

================
PXE Boot Network
================

You can set up a |PXE| boot network for booting all nodes to allow a
non-standard management network configuration.

The internal management network is used for |PXE| booting of new hosts and the
|PXE| boot network is not required. However there are scenarios where the
internal management network cannot be used for |PXE| booting of new hosts. For
example, if the internal management network needs to be on a |VLAN|-tagged
network for deployment reasons, or if it must support IPv6, you must configure
the optional untagged |PXE| boot network for |PXE| booting of new hosts using
IPv4.

.. only:: partner

   .. include:: /_includes/subnet-sizing-restrictions.rest

.. note::
    |prod| does not support IPv6 |PXE| booting.
