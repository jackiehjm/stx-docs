
.. hfk1575913849620
.. _provisioning-board-management-control-using-the-cli:

================================================
Provision Board Management Control Using the CLI
================================================

You can provision |BMC| either when adding a host or at a later time.

|BMC| can be provisioned to use either Redfish or |IPMI|. You can allow the
selection made dynamically based on the capabilities of the host, in which case
Redfish will be used if available, and otherwise |IPMI|.

For more information about Redfish,
see `https://www.dmtf.org/standards/redfish
<https://www.dmtf.org/standards/redfish>`__.

For more information about |IPMI|, see:
`https://www.intel.com/content/www/us/en/products/docs/servers/ipmi/ipmi-home.html?wapkw=ipmi
<https://www.intel.com/content/www/us/en/products/docs/servers/ipmi/ipmi-home.html?wapkw=ipmi>`__.

For information about deprovisioning |BMC|,
see :ref:`Deprovision Board Management Control from the CLI
<deprovisioning-board-management-control-from-the-cli>`.
