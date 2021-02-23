
.. asw1579609255900
.. _provisioning-bmc-when-adding-a-host:

================================
Provision BMC when Adding a Host
================================

|BMC| can be provisioned when adding a host by using the
:command:`host-add` command.

.. rubric:: |proc|

-   To provision the host, use the following syntax.

    .. code-block:: none

        system host-add -n <name> -p <personality> -m <mgmtMacAddress> -I <bm_IP> -U <bm_UserName> -P <bm_Password> -T [redfish|ipmi|dynamic]
