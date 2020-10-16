
.. mfu1579635483475
.. _removing-node-labels-from-the-cli:

===============================
Remove Node Labels from the CLI
===============================

You can remove labels to affect the scheduling of Kubernetes objects,
such as pods.

.. rubric:: |prereq|

Hosts must be locked before labels can be removed.

Labels are key/value pairs that are attached to nodes and are used to specify
identifying attributes of nodes. Labels can be used to identify physical
attributes of a node such as special purpose hardware or labels can be used
to identify logical attributes of a node, for example the role of a node.

To change the value of a label, you must remove and reapply it. For more
information, see :ref:`Assign Node Labels from the CLI
<assigning-node-labels-from-the-cli>`.

For more information on labels that are used to assign pods to nodes, refer
to `https://kubernetes.io/docs/concepts/configuration/assign-pod-node/ <https://kubernetes.io/docs/concepts/configuration/assign-pod-node/>`__.

.. rubric:: |proc|

.. _removing-node-labels-from-the-cli-steps-s5l-jsy-thb:

-   To remove a label from a host, use the :command:`host-label-remove`
    command.

    One or more labels can be removed.

    The command format is:

    .. code-block:: none

        system host-label-remove (<hostName> | <hostID>) <key> [<key> ...]

    For example:

    .. code-block:: none

        ~(keystone)admin)$ system host-label-remove worker-0 openstack-compute-node openvswitch sriov
        Deleted host label openstack-compute-node for host worker-0
        Deleted host label openvswitch for host worker-0
        Deleted host label SRIOV for host worker-0
