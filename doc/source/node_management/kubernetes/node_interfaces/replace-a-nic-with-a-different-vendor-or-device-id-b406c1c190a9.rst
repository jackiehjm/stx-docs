.. _replace-a-nic-with-a-different-vendor-or-device-id-b406c1c190a9:

==================================================
Replace a NIC with a different vendor or device-id
==================================================

.. rubric:: |context|

The following procedure allows the replacement of a NIC on a host, without
requiring a host or system (in case of |AIO-SX|) re-install and
re-configuration, in the case of the replaced NIC having the different vendor
or device ID information.

The normal approach to making such a change would be to do a ``system
host-delete``, a ``system host-add`` (re-install) and a re-configure of the
host.  In the case of an |AIO-SX| deployment, with only one host, this would
result in a full system re-install and full system re-configuration.

This procedure can be used either for a replacement on the same |PCI| slot or
to a different one. You will first record the current configuration and then
reapply it after replacing the NIC card.

* To replace a NIC with a different vendor or device-id, you must first remove
  the current configuration (if it exists) associated with the physical
  interface.

* If a backup was available prior to this operation, it is necessary to
  regenerate the backup after changing the NIC card as the |PCI| addresses will
  no longer match the saved database files.

* If the replacement affects the |OAM| interface, plan to have an alternative
  access path or keep the serial console access available.

* If the affected interface configuration was not removed prior to the NIC
  replacement, an alarm will be raised asking for the host locking, removal of
  dependent configuration, and host unlocking for the port database correction
  to take effect.  After doing so, you must lock the host again to reconfigure
  the interface with the desired or previous configuration.

* If the affected interfaces are unconfigured (class is ``none`` and the
  :guilabel:`used by i/f` column of :command:`host-if-list` output is empty),
  then the procedure described in
  :ref:`nic-replacement-with-the-same-vendor-and-device-id-32942b7b05e5` can be
  followed.

.. rubric:: |proc|

.. note::
   |UUID| values in the output shown below have been truncated for display
   purposes. When using a |UUID| value as input to a command, use the entire 36
   character string.

#.  If the host in question is the single host of an |AIO-SX| subcloud
    deployment, set the subcloud as unmanaged.

    .. code-block:: none

       ~(keystone_admin)]$ dcmanager subcloud unmanage <subcloud-name>

#.  Lock the host.

    .. code-block:: none

       ~(keystone_admin)]$ system host-lock <hostname>

#.  Identify the port(s) to be replaced.

    .. code-block:: none

       ~(keystone_admin)]$ system host-port-list <hostname>

       +--------------+----------+----------+--------------+--------+-----------+-------------+-------------------------------------------------------+
       | uuid         | name     | type     | pci address  | device | processor | accelerated | device type                                           |
       +--------------+----------+----------+--------------+--------+-----------+-------------+-------------------------------------------------------+
       | f8c45520-... | eno1     | ethernet | 0000:03:00.0 | 0      | 0         | True        | Ethernet Controller 10-Gigabit X540-AT2 [1528]        |
       | c0532da6-... | eno2     | ethernet | 0000:03:00.1 | 0      | 0         | True        | Ethernet Controller 10-Gigabit X540-AT2 [1528]        |
       | a12a5046-... | ens787f0 | ethernet | 0000:81:00.0 | 0      | 1         | True        | Ethernet Controller X710 for 10GbE SFP+ [1572]        |
       | 54877560-... | ens787f1 | ethernet | 0000:81:00.1 | 0      | 1         | True        | Ethernet Controller X710 for 10GbE SFP+ [1572]        |
       | cc702aad-... | ens787f2 | ethernet | 0000:81:00.2 | 0      | 1         | True        | Ethernet Controller X710 for 10GbE SFP+ [1572]        |
       | b27d53ba-... | ens787f3 | ethernet | 0000:81:00.3 | 0      | 1         | True        | Ethernet Controller X710 for 10GbE SFP+ [1572]        |
       | 68e94c5c-... | ens802f0 | ethernet | 0000:83:00.0 | 0      | 1         | True        | 82599ES 10-Gigabit SFI/SFP+ Network Connection [10fb] |
       | 38d28361-... | ens802f1 | ethernet | 0000:83:00.1 | 0      | 1         | True        | 82599ES 10-Gigabit SFI/SFP+ Network Connection [10fb] |
       | c82dc9d0-... | ens803f0 | ethernet | 0000:86:00.0 | 0      | 1         | True        | 82599ES 10-Gigabit SFI/SFP+ Network Connection [10fb] |
       | c6188d09-... | ens803f1 | ethernet | 0000:86:00.1 | 0      | 1         | True        | 82599ES 10-Gigabit SFI/SFP+ Network Connection [10fb] |
       +--------------+----------+----------+--------------+--------+-----------+-------------+-------------------------------------------------------+


    #. Record the current port configuration.

       .. code-block:: none

          ~(keystone_admin)]$ system host-port-show <hostname> <affected-port-name>

#.  Identify the interfaces that are using the port.

    .. code-block:: none

       ~(keystone_admin)]$ system host-if-list <hostname>

       +--------------+----------+-----------------+----------+---------+---------------+---------------+-------------------------+------------+
       | uuid         | name     | class           | type     | vlan id | ports         | uses i/f      | used by i/f             | attributes |
       +--------------+----------+-----------------+----------+---------+---------------+---------------+-------------------------+------------+
       | 0eb262fa-... | pthru0   | pci-passthrough | ethernet | None    | [u'ens787f1'] | []            | []                      | MTU=1500   |
       | 1f7fb5bb-... | oam0     | platform        | ethernet | None    | [u'eno1']     | []            | []                      | MTU=1500   |
       | 2d08c554-... | sriov0   | pci-sriov       | ethernet | None    | [u'ens787f2'] | []            | [u'sriov1']             | MTU=1500   |
       | 39abaab8-... | pxeboot0 | platform        | ethernet | None    | [u'ens802f1'] | []            | [u'cluster0', u'mgmt0'] | MTU=1500   |
       | accadbd9-... | sriov1   | pci-sriov       | vf       | None    | []            | [u'sriov0']   | []                      | MTU=1500   |
       | b0129323-... | mgmt0    | platform        | vlan     | 39      | []            | [u'pxeboot0'] | []                      | MTU=1500   |
       | b27d72e2-... | cluster0 | platform        | vlan     | 44      | []            | [u'pxeboot0'] | []                      | MTU=1500   |
       +--------------+----------+-----------------+----------+---------+---------------+---------------+-------------------------+------------+


    #. Select the interface associated with the port to be replaced.

       #. Check the column :guilabel:`used by i/f` to get the list of dependent
          interfaces (sub-interfaces) on the port.

       #. Record the current configuration for the affected interfaces and
          sub-interfaces.

          .. code-block:: none

             ~(keystone_admin)]$ system host-if-show <hostname> <ifname-for-port>
             ~(keystone_admin)]$ system host-if-show <hostname> <ifname-for-subinterface>

#.  Record the list of addresses and routes on the controller.

    .. code-block:: none

       ~(keystone_admin)]$ system host-addr-list <hostname>

       +--------------+----------+------------------------+--------+
       | uuid         | ifname   | address                | prefix |
       +--------------+----------+------------------------+--------+
       | 02367673-... | cluster0 | aefd::2                | 64     |
       | b5589563-... | mgmt0    | fd01:8a::3             | 64     |
       | f5d42be7-... | oam0     | 2620:10a:a001:a103::41 | 64     |
       | 553b8c78-... | pxeboot0 | 192.168.202.2          | 24     |
       +--------------+----------+------------------------+--------+

       ~(keystone_admin)]$ system host-route-list <hostname>

       +--------------+--------+-----------+--------+------------+--------+
       | uuid         | ifname | network   | prefix | gateway    | metric |
       +--------------+--------+-----------+--------+------------+--------+
       | 548dfd96-... | mgmt0  | fd01:81:: | 64     | fd01:8a::1 | 1      |
       +--------------+--------+-----------+--------+------------+--------+


#.  Remove any affected sub-interfaces.

    * If the sub-interface is of the class ``platform``, then remove the
      affected sub-interfaces from the associated interface-network.

      .. code-block:: none

         ~(keystone_admin)]$ system interface-network-list <hostname>

         +--------------+--------------+----------+--------------+
         | hostname     | uuid         | ifname   | network_name |
         +--------------+--------------+----------+--------------+
         | controller-0 | 6456a935-... | oam0     | oam          |
         | controller-0 | 805d7f2c-... | cluster0 | cluster-host |
         | controller-0 | a86890d0-... | pxeboot0 | pxeboot      |
         | controller-0 | b54bfac0-... | mgmt0    | mgmt         |
         +--------------+--------------+----------+--------------+

         ~(keystone_admin)]$ system interface-network-remove <uuid>

    * If the interface is of the class ``data``, ``pci-sriov`` or
      ``pci-passthrough``, then remove the interface-datanetwork(s) associated
      with the affected sub-interface(s).

      .. code-block:: none

         ~(keystone_admin)]$ system interface-datanetwork-list <hostname>

         +--------------+--------------+--------+------------------+
         | hostname     | uuid         | ifname | datanetwork_name |
         +--------------+--------------+--------+------------------+
         | controller-0 | 4fc6d3d4-... | sriov0 | group0-data0     |
         | controller-0 | 6712d006-... | pthru0 | group0-data0     |
         | controller-0 | b2d8f970-... | sriov1 | group0-data1     |
         +--------------+--------------+--------+------------------+

         ~(keystone_admin)]$ system interface-datanetwork-remove <uuid>

    Remove the sub-interface.

    .. code-block:: none

        ~(keystone_admin)]$ system host-if-delete <hostname> <uuid-or-name>

#.  If the interface is configured, re-configure the interface class to
    ``none``.

    #. If the interface is of the class ``platform``, then remove the
       interface-network(s) associated with the affected sub-interface(s).

       .. code-block:: none

          ~(keystone_admin)]$ system interface-network-list <hostname>
          ~(keystone_admin)]$ system interface-network-remove <uuid>

    #. If the interface is of the class ``data``, ``pci-sriov`` or
       ``pci-passthrough``, then remove the interface-datanetwork(s) associated
       with the affected sub-interface(s).

       .. code-block:: none

          ~(keystone_admin)]$ system interface-datanetwork-list <hostname>
          ~(keystone_admin)]$ system interface-datanetwork-remove <uuid>

    #. Modify the interface.

       .. code-block:: none

          ~(keystone_admin)]$ system host-if-modify <hostname> <ifname> -c none

    #. Confirm that the interface does not have sub-interfaces referenced in
       the :guilabel:`used by i/f` column.

       .. code-block:: none

          ~(keystone_admin)]$ system host-if-list <hostname>

#.  Power down the host manually and make the NIC card replacement.

#.  Power up the host.

#.  After rebooting, check the new port's inventoried data:

    .. code-block::

       ~(keystone_admin)]$  system host-port-list <hostname>
       ~(keystone_admin)]$ system host-if-list <hostname> –a

    The old interface will no longer be available, replaced by a new one with
    the same name assigned to the new port.

#.  Reconfigure the base interface associated with the port.

    .. note::
       It is recommended that you reuse the previous interface names.

    If the old interface was of class ``pci-sriov``, do the following:

    #. Check the port capabilities, particularly that it has the required value
       for ``sriov_totalvfs``. If not, plan the interface and sub-interface
       reconfiguration accordingly.

       .. code-block::

            ~(keystone_admin)]$ system host-port-show <hostname> <port-name>
            ~(keystone_admin)]$ system host-if-modify <hostname> <ifname> -c pci-sriov -n <previous-configured-name> <previous-interface-parameters>

    #. If the old interface was of class ``data``, ``platform``, or
       ``pci-passthrough``, modify the new interface back to the previous
       configuration.

       .. code-block::

          ~(keystone_admin)]$ system host-if-modify <hostname> <ifname> -c <class> -n <previous-configured-name> <previous-interface-parameters>

#.  Reconnect the interface to any previously connected network.

    #. For a platform class interface, select the respective network that
       supports the desired new interface.

       .. code-block::

          ~(keystone_admin)]$ system network-list
          ~(keystone_admin)]$ system interface-network-assign <hostname> <ifname-or-uuid> <>network-name-or-uuid>

    #. For ``data``, ``pci-sriov``, and ``pci-passthrough`` class interfaces,
       select the respective datanetwork that supports the desired new
       interface.

       .. code-block::

          ~(keystone_admin)]$ system datanetwork-list
          ~(keystone_admin)]$ system interface-datanetwork-assign <hostname> <ifname-or-uuid> <datanetwork-name-or-uuid>

#.  Add the necessary sub-interfaces.

    #. Recreate all necessary sub-interfaces that existed prior to the NIC
       replacement.

       It is recommended to use the previous sub-interface names.

       .. code-block::

          ~(keystone_admin)]$ system host-if-add <hostname> <previous-sub-interface-name> <iftype [ae,vlan,vf,ethernet]> <interface-name> <previous-parameters>


#.  Reconnect the sub-interface with the desired network (if it was previously
    connected).

    #. For a platform class interface, select the respective network that
       supports the desired new sub-interface.

       .. code-block:: none

          ~(keystone_admin)]$ system network-list
          ~(keystone_admin)]$ system interface-network-assign <hostname> <sub-interface-name-or-uuid> <>network-name-or-uuid>

    #. For ``data``, ``pci-sriov``, and ``pci-passthrough`` class interfaces,
       select the respective datanetwork that supports the desired new
       sub-interface.

       .. code-block:: none

          ~(keystone_admin)]$ system datanetwork-list
          ~(keystone_admin)]$ system interface-datanetwork-assign <hostname> <sub-interface or uuid> <network-name-or-uuid>

#.  Check addresses and routes on the affected interfaces.

    .. code-block:: none

       ~(keystone_admin)]$ system host-addr-list <hostname>
       ~(keystone_admin)]$ system host-route-list <hostname>

#.  Recreate static addresses and routes using the affected interfaces or
    sub-interfaces.

    .. code-block:: none

       ~(keystone_admin)]$ system host-addr-add <hostname> <interface-name> <address> <prefix-length>
       ~(keystone_admin)]$ system host-route-add <hostname> <interface-name> <network-address> <prefix-length> <gateway-address> <metric>

#.  Unlock the controller.

    .. code-block:: none

       ~(keystone_admin)]$ system host-unlock <hostname>

#.  If the host in question is the single host of an |AIO-SX| subcloud
    deployment, set the subcloud as managed.

    .. code-block:: none

       ~(keystone_admin)]$ dcmanager subcloud manage <subcloud-name>
