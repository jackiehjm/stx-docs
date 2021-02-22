
.. rqs1579635366039
.. _listing-node-labels-from-the-cli:

=============================
List Node Labels from the CLI
=============================

You can list assigned labels to review and manage the scheduling of
Kubernetes objects, such as pods.

Labels are key/value pairs that are attached to nodes and are used to specify
identifying attributes of nodes. Labels can be used to identify physical
attributes of a node such as special purpose hardware or labels can be used
to identify logical attributes of a node, for example the role of a node.

For more information on labels that are used to assign pods to nodes, refer
to `https://kubernetes.io/docs/concepts/configuration/assign-pod-node/ <https://kubernetes.io/docs/concepts/configuration/assign-pod-node/>`__.

.. rubric:: |proc|


.. _listing-node-labels-from-the-cli-steps-s5l-jsy-thb:

-   To list labels currently assigned to a host, use the
    :command:`host-label-list` command.

    The command format is:

    .. code-block:: none

        system host-label-list (<hostName> | <hostID>)

    For example:

    .. code-block:: none

        ~(keystone)admin)$ system host-label-list controller-0
        +--------------+-------------------------+-------------+
        | hostname     | label key               | label value |
        +--------------+-------------------------+-------------+
        | controller-0 | openstack-compute-node  | enabled     |
        | controller-0 | openstack-control-plane | enabled     |
        | controller-0 | openvswitch             | enabled     |
        | controller-0 | SRIOV                   | enabled     |
        +--------------+-------------------------+-------------+
