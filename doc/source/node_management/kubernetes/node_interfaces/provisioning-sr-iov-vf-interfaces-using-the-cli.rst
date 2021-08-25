
.. qiw1575604699794
.. _provisioning-sr-iov-vf-interfaces-using-the-cli:

============================================
Provision SR-IOV VF Interfaces using the CLI
============================================

An |SRIOV| VF interface can be provisioned for a single |SRIOV| interface to
support multiple VF drivers.

For example, you can provision a single |SRIOV| interface to support
both netdevice, and vfio based containers. In this case, a VF interface
can be created to provision a subset of virtual functions from the parent
|SRIOV| interface that can be bound to a different driver.

For information about creating and using network attachments,
see |usertasks-doc|: :ref:`Create Network Attachment Definitions
<creating-network-attachment-definitions>` |usertasks-doc|:
:ref:`Use Network Attachment Definitions in a Container
<using-network-attachment-definitions-in-a-container>`.

.. rubric:: |prereq|

You must create data networks before you can provision
the |SRIOV| interfaces.

.. xbooklink  See |datanet-doc|:`Adding Data Networks using the CLI <adding-data-networks-using-the-cli>`.

You must create an |SRIOV| interface before you can provision a |VF| interface.
For more information, see :ref:`Provision SR-IOV Interfaces using the CLI
<provisioning-sr-iov-interfaces-using-the-cli>`.

.. rubric:: |proc|

#.  Lock the host to which you will assign a |VF| interface.

    For example:

    .. code-block:: none

        ~(keystone_admin)$ system host-lock compute-0

    .. note::
       |AIO-SX| hosts do not need to be locked to provision an |SRIOV| interface and
       assign it to a data network.

#.  Identify the parent |SRIOV| interface to be configured.

    For example:

    .. code-block:: none

        ~(keystone_admin)$ system host-if-list compute-0

        +---...+----------+----------+...+---------------+...+-------------------+
        | uuid | name     | class    |   | ports         |   | datanetworks      |
        +---...+----------+----------+...+---------------+...+-------------------+
        | 68...| ens787f3 | None     |   | [u'ens787f3'] |   | []                |
        | 79...| data0    | data     |   | [u'ens787f0'] |   | [u'group0-data0'] |
        | 78...| cluster0 | platform |   | []            |   | []                |
        | 89...| ens513f3 | None     |   | [u'ens513f3'] |   | []                |
        | 97...| ens803f1 | None     |   | [u'ens803f1'] |   | []                |
        | d6...| pxeboot0 | platform |   | [u'eno2']     |   | []                |
        | d6...| mgmt0    | platform |   | []            |   | []                |
        | d7...| sriov1   | pci-sriov|   | [u'ens787f3'] |   | [u'group0-data0'] |
        +---...+----------+----------+...+---------------+...+-------------------+

#.  Use the :command:`system host-if-add`, and
    :command:`interface-datanetwork-assign` commands to configure the |SRIOV|
    VF interface.

    For example:

    .. code-block:: none

        ~(keystone_admin)$ system host-if-add -c pci-sriov <hostname> <interfacename> vf <parentinterfacename> -N <numvfs> --vf-driver=<drivername>

    .. code-block:: none

        ~(keystone_admin)$ system interface-datanetwork-assign <hostname> <interfacename> <networks>

    where the following options are available:

    **hostname**
        This is the host name or ID of the compute \(worker\) node.

    **interfacename**
        The name for the VF interface.

    **parentinterfacename**
        The name of the parent |SRIOV| interface.

    **numvfs**
        The number of virtual functions to enable on the device. This must
        be less than the number of |VFs| configured on the parent |SRIOV|
        interface.

    **drivername**
        An optional virtual function driver to use. Valid choices are |VFIO|
        and 'netdevice'. The default value is netdevice, which will cause
        |SRIOV| virtual function interfaces to appear as kernel network devices'
        in the container. A value of '**vfio**' will cause the device to be
        bound to the vfio-pci driver. |VFIO| based devices will not appear as
        kernel network interfaces, but may be used by |DPDK| based
        applications.

        .. note::

            -   If the driver for the |VF| interface and parent |SRIOV|
                interface differ, a separate data network should be created
                for each interface.

            .. only:: partner

                .. include:: /_includes/provisioning-sr-iov-vf-interfaces-using-the-cli.rest

    **networks**
        A list of data networks that are attached to the interface, delimited
        by quotes and separated by commas; for example,
        "data-net-a,data-net-b". To specify a single data network,
        omit the quotes.

    For example, to create |VF| interface sriov2 as a subinterface of pci-sriov
    interface sriov1 with 8 virtual functions bound to vfio and attached data
    network datanet-b, do the following:

    .. code-block:: none

        ~(keystone_admin)$ system host-if-add -c pci-sriov compute-0 sriov2 vf sriov1 -N 8 --vf-driver=vfio
        +----------------+--------------------------------------+
        | Property        | Value                                |
        +-----------------+--------------------------------------+
        | ifname          | sriov2                               |
        | iftype          | vf                                   |
        | ports           | []                                   |
        | imac            | 68:05:ca:3a:2d:88                    |
        | imtu            | 1500                                 |
        | ifclass         | pci-sriov                            |
        | aemode          | None                                 |
        | schedpolicy     | None                                 |
        | txhashpolicy    | None                                 |
        | uuid            | 8b65ff1a-3472-43ed-bfd4-c9a499c23093 |
        | ihost_uuid      | 9491c54a-903d-4765-8b9b-bdfd754b796a |
        | vlan_id         | None                                 |
        | uses            | [u'sriov1']                          |
        | used_by         | []                                   |
        | created_at      | 2019-12-03T18:27:27.152940+00:00     |
        | updated_at      | None                                 |
        | sriov_numvfs    | 8                                    |
        | sriov_vf_driver | vfio                                 |
        +-----------------+--------------------------------------+

        ~(keystone_admin)$ system interface-datanetwork-assign compute-0 sriov2 datanet-b

#.  Unlock the host.

    .. note::
       AIO-SX hosts do not need to be locked to provision an |SRIOV|
       interface and assign it to a data network.

    .. code-block:: none

        ~(keystone_admin)$ system host-unlock compute-0

    .. note::
       |AIO-SX| hosts do not need to be locked to provision an |SRIOV| interface and
       assign it to a data network.
