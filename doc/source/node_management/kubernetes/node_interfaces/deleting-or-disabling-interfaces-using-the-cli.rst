
.. fjq1579522386668
.. _deleting-or-disabling-interfaces-using-the-cli:

==========================================
Delete or Disable Interfaces Using the CLI
==========================================

You can delete an interface using the CLI.

.. note::

   You cannot delete an interface of type **Ethernet**. You can designate it as
   unused by setting its **Interface Class** to **none**.

.. rubric:: |proc|

.. _deleting-or-disabling-interfaces-using-the-cli-steps-fpc-g4h-lkb:

-  Depending on the type of interface, do one of the following:

   *  Use the :command:`system host-if-delete` command.

      .. code-block:: none

         ~(keystone_admin)system host-if-delete <host> <interface>

      where the following options are available:

      **<host>**
        The hostname or ID of the host.

      **<interface>**
        The name or UUID of the interface.

      For example, to delete an aggregated Ethernet interface named **eth1a**
      on **worker-0**:

      .. code-block:: none

         ~(keystone_admin)$ system host-if-delete worker-0 eth1a
         Deleted interface: host worker-0 if eth1a

   *  Use the :command:`system host-if-modify` command.

      For example, to designate the **eth1** Ethernet interface on
      **worker-0** as unused:

      .. code-block:: none

         ~(keystone_admin)$ system host-if-modify -c none worker-0 eth1
         +-------------------+---------------------------------------+
         | Property          | Value                                 |
         +-------------------+---------------------------------------+
         | ifname            | eth1                                  |
         | ifclass           | none                                  |
         | iftype            | ethernet                              |
         | ports             | [u'eth1']                             |
         | providernetworks  | None                                  |
         | imac              | 08:00:27:91:f9:b6                     |
         | imtu              | 1500                                  |
         | aemode            | None                                  |
         | schedpolicy       | None                                  |
         | txhashpolicy      | None                                  |
         | uuid              | 87dd1d4b-1e38-4f6c-a692-4c4199a3ef0e  |
         | ihost_uuid        | 3b659824-eac3-4446-af73-f4a519e8ab30  |
         | vlan_id           | None                                  |
         | uses              | []                                    |
         | used_by           | []                                    |
         | created_at        | 2016-09-22T18:24:08.092296+00:00      |
         | updated_at        | 2016-09-22T18:36:46.333354+00:00      |
         | sriov_numvfs      | 0                                     |
         | ipv4_mode         | disabled                              |
         | ipv6_mode         | disabled                              |
         | accelerated       | [u'True']                             |
         +-------------------+---------------------------------------+
