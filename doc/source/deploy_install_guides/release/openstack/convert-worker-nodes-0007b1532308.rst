.. _convert-worker-nodes-0007b1532308:

====================
Convert Worker Nodes
====================

.. rubric:: |context|

In a hybrid (Kubernetes and OpenStack) cluster scenario you may need to convert
worker nodes to/from ``openstack-compute-nodes``.

.. rubric:: |proc|

#.  Convert a k8s-only worker into a OpenStack compute

    #.  Lock the worker host:

        .. code-block:: none

            system host-lock <host>

    #.  Add the ``openstack-compute-node`` taint.

        .. code-block:: none

            kubectl taint nodes <kubernetes-node-name> openstack-compute-node:NoSchedule

    #.  Assign OpenStack labels:

        .. code-block:: none

            system host-label-assign <host> --overwrite openstack-compute-node=enabled avs=enabled sriov=enabled

    #.  Allocate vswitch huge pages:

        .. code-block:: none

            system host-memory-modify -1G 1 -f vswitch <host> 0
            system host-memory-modify -1G 1 -f vswitch <host> 1

    #.  Change the class of the data network interface:

        .. code-block:: none

            system host-if-modify -c data <host> <if_name_or_uuid>

        .. note::

            If data network interface does not exist yet, refer to |prod-os|
            documentation on creating it.

    #.  Change Kubernetes CPU Manager Policy to allow |VMs| to use application
        cores:

        .. code-block:: none

            system host-label-remove <host> kube-cpu-mgr-policy

    #.  Unlock the worker host:

        .. code-block:: none

            system host-unlock <host>

#.  Convert a OpenStack compute into a k8s-only worker.

    #.  Lock the worker host:

        .. code-block:: none

            system host-lock <host>

    #.  Remove OpenStack labels:

        .. code-block:: none

            system host-label-remove <host> openstack-compute-node avs sriov

        .. note::

            The labels have to be removed, not to have its values changed.

    #.  Deallocate vswitch huge pages:

        .. code-block:: none

            system host-memory-modify -1G 0 -f vswitch <host> 0
            system host-memory-modify -1G 0 -f vswitch <host> 1

    #.  Change the class of the data network interface:

        .. code-block:: none

            system host-if-modify -c none <host> <if_name_or_uuid>

        .. note::

            This change is needed to avoid raising a permanent alarm for the
            interface without the need to delete it.

    #.  Unlock the worker host:

        .. code-block:: none

            system host-unlock <host>
