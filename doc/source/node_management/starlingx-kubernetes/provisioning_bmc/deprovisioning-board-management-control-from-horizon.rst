
.. fya1579613399228
.. _deprovisioning-board-management-control-from-horizon:

=================================================
Deprovision Board Management Control from Horizon
=================================================

You can deprovision |BMC| for a host from Horizon.

|BMC| can be decommissioned by selecting the none option.

For more information about Redfish,
see `https://www.dmtf.org/standards/redfish <https://www.dmtf.org/standards/redfish>`__.

For more information about |IPMI|, see:
`https://www.intel.com/content/www/us/en/products/docs/servers/ipmi/ipmi-home.html?wapkw=ipmi
<https://www.intel.com/content/www/us/en/products/docs/servers/ipmi/ipmi-home.html?wapkw=ipmi>`__.

.. rubric:: |proc|

#.  In Horizon, navigate to **Admin** \> **Host Inventory** and select
    **Edit Host** for the host you wish to edit.

    The Edit Host dialog appears.

#.  Switch to the Board Management tab.

    .. figure:: ../figures/sxl1575923501137.jpeg
        :scale: 80%

#.  From the **Board Management Controller Type** drop-down list, select
    the **No Board Management** mode.
