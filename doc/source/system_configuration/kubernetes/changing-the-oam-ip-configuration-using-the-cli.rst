
.. jpu1552672927783
.. _changing-the-oam-ip-configuration-using-the-cli:

=============================================
Change the OAM IP Configuration Using the CLI
=============================================

If you prefer, you can use the CLI to view or change the |OAM| IP Configuration.

To view the existing |OAM| IP configuration, use the following command.

.. code-block:: none

    ~(keystone_admin)]$ system oam-show
    +-----------------+--------------------------------------+
    | Property        | Value                                |
    +-----------------+--------------------------------------+
    | created_at      | 2018-05-16T20:06:25.523495+00:00     |
    | isystem_uuid    | b0380a56-697c-42f7-97bc-f1e407111416 |
    | oam_c0_ip       | 10.10.10.3                           |
    | oam_c1_ip       | 10.10.10.4                           |
    | oam_floating_ip | 10.10.10.2                           |
    | oam_gateway_ip  | 10.10.10.1                           |
    | oam_subnet      | 10.10.10.0/24                        |
    | updated_at      | None                                 |
    | uuid            | 2818e7c4-f730-43bd-b33d-eaff53a92ee1 |
    +-----------------+--------------------------------------+

To change the OAM IP subnet, floating IP address, gateway IP address, or
controller IP addresses, use the following command syntax.

.. code-block:: none

    ~(keystone_admin)]$ system oam-modify oam_subnet=<subnet>/<netmask> \
    oam_gateway_ip=<gateway_ip_address> \
    oam_floating_ip=<floating_IP_address> \
    oam_c0_ip=<controller-0_IP_address> \
    oam_c1_ip=<controller-1_ip_address>

For example:

.. code-block:: none

    ~(keystone_admin)]$ system oam-modify oam_subnet=10.10.10.0/24 \
    oam_gateway_ip=10.10.10.1 \
    oam_floating_ip=10.10.10.2 \
    oam_c0_ip=10.10.10.3 \
    oam_c1_ip=10.10.10.4

.. note::
    On AIO Simplex systems, the
    oam\_floating\_ip, oam\_c0\_ip and oam\_c0\_ip parameters are not
    supported. To change the |OAM| IP address of a Simplex System, the parameter
    oam\_ip must be used in combination with oam\_gateway\_ip and oam\_subnet.

    For example:

    .. code-block:: none

        ~(keystone_admin)]$ system oam-modify oam_subnet=10.10.10.0/24 oam_gateway_ip=10.10.10.1 oam_ip=10.10.10.2

.. note::
    If you change the IP address version \(IPv4 or IPv6\), ensure that the
    same version is used for the DNS and NTP servers.

After changing the |OAM| server configuration, you must lock and unlock the
controllers. This process requires a swact on the controllers. Then you must
lock and unlock the worker nodes one at a time, ensuring that sufficient
resources are available to migrate any running instances.

.. note:: 
   On AIO Simplex systems you do not need to lock and unlock the host. The
   changes are applied automatically.