
.. cyw1552673027689
.. _configuring-ptp-service-using-the-cli:

===================================
Configure PTP Service Using the CLI
===================================

You can use the CLI to configure |PTP| services.

.. contents::
   :local:
   :depth: 1

For information on configuring the |PTP| service for clock synchronization
using the Horizon Web interface see
:ref:`Configure PTP Service Using Horizon
<configuring-ptp-service-using-horizon>`.

You can also specify the |PTP| service for **clock\_synchronization** using
the web administration interface.

.. xbooklink For more information, see |node-doc|: `Host Inventory <hosts-tab>`.

**PTP Service**

To view the existing |PTP| status, use the following command.

.. code-block:: none

    ~(keystone_admin)$ system ptp-show
    +--------------+--------------------------------------+
    | Property     | Value                                |
    +--------------+--------------------------------------+
    | uuid         | 4844eca1-13bb-471e-9162-e5f2bb97d650 |
    | mode         | hardware                             |
    | transport    | l2                                   |
    | mechanism    | e2e                                  |
    | isystem_uuid | a16d7b07-1d42-41cf-b001-04bc25216a2b |
    | created_at   | 2019-12-09T16:08:34.319374+00:00     |
    | updated_at   | None                                 |
    +--------------+--------------------------------------+

.. warning::
    |NTP| and |PTP| are mutually exclusive on a particular host; only one can be
    enabled at any time.

The default value for **clock\_synchronization** is **ntp**. Use the
following command to change the clock synchronization on the host. |NTP|
and |PTP| are configured per host. Lock/unlock the host when updating.

.. code-block:: none

    ~(keystone_admin)$ system host-update controller-0 clock_synchronization=ptp
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
    | software_load         | 20.06                                 |
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

    ~(keystone_admin)$ system host-show controller-0
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
    | software_load         | 20.06                                          |
    | task                  |                                                |
    | tboot                 | false                                          |
    | ttys_dcd              | None                                           |
    | updated_at            | 2019-12-10T14:55:58.595239+00:00               |
    | uptime                | 159970                                         |
    | uuid                  | 92c86da2-adb7-4fb2-92fc-82759e25108d           |
    | vim_progress_status   | services-enabled                               |
    +-----------------------+------------------------------------------------+


.. _configuring-ptp-service-using-the-cli-ul-srp-rnn-3jb:

-   **PTP Time Stamping Mode**: |NTP| and |PTP| are configured per host.
    Lock/unlock the host when Hardware time stamping is the default
    option, and achieves best time synching. Use the following command:

    .. code-block:: none

        ~(keystone_admin)$ system ptp-modify --mode=<hardware/software/legacy>

-   **PTP Network Transport**: Switch between IEEE 802.3 network
    transport \(L2\) or |UDP| IPv4/v6 network transport for |PTP|
    messaging. Use the following command:

    .. code-block:: none

        ~(keystone_admin)$ system ptp-modify --transport=<l2/UDP>

    .. note::
        L2 is the default option.

        If you use |UDP| for |PTP| transport, each |PTP| interface must have an
        IP assigned. This is enforced during host unlock, and when switching
        |PTP| transport to |UDP|.

-   **PTP Delay Mechanism**

    Set the |PTP| delay mechanism, the options are:

    -   E2E: default delay request-response

    -   P2P: peer delay

    Use the following command:

    .. code-block:: none

        ~(keystone_admin)$ system ptp-modify --mechanism=<e2e/p2p>

-   **PTP Role**

    |PTP| master/slave interfaces are not defined by default. They must be
    specified by the administrator for each host.

    The **ptp\_role** option can be added to interfaces, and can be defined
    for master, slave, and none. This option allows administrators to
    configure interfaces that can be used for |PTP| services. The master and
    slave roles are limited to platform, |SRIOV|, and VF interfaces. Any number
    of master and slave interfaces can be specified per host.

    If a host has **clock\_synchronization=ptp**, there must be at least one
    host interface with a |PTP| role specified. This is enforced during host
    unlock.

    For example, this service can be specified using the following commands:

    .. code-block:: none

        ~(keystone_admin)$ system host-if-modify compute-3 ens803f0 -n sriovptp --ptp-role slave

To apply changes to hosts, use the following command:

.. code-block:: none

    ~(keystone_admin)$ system ptp-apply

|PTP| changes will be applied to all unlocked hosts configured with ptp
clock\_synchronization.

.. _configuring-ptp-service-using-the-cli-section-qn1-p3d-vkb:

----------------------
Advanced Configuration
----------------------

Using service parameters, you can customize a wide range of linuxptp module
settings to use the system in a much wider range of |PTP| configurations.

.. caution::
    These parameters are written to the ptp4l configuration file without error
    checking. Caution must be taken to ensure that parameter names and
    values are correct as errors will cause ptp4l launch failures.

The following service parameters are available:

**ptp global <name>=<value>**
    This service parameter allows you to write or overwrite values found
    in the global section of the ptp4l configuration file. For example,
    the command

    .. code-block:: none

        ~(keystone_admin)$ system service-parameter-add ptp global domainNumber=24

    results in the following being written to the configuration file:

    .. code-block:: none

        domainNumber 24

    ptp global service parameters take precedence over the system ptp
    values. For example, if the system ptp delay mechanism is
    **E2E**, and you subsequently run the command

    .. code-block:: none

        ~(keystone_admin)$ system service-parameter-add ptp global delay_mechanism=P2P

    Then the **P2P** will be used instead.

**ptp phc2sys update-rate=<value>**
    This parameter controls the update-rate of the phc2sys service, in
    seconds.

**ptp phc2sys summary-updates=<value>**
    This parameter controls the number of clock updates to be included in
    summary statistics.

To apply service parameter changes to hosts, use the following command:

.. code-block:: none

    ~(keystone_admin)$ system service-parameter-apply ptp

|PTP| changes will be applied to all unlocked hosts configured with
ptp clock\_synchronization.