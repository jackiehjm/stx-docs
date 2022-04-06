
.. wdq1463583173409
.. _os-planning-data-networks-overview:

========
Overview
========

Data networks are used to model the L2 Networks that nodes' data, pci-sriov and
pci-passthrough interfaces attach to.

A Layer 2 physical or virtual network or set of virtual networks is used to
provide the underlying network connectivity needed to support the application
project networks. Multiple data networks may be configured as required, and
realized over the same or different physical networks. Access to external
networks is typically granted to the **openstack-compute** labeled worker nodes
using the data network. The extent of this connectivity, including access to
the open internet, is application dependent.

Data networks are created at the |prod| level.

.. _data-networks-overview-ul-yj1-dtq-3nb:

.. xbooklink VXLAN Data Networks are specific to |prod-os| application and are described in detail in :ref:`VXLAN Data Networks <vxlan-data-networks>` .

Segmentation ID ranges, for |VLAN| and |VXLAN| data networks, are defined
through OpenStack Neutron commands, see :ref:`Add Segmentation Ranges Using
the CLI <adding-segmentation-ranges-using-the-cli>`.

For details on creating data networks and assigning them to node interfaces,
see the |datanet-doc| documentation:

-   :ref:`Add Data Networks Using the CLI <adding-data-networks-using-the-cli>`

-   :ref:`Assign a Data Network to an Interface
    <assigning-a-data-network-to-an-interface>`

-   :ref:`Remove a Data Network Using the CLI
    <removing-a-data-network-using-the-cli>`

.. only:: partner

   .. include:: /_includes/os-data-networks-overview.rest
