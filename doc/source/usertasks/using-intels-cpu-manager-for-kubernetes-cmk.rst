
.. nnj1569261145380
.. _using-intels-cpu-manager-for-kubernetes-cmk:

==============================================
Use Intel's CPU Manager for Kubernetes \(CMK\)
==============================================

Use the CMK user manual to run a workload via CMK.

See `https://github.com/intel/CPU-Manager-for-Kubernetes/blob/master/docs/user.md#pod-configuration-on-the-clusters-with-cmk-mutating-webhook-kubernetes-v190
<https://github.com/intel/CPU-Manager-for-Kubernetes/blob/master/docs/user.md#pod-configuration-on-the-clusters-with-cmk-mutating-webhook-kubernetes-v190>`__ for detailed instructions.

.. xreflink See Kubernetes Admin Tasks: :ref:`Kubernetes CPU Manager Static Policy
   <isolating-cpu-cores-to-enhance-application-performance>` for details on how
   to enable this CPU management mechanism.

The basic workflow is to:

.. _using-intels-cpu-manager-for-kubernetes-cmk-ul-xcq-cwb-2jb:

#.  Request the number of exclusive cores you want as:

    .. code-block:: none

        cmk.intel.com/exclusive-cores

#.  Run your workload as:

    .. code-block:: none

        /opt/bin/cmk isolate --pool=exclusive <workload>
