.. bwx1558617101415
.. _distributed-cloud-architecture:

==============================
Distributed Cloud Architecture
==============================

A |prod-dc| system consists of a Central Cloud and one or more subclouds
connected to the Central Cloud over L3 networks.

The Central Cloud has two regions: RegionOne, used to manage the nodes in the
Central Cloud, and system controller, used to manage the subclouds in the
|prod-dc| system. You can select RegionOne or system controller regions from the
Horizon Web interface or by setting the <OS_REGION_NAME> environment variable
if using the CLI.

**Central Cloud**
    The Central Cloud provides a RegionOne region for managing the physical
    platform of the Central Cloud and the system controller region for managing
    and orchestrating over the subclouds.

    The Central Cloud does not support worker hosts. All worker functions are
    performed at the subcloud level.

**RegionOne**
    RegionOne is the name of the access mode, or region, for managing the
    Central Cloud's physical platform.

**System Controller**
    The system controller access mode, or region, for managing subclouds is
    System Controller.

    You can use the system controller to add subclouds, synchronize select
    configuration data across all subclouds and monitor subcloud operations and
    alarms. You can also access the individual subclouds through the single
    central Horizon interface at the Central Cloud to perform subcloud-specific
    operations such as configuring and managing the subclouds' host nodes and
    containers. System software updates for the subclouds are also centrally
    managed and applied from the system controller.

    DNS and other select configuration settings are centrally managed at the
    system controller and pushed to the subclouds in parallel to maintain
    synchronization across the |prod-dc|.

**Subclouds**
    The subclouds are |prod| instances used to host containerized applications.
    Any type of |prod| deployment configuration, i.e. simplex, duplex or
    standard with or without storage nodes, can be used for a subcloud.

    Alarms raised at the subclouds are sent to the system controller for
    central reporting.

    .. note::

        Services in a Subcloud authenticate against their local Identity
        Provider only (i.e. Keystone for StarlingX and Kubernetes Service
        Accounts for Kubernetes). This allows the subcloud to not only be
        autonomous in the face of disruptions with the Central Region, but also
        allows the subcloud to improve service performance since authentication
        is localized within the subcloud.

    Each subcloud can be in a Managed or Unmanaged state.

    **Managed**
        When a subcloud is in the Managed state, it is updated (synchronized)
        immediately with configuration changes made at the system controller.
        This is the normal operating state. Updates may be delayed slightly
        depending on network conditions.

    **Unmanaged**
        When the subcloud is in an Unmanaged state, configuration changes are
        queued at the system controller. They are sent to the subcloud when the
        subcloud is returned to a Managed state. The Unmanaged state is used to
        disconnect the subcloud from synchronization operations for local
        maintenance. Alarms generated by the subcloud are still sent to the
        system controller.

**Networks**
    Subclouds are connected to the system controller over L3 Networks. They are
    connected via the |OAM| Network by either the management network or the admin
    network.

    .. note::

        The parameters of the management network cannot be changed after the
        initial subcloud bootstrap operation. On subclouds, an optional admin
        network can be used on the subcloud to facilitate network subnetting
        changes after bootstrapping the system. In this case, the admin network
        handles traffic between the subcloud and the L3 router. In this
        configuration, the management network still exists on the subcloud but
        it is used only for private communication with other hosts in the
        subcloud. The system controller, which does not have an admin network,
        continues to use the management network.

        The |PXE| Boot network of the subcloud, if present, is also local to the
        subcloud.
    
    To update subcloud network parameters, see :ref:`Update a Subcloud
    Network Parameters <update-a-subcloud-network-parameters-b76377641da4>`.

    The settings required to connect a subcloud to the system controller are
    specified when a subcloud is defined. For more information, see
    :ref:`Installing a Subcloud Without Redfish Platform Management Service
    <installing-a-subcloud-without-redfish-platform-management-service>`.

    No additional platform configuration is required to establish network
    communications. However, third-party routers are required to complete the
    L3 connections. The routers must be configured independently according to
    |OEM| instructions.

    All messaging between system controllers and subclouds uses the **admin**
    REST API service endpoints which, in this distributed cloud environment,
    are all configured for secure HTTPS. Certificates for these HTTPS
    connections are managed internally by |prod|.

.. xbooklink For more information, see :ref:`Certificate Management for Admin
    REST API Endpoints  <certificate-management-for-admin-rest-endpoints>`.

