
.. cyw1552673027689
.. _configuring-ptp-service-using-the-cli:

===================================
Configure PTP Service Using the CLI
===================================

You can use the CLI to configure |PTP| services.

.. xbooklink For more information, see |node-doc|: `Host Inventory <hosts-tab>`.

**PTP Service**

To view the existing |PTP| status, use the following commands.

.. code-block:: none

    ~(keystone_admin)]$ system ptp-instance-list

    ~(keystone_admin)]$ system host-ptp-instance-list <host>

.. warning::
    |NTP| and |PTP| are mutually exclusive on a particular host; only one can be
    enabled at any time.

The default value for **clock_synchronization** is **ntp**. Use the
following command to change the clock synchronization on the host. |NTP|
and |PTP| are configured per host. Lock/unlock the host when updating.

.. code-block:: none

    ~(keystone_admin)]$ system host-update controller-0 clock_synchronization=ptp
    +-----------------------+---------------------------------------+
    | Property              | Value                                 |
    +-----------------------+---------------------------------------+
    | action                | none                                  |
    | administrative        | unlocked                              |
    | availability          | available                             |
    | bm_ip                 | None                                  |
    | bm_type               | None                                  |
    | bm_username           | None                                  |
    | boot_device           | /dev/disk/by-path/pci-0000:04:00.0-sas|
    |                       |   -0x5001e6754aa38000-lun-0           |
    | capabilities          | {u'stor_function': u'monitor'}        |
    | clock_synchronization | ptp                                   |
    | config_applied        | 590f29ad-19e2-43ee-855e-f765814e3ecd  |
    | config_status         | None                                  |
    | config_target         | 590f29ad-19e2-43ee-855e-f765814e3ecd  |
    | console               | ttyS0,115200n8                        |
    | created_at            | 2019-12-07T18:32:58.752361+00:00      |
    | hostname              | controller-0                          |
    | id                    | 1                                     |
    | install_output        | text                                  |
    | install_state         | None                                  |
    | install_state_info    | None                                  |
    | inv_state             | inventoried                           |
    | invprovision          | provisioned                           |
    | location              | {}                                    |
    | mgmt_ip               | 192.168.204.3                         |
    | mgmt_mac              | 00:1e:67:54:aa:39                     |
    | operational           | enabled                               |
    | personality           | controller                            |
    | reserved              | False                                 |
    | rootfs_device         | /dev/disk/by-path/pci-0000:04:00.0    |
    |                       |   -sas-0x5001e6754aa38000-lun-0       |
    | serialid              | None                                  |
    | software_load         | nn.nn                                 |
    | task                  |                                       |
    | tboot                 | false                                 |
    | ttys_dcd              | None                                  |
    | updated_at            | 2019-12-07T21:17:28.627489+00:00      |
    | uptime                | 9020                                  |
    | uuid                  | 92c86da2-adb7-4fb2-92fc-82759e25108d  |
    | vim_progress_status   | services-enabled                      |
    +-----------------------+---------------------------------------+

To view the |PTP| service configuration, use the following command:

.. code-block:: none

    ~(keystone_admin)]$ system host-show controller-0
    +-----------------------+------------------------------------------------+
    | Property              | Value                                          |
    +-----------------------+------------------------------------------------+
    | action                | none                                           |
    | administrative        | unlocked                                       |
    | availability          | available                                      |
    | bm_ip                 | None                                           |
    | bm_type               | None                                           |
    | bm_username           | None                                           |
    | boot_device           | /dev/disk/by-path/pci-0000:04:00.0-sas         |
    |                       |-0x5001e6754aa38000-lun-0                       |
    | capabilities          | {u'stor_function': u'monitor', u'Personality': |
    |                       | u'Controller-Active'}                          |
    | clock_synchronization | ptp                                            |
    | config_applied        | 590f29ad-19e2-43ee-855e-f765814e3ecd           |
    | config_status         | Config out-of-date                             |
    | config_target         | cd18ec25-c030-4b0c-862b-c39726275743           |
    | console               | ttyS0,115200n8                                 |
    | created_at            | 2019-12-09T16:10:19.143372+00:00               |
    | hostname              | controller-0                                   |
    | id                    | 1                                              |
    | install_output        | text                                           |
    | install_state         | None                                           |
    | install_state_info    | None                                           |
    | inv_state             | inventoried                                    |
    | invprovision          | provisioned                                    |
    | location              | {}                                             |
    | mgmt_ip               | 192.168.204.3                                  |
    | mgmt_mac              | 00:1e:67:54:aa:39                              |
    | operational           | enabled                                        |
    | personality           | controller                                     |
    | reserved              | False                                          |
    | rootfs_device         | /dev/disk/by-path/pci-0000:04:00.0-sas         |
    |                       | -0x5001e6754aa38000-lun-0                      |
    | serialid              | None                                           |
    | software_load         | nn.nn                                          |
    | task                  |                                                |
    | tboot                 | false                                          |
    | ttys_dcd              | None                                           |
    | updated_at            | 2019-12-10T14:55:58.595239+00:00               |
    | uptime                | 159970                                         |
    | uuid                  | 92c86da2-adb7-4fb2-92fc-82759e25108d           |
    | vim_progress_status   | services-enabled                               |
    +-----------------------+------------------------------------------------+


.. _configuring-ptp-service-using-the-cli-ul-srp-rnn-3jb:

PTP Instance Configuration
==========================

|PTP| instances are the top level configuration unit. The supported instance
types are:

``ptp4l``
    Represents an instance of ``ptp4l``. A node may have several of these
    instances.

``phc2sys``
    Represents an instance of ``phc2sys``. A node will generally only have one
    of these.

``ts2phc``
    Represents an instance of ``ts2phc``.

``clock``
    ``clock`` is not an daemon or service, but instead an abstract unit used to
    hold the interfaces and configuration for setting Westport Channel
    or Logan Beach NIC control parameters (syncE and PPS transmission).

Valid instance level parameters are found in the man pages for each service,
under:

* GLOBAL OPTIONS - ptp4l

* OPTIONS - phc2sys

* GLOBAL OPTIONS - ts2phc

* None for clock


Set host to use |PTP|:

.. code-block::

    ~(keystone_admin)]$ system host-update controller-0 clock_synchronization=ptp

Create an instance and assigning parameters
-------------------------------------------

#. Create an instance by providing a name and type.

   .. code-block::

      ~(keystone_admin)]$ system ptp-instance-add myptp1 ptp4l

#. Add any required instance level parameters.

   .. code-block::

      ~(keystone_admin)]$ system ptp-instance-parameter-add myptp1 domainNumber=24 slaveOnly=0

Create an interface and assign to ports
---------------------------------------

#. Create an interface unit by providing a name and assigning it to an instance.

   .. code-block::

      ~(keystone_admin)]$ system ptp-interface-add ptpinterface myptp1

#. Add ports to the interface.

   .. code-block::

      ~(keystone_admin)]$ system host-if-ptp-assign controller-0 oam0 ptpinterface

#. Add interface level parameters as required.

   .. code-block::

      ~(keystone_admin)]$ system ptp-interface-parameter-add ptpinterface masterOnly=1

   .. note::

      Multiple ports may be assigned to an interface in order to simplify
      parameter application.

   .. code-block::

      ~(keystone_admin)]$ system host-if-ptp-assign controller-0 data0 ptpinterface
      ~(keystone_admin)]$ system ptp-interface-show ptpinterface


#. Assign the instance to a host and apply the configuration.

   #. Assign the |PTP| instance to a host so that the configuration can be
      applied.

      .. code-block::

         ~(keystone_admin)]$ system host-ptp-instance-assign controller-0 myptp1

   #. Apply the configuration and verify that it completed.

      .. code-block::

         ~(keystone_admin)]$ system ptp-instance-apply
         ~(keystone_admin)]$ fm alarm-list


PTP Limitations
---------------


* NICs using the Intel® ice driver may report the following error in the
  ``ptp4l`` logs, which results in a |PTP| port switching to ``FAULTY`` before
  re-initializing.

  .. note::
 
     |PTP| ports frequently switching to ``FAULTY`` may degrade the accuracy of
     the |PTP| timing.
  
  .. code-block:: none
  
      ptp4l[80330.489]: timed out while polling for tx timestamp
      ptp4l[80330.489]: increasing tx_timestamp_timeout may correct this issue, but it is likely caused by a driver bug
  
  .. note::

      This is due to a limitation with the Intel® ice driver as the driver
      cannot guarantee the time interval to return the timestamp to the
      ``ptp4l`` user space process which results in the occasional timeout
      error message.

  **Workaround**: The workaround recommended by Intel is to increase the
  ``tx_timestamp_timeout`` parameter in the ``ptp4l`` config. The increased
  timeout value gives more time for the ice driver to provide the timestamp to
  the ``ptp4l`` user space process. Timeout values of 50ms and 700ms have been
  validated. However, the user can use a different value if it is more suitable
  for their system.

  .. code-block:: none
 
     ~(keystone_admin)]$ system ptp-instance-parameter-add <instance_name> tx_timestamp_timeout=700
     ~(keystone_admin)]$ system ptp-instance-apply

  .. note::

     The ``ptp4l`` timeout error log may also be caused by other underlying
     issues, such as NIC port instability. Therefore, it is recommended to
     confirm the NIC port is stable before adjusting the timeout values.

.. begin-silicom-ptp-limitations

* Silicom and Intel based Time Sync NICs may not be deployed on the same system
  due to conflicting time sync services and operations.

  |PTP| configuration for Silicom TimeSync (STS) cards is handled separately
  from |prod| host |PTP| configuration and may result in configuration
  conflicts if both are used at the same time.

  The sts-silicom application provides a dedicated ``phc2sys`` instance which
  synchronizes the local system clock to the Silicom TimeSync (STS) card. Users
  should ensure that ``phc2sys`` is not configured via |prod| |PTP| Host
  Configuration when the sts-silicom application is in use.

  Additionally, if |prod| |PTP| Host Configuration is being used in parallel
  for non-STS NICs, users should ensure that all ``ptp4l`` instances do not use
  conflicting ``domainNumber`` values.

* When the Silicom TimeSync (STS) card is configured in timing mode using the
  sts-silicom application, the card goes through an initialization process on
  application apply and server reboots. The ports will bounce up and down
  several times during the initialization process, causing network traffic
  disruption. Therefore, configuring the platform networks on the Silicom
  TimeSync (STS) card is not supported since it will cause platform
  instability.

.. end-silicom-ptp-limitations
