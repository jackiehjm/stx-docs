
.. spv1552675734173
.. _changing-a-management-interface-to-aggregated-using-the-cli:

=========================================================
Change a Management Interface to Aggregated Using the CLI
=========================================================

When worker and storage nodes are provisioned, the Ethernet interface used
for |PXE| booting is automatically
assigned to the internal management network.

To configure a management |LAG| interface you
first need to remove the internal management network type from the existing
management Ethernet interface and then add a new |AE| interface, specifying the
mgmt network type, ae interface type, 802.3 |AE| mode, transmit hash policy
and the standby interfaces.

.. rubric:: |prereq|

The node must be locked to edit an interface.

.. rubric:: |proc|

.. _changing-a-management-interface-to-aggregated-using-the-cli-steps-kj4-15r-hkb:

#.  From the command line, delete and then recreate the management interface.

    .. code-block:: none

        ~(keystone_admin)$ system host-if-modify -c <node> <interface>

    where the following options are available:

    **node**
        The name of the node from which to delete an interface.

    **interface**
        The Ethernet interface to delete.

#.  Create the new interface.

    #.  Add the interface to the host.

        .. code-block:: none

            ~(keystone_admin)$ system host-if-add -c platform -a 802.3ad -x layer2 <node> <interface> ae <ports>

    #.  Assign the interface to a network.

        .. code-block:: none

            ~(keystone_admin)$ system interface-network-assign <node> <interface> <network>

    where the following options are available:

    **node**
        The name of the node.

    **interface**
        The name to be assigned to the interface.

        .. caution::
            To avoid potential internal inconsistencies, do not use upper
            case characters when creating interface names. Some components
            normalize all interface names to lower case.

    **ports**
        The Ethernet ports to assign.

    **network**
        The network to assign the interface to.

    For example:

    .. code-block:: none

        ~(keystone_admin)$ system host-if-add -c platform -a 802.3ad -x layer2 worker-0 bond0 ae enp0s8 enp0s9
        ~(keystone_admin)$ system interface-network-assign worker-0 bond0 mgmt
