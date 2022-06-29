
.. rho1557409702625
.. _using-labels-to-identify-openstack-nodes:

========================================
Use Labels to Identify OpenStack Nodes
========================================

The |prod-os| application is deployed on the nodes of the |prod| based on node
labels.

.. rubric:: |context|

Prior to initially installing the |prod-os| application or when adding nodes to
a |prod-os| deployment, you need to label the nodes appropriately for their
OpenStack role.

.. _using-labels-to-identify-openstack-nodes-table-xyl-qmy-thb:



.. only:: starlingx

    .. table:: Table 1. Common OpenStack Labels
        :widths: auto

        +-----------------------------+---------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
        | Label                       | Worker/Controller         | Description                                                                                                                                                                               |
        +=============================+===========================+===========================================================================================================================================================================================+
        | **openstack-control-plane** | -   Controller            | Identifies a node to deploy openstack controller services on.                                                                                                                             |
        |                             |                           |                                                                                                                                                                                           |
        |                             | -   All-in-One Controller |                                                                                                                                                                                           |
        +-----------------------------+---------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
        | **openstack-compute-node**  | Worker                    | Identifies a node to deploy openstack compute agents on.                                                                                                                                  |
        |                             |                           |                                                                                                                                                                                           |
        |                             |                           | .. note::                                                                                                                                                                                 |
        |                             |                           |     Adding or removing this label, or removing a node with this label from a cluster, triggers the regeneration and application of the helm chart overrides of the openstack application. |
        +-----------------------------+---------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
        | **sriov**                   | -   Worker                | Identifies a node as supporting sr-iov.                                                                                                                                                   |
        |                             |                           |                                                                                                                                                                                           |
        |                             | -   All-in-One Controller |                                                                                                                                                                                           |
        +-----------------------------+---------------------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

.. only:: partner

    .. include:: /_includes/using-labels-to-identify-openstack-nodes.rest

    :start-after: table-1-of-contents-begin
    :end-before: table-1-of-contents-end

For more information. see |node-doc|: :ref:`Configuring Node Labels from The CLI <assigning-node-labels-from-the-cli>`.

.. rubric:: |prereq|

Nodes must be locked before labels can be assigned or removed.

.. rubric:: |proc|

.. only:: starlingx

    #.  To assign Kubernetes labels to identify compute-0 as a compute node with and SRIOV, use the following command:

        .. code-block:: none

            ~(keystone)admin)$ system host-label-assign compute-0 openstack-compute-node=enabled sriov=enabled
            +-------------+--------------------------------------+
            | Property    | Value                                |
            +-------------+--------------------------------------+
            | uuid        | 2909d775-cd6c-4bc1-8268-27499fe38d5e |
            | host_uuid   | 1f00d8a4-f520-41ee-b608-1b50054b1cd8 |
            | label_key   | openstack-compute-node               |
            | label_value | enabled                              |
            +-------------+--------------------------------------+
            +-------------+--------------------------------------+
            | Property    | Value                                |
            +-------------+--------------------------------------+
            | uuid        | d8e29e62-4173-4445-886c-9a95b0d6fee1 |
            | host_uuid   | 1f00d8a4-f520-41ee-b608-1b50054b1cd8 |
            | label_key   | sriov                                |
            | label_value | enabled                              |
            +-------------+--------------------------------------+

    #.  To remove the labels from the host, do the following.

        .. code-block:: none

            ~(keystone)admin)$ system host-label-remove compute-0 openstack-compute-node sriov
            Deleted host label openstack-compute-node for host compute-0
            Deleted host label sriov for host compute-0

.. only:: partner

    .. include:: /_includes/using-labels-to-identify-openstack-nodes.rest

    :start-after: table-1-of-contents-end
