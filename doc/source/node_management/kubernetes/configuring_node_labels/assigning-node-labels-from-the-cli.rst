
.. pux1533065180756
.. _assigning-node-labels-from-the-cli:

===============================
Assign Node Labels from the CLI
===============================

You can assign labels to affect the scheduling of Kubernetes objects,
such as pods.

.. rubric:: |prereq|

Hosts must be locked before labels can be assigned.

Labels are key/value pairs that are attached to nodes and are used to
specify identifying attributes of nodes. Labels can be used to identify
physical attributes of a node such as special purpose hardware or labels can
be used to identify logical attributes of a node, for example the role of a
node.

To change the value of a label, you must remove and reapply it.
For more information, see :ref:`Remove Node Labels from the CLI
<removing-node-labels-from-the-cli>`.

For more information on labels that are used to assign pods to nodes,
refer to `https://kubernetes.io/docs/concepts/configuration/assign-pod-node/ <https://kubernetes.io/docs/concepts/configuration/assign-pod-node/>`__.

.. rubric:: |proc|

.. _assigning-node-labels-from-the-cli-steps-s5l-jsy-thb:

-   To assign a label to a host, use the :command:`host-label-assign` command.

    This command accepts a list of labels to assign. There can be one or
    many key-value pairs. Each added label will be returned.

    The command format is:

    .. code-block:: none

        system host-label-assign (<hostName> | <hostID>) <key>=<value> [<key>=<value> ...]

    For example:

    .. code-block:: none

        ~(keystone)admin)$ system host-label-assign controller-0 openstack-compute-node=enabled openvswitch=enabled sriov=enabled
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
        | uuid        | 8dafcfcf-e417-4fd0-8829-8baadb3a3981 |
        | host_uuid   | 1f00d8a4-f520-41ee-b608-1b50054b1cd8 |
        | label_key   | openvswitch                          |
        | label_value | enabled                              |
        +-------------+--------------------------------------+
        +-------------+--------------------------------------+
        | Property    | Value                                |
        +-------------+--------------------------------------+
        | uuid        | d8e29e62-4173-4445-886c-9a95b0d6fee1 |
        | host_uuid   | 1f00d8a4-f520-41ee-b608-1b50054b1cd8 |
        | label_key   | SRIOV                                |
        | label_value | enabled                              |
        +-------------+--------------------------------------+


    .. note::
        You can look up host names and IDs using the :command:`host-list`
        command.
