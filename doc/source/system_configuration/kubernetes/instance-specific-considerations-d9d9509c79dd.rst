.. _instance-specific-considerations-d9d9509c79dd:

================================
Instance Specific Considerations
================================

ptp4l
=====

**Default global parameters**

*   tx_timestamp_timeout 20
*   summary_interval 6
*   clock_servo linreg
*   network_transport L2
*   time_stamping hardware
*   delay_mechanism E2E
*   boundary_clock_jbod 1
*   uds_address /var/run/ptp4l-<instance name>
*   uds_ro_address /var/run/ptp4l-<instance name>ro

**Default interface parameters**

NONE

**Required user-supplied parameters**

``domainNumber <number>``

**Other requirements**

An interface with a port must be assigned to the ``ptp4l`` instance in order
for it to start.

.. note::

   It is recommended to configure one ``ptp4l`` instance per |PHC|. Some |NIC|
   designs have a single |PHC| shared between all the ports on the |NIC|, while
   others may have one |PHC| per port. Refer to the |NIC| documentation to
   determine if a |NIC| has multiple |PHCs|. Configuring a ``ptp4l`` instance
   with multiple interfaces, each with its own |PHC| results in degraded
   timing accuracy or other undesirable behaviors. This means that a given
   ``ptp4l`` instance should only be configured with interfaces that are on the
   same |NIC| and share a |PHC|.

phc2sys
=======

**Default global parameters**

``cmdline_opts '-a -r -R 2 -u 600'``

**Default interface parameters**

NONE

**Required user-supplied parameters**

``domainNumber <number>``
   This should match with the associated ``ptp4l`` instance.

``uds_address <path>``
   This value needs to be the same as the uds_address for the ``ptp4l``
   instance that ``phc2sys`` is tracking.

**Other requirements**

The ``cmdline_opts`` are defaulted to support interaction with ``ptp4l``. If
``phc2sys`` is instead being used with ``ts2phc``, this parameter will have to
be updated. See :ref:`ptp-instance-examples-517dce312f56` for more information.

.. note::


   The ``cmdline_opts parameter`` overrides all default command line flags for
   the service. This means that when setting ``cmdline_opts``, the full list
   of desired flags should be set.


ts2phc
======

**Default global parameters**

*  ``ts2phc.pulsewidth 100000000``
*  ``leapfile /usr/share/zoneinfo/leap-seconds.list``
*  ``cmdline_opts '-s nmea'``

**Default interface parameters**

``ts2phc.extts_polarity rising``

**Required user-supplied parameters**

This value is the path to the GNSS serial port that is connected, it will be
named differently on each system.

``ts2phc.nmea_serialport=/dev/ttyGNSS_BBDD_0``

**Other requirements**

An interface with a port must be assigned to the ``ts2phc`` instance in order
for time to be synced from GNSS to the |PHC|.

clock
=====

**Default global parameters**

There are no supported global parameters for clock type.

**Default interface parameters**

NONE

**Required user-supplied parameters**

NONE

**Other requirements**

The clock type instance is a special instance used for configuring the |NIC|
control parameters of the Westport Channel or Logan Beach |NIC| clock
interface parameters.

These parameters can be applied to the interface of a clock instance |PTP|
parameters:

*  sma1 input/output
*  sma2 input/output
*  u.fl1 output
*  u.fl2 input
*  synce_rclka enabled
*  synce_rclkb enabled
