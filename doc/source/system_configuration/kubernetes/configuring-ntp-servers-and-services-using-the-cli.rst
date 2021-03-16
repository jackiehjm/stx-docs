
.. ktx1552673128591
.. _configuring-ntp-servers-and-services-using-the-cli:

================================================
Configure NTP Servers and Services Using the CLI
================================================

You can use the CLI to add or update a list of |NTP| servers and services.

**NTP Servers**

You can specify up to three |NTP| servers using the CLI or the Horizon Web
interface. For more information, see :ref:`Configure NTP Servers and Services Using Horizon <configuring-ntp-servers-and-services-using-horizon>`.

To view the existing |NTP| server configuration, use the following command.

.. code-block:: none

    ~(keystone_admin)]$ system ntp-show
    +--------------+----------------------------------------------+
    | Property     | Value                                        |
    +--------------+----------------------------------------------+
    | uuid         | c65d5dcd-de6c-4ff9-89a1-c385dd4c7310         |
    | ntpservers   | 0.pool.ntp.org,1.pool.ntp.org,3.pool.ntp.org |
    | isystem_uuid | a16d7b07-1d42-41cf-b001-04bc25216a2b         |
    | created_at   | 2019-12-07T18:31:14.242942+00:00             |
    | updated_at   | 2019-12-07T18:42:09.244572+00:00             |
    +--------------+----------------------------------------------+

.. note::
    When you change the |NTP| system configuration you must lock/unlock all
    hosts. This process requires a swact on the controllers. During a host
    swact the system may raise |NTP| alarms.

To change the |NTP| server IP addresses, use the following command syntax. The
ntpservers option takes a comma-delimited list of |NTP| server names.

.. code-block:: none

    ~(keystone_admin)]$ system ntp-modify \
    ntpservers=<server_1[,server_2][,server_3]>

For example:

.. code-block:: none

    ~(keystone_admin)]$ system ntp-modify ntpservers=0.pool.ntp.org,1.pool.ntp.org,3.pool.ntp.org

**NTP Service**

Clock synchronization, synchronizes time across multiple systems in a
network. The default value for **clock\_synchronization** is **ntp**.

.. xbooklink For more information on configuring the NTP service for clock
   synchronization, see |node-doc|: `Host Inventory <hosts-tab>`.

.. note::
    |NTP| and |PTP| is configured per host. Lock/unlock the host when
    updating **clock\_synchronization** for the host.

Use the following command to change the clock synchronization on the host:

.. code-block:: none

    ~(keystone_admin)]$ system host-update controller-0 clock_synchronization=ntp
    +-----------------------+--------------------------------------------+
    | Property              | Value                                      |
    +-----------------------+--------------------------------------------+
    | action                | none                                       |
    | administrative        | unlocked                                   |
    | availability          | available                                  |
    | bm_ip                 | None                                       |
    | bm_type               | None                                       |
    | bm_username           | None                                       |
    | boot_device           | /dev/disk/by-path/pci-0000:00:1f.2-ata-1.0 |
    | capabilities          | {u'stor_function': u'monitor'}             |
    | clock_synchronization | ntp                                        |
    | config_applied        | 16dfa935-e21e-4737-90f4-1afa83a3091b       |
    | config_status         | None                                       |
    | config_target         | 16dfa935-e21e-4737-90f4-1afa83a3091b       |
    | console               | ttyS0,115200n8                             |
    | created_at            | 2020-02-27T15:00:07.108865+00:00           |
    | hostname              | controller-0                               |
    | id                    | 1                                          |
    | install_output        | text                                       |
    | install_state         | None                                       |
    | install_state_info    | None                                       |
    | inv_state             | inventoried                                |
    | invprovision          | provisioned                                |
    | location              | {}                                         |
    | mgmt_ip               | 192.168.204.3                              |
    | mgmt_mac              | 00:00:00:00:00:00                          |
    | operational           | enabled                                    |
    | personality           | controller                                 |
    | reserved              | False                                      |
    | rootfs_device         | /dev/disk/by-path/pci-0000:00:1f.2-ata-1.0 |
    | serialid              | None                                       |
    | software_load         | 20.06                                      |
    | subfunction_avail     | available                                  |
    | subfunction_oper      | enabled                                    |
    | subfunctions          | controller,worker                          |
    | task                  |                                            |
    | tboot                 | false                                      |
    | ttys_dcd              | None                                       |
    | updated_at            | 2020-02-28T17:21:42.374847+00:00           |
    | uptime                | 7403                                       |
    | uuid                  | cc870915-b8dd-4989-914c-7095eabe36e8       |
    | vim_progress_status   | services-enabled                           |
    +-----------------------+--------------------------------------------+

To view the |NTP| service configuration, use the following command:

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
    | clock_synchronization | ntp                                            |
    | config_applied        | 590f29ad-19e2-43ee-855e-f765814e3ecd           |
    | config_status         | Config out-of-date                             |
    | config_target         | cd18ec25-c030-4b0c-862b-c39726275743           |
    | console               | ttyS0,115200n8                                 |
    | created_at            | 2020-02-27T18:32:58.752361+00:00               |
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
    | updated_at            | 2020-02-28T15:17:06.658008+00:00               |
    | uptime                | 159970                                         |
    | uuid                  | 92c86da2-adb7-4fb2-92fc-82759e25108d           |
    | vim_progress_status   | services-enabled                               |
    +-----------------------+------------------------------------------------+
