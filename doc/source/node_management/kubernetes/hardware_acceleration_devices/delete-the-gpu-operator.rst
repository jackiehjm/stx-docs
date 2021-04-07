
.. nsr1616019467549
.. _delete-the-gpu-operator:

=======================
Delete the GPU Operator
=======================

|release-caveat|

Use the commands in this section to delete the GPU Operator, if required.

.. rubric:: |prereq|

Ensure that all user generated pods with access to `nvidia.com/gpu` resources are deleted first.

.. rubric:: |proc|

#.  Remove the GPU Operator pods from the system using the following commands:

    .. code-block:: none

        ~(keystone_admin)]$ helm delete --purge gpu-operator
        ~(keystone_admin)]$ kubectl delete runtimeclasses.node.k8s.io nvidia

#.  Remove the GPU Operator, and remove the service parameter platform
    `container\_runtime custom\_container\_runtime` from the system, using the
    following commands:

    #.  Lock the host\(s\).

        .. code-block:: none

            ~(keystone_admin)]$ system host-lock <hostname>

    #.  List the service parameter using the following command.

        .. code-block:: none

            ~(keystone_admin)]$ system service-parameter-list

    #.  Remove the service parameter platform `container\_runtime custom\_container\_runtime`
        from the system, using the following command.

        .. code-block:: none

            ~(keystone_admin)]$ system service-parameter-delete <service param ID>

        where ``<service param ID>`` is the ID of the service parameter, for example, 3c509c97-92a6-4882-a365-98f1599a8f56.

    #.  Unlock the hosts\(s\).

        .. code-block:: none

            ~(keystone_admin)]$ system host-unlock <hostname>

    For information on configuring the GPU Operator, see :ref:`Configure NVIDIA
    GPU Operator for PCI Passthrough Operator
    <configure-nvidia-gpu-operator-for-pci-passthrough>`.
