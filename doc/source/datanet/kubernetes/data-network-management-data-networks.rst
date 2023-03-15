
.. jjl1559817878161
.. _data-network-management-data-networks:

===========================
Data Networks in Kubernetes
===========================

|prod-long| data network management allows you to model the L2 networks that
are attached to node data, pci-sriov and pci-passthrough interfaces.

A data network represents a Layer 2 physical or virtual network, or set of
virtual networks, used to provide the underlying network connectivity needed
to support the application networks. Multiple data networks may be configured
as required, and realized over the same or different physical networks. Access
to external networks is typically (although not necessarily) granted to
worker nodes using a data network. The extent of this connectivity, including
access to the open internet, is application dependent.

Data networks are required for |prod-os| deployments and for the base
|prod-long| if you wish to deploy container applications with SR-IOV devices.

Data networks are created by the administrator to make use of an underlying set
of resources on a physical network. The following types of data networks can be
created:

**flat**
    A data network mapped entirely over the physical network.

**VLAN**
    A data network implemented on a physical network using a VLAN identifier.
    This allows multiple data networks over the same physical network.

**VXLAN**
    .. note::
        This data interface is ONLY applicable to the |prod-os| application.

    A data network implemented across non-contiguous physical networks
    connected by Layer 3 routers, using a VNI identifier. This allows
    multiple data networks over physically separated Layer 2 networks.

.. xbooklink VXLAN Data Networks are specific to |prod-os| application and are described in detail in :ref:`VXLAN Data Networks <vxlan-data-networks>` .
     See |prod-os| Configuration and Management: :ref:`VXLAN Data Networks
    <vxlan-data-networks>`

There are no specific requirements for network services to be available on the
data network. However, you must ensure that all network services required by
the guests running on the worker nodes are available. For configuration
purposes, the worker nodes themselves are entirely served by the services
provided by the controller nodes over the internal management and cluster-host
networks.