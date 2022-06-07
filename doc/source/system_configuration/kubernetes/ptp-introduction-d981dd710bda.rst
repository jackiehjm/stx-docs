.. _ptp-introduction-d981dd710bda:

================
PTP Introduction
================

As an alternative to |NTP| services, |PTP| can be used by |prod| nodes to
synchronize clocks in a network. It provides:

*	more accurate clock synchronization

*	the ability to extend the clock synchronization, not only to |prod| hosts
 	(controllers, workers, and storage nodes), but also to hosted applications
 	on |prod| hosts.

When used in conjunction with hardware support on the |OAM| and Management
network interface cards, |PTP| is capable of sub-microsecond accuracy. |prod|
supports the configuration of three services that are used for various |PTP|
configurations: ``ptp4l``, ``phc2sys`` and ``ts2phc``.

|prod| also supports a 'clock' service is used to manage specific NIC
parameters related to Synchronous Ethernet (SyncE) and Pulse Per Second (PPS)
support. Please see :ref:`gnss-and-synce-support-62004dc97f3e` for information
on the 'clock' service. The ``ptp4l``, ``phc2sys`` and ``ts2phc`` services are
part of the linuxptp project (https://sourceforge.net/projects/linuxptp/).

``ptp4l``
   ptp4l is the implementation of Precision Time Protocol according to the IEEE
   standard 1588 for Linux. It handles communication between |PTP| nodes as
   well as setting the |PTP| Hardware Clock (PHC) on the NIC. See man ptp4l for
   a complete list of configuration parameters.

``phc2sys``
   phc2sys is used to synchronize the system time with a PHC. The PHC may be
   set by either ``ptp4l`` or ``ts2phc``, depending on the system
   configuration. Refer to the man pages (:command:`man phc2sys`) for a
   complete list of configuration parameters.

``ts2phc``
   ts2phc synchronizes |PTP| Hardware Clocks (PHC) to external time stamp
   signals, such as those coming from GNSS.  A single source may be used to
   distribute time to one or more PHC devices. Refer to the man pages
   (:command:`man ts2phc`) for a complete list of configuration parameters.

Overview of the |prod| configuration units
==========================================

* Instances

  * Each instance represents a service of type ``ptp4l``, ``phc2sys`` or
    ``ts2phc``. There may be multiple instances of each type of service
    depending on the required configuration.

* Interfaces

  * An interface is assigned to an instance. One or more physical ports on a
    system may be assigned to an interface. Assigning multiple ports to the
    same interface allows for them to share the same configuration.

* Parameters

  * Parameters are key/value pairs that represent various program options. The
    key should exactly match an option from one of the service man pages, but
    this is not enforced. It is possible to enter invalid parameters which
    could prevent a service from starting.

  * Parameters are scoped to an instance or an interface. The commands system
    ptp-instance-parameter-add and system ptp-interface-parameter-add are used
    to assign these respectively.

  * A special instance level parameter called ``cmdline_opts`` is provided to
    allow certain parameters to be set which do not have a long name option
    supported in the configuration file.

  * A special ``ptp4l`` instance level parameter is provided to allow a |PTS|
    node to set the ``currentUtcOffsetValid`` flag in its announce messages and
    to correctly set the ``CLOCK_TAI`` on the system. Assign
    ``currentUtcOffsetValid=1`` at the the ``ptp4l`` instance level to set this
    flag.

    To return the CLOCK_TAI offset to 0, the ``currentUtcOffsetValid=1`` parameter
    must be removed and the host must be restarted via lock/unlock.


General information
===================

The relevant system locations for |PTP| instance configuration files are:

``/etc/ptpinstance/``
    Application configuration files, one per instance (excluding clock type).

``/etc/sysconfig/ptpinstance``
    Environment variable files, one per instance

``/etc/systemd/system/ptpinstance/``
    systemd service files, one per instance type (excluding clock type).

``/var/log/user.log``
    log output for |PTP| instance services.

Instances provide several default parameters that can be overwritten by
setting a parameter with the same key.

|org| recommends using the :command:`system ptp-instance-apply`` command to
validate your configuration prior to performing any system host-lock/unlock
actions, as a bad |PTP| configuration could result in a configuration
failure and trigger additional reboots as the system tries to recover.
