
.. ruc1552675803041
.. _lldp-overview:

=============
LLDP Overview
=============

|prod| supports the sending and receiving of |LLDP| messages on all physical
interfaces.

The |LLDP|, defined in the *IEEE 802.1AB Station and Media Access Control
Connectivity Discovery* specification, enables devices attached to the network
to advertise their properties to other devices on the same network.

|LLDP| neighbor information is displayed in the |LLDP| tab of the Host Detail
window, or through system CLI commands.

|LLDP| information can be used to verify cabling to the next hop device
\(typically the Top-of-Rack switch\).

.. note::
    The neighboring device must be capable of, and enabled for, transmitting
    |LLDP| frames.

    Devices differ in the level of information sent in an |LLDP| |PDU|. This
    can often be configured on the neighboring device. Refer to the
    device documentation for specific information.
