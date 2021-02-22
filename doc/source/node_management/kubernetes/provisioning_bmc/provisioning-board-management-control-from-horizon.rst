
.. ylw1575916355194
.. _provisioning-board-management-control-from-horizon:

===============================================
Provision Board Management Control from Horizon
===============================================

You can provision |BMC| for a host from Horizon.

|BMC| can be provisioned to use either Redfish or |IPMI|. You can also have the
selection made dynamically, in which case Redfish will be used if available,
and otherwise |IPMI| will be attempted.

For more information about Redfish, see `https://www.dmtf.org/standards/redfish
<https://www.dmtf.org/standards/redfish>`__.

For more information about |IPMI|, see:
`https://www.intel.com/content/www/us/en/products/docs/servers/ipmi/ipmi-home.html?wapkw=ipmi
<https://www.intel.com/content/www/us/en/products/docs/servers/ipmi/ipmi-home.html?wapkw=ipmi>`__.

For information about deprovisioning |BMC|, see :ref:`Deprovision Board
Management Control from Horizon
<deprovisioning-board-management-control-from-horizon>`.

.. rubric:: |proc|

#.  In Horizon, navigate to **Admin** \> **Host Inventory** and select
    **Edit Host** for the host you wish to edit.

    The Edit Host dialog appears.

#.  Switch to the Board Management tab.

    .. figure:: ../figures/sxl1575923501137.jpeg
        :scale: 80%

#.  From the **Board Management Controller Type** drop-down list, select
    a mode.

    **Dynamic**
        This option attempts to use Redfish followed by |IPMI| if Redfish is
        not available.

    **IPMI**
        Board management operations will use the |IPMI| protocol.

    **Redfish**
        Board management operations will use the Redfish protocol.
