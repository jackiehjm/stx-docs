.. _ptp-interfaces-df73e9b43677:

==============
PTP Interfaces
==============

|PTP| interfaces are assigned to an instance. An interface has a name, can have
multiple physical ports assigned to it and can have multiple parameters.

Interface level parameters are applied to all ports in the interface.

Valid interface parameters can be located in the man page for a service under:

* PORT OPTIONS - ptp4l
* SLAVE CLOCK OPTIONS - ts2phc
* None for phc2sys

Clock has a special list of interface parameters, detailed in the clock section
of the document.
