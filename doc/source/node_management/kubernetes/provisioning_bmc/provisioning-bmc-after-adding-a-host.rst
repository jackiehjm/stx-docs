
.. wgl1579609702688
.. _provisioning-bmc-after-adding-a-host:

=================================
Provision BMC after Adding a Host
=================================

|BMC| can be provisioned after adding a host by using the
:command:`host-update` command.

.. rubric:: |proc|

-   To provision the host, use the following syntax.

    .. code-block:: none

        system host-update <name> bm_ip=<bm_IP> bm_username=<bm_UserName> bm_password=<bm_Password> bm_type=[redfish|ipmi|dynamic]
