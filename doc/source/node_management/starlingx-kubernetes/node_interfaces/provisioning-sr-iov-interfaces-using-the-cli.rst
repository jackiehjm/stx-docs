
.. zyz1559061425196
.. _provisioning-sr-iov-interfaces-using-the-cli:

=========================================
Provision SR-IOV Interfaces using the CLI
=========================================

|SRIOV| interfaces must be provisioned on at least one host before using
|SRIOV| network attachments in a container.

By default, a Kubernetes container is started with a default network virtual
interface for cluster networking. For accelerated networking between
containers or external networks, additional |SRIOV| backed interfaces
\(network attachments\) can be added to the container.

You can use the CLI to provision |SRIOV| interfaces on a |prod| system.

The |SRIOV| device plugin discovers and advertises |SRIOV| network virtual
functions \(VFs\) in a Kubernetes host. To enable the device plugin, all hosts
on which accelerated networking pods will be enabled should have the
**sriovdp** label applied.

For information about creating and using network attachments,
see |usertasks-doc|: :ref:`Create Network Attachment Definitions
<creating-network-attachment-definitions>`
and |usertasks-doc|: :ref:`Use Network Attachment Definitions in a Container
<using-network-attachment-definitions-in-a-container>`.

.. rubric:: |prereq|

You must create data networks before you can provision the |SRIOV| interfaces.
See |datanet-doc|: :ref:`Add Data Networks using the CLI
<adding-data-networks-using-the-cli>`.

.. rubric:: |proc|

#.  Lock the host to which you will assign the label.

    For example:

    .. code-block:: none

        ~(keystone_admin)$ system host-lock compute-0

#.  Use the :command:`host-label-assign` command to assign the **sriovdp**
    label to the node.

    For example, to set **sriovdp** on worker-0 you would do the following:

    .. code-block:: none

        ~(keystone_admin)$ system host-label-assign compute-0 sriovdp=enabled
        +-------------+--------------------------------------+
        | Property    | Value                                |
        +-------------+--------------------------------------+
        | uuid        | a2c5d21b-f91a-4b8b-8dbc-d40b2f3bdaa9 |
        | host_uuid   | 772df330-6a42-4b8e-9a18-ae9a9f3f2336 |
        | label_key   | sriovdp                              |
        | label_value | enabled                              |
        +-------------+--------------------------------------+

#.  Identify the interfaces to be configured.

    To list all interfaces, use the :command:`system host-if-list` command
    and include the ``-a`` flag.

    For example:

    .. code-block:: none

        ~(keystone_admin)$ system host-if-list -a compute-0
        +---...+----------+----------+...+---------------+...+-------------------+
        | uuid | name     | class    |   | ports         |   | data networks     |
        +---...+----------+----------+...+---------------+...+-------------------+
        | 68...| ens787f3 | None     |   | [u'ens787f3'] |   | []                |
        | 79...| data0    | data     |   | [u'ens787f0'] |   | [u'group0-data0'] |
        | 78...| cluster0 | platform |   | []            |   | []                |
        | 89...| ens513f3 | None     |   | [u'ens513f3'] |   | []                |
        | 97...| ens803f1 | None     |   | [u'ens803f1'] |   | []                |
        | d6...| pxeboot0 | platform |   | [u'eno2']     |   | []                |
        | d6...| mgmt0    | platform |   | []            |   | []                |
        +---...+----------+----------+...+---------------+...+-------------------+

#.  Use the :command:`system host-if-modify` and
    :command:`interface-datanetwork-assign` commands to configure the |SRIOV|
    interfaces.

    .. code-block:: none

        ~(keystone_admin)$ system host-if-modify -m 1500 -n sriov1 -c pci-sriov -N <numvfs> --vf-driver=<drivername> compute-0 <ethname>
        ~(keystone_admin)$ system interface-datanetwork-assign compute-0 <interface> <networks>

    where the following options are available:

    **hostname**
        This is the host name or ID of the compute \(worker\) node.

    **numvfs**
        The number of virtual functions to enable on the device.

    **drivername**
        An optional virtual function driver to use. Valid choices are
        'vfio' and 'netdevice'. The default value is netdevice, which will
        cause |SRIOV| virtual function interfaces to appear as kernel network
        devices in the container. A value of 'vfio' will cause the device to be
        bound to the vfio-pci driver. Vfio based devices will not appear as
        kernel network interfaces, but may be used by |DPDK| based applications.

        .. note::

            -   Applications backed by Mellanox |NICs| should use the netdevice
                VF driver.

            -   If a mix of netdevice and vfio based containers is required,
                a separate data network should be created for each type.


    **ethname**
        The name or UUID of the Ethernet interface to use.

    **networks**
        A list of data networks that are attached to the interface, delimited
        by quotes and separated by commas; for example,
        "data-net-a,data-net-b". To specify a single data network,
        omit the quotes.

    For example, to attach Ethernet interface **ens787f3** to data network
    **datanet-a** configured with 16 virtual functions, do the following:

    .. code-block:: none

        ~(keystone_admin)$ system host-if-modify -m 1500 -n sriov1 -c pci-sriov -N 16 compute-0 ens787f3
        +----------------+--------------------------------------+
        | Property        | Value                                |
        +-----------------+--------------------------------------+
        | ifname          | sriov1                               |
        | iftype          | ethernet                             |
        | ports           | [u'ens787f3']                        |
        | imac            | 68:05:ca:3a:18:4b                    |
        | imtu            | 1500                                 |
        | ifclass         | pci-sriov                            |
        | networks        |                                      |
        | aemode          | None                                 |
        | schedpolicy     | None                                 |
        | txhashpolicy    | None                                 |
        | uuid            | 68544dbc-244c-4d24-a629-ca8e4543c6f8 |
        | ihost_uuid      | 54c28c7c-5b53-4191-97b5-9ddde3cbec81 |
        | vlan_id         | None                                 |
        | uses            | []                                   |
        | used_by         | []                                   |
        | created_at      | 2019-05-14T00:12:56.673418+00:00     |
        | updated_at      | 2019-05-14T00:16:56.864997+00:00     |
        | sriov_numvfs    | 16                                   |
        | sriov_vf_driver | None                                 |
        | accelerated     | [True]                               |
        +-----------------+--------------------------------------+

        ~(keystone_admin)$ system interface-datanetwork-assign compute-0 sriov1 datanet-a

#.  Unlock the host.

    .. code-block:: none

        ~(keystone_admin)$ system host-unlock compute-0

    When launching an SRIOV-enabled Kubernetes deployment, pods will only be
    scheduled on hosts with the **sriovdp** label enabled.
