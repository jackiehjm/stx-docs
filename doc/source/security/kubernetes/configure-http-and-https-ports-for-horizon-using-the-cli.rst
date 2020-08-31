
.. luj1551986512461
.. _configure-http-and-https-ports-for-horizon-using-the-cli:

========================================================
Configure HTTP and HTTPS Ports for Horizon Using the CLI
========================================================

You can configure the **HTTP / HTTPS** ports for accessing the Horizon Web
interface using the CLI.

To access Horizon, use **http://<external OAM IP\>:8080**. By default, the
ports are **HTTP=8080**, and **HTTPS=8443**.

.. rubric:: |prereq|

You can configure **HTTP / HTTPS** ports only when all hosts are unlocked
and enabled.

.. rubric:: |context|

Use the system :command:`service-parameter-list --service=http` command to
list the configured **HTTP**, and **HTTPS** ports.

.. code-block:: none

    ~(keystone_admin)$ system service-parameter-list --service http
    +---------+----------+---------+------------+-------+------------+--------+
    | uuid    | service  | section | name       | value |personality |Resource|
    +---------+----------+---------+------------+-------+------------+--------+
    | 4fc7... | http     | config  | http_port  | 8080  | None       |None    |
    | 9618... | http     | config  | https_port | 8443  | None       |None    |
    +---------+----------+---------+------------+-------+-------------+-------+

.. rubric:: |proc|

#.  Use the :command:`system service-parameter-modify` command to configure
    a different port for **HTTP**, and **HTTPS**. For example,

    .. code-block:: none

        ~(keystone_admin)$ system service-parameter-modify http config http_port=8090

        ~(keystone_admin)$ system service-parameter-modify http config https_port=9443


#.  Apply the service parameter change.

    .. code-block:: none

        ~(keystone_admin)$ system service-parameter-apply http
        Applying http service parameters

    .. note::
        Do not use ports used by other services on the platform, OAM and
        management interfaces on the controllers, or in custom
        applications. For more information, see, |sec-doc|: :ref:`Default
        Firewall Rules <security-default-firewall-rules>`.

        If you plan to run |prod-os|, do not reset the ports to 80/443, as
        these ports may be used by containerized OpenStack, by default.


.. rubric:: |postreq|

A configuration out-of-date alarm is generated for each host. Wait for the
configuration to be automatically applied to all nodes and the alarms to be
cleared on all hosts before performing maintenance operations, such as
rebooting or locking/unlocking a host.

