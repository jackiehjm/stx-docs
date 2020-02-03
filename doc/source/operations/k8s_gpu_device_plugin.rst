================================================
Kubernetes Intel GPU Device Plugin Configuration
================================================

This document describes how to enable the Intel GPU device plugin in StarlingX
and schedule pods on nodes with an Intel GPU.

------------------------------
Enable Intel GPU device plugin
------------------------------

You can pre-install the ``intel-gpu-plugin`` daemonset as follows:

#. Launch the ``intel-gpu-plugin`` daemonset.

   Add the following lines to the ``localhost.yaml`` file before playing the
   Ansible bootstrap playbook to configure the system.

   ::

     k8s_plugins:
       intel-gpu-plugin: intelgpu=enabled

#. Assign the ``intelgpu`` label to each node that should have the Intel GPU
   plugin enabled. This will make any GPU devices on a given node available for
   scheduling to containers. The following example assigns the ``intelgpu``
   label to the worker-0 node.

   ::

      $ NODE=worker-0
      $ system host-lock $NODE
      $ system host-label-assign $NODE intelgpu=enabled
      $ system host-unlock $NODE

#. After the node becomes available, verify the GPU device plugin is registered
   and that the available GPU devices on the node have been discovered and reported.

   ::

      $ kubectl describe node $NODE | grep gpu.intel.com
      gpu.intel.com/i915:  1
      gpu.intel.com/i915:  1

-------------------------------------
Schedule pods on nodes with Intel GPU
-------------------------------------

Add a ``resources.limits.gpu.intel.com`` to your container specification in order
to request an available GPU device for your container.

::

  ...
  spec:
    containers:
      - name: ...
        ...
        resources:
          limits:
            gpu.intel.com/i915: 1


The pods will be scheduled to the nodes with available Intel GPU devices. A GPU
device will be allocated to the container and the available GPU devices will be
updated.

::

      $ kubectl describe node $NODE | grep gpu.intel.com
      gpu.intel.com/i915:  1
      gpu.intel.com/i915:  0

For more details, refer to the following examples:

* `Kubernetes manifest file example <https://github.com/intel/intel-device-plugins-for-kubernetes/blob/master/demo/intelgpu-job.yaml>`_
* `Scheduling pods on nodes with Intel GPU example <https://github.com/intel/intel-device-plugins-for-kubernetes/blob/master/cmd/gpu_plugin/README.md#test-gpu-device-plugin>`_
