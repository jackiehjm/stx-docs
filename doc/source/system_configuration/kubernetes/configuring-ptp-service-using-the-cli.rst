
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

NICs using the Intel Ice NIC driver may report the following in the ``ptp4l``
logs, which might coincide with a |PTP| port switching to ``FAULTY`` before
re-initializing.

.. code-block:: none

    ptp4l[80330.489]: timed out while polling for tx timestamp
    ptp4l[80330.489]: increasing tx_timestamp_timeout may correct this issue, but it is likely caused by a driver bug

This is due to a limitation of the Intel Ice driver. The recommended workaround
is to set the ``tx_timestamp_timeout`` parameter to 700 (ms) in the ``ptp4l``
config.

.. code-block:: none

    ~(keystone_admin)]$ system ptp-instance-parameter-add ptp-inst1 tx_timestamp_timeout=700