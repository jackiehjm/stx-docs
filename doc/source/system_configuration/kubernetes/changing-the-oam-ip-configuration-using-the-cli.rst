
.. jpu1552672927783
.. _changing-the-oam-ip-configuration-using-the-cli:

=============================================
Change the OAM IP Configuration Using the CLI
=============================================

If you prefer, you can use the CLI to view or change the |OAM| IP Configuration.

.. rubric:: |context|

During installation, |prod-long| is configured with an |OAM| network subnet and
related IP addresses. You can change these addresses using the the CLI or the
Horizon Web Interface. You can use IPv4 or IPv6 addresses.

.. caution::

    Access to the |OAM| network is interrupted during this procedure. When a
    :command:`swact` is performed on the controllers, the newly active
    controller uses the changed |OAM| IP addresses. The existing |OAM| IP
    addresses are no longer valid, and you must use the new OAM IP addresses
    to reconnect to the controller. Changes to external |OAM| access routing
    settings may also be required. In addition, |VNC| console access to
    worker-node hosts is interrupted until the hosts are locked and unlocked.

    Once the |OAM| IP addresses are changed, any existing server certificates
    (ssl, docker_registry, OpenStack etc.) that have the old |OAM| IP addresses
    in their |SANs| must be updated with new certificates reflecting the new
    addresses. For more information, see :ref:`Install/Update Local Registry
    Certificates <installing-updating-the-docker-registry-certificate>`.

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
    oam_floating_ip, oam_c0\_ip and oam_c0\_ip parameters are not
    supported. To change the |OAM| IP address of a Simplex System, the parameter
    oam_ip must be used in combination with oam_gateway_ip and oam_subnet.

    For example:

    .. code-block:: none

        ~(keystone_admin)]$ system oam-modify oam_subnet=10.10.10.0/24 oam_gateway_ip=10.10.10.1 oam_ip=10.10.10.2

.. note::
    If you change the IP address version (IPv4 or IPv6), ensure that the
    same version is used for the DNS and NTP servers.

After changing the |OAM| server configuration, you must lock and unlock the
controllers. This process requires a swact on the controllers. Then you must
lock and unlock the worker nodes one at a time, ensuring that sufficient
resources are available to migrate any running instances.

.. note::
   On AIO Simplex systems you do not need to lock and unlock the host. The
   changes are applied automatically.

.. rubric:: |postreq|

(Optional) If you are running Docker proxy on your system, you need to
change the **no_proxy** service parameter using the CLI to append the new
OAM IP, using the following steps:

#.  To list the service parameters, use the :command:`system service-parameter-list`
    command. Note the old **no_proxy** values.

#.  To append the new OAM IP to the no_proxy parameter, use the
    :command:`system serviceparameter-modify docker proxy no_proxy=old_value, new_oam_ip(s)`
    command.

    Where, *<new_oam_ip(s)>* is the new OAM IP(s) that needs to be appended
    to the **no_proxy** parameter. Ensure you include new values for the
    floating OAM, controller-0 OAM, and controller-1 if they are changed.

#.  To apply the changes, use the :command:`system service-parameter-apply docker`
    command.

#.  Lock and unlock the controller(s).

.. seealso::

    :ref:`Default Firewall Rules <security-default-firewall-rules>`

    :ref:`Modify Firewall Options <security-firewall-options>`