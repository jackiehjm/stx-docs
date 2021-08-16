==========================================
Kubernetes QAT Device Plugin Configuration
==========================================

Intel® QuickAssist Technology (Intel® QAT) accelerates cryptographic workloads
by offloading the data to hardware capable of optimizing those functions. This
guide describes how to enable and consume the Intel QAT device plugin in
StarlingX.

.. contents::
   :local:
   :depth: 1

-------------
Prerequisites
-------------

- Install Intel QuickAssist device on host.
- Install StarlingX on bare metal with DPDK enabled. Refer to the
  `installation guide <https://docs.starlingx.io/deploy_install_guides/index.html>`_
  for details.

------------------------------
Enable Intel QAT device plugin
------------------------------

The Intel QAT device plugin daemonset is pre-installed in StarlingX. This
section describes the steps to enable the Intel QAT device plugin for
discovering and advertising QAT VF resources to Kubernetes host.

#. Verify QuickAssist SR-IOV virtual functions are configured on a specified
   node after StarlingX is installed. This example uses the worker-0 node.

   ::

      $ ssh worker-0
      $ for i in 0442 0443 37c9 19e3; do lspci -d 8086:$i; done

   .. note::

    The Intel QAT device plugin only supports QAT VF resources in the current
    release.

#. Assign the ``intelqat`` label to the node (worker-0 in this example).

   ::

      $ NODE=worker-0
      $ system host-lock $NODE
      $ system host-label-assign $NODE intelqat=enabled
      $ system host-unlock $NODE

#. After the node becomes available, verify the Intel QAT device plugin is
   registered.

   ::

      $ kubectl describe node $NODE | grep qat.intel.com/generic
      qat.intel.com/generic: 10
      qat.intel.com/generic: 10

-------------------------------
Consume Intel QAT device plugin
-------------------------------

#. Build the DPDK image.

   ::

      $ git clone https://github.com/intel/intel-device-plugins-for-kubernetes.git
      $ cd demo
      $ ./build-image.sh crypto-perf

   This command produces a Docker image named ``crypto-perf``.

#. Deploy a pod to run an example DPDK application named
   ``dpdk-test-crypto-perf``.

   In the pod specification file, add the container resource request and
   limit.

   For example, use ``qat.intel.com/generic: <number of devices>`` for a
   container requesting Intel QAT devices.


   For a DPDK-based workload, you may need to add a hugepage request and limit.

   ::

      $ kubectl apply -k deployments/qat_dpdk_app/base/
      $ kubectl get pods
        NAME                     READY     STATUS    RESTARTS   AGE
        qat-dpdk                 1/1       Running   0          27m
        intel-qat-plugin-5zgvb   1/1       Running   0          3h

   .. Note::

    The deployment example above uses kustomize, which is a tool supported by
    kubectl since the Kubernetes v1.14 release.


#. Manually execute the ``dpdk-test-crypto-perf`` application to review the
   logs.

   ::

      $ kubectl exec -it qat-dpdk bash

      $ ./dpdk-test-crypto-perf -l 6-7 -w $QAT1 -- --ptest throughput --\
       devtype crypto_qat --optype cipher-only --cipher-algo aes-cbc --cipher-op \
       encrypt --cipher-key-sz 16 --total-ops 10000000 --burst-sz 32 --buffer-sz 64

