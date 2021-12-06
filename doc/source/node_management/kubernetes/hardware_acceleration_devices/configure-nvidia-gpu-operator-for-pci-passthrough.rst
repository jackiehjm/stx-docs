
.. fgy1616003207054
.. _configure-nvidia-gpu-operator-for-pci-passthrough:

=================================================
Configure NVIDIA GPU Operator for PCI Passthrough
=================================================

|release-caveat|

This section provides instructions for configuring NVIDIA GPU Operator.

.. rubric:: |context|

.. note::
    NVIDIA GPU Operator is only supported for standard performance kernel
    profile. There is no support provided for low-latency performance kernel
    profile.

NVIDIA GPU Operator automates the installation, maintenance, and management of
NVIDIA software needed to provision NVIDIA GPU and provisioning of pods that
require nvidia.com/gpu resources.

NVIDIA GPU Operator is delivered as a Helm chart to install a number of services
and pods to automate the provisioning of NVIDIA GPUs with the needed NVIDIA
software components. These components include:

.. _fgy1616003207054-ul-sng-blk-z4b:

-   NVIDIA drivers \(to enable CUDA which is a parallel computing platform\)

-   Kubernetes device plugin for GPUs

-   NVIDIA Container Runtime

-   Automatic Node labelling

-   DCGM \(NVIDIA Data Center GPU Manager\) based monitoring

.. rubric:: |prereq|

Download the **gpu-operator-v3-1.8.1.4.tgz** file at
`http://mirror.starlingx.cengn.ca/mirror/starlingx/release/latest_release/centos/containers/inputs/downloads/
<http://mirror.starlingx.cengn.ca/mirror/starlingx/release/latest_release/centos/containers/inputs/downloads/>`__.

Use the following steps to configure the GPU Operator container:

.. rubric:: |proc|

#.  Lock the hosts\(s\).

    .. code-block:: none

        ~(keystone_admin)]$  system host-lock <hostname>

#.  Configure the Container Runtime host path to the NVIDIA runtime which will
    be installed by the GPU Operator Helm deployment.

    .. code-block:: none

        ~(keystone_admin)]$ system service-parameter-add platform container_runtime custom_container_runtime=nvidia:/usr/local/nvidia/toolkit/nvidia-container-runtime

#.  Unlock the hosts\(s\). Once the system is unlocked, the system will reboot automatically.

    .. code-block:: none

        ~(keystone_admin)]$ system host-unlock <hostname>

#.  Install the GPU Operator Helm charts.

    .. code-block:: none

        ~(keystone_admin)]$ helm install gpu-operator /path/to/gpu-operator-v3-1.8.1.4.tgz

#.  Check if the GPU Operator is deployed using the following command.

    .. code-block:: none

        ~(keystone_admin)]$ kubectl get pods –A
        NAMESPACE                NAME                                                          READY   STATUS      RESTARTS   AGE
        ..............
        default                  gpu-operator-5dddfcbb58-xpwbh                                 1/1     Running     0          3m13s
        default                  gpu-operator-node-feature-discovery-master-58d884d5cc-56qch   1/1     Running     0          3m13s
        default                  gpu-operator-node-feature-discovery-worker-p495j              1/1     Running     0          3m13s
        gpu-operator-resources   gpu-feature-discovery-swmj8                                   1/1     Running     0          2m52s
        gpu-operator-resources   nvidia-cuda-validator-zcfp9                                   0/1     Completed   0          2m31s
        gpu-operator-resources   nvidia-dcgm-9447k                                             1/1     Running     0          2m52s
        gpu-operator-resources   nvidia-dcgm-exporter-9c82q                                    1/1     Running     0          2m52s
        gpu-operator-resources   nvidia-device-plugin-daemonset-ljm4q                          1/1     Running     0          2m52s
        gpu-operator-resources   nvidia-device-plugin-validator-j9kjz                          0/1     Completed   0          2m25s
        gpu-operator-resources   nvidia-driver-daemonset-qph2s                                 1/1     Running     0          2m52s
        gpu-operator-resources   nvidia-operator-validator-dw6sc                               1/1     Running     0          2m52s
        ..........
        kube-system              toolkit-installer-xzrt8                                       1/1     Running     0          3m13s

    The plugin validation pod is marked completed.

#.  Check if the nvidia.com/gpu resources are available using the following command.

    .. code-block:: none

        ~(keystone_admin)]$ kubectl describe nodes <hostname> | grep nvidia

#.  Create a pod that uses the NVIDIA RuntimeClass and requests a
    nvidia.com/gpu resource. Update the nvidia-usage-example-pod.yml file to launch
    a pod NVIDIA GPU. For example:

    .. code-block:: none

        cat <<EOF > nvidia-usage-example-pod.yml
        apiVersion: v1
        kind: Pod
        metadata:
          name: nvidia-usage-example-pod
        spec:
          runtimeClassName: nvidia
          containers:
           - name: nvidia-usage-example-pod
             image: nvidia/samples:cuda10.2-vectorAdd
             imagePullPolicy: IfNotPresent
             command: [ "/bin/bash", "-c", "--" ]
             args: [ "while true; do sleep 300000; done;" ]
             resources:
               requests:
                 nvidia.com/gpu: 1
               limits:
                 nvidia.com/gpu: 1
        EOF

#.  Create a pod using the following command.

    .. code-block:: none

        ~(keystone_admin)]$ kubectl create -f nvidia-usage-example-pod.yml

#.  Check that the pod has been set up correctly. The status of the NVIDIA device is displayed in the table.

    .. code-block:: none

        ~(keystone_admin)]$ kubectl exec -it nvidia-usage-example-pod -- nvidia-smi
        +-----------------------------------------------------------------------------+
        | NVIDIA-SMI 460.32.03    Driver Version: 460.32.03    CUDA Version: 11.2     |
        |-------------------------------+----------------------+----------------------+
        | GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
        | Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
        |                               |                      |               MIG M. |
        |===============================+======================+======================|
        |   0  Tesla T4            On   | 00000000:AF:00.0 Off |                    0 |
        | N/A   28C    P8    14W /  70W |      0MiB / 15109MiB |      0%      Default |
        |                               |                      |                  N/A |
        +-------------------------------+----------------------+----------------------+

        +-----------------------------------------------------------------------------+
        | Processes:                                                                  |
        |  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
        |        ID   ID                                                   Usage      |
        |=============================================================================|
        |  No running processes found                                                 |
        +-----------------------------------------------------------------------------+

    For information on deleting the GPU Operator, see :ref:`Delete the GPU
    Operator <delete-the-gpu-operator>`.
