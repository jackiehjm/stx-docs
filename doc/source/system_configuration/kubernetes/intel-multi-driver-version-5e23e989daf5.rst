.. _intel-multi-driver-version-5e23e989daf5:

==========================
Intel Multi-driver Version
==========================

.. rubric:: |context|

This sections describes how to change the Intel driver bundle version.
Currently there are 2 CVL versions available:

.. warning::

    The |NIC| firmware (NVM) has to align with one of the selected driver
    bundles listed below.

-   ``cvl-4.0.1`` (default)
      - ice: 1.9.11 / Required NVM/firmware: 4.0
      - i40e: 2.20.12 / Required NVM/firmware: 8.70
      - iavf: 4.5.3

-   ``cvl-2.54`` (legacy)
      - ice: 1.5.8.1 / Required NVM/firmware: 2.54
      - i40e: 2.14.13 / Required NVM/firmware: 8.21
      - iavf: 4.0.1

Change Intel Multi-driver Version
---------------------------------

On initial installation, the system will use the default driver bundle version
which is ``cvl-4.0.1``. The chosen driver bundle will be applied subsequently
as part of the deployment configuration, if specified.

When there is no driver bundle specified as part of deployment, the system will
continue to use the default driver bundle.

To change the driver bundle to the legacy version, add the system service
parameter ``intel_nic_driver_version`` to ``cvl-2.54``.

.. code-block:: none

    ~(keystone_admin)$ system service-parameter-add platform config intel_nic_driver_version=cvl-2.54


To change the driver bundle back to the default version, there are two options:

#.  Modify the system service parameter ``intel_nic_driver_version`` to
    ``cvl-4.0.1``.

    .. code-block:: none

        ~(keystone_admin)$ system service-parameter-modify platform config intel_nic_driver_version=cvl-4.0.1

#.  Apply the service parameter change.

    .. code-block:: none

        ~(keystone_admin)$ system service-parameter-apply platform
        Applying platform service parameters

#.  Remove the system service parameter ``intel_nic_driver_version``.

.. code-block:: none

    ~(keystone_admin)$ system service-parameter-list --service platform --section config --name intel_nic_driver_version
    +--------------------------------------+------------+---------+---------------------------+-----------+-------------+----------+
    | uuid                                 | service    | section | name                      | value     | personality | resource |
    +--------------------------------------+------------+---------+---------------------------+-----------+-------------+----------+
    | 84306212-d96d-4a2a-8cc0-2d48781e006c | platform   | config  | intel_nic_driver_version  | cvl-2.54  | None        | None     |
    +--------------------------------------+------------+---------+---------------------------+-----------+-------------+----------+
    ~(keystone_admin)$ system service-parameter-delete 84306212-d96d-4a2a-8cc0-2d48781e006c

To apply the service parameter change, all hosts need to be locked and
unlocked, using the following commands for each host depending on the deployed
configuration:

For |AIO-SX| deployments:

.. code-block:: none

    ~(keystone_admin)$ system host-lock controller-0
    ~(keystone_admin)$ system host-unlock controller-0

For |AIO-DX| and Standards deployments, after controller-1 is locked/unlocked
swact controller-0 to make controller-1 the active node. The next set of
commands are executed on controller-0 node:

.. code-block:: none

    ~(keystone_admin)$ system host-lock controller-1
    ~(keystone_admin)$ system host-unlock controller-1
    ~(keystone_admin)$ system host-swact controller-0

On controller-1, after controller-0 is locked/unlocked swact controller-1 to go
back to controller-0 as the active node. The next set of commands are executed
on controller-1 node:

.. code-block:: none

    ~(keystone_admin)$ system host-lock controller-0
    ~(keystone_admin)$ system host-unlock controller-0
    ~(keystone_admin)$ system host-swact controller-1

For each worker node in the configuration execute the commands from
controller-0:

.. code-block:: none

    ~(keystone_admin)$ system host-lock worker-0
    ~(keystone_admin)$ system host-unlock worker-0

To verify the current Intel driver version use ``ethtool -i`` on the desired
Intel network interface. For example:

.. code-block:: none

    ~(keystone_admin)$ ethtool -i ens785f0 | egrep '^(driver|version):'
    driver: i40e
    version: 2.20.12

Upgrades
--------

For an upgrade, the default drivers will be configured after the upgrade.
To set the legacy drivers for an upgrade, set the driver bundle on
controller-0 prior to the upgrade using the following commands:

.. code-block:: none

    ~(keystone_admin)$ system service-parameter-add platform config intel_nic_driver_version=cvl-2.54 --resource platform::compute::grub::params::g_intel_nic_driver_version
    ~(keystone_admin)$ system service-parameter-apply platform

Backup and Restore
------------------

In case a Backup and Restore is performed, after unlocking the host during a
restore operation, the system will be configured with the correct multi-driver
version, but the drivers will be loaded to the default version.

To load the drivers to the correct configured version a second host-unlock will
be needed.

.. only:: partner

    .. include:: /_includes/intel-multi-driver-version.rest

