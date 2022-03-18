.. _gnss-and-synce-support-62004dc97f3e:

======================
SyncE and Introduction
======================

Intel's Westport Channel NICs support a built-in GNSS module and the ability to
distribute clock via Synchronous Ethernet (SyncE). This feature allows a PPS
signal to be taken in via the GNSS module and redistributed to additional NICs
on the same host or on different hosts. This behavior is configured on |prod|
using the ``clock`` instance type in the |PTP| configuration. Many of the
configuration steps in this section are similar to those in the |PTP|
Configuration section - reference this for additional details if required.

.. important::

   Users should reference the user guide for their Westport Channel NIC for
   additional information on configuring these features. The intent of this
   section is to explain how these parameters can be set, rather than
   describing each possible configuration.

Basic 'clock' instance configuration
====================================

General 'clock' information
---------------------------

**Default global parameters**

There are no supported global parameters for the clock type

**Default interface parameters**

NONE

**Required user-supplied parameters**

NONE

**Other requirements**

The clock type instance is a special instance used for configuring the NIC
control parameters of the Westport Channel NIC.

Configure a 'clock' instance
----------------------------

#.  Create the instance.

    .. code-block::

       ~(keystone_admin)]$ system ptp-instance-add myclock1 clock

#.  Create an interface for ``myclock1``.

    .. code-block::

       ~(keystone_admin)]$ system ptp-interface-add clockint1 myclock1

#.  Add a port to the interface.

    .. code-block::

       ~(keystone_admin)]$ system host-if-ptp-assign controller-0 oam0 clockint1

#.  Add parameters to the interface.

    .. code-block::

       ~(keystone_admin)]$ system ptp-interface-parameter-add clockint1 sma1=output

#.  Assign the instance to a host.

    .. code-block::

       ~(keystone_admin)]$ system host-ptp-instance-assign controller-0 myclock1

#.  Apply the configuration.

    .. code-block::

       ~(keystone_admin)]$ system ptp-instance-apply

Clock interface parameters
--------------------------

.. note::

    All parameters are scoped to the entire NIC, except for ``synce_rclka`` and
    ``synce_rclkb``. This means that if ``sma1=input`` is applied to ens1f0 and
    ``sma1=output`` is applied to ``ens1f2``, they will override each other and
    the last one processed by the system will be applied. Only the
    ``synce_rclka`` and ``synce_rclkb`` parameters can be configured
    per-interface. See the NIC user guide document for additional details.

.. note::

   The absence of a parameter is treated as disabled.

The following parameters can be applied to the interface of a clock instance.

PTP Parameters:

* sma1=input
* sma1=output
* sma2=input
* sma2=output
* u.fl1=output
* u.fl2=input
* synce_rclka=enabled
* synce_rclkb=enabled