
.. wjw1596720840345
.. _configure-pci-passthrough-ethernet-interfaces:

=============================================
Configure PCI Passthrough Ethernet Interfaces
=============================================

A passthrough Ethernet interface is a physical |PCI| Ethernet |NIC| on a compute
node to which a virtual machine is granted direct access. This minimizes packet
processing delays but at the same time demands special operational
considerations.

.. rubric:: |context|


Configure a |PCI| Passthrough Ethernet Interface on a host and request it for an
instance at boot/create time.

.. rubric:: |prereq|

-   To use |PCI| passthrough or |SRIOV| devices, you must have Intel VT-x and
    Intel VT-d features enabled in the BIOS.

-   The exercise assumes that the underlying data network **group0-data0**
    exists already, and that |VLAN| ID 10 is a valid segmentation ID assigned
    to **project1**.

.. rubric:: |proc|

#.  Log in as the **admin** user to the |prod-p| |prod-hor-long|.

#.  Lock the compute node you want to configure.

#.  Configure the Ethernet interface to be used as a |PCI| passthrough
    interface. You can do this using Horizon or the |CLI|.

    -   Using Horizon:

        #.  Select **Admin** \> **Platform** \> **Host Inventory** from the
            left-hand pane.

        #.  Select the **Hosts** tab.

        #.  Click the name of the compute host.

        #.  Select the **Interfaces** tab.

        #.  Click the **Edit Interface** button associated with the interface
            you want to configure.


            The Edit Interface dialog appears.

            .. image:: /node_management/figures/ptj1538163621289.png


        #.  Select **pci-passthrough**, from the **Interface Class** drop-down,
            and then select the data network to attach the interface.

        #.  (Optional) You may also need to change the |MTU|.

    -   Using the CLI:

        Assign the ``pci-sriov`` class to the interface.

        .. code-block:: none

            ~(keystone_admin)$ system host-if-modify -c pci-passthrough compute-0 enp0s3
            ~(keystone_admin)$ system interface-datanetwork-assign compute-0 <enp0s3_interface_uuid> <group0_data0_data_network_uuid>


#.  Check if the Ethernet interface supports |SRIOV|.


    #.  Check the host port associated with the configured |PCI|-passthrough interface.

        .. code-block:: none

            ~(keystone_admin)$ system host-if-list <host-name> | grep pci-passthrough

    #.  Review the value of ``sriov_totalvfs`` on the target port.

        If the value is ``None``, the Ethernet interface does not support
        |SRIOV|. Otherwise, it does.

        .. code-block:: none

            ~(keystone_admin)$ system host-port-show <host-name> <port-name> | grep sriov_totalvfs


    .. note::

        For Ethernet interfaces without |SRIOV| support, there is a known limitation
        reported `here <https://bugs.launchpad.net/starlingx/+bug/1836682>`__.
        This limitation is overcome with a specific step later on this procedure.

    .. _create-the-net0-project-network:

#.  Create the ``net0`` project network for Ethernet interfaces that support
    |SRIOV|.

    .. warning::

        If the Ethernet interface does not support |SRIOV|, **skip** this step.

    Log in as the **admin** user to the |os-prod-hor-long|.

    Select **Admin** \> **Network** \> **Networks**, select the Networks tab,
    and then click **Create Network**. Fill in the Create Network dialog box as
    illustrated below. You must ensure that:

    -   **project1** has access to the project network. Either by assigning it
        as the owner, as in the illustration \(using **Project**\), or by
        enabling the shared flag.

    -   The segmentation ID is set to 10.


    .. image:: /node_management/figures/bek1516655307871.png


    Click the **Next** button to proceed to the **Subnet** tab.

    Click the **Next** button to proceed to the **Subnet Details** tab.

#.  Configure the access switch. Refer to the OEM documentation to configure
    the access switch.

    Log in as the **admin** user to the |prod-p| |prod-hor-long|.

    Configure the physical port on the access switch used to connect to
    Ethernet interface ``enp0s3`` to be an access port with the default |VLAN|
    ID of 10. Traffic across the connection is therefore untagged, and
    effectively integrated into the targeted project network.

    You can also use a trunk port on the access switch so that it handles
    tagged packets as well. However, this opens the possibility for guest
    applications to join other project networks using tagged packets with
    different |VLAN| IDs, which might compromise the security of the system.
    See |os-intro-doc|: :ref:`L2 Access Switches
    <network-planning-l2-access-switches>` for other details regarding the
    configuration of the access switch.

#.  Unlock the compute node.

#.  Create a neutron port with a |VNIC| of type ``direct-physical`` for
    Ethernet interfaces that support |SRIOV|.

    .. warning::

        If the Ethernet interface does not support |SRIOV|, **skip** this step.

    First, you must set up the environment and determine the correct
    network |UUID| to use with the port.

    .. code-block:: none

        ~(keystone_admin)$ source /etc/platform/openrc
        ~(keystone_admin)$ OS_AUTH_URL=http://keystone.openstack.svc.cluster.local/v3
        ~(keystone_admin)$ openstack network list | grep net0
        ~(keystone_admin)$ openstack port create --network <uuid_of_net0> --vnic-type direct-physical <port_name>

    You have now created a port to be used when launching the server in the
    next step.

#.  Complete the following Nova configuration, for Ethernet interfaces that do
    not support |SRIOV|.

    .. warning::

        If the Ethernet interface supports |SRIOV|, **skip** this step.

    #.  Get the Ethernet interface ``vendor_id`` and ``product_id``:

        .. code-block:: none

              ~(keystone_admin)$ source /etc/platform/openrc
            ~(keystone_admin)$ system host-port-show <host-name> <port-name> | grep -E '(pvendor |pdevice )'

    #.  Use the retrieved IDs to create a |PCI| alias with
        ``"device_type":"type-PCI"``, as peer :ref:`Configure a PCI Alias in
        Nova <configuring-a-pci-alias-in-nova>`.

    #.  Configure a flavor with the extra spec key ``pci_passthrough:alias``
        pointing to the previously created |PCI| alias, as peer :ref:`Configure
        a Flavor to Use a Generic PCI Device
        <configuring-a-flavor-to-use-a-generic-pci-device>`

#.  Launch the virtual machine

    .. note::

        You will need to source to the same project selected in the :ref:`Create
        Network net0 <create-the-net0-project-network>` step.

    - For Ethernet interfaces with |SRIOV| support: specify the port uuid
      created.

      .. code-block:: none

          ~(keystone_admin)$ openstack server create --flavor <flavor_name> --image <image_name> --nic port-id=<port_uuid> <name>

    - For Ethernet interfaces without |SRIOV| support: specify the created
      flavor to use the |PCI| device.

      .. code-block:: none

          ~(keystone_admin)$ openstack server create --flavor <pci_flavor_name> --image <image_name>

    For more information, see the Neutron documentation at:
    `https://docs.openstack.org/neutron/train/admin/config-sriov.html
    <https://docs.openstack.org/neutron/train/admin/config-sriov.html>`__.

.. rubric:: |result|

The new virtual machine instance is up now. It has a PCI passthrough connection
to the **net0** project network identified with |VLAN| ID 10.

.. only:: partner

    .. include:: /_includes/configuring-pci-passthrough-ethernet-interfaces.rest

    :start-after: warning-text-begin
    :end-before: warning-text-end

.. rubric:: |prereq|

Access switches must be properly configured to ensure that virtual machines
using |PCI|-passthrough or |SRIOV| Ethernet interfaces have the expected
connectivity. In a common scenario, the virtual machine using these interfaces
connects to external end points only, that is, it does not connect to other
virtual machines in the same |prod-os| cluster. In this case:


.. _configure-pci-passthrough-ethernet-interfaces-ul-pz2-w4w-rr:

-   Traffic between the virtual machine and the access switch can be tagged or
    untagged.

-   The connecting port on the access switch is part of a port-based |VLAN|.

.. only:: partner

    .. include:: /_includes/configuring-pci-passthrough-ethernet-interfaces.rest

    :start-after: vlan-bullet-1-begin
    :end-before: vlan-bullet-1-end

-   The port-based |VLAN| provides the required connectivity to external
    switching and routing equipment needed by guest applications to establish
    connections to the intended end points.


For connectivity to other virtual machines in the |prod-os| cluster the
following configuration is also required:


.. _configure-pci-passthrough-ethernet-interfaces-ul-ngs-nvw-rr:

-   The |VLAN| ID used for the project network, 10 in this example, and the
    default port |VLAN| ID of the access port on the switch are the same. This
    ensures that incoming traffic from the virtual machine is tagged internally by
    the switch as belonging to |VLAN| ID 10, and switched to the appropriate exit
    ports.

.. only:: partner

    .. include:: /_includes/configuring-pci-passthrough-ethernet-interfaces.rest

    :start-after: vlan-bullet-2-begin
    :end-before: vlan-bullet-2-end

.. only:: partner

    .. include:: /_includes/configuring-pci-passthrough-ethernet-interfaces.rest

    :start-after: vlan-bullet-3-begin
    :end-before: vlan-bullet-3-end



