
.. tie1580219717420
.. _setting-snmp-identifying-information:

================================
Set SNMP Identifying Information
================================

You can set :abbr:`SNMP (Simple Network Management Protocol)` system
information including name, location and contact details.

.. rubric:: |proc|

-   Use the following command syntax to set the **sysContact** attribute.

    .. code-block:: none

        ~(keystone_admin)$ system modify --contact <site-contact>

-   Use the following command syntax to set the **sysLocation** attribute.

    .. code-block:: none

        ~(keystone_admin)$ system modify --location <location>

-   Use the following command syntax to set the **sysName** attribute.

    .. code-block:: none

        ~(keystone_admin)$ system modify --location <system-name>