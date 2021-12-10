.. _configure-collectd-to-store-host-performance-data-caf7802851bc:

=================================================
Configure collectd to Store Host Performance Data
=================================================

You can use collectd to receive and store performance data from multiple hosts.

.. contents:: |minitoc|
   :local:
   :depth: 1

.. rubric:: |context|

The collectd network plugin configuration is disabled by default. Use the
|prod| ``network_servers`` service-parameter to enable and configure it for use
on one or more hosts and ports.

.. note::
    If you are planning to use a remote InfluxDB instance as a receiver, the
    default port is 25826. Overriding this port must be done on the host where
    an InfluxDB instance is running.

    If a port is not defined using the service parameter, the default port from
    InfluxDB will be automatically set but will not be visible in the service
    parameter list. Therefore, skipping port definition is discouraged.

Add collectd configuration parameters
=====================================

.. rubric:: |proc|

#. List the currently configured service parameters:

   .. code-block:: none

       ~(keystone_admin)]$ system service-parameter-list

       +-------------+------------+---------+-----------------+-------+-------------+----------+
       | uuid        | service    | section | name            | value | personality | resource |
       +-------------+------------+---------+-----------------+-------+-------------+----------+
       | 17d024d1... | horizon    | auth    | lockout_retries | 3     | None        | None     |
       | bf3cefdb... | horizon    | auth    | lockout_seconds | 300   | None        | None     |
       | d574763b... | radosgw    | config  | fs_size_mb      | 25    | None        | None     |
       | 03dd07ba... | http       | config  | http_port       | 8080  | None        | None     |
       | 1bbdb378... | http       | config  | https_port      | 8443  | None        | None     |
       | 8dc30732... | kubernetes | config  | pod_max_pids    | 10000 | None        | None     |
       | 3346bec7... | radosgw    | config  | service_enabled | false | None        | None     |
       +-------------+------------+---------+-----------------+-------+-------------+----------+

   Note that collectd is not listed in the :guilabel:`section` column.

#. Add the platform collectd ``network_servers`` service parameter using the
   following command format:

   .. code-block:: none

       platform collectd network_servers=<host>:<port>,<host>:<port>,...,<hostN>:<portN>

   where:

   ``host``
       A host to receive and store data on. IPv6 addresses are also supported.
       For example:

       .. code-block:: none

           network_servers=[2001:0db8:85a3:08d3:1319:8a2e:0370:7344]:8080,[ff18::efc0:4a42]:25826

   ``port``
       A port on ``<host>`` to send data to. The port must be an integer
       between 1 and 65535.

   Multiple host/port combinations can be specified as a comma-separated list.
   For example:

   .. code-block:: none

       ~(keystone_admin)]$ system service-parameter-add platform collectd network_servers=controller:25826,192.168.1.123:25826

       +-------------+--------------------------------------+
       | Property    | Value                                |
       +-------------+--------------------------------------+
       | uuid        | 69553a96-1f73-4e7c-8fd0-1235c0aa1771 |
       | service     | platform                             |
       | section     | collectd                             |
       | name        | network_servers                      |
       | value       | controller:25826,192.168.1.123:25826 |
       | personality | None                                 |
       | resource    | None                                 |
       +-------------+--------------------------------------+

#. |optional| To persist the new parameter, run the following command:

   .. code-block:: none

       ~(keystone_admin)]$ system service-parameter-apply platform

#. List the currently configured service parameters again and confirm your
   change:

   .. code-block:: none

       ~(keystone_admin)]$ system service-parameter-list

       +-------------+------------+----------+-----------------+--------------------------+-------------+----------+
       | uuid        | service    | section  | name            | value                    | personality | resource |
       +-------------+------------+----------+-----------------+--------------------------+-------------+----------+
       | 17d024d1... | horizon    | auth     | lockout_retries | 3                        | None        | None     |
       | bf3cefdb... | horizon    | auth     | lockout_seconds | 300                      | None        | None     |
       | 69553a96... | platform   | collectd | network_servers | influxdb-host:25826,192. | None        | None     |
       |             |            |          |                 | 168.1.123:25826          |             |          |
       |             |            |          |                 |                          |             |          |
       | d574763b... | radosgw    | config   | fs_size_mb      | 25                       | None        | None     |
       | 03dd07ba... | http       | config   | http_port       | 8080                     | None        | None     |
       | 1bbdb378... | http       | config   | https_port      | 8443                     | None        | None     |
       | 8dc30732... | kubernetes | config   | pod_max_pids    | 10000                    | None        | None     |
       | 3346bec7... | radosgw    | config   | service_enabled | false                    | None        | None     |
       +-------------+------------+----------+-----------------+--------------------------+-------------+----------+

#. Lock and unlock the controller to have your changes take effect:

   .. code-block:: none

       ~(keystone_admin)]$ system host-lock controller-0
       ~(keystone_admin)]$ system host-unlock controller-0

   This step can take up to 10 minutes.

Edit collectd configuration parameters
======================================

Use the :command:`system service-parameter-modify` command to change an
existing collectd configuration.

.. rubric:: |eg|

#. Change the parameter.

   This example replaces port 25826 on host 192.168.1.123 with port 25000 on
   host 192.168.1.200.

   .. code-block:: none

       ~(keystone_admin)]$ system service-parameter-modify platform collectd network_servers=192.168.1.200:25000,influxdb-host:25826

       +-------------+--------------------------------------+
       | Property    | Value                                |
       +-------------+--------------------------------------+
       | uuid        | 69553a96-1f73-4e7c-8fd0-1235c0aa1771 |
       | service     | platform                             |
       | section     | collectd                             |
       | name        | network_servers                      |
       | value       | 192.168.1.200:25000,controller:25826 |
       | personality | None                                 |
       | resource    | None                                 |
       +-------------+--------------------------------------+

#. |optional| Persist the new parameter:

   .. code-block:: none

       ~(keystone_admin)]$ system service-parameter-apply platform

#. Lock and unlock the controller to have your changes take effect:

   .. code-block:: none

       ~(keystone_admin)]$ system host-lock controller-0
       ~(keystone_admin)]$ system host-unlock controller-0

   This step can take up to 10 minutes.

Remove collectd configuration parameters
========================================

Use the :command:`system service-parameter-delete` command to remove an
existing collectd configuration.

.. rubric:: |eg|

#. List the currently configured service parameters and locate the
   appropriate |UUID|:

   .. code-block:: none

       ~(keystone_admin)]$ system service-parameter-list

       +--------------------------------------+------------+----------+-----------------+-----------------------+-------------+----------+
       | uuid                                 | service    | section  | name            | value                 | personality | resource |
       +--------------------------------------+------------+----------+-----------------+-----------------------+-------------+----------+
       | 17d024d1-55d3-4bc9-a490-2eda6e19e6d1 | horizon    | auth     | lockout_retries | 3                     | None        | None     |
       | bf3cefdb-3b27-4dd0-aa77-47f362a23db2 | horizon    | auth     | lockout_seconds | 300                   | None        | None     |
       | 69553a96-1f73-4e7c-8fd0-1235c0aa1771 | platform   | collectd | network_servers | controller:25826,192. | None        | None     |
       |                                      |            |          |                 | 168.1.123:25826       |             |          |
       |                                      |            |          |                 |                       |             |          |
       | d574763b-e90b-4cca-a577-03269f1fc473 | radosgw    | config   | fs_size_mb      | 25                    | None        | None     |
       | 03dd07ba-fd7e-4ec1-8113-42ea9d6bcb96 | http       | config   | http_port       | 8080                  | None        | None     |
       | 1bbdb378-a1d6-4eb0-b210-73d573954b8d | http       | config   | https_port      | 8443                  | None        | None     |
       | 8dc30732-b617-4ddd-aa97-69edd25e4075 | kubernetes | config   | pod_max_pids    | 10000                 | None        | None     |
       | 3346bec7-3b57-4f21-a571-24d39f27dd0b | radosgw    | config   | service_enabled | false                 | None        | None     |
       +--------------------------------------+------------+----------+-----------------+-----------------------+-------------+----------+

   In this example, the |UUID| for collectd is ``69553a96-1f73-4e7c-8fd0-1235c0aa1771``.

#. Remove the parameter:

   .. code-block:: none

       ~(keystone_admin)]$ system service-parameter-delete 69553a96-1f73-4e7c-8fd0-1235c0aa1771

#. List the currently configured service parameters:

   .. code-block:: none

       ~(keystone_admin)]$ system service-parameter-list

       +-------------+------------+---------+-----------------+-------+-------------+----------+
       | uuid        | service    | section | name            | value | personality | resource |
       +-------------+------------+---------+-----------------+-------+-------------+----------+
       | 17d024d1... | horizon    | auth    | lockout_retries | 3     | None        | None     |
       | bf3cefdb... | horizon    | auth    | lockout_seconds | 300   | None        | None     |
       | d574763b... | radosgw    | config  | fs_size_mb      | 25    | None        | None     |
       | 03dd07ba... | http       | config  | http_port       | 8080  | None        | None     |
       | 1bbdb378... | http       | config  | https_port      | 8443  | None        | None     |
       | 8dc30732... | kubernetes | config  | pod_max_pids    | 10000 | None        | None     |
       | 3346bec7... | radosgw    | config  | service_enabled | false | None        | None     |
       +-------------+------------+---------+-----------------+-------+-------------+----------+

   Note that collectd is no longer listed in the :guilabel:`section` column.

#. Lock and unlock the controller to have your changes take effect:

   .. code-block:: none

       ~(keystone_admin)]$ system host-lock controller-0
       ~(keystone_admin)]$ system host-unlock controller-0

   This step can take up to 10 minutes.
