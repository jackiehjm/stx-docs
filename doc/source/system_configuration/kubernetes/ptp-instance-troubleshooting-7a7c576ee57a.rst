.. _ptp-instance-troubleshooting-7a7c576ee57a:

============================
PTP Instance Troubleshooting
============================

The most common error encountered using multi-instance |PTP| is a failure to
start one or more instances after running the :command:`ptp-instance-apply`
command. This is often due to an invalid configuration or missing parameter.

This section provides some troubleshooting steps to assist with determining the
error.

Example
=======

After running the :command:`ptp-instance-apply` command, the 250.001 alarm will
appear if the |PTP| instances could not be created/started properly. The system
may also show the 200.011 alarm if, after an unlock, |PTP| instances were
unable to start.

The following example shows these alarms as they would appear in tabular
terminal output.

.. code-block::

   | 250.001  | controller-0 Configuration is out-of-date.          | host=controller-0     | major    | 2022-02-25T21: |
   |          |                                                     |                       |
   | 200.011  | controller-0 experienced a configuration failure.   | host=controller-0     | critical | 2022-02-25T20: |
   |          |                                                     |                       |          | 47:59.561262   |

#. Determine if there was a |PTP|-instance failure by looking at the latest
   runtime puppet logs.

   .. code-block::

      sudo less /var/log/puppet/latest/puppet.log

      # Searching for "Error" in the log file shows this entry
      2022-02-28T17:26:49.529 ESC[1;31mError: 2022-02-28 17:26:49 +0000 Systemd start for ptp4l@ptp4l-legacy failed!

#. Once the instance has been identified, examine the config file for
   configuration errors.

   .. code-block::

      ~(keystone_admin)]$ cat /etc/ptpinstance/ptp4l-ptp4l-legacy.conf

      [global]
      ##
      ## Default Data Set
      ##
      boundary_clock_jbod 1
      clock_servo linreg
      delay_mechanism E2E
      domainNumber 0
      message_tag ptp4l-legacy
      network_transport L2
      summary_interval 6
      time_stamping hardware
      tx_timestamp_timeout 20
      uds_address /var/run/ptp4l-ptp4l-legacy
      uds_ro_address /var/run/ptp4l-ptp4l-legacyro

#. Start the service manually and check for errors.

   .. code-block::

      ~(keystone_admin)]$ ptp4l -f /etc/ptpinstance/ptp4l-ptp4l-legacy.conf
      no interface specified

   In this example the ``ptp4l`` program indicates that there is no interface
   specified, which is confirmed by the contents of the config file above.

#. Check using the relevant ``system`` commands to see if there is an interface
   assigned to this instance and add one as required.

Additional tools
================

:command:`PMC`
  |PTP| management client.

  Used to interact with ptp4l and read/set various |PTP| parameters.

  .. code-block::

     $ man pmc

     # General command format:
     sudo pmc -u -b 0 -f <path to ptp4l.conf for targeted instance> -s <path to uds socket for target instance> 'COMMAND GOES HERE'

     eg. pmc -u -b 0 -f /etc/ptpinstance/ptp4l-ptp1.conf -s /var/run/ptp4l-ptp1 'get PORT_DATA_SET


:command:`PHC_CTL`
  Directly control PHC device clock.

  Used to perform operations on the physical hardware clock (phc). PHC_CTL can
  be used to set the time on a NIC, check the delta between the NIC and the
  system clock, adjust the clock frequency.

  .. code-block::

     $ man phc_ctl

     # Example commands

     phc_ctl <ptp_interface> get
     phc_ctl <ptp_interface> cmp

     # Rhis syncs the NIC clock to the system clock
     phc_ctl <ptp_interface> set


:command:`TCPDUMP`
  Check if |PTP| traffic is sending or receiving on a given interface.

  You can capture L2 ptp traffic by filtering on proto 0x88F7

  .. code-block::

      sudo tcpdump ether proto 0x88F7 -i <ptp_interface>

      # Write it to file

      sudo tcpdump ether proto 0x88F7 -i <ptp_interface> -w <output_file.pcap>