
.. fuq1561551658529
.. _removing-cpu-manager-for-kubernetes:

=================================
Remove CPU Manager for Kubernetes
=================================

You can uninstall CMK by removing related Helm charts in the reverse order of
their installation.

.. rubric:: |proc|

#.  Delete **cmk manager**.

    #.  Run the :command:`helm delete` command.

        .. code-block:: none

            ~(keystone)admin)$ helm delete --purge
            release "cpu-manager" deleted

    #.  Ensure that any pods in the Terminating state have deleted before
        proceeding to the next step. The pods being terminated are in the
        **kube-system** namespace.

        For example:

        .. code-block:: none

            ~(keystone)admin)$ kubectl get pods -n kube-system | grep cmk
            cmk-setup 0/1 Completed 0 71m
            cmk-uninstall-2z29p 0/1 ContainerCreating 0 4s
            cmk-webhook-deployment-778c787679-7bpw2 1/1 Running 0 71m
            cpu-manager-k8s-cmk-compute-0-5621f953-pchjr 3/3 Terminating 0 38
            ~(keystone)admin)$ kubectl get pods -n kube-system | grep cmk
            cmk-setup 0/1 Completed 0 72m
            cmk-webhook-deployment-778c787679-7bpw2 1/1 Running 0 72m


#.  Delete **cmk-manager-webhook**.

    #.  Run the :command:`helm delete` command.

        .. code-block:: none

            ~(keystone)admin)$ helm delete cmk-webhook --purge

    #.  Ensure that any pods in the Terminating state have been deleted before
        proceeding to the next step.

        .. code-block:: none

            ~(keystone)admin)$ kubectl get pods -n kube-system | grep cmk
            cmk-uninstall-webhook 0/1 Completed 0 11s
            cmk-webhook-deployment-778c787679-7bpw2 1/1 Terminating 0 73m
            ~(keystone)admin)$ kubectl get pods -n kube-system | grep cmk
            cmk-uninstall-webhook 0/1 Completed 0 49s


#.  Delete **cmk-manager-init**. Run the :command:`helm delete` command.

    .. code-block:: none

        ~(keystone)admin)$ helm delete cmk-manager-init --purge
        release "cpu-manager-init" deleted


.. rubric:: |result|

The CPU Manager for Kubernetes is now deleted.

.. seealso::

   :ref:`Uninstall CPU Manager for Kubernetes on IPv6 <uninstalling-cpu-manager-for-kubernetes-on-ipv6>`
