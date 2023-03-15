
.. vhp1558616349331
.. _synchronization-monitoring-and-control:

======================================
Synchronization Monitoring and Control
======================================

Configuration changes made at the System Controller are synchronized
automatically across the |prod-dc|. You can monitor synchronization and enable
or disable it through the managed attribute of the subcloud.

Each subcloud is initially in the unmanaged state. Use the following command to
change the subcloud to the managed state and synchronize configuration data,
and to collect alarms from the subcloud.

.. code-block:: none

    ~(keystone_admin)]$ dcmanager subcloud manage <subcloud>

The subcloud is synchronized when it is first connected to the |prod-dc| and
set to managed. A backup audit and synchronization is run at regular intervals
\(every ten minutes) for subclouds in the Managed state, synchronizing them to
the System Controller. You can view the synchronization status for individual
subclouds on the Cloud Overview page from **Distributed Cloud Admin** \>
**Cloud Overview**.

If a subcloud is not synchronized, it may be in an **Unmanaged** state. The
subcloud is synchronized immediately when it is changed to the **Managed**
state.

Configuration changes made from the System Controller, and i.e. by specifying
the ``--os-region-name`` option as ``SystemController`` are synchronized
immediately. For example, to add an |SNMP| trap destination and immediately
synchronize this configuration change to all subclouds in the **Managed**
state, use the following command:

.. code-block:: none

    ~(keystone_admin)]$ system --os-region-name SystemController snmp-trapdest-add -i 10.10.10.2 -c my-community

