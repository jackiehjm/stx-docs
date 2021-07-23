
.. wdq1463583173409
.. _data-networks-overview:

===================================
Data Networks in OpenStack Overview
===================================

Data networks are used to model the L2 Networks that nodes' data, pci-sriov
and pci-passthrough interfaces attach to.

.. note::

    Data networks are required if you plan to deploy the openstack application
    or provide |SRIOV| network interface access to container workloads.

A Layer 2 physical or virtual network or set of virtual networks is used to
provide the underlying network connectivity needed to support the application
project networks. Multiple data networks may be configured as required, and
realized over the same or different physical networks. Access to external
networks is typically granted to the **openstack-compute** labeled worker nodes
using the data network. The extent of this connectivity, including access to
the open internet, is application dependent.

Data networks are created at the |prod| level. Flat, |VLAN| and |VXLAN| type
data networks are supported by the |prod-os| virtual switch. For details on
creating data networks, assigning them to node interfaces, and displaying
data networks, see the following |prod| documentation:

.. _data-networks-overview-ul-yj1-dtq-3nb:

-   :ref:`Adding Data Networks Using the CLI
    <adding-data-networks-using-the-cli>`

-   :ref:`Assigning a Data Network to an Interface
    <assigning-a-data-network-to-an-interface>`

-   :ref:`Removing a Data Network Using the CLI
    <removing-a-data-network-using-the-cli>`

-  :ref:`Display Data Network information using Horizon
   <displaying-data-network-information-using-horizon>`

-  :ref:`Display Data Network information using the CLI
   <displaying-data-network-information-using-the-cli>`

-  :ref:`The Data Network topology view
   <the-data-network-topology-view>`



|VXLAN| Data Networks are specific to |prod-os| application.

.. xreflink and are described in detail in :ref:`VXLAN Data Networks
   <vxlan-data-networks>`.

Segmentation ID ranges for VLAN and VXLAN data networks are defined through
OpenStack Neutron commands, see :ref:`Adding Segmentation Ranges Using the CLI
<adding-segmentation-ranges-using-the-cli>`.

.. only:: partner

   .. include:: /_includes/data-networks-overview.rest
