
.. klf1569260954792
.. _using-kubernetes-cpu-manager-static-policy:

===================================================================================
Use Kubernetes CPU Manager Static Policy’s Guaranteed QoS class with exclusive CPUs
===================================================================================

You can launch a container pinned to a particular set of CPU cores using the
Kubernetes CPU manager static policy's **Guaranteed QoS** class.

.. rubric:: |prereq|

You will need to enable the Kubernetes CPU Manager's Static Policy for the
target worker node(s).

See |admintasks-doc|: :ref:`Kubernetes CPU Manager Policies
<kubernetes-cpu-manager-policies>` for details on how to enable this CPU
management mechanism.

.. rubric:: |proc|

#.  Create your pod with <resources:requests:cpu/memory> and
    <resources:limits:cpu/memory> according to
    `https://kubernetes.io/docs/tasks/administer-cluster/cpu-management-policies/#cpu-management-policies
    <https://kubernetes.io/docs/tasks/administer-cluster/cpu-management-policies/#cpu-management-policies>`__,
    in order to select the Guaranteed QoS class with exclusive CPUs.
    Specifically this requires either:

    -   <resources:requests:cpu/memory> to be equal to
        <resources:limits:cpu/memory>, and cpu to be an integer value > 1,

    or

    -   only <resources:limits:cpu/memory> to be specified, and cpu to be an
        integer value > 1.

    The CPUs allocated to the pod will be exclusive (or dedicated/pinned) to
    the pod, and taken from the CPUs configured as ‘application’ function for
    the host. Processes within the pod can float across the set of CPUs
    allocated to the pod, unless the application in the pod explicitly pins the
    process(es) to a subset of the CPUs.

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
                memory: "2Gi"
              limits:
                cpu: 2
                memory: "2Gi"
          nodeSelector:
            kubernetes.io/hostname: worker-1
        EOF

    You will likely need to adjust some values shown above to reflect your
    deployment configuration. For example, on an AIO-SX or AIO-DX system.
    worker-1 would probably become controller-0 or controller-1.

    The significant addition to this definition in support of CPU pinning, is
    the **resources** section , which sets a CPU resource request and limit of
    2.

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
        Namespace                  Name           CPU Requests  CPU Limits  Memory Requests  Memory Limits  AGE
        ---------                  ----           ------------  ----------  ---------------  -------------  ---
        default                    stress-ng-cpu  2 (15%)       2 (15%)     2Gi (7%)         2Gi (7%)       9m31s

        % kubectl describe <pod> stress-ng-cpu
        ...
        QoS Class: Guaranteed

#.  Delete the container.

    .. code-block:: none

        % kubectl delete -f stress-cpu-pinned.yaml
