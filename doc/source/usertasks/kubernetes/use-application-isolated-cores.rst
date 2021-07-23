
.. klf1569260954795
.. _use-application-isolated-cores:

========================================================================
Use Kubernetes CPU Manager Static Policy with application-isolated cores
========================================================================

|prod| supports running the most critical low-latency applications on host CPUs
which are completely isolated from the host process scheduler and exclusive (or
dedicated/pinned) to the pod.

.. rubric:: |prereq|

-   You will need to enable the Kubernetes CPU Manager’s Static Policy for the
    target worker node(s).
    See |admintasks-doc|: :ref:`Kubernetes CPU Manager Policies
    <kubernetes-cpu-manager-policies>` for details on how to enable this CPU
    management mechanism.

-   You will need to configure application-isolated cores for the target worker
    node(s).
    See |admintasks-doc|: :ref:`Isolate the CPU Cores to Enhance Application
    Performance <isolating-cpu-cores-to-enhance-application-performance>` for
    details on how to configure application-isolated cores.

.. rubric:: |proc|

#.  Create your pod with <resources:requests:cpu/memory> and
    <resources:limits:cpu/memory> according to
    `https://kubernetes.io/docs/tasks/administer-cluster/cpu-management-policies/#cpu-management-policies <https://kubernetes.io/docs/tasks/administer-cluster/cpu-management-policies/#cpu-management-policies>`__
    in order to select **Best Effort** or **Burstable** class; use of
    application-isolated cores are NOT supported with **Guaranteed
    QoS** class. Specifically this requires either:

    -   for **Best Effort**, do NOT specify resources:limits:cpu/memory>

    or

    -   for **Burstable**, <resources:limits:cpu/memory> and
        <resources:limits:cpu/memory> are specified but NOT equal to each other.

    Then, to add ‘application-isolated’ CPUs to the pod, configure
    '<resources:requests:windriver.com/isolcpus>' and
    '<resources:limits:windriver.com/isolcpus>' equal to each other, in the pod
    spec. These cores will be exclusive (dedicated/pinned) to the pod. If there
    are multiple processes within the pod/container, they can be individually
    affined to separate application-isolated CPUs if the pod/container requests
    multiple windriver.com/isolcpus resources. This is highly recommended as the
    Linux kernel does not load balance across application-isolated cores.
    Start-up code in the container can determine the available CPUs by running
    sched_getaffinity(), by looking for files of the form /dev/cpu/<X> where
    <X> is a number, or by parsing /sys/fs/cgroup/cpuset/cpuset.cpus within the
    container.

    For example:

    .. code-block:: none

        % cat <<EOF > stress-cpu-pinned.yaml
        apiVersion: v1
        kind: Pod
        metadata:
          name: stress-ng-cpu
        spec:
          containers:
          - name: stress-ng-app
            image: alexeiled/stress-ng
            imagePullPolicy: IfNotPresent
            command: ["/stress-ng"]
            args: ["--cpu", "10", "--metrics-brief", "-v"]
            resources:
              requests:
                cpu: 2
                memory: "1Gi"
                windriver.com/isolcpus: 2
              limits:
                cpu: 2
                memory: "2Gi"
                windriver.com/isolcpus: 2
          nodeSelector:
            kubernetes.io/hostname: worker-1
        EOF

    .. note::

        The nodeSelector is optional and it can be left out entirely. In which
        case, it will run in any valid note.

    You will likely need to adjust some values shown above to reflect your
    deployment configuration. For example, on an AIO-SX or AIO-DX system.
    worker-1 would probably become controller-0 or controller-1.

    The significant addition to this definition in support of
    application-isolated CPUs, is the **resources** section, which sets the
    windriver.com/isolcpus resource request and limit of 2.

    Limitation: If Hyperthreading is enabled in the BIOS and application-isolated
    CPUs are configured, and these CPUs are allocated to more than one container,
    the |SMT| siblings may be allocated to different containers and that could
    adversely impact the performance of the application.

    Workaround: The suggested workaround is to allocate all application-isolated
    CPUs to a single pod.


#.  Apply the definition.

    .. code-block:: none

        % kubectl apply -f stress-cpu-pinned.yaml

    You can SSH to the worker node and run :command:`top`, and type '1' to see
    CPU details per core:

#.  Describe the pod or node to see the CPU Request, CPU Limits and that it is
    in the "Guaranteed" QoS Class.

    For example:

    .. code-block:: none

        % kubectl describe <node>
        Namespace                  Name           CPU Requests  CPU Limits  Memory Requests  Memory Limits  windriver/isolcpus Requests  windriver/isolcpus Limits  AGE
        ---------                  ----           ------------  ----------  ---------------  -------------  ---------------------------  -------------------------  ---
        default                    stress-ng-cpu  1 (7%)        2 (15%)     1Gi (3%)         2Gi (7%)       2 (15%)                      2 (15%)                    9m31s

        % kubectl describe <pod> stress-ng-cpu
        ...
        QoS Class: Burstable

#.  Delete the container.

    .. code-block:: none

        % kubectl delete -f stress-cpu-pinned.yaml
