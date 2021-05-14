
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

Download the **gpu-operator-v3-1.6.0.3.tgz** file at
`http://mirror.starlingx.cengn.ca/mirror/starlingx/
<http://mirror.starlingx.cengn.ca/mirror/starlingx/>`__.

Use the following steps to configure the GPU Operator container:

.. rubric:: |proc|

#.  Lock the hosts\(s\).

    .. code-block:: none

        ~(keystone_admin)]$  system host-lock <hostname>

#.  Configure the Container Runtime host path to the NVIDIA runtime which will be installed by the GPU Operator Helm deployment.

    .. code-block:: none

        ~(keystone_admin)]$ system service-parameter-add platform container_runtime custom_container_runtime=nvidia:/usr/local/nvidia/toolkit/nvidia-container-runtime

#.  Unlock the hosts\(s\). Once the system is unlocked, the system will reboot automatically.

    .. code-block:: none

        ~(keystone_admin)]$ system host-unlock <hostname>

#.  Create the RuntimeClass resource definition and apply it to the system.

    .. code-block:: none

        cat > nvidia.yml << EOF
            kind: RuntimeClass
            apiVersion: node.k8s.io/v1beta1
            metadata:
              name: nvidia
            handler: nvidia
        EOF

    .. code-block:: none

        ~(keystone_admin)]$ kubectl apply -f nvidia.yml

#.  Install the GPU Operator Helm charts.

    .. code-block:: none

        ~(keystone_admin)]$ helm install -–name gpu-operator /path/to/gpu-operator-1.6.0.3.tgz

#.  Check if the GPU Operator is deployed using the following command.

    .. code-block:: none

        ~(keystone_admin)]$ kubectl get pods –A
        NAMESPACE               NAME      READY  STATUS    RESTART  AGE
        default                 g-node..  1/1    Running   1       7h54m
        default                 g-node..  1/1    Running   1       7h54m
        default                 gpu-ope.  1/1    Running   1       7h54m
        gpu-operator-resources  gpu-..    1/1    Running   4       28m
        gpu-operator-resources  nvidia..  1/1    Running   0       28m
        gpu-operator-resources  nvidia..  1/1    Running   0       28m
        gpu-operator-resources  nvidia..  1/1    Running   0       28m
        gpu-operator-resources  nvidia..  0/1    Completed 0       7h53m
        gpu-operator-resources  nvidia..  1/1    Running   0       28m

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
              imagePullPolicy: IfNotPresent    command: [ "/bin/bash", "-c", "--" ]
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
