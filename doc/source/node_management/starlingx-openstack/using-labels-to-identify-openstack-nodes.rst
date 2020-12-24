
.. rho1557409702625
.. _using-labels-to-identify-openstack-nodes:

======================================
Use Labels to Identify OpenStack Nodes
======================================

The |prod-os| application is deployed on the nodes of the |prod| based on node
labels.

Prior to initially installing the |prod-os| application or when adding nodes to
a |prod-os| deployment, you need to label the nodes appropriately for their
OpenStack role.

.. _using-labels-to-identify-openstack-nodes-table-xyl-qmy-thb:

.. Common OpenStack labels

.. include:: ../../_includes/common-openstack-labels.rest

For more information, see |node-doc|: :ref:`Configure Node Labels from The CLI
<assigning-node-labels-from-the-cli>`.

.. rubric:: |prereq|

Nodes must be locked before labels can be assigned or removed.

.. rubric:: |proc|

.. include:: ../../_includes/using-labels-to-identify-openstack-nodes.rest
