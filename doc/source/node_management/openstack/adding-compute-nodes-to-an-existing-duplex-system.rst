
.. sjf1596039104044
.. _adding-compute-nodes-to-an-existing-duplex-system:

==============================================
Add Compute Nodes to an Existing Duplex System
==============================================

You can add up to 6 compute nodes to an existing Duplex system by following
the standard procedures for adding compute nodes to a system.

.. rubric:: |prereq|

.. only:: partner

    .. include:: /_includes/adding-compute-nodes-to-an-existing-duplex-system.rest

Before adding compute nodes to a duplex system, you can either add and
provision platform RAM and CPU cores on the controllers or reallocate RAM and
CPU cores from the VMs to the platform.

.. xbooklink To add platform RAM and CPU cores on the controllers,
   see |node-doc|: `Changing Hardware Components for a Controller Host <changing-hardware-components-for-a-controller-host>`.

The requirements for each added compute node are as follows:

.. _adding-compute-nodes-to-an-existing-duplex-system-simpletable-axc-yry-12b:

.. table::
    :widths: auto

    +---------------+---------------+---------------+
    | Compute Nodes | RAM (GB)      | CPU Cores     |
    +===============+===============+===============+
    | 1             | +2            | +1            |
    +---------------+---------------+---------------+
    | 2             | +4            | +1            |
    +---------------+---------------+---------------+
    | 3             | +6            | +2            |
    +---------------+---------------+---------------+
    | 4             | +8            | +2            |
    +---------------+---------------+---------------+

.. rubric:: |proc|

#.  Provision the resources.

    To allocate resources to the controller, update the controller resource
    inventory in |prod-os|. See |node-doc|: :ref:`Memory Tab <memory-tab>` and
    :ref:`Processor Tab <processor-tab>`.

#.  Add the hosts (compute nodes).

    Add one or more host entries to the system inventory.

.. xbooklink See |prod|| Installation Overview: `Adding Hosts Using the host-add Command <adding-hosts-using-the-host-add-command>`.

For more information on Host memory provisioning, see, |node-doc|:

.. _adding-compute-nodes-to-an-existing-duplex-system-ul-ovd-wnc-nmb:

-   :ref:`Allocate Host Memory Using Horizon
    <allocating-host-memory-using-horizon>`

-   :ref:`Allocate Host Memory Using the CLI
    <allocating-host-memory-using-the-cli>`

For more information about labeling Compute nodes, see :ref:`Use Labels to
Identify OpenStack Nodes <using-labels-to-identify-openstack-nodes>`.

.. xbooklink For more information about adding data networks and data network interfaces,
   see: Data Networks and Data Network Interfaces: `Overview <data-networks-overview>`.
