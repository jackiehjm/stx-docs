
.. klf1569260954792
.. _using-kubernetes-cpu-manager-static-policy:

========================================
Use Kubernetes CPU Manager Static Policy
========================================

You can launch a container pinned to a particular set of CPU cores using a
Kubernetes CPU manager static policy.

.. rubric:: |prereq|

You will need to enable this CPU management mechanism before applying a
policy.

See |admintasks-doc|: :ref:`Optimizing Application Performance <kubernetes-cpu-manager-policies>` for details on how to enable this CPU management mechanism.

.. rubric:: |proc|

#.  Define a container running a CPU stress command.

    .. note::

        -   The pod will be pinned to the allocated set of CPUs on the host
            and have exclusive use of those CPUs if <resource:request:cpu> is
            equal to <resource:cpulimit>.

        -   Resource memory must also be specified for guaranteed resource
            allocation.

        -   Processes within the pod can float across the set of CPUs allocated
            to the pod, unless the application in the pod explicitly pins them
            to a subset of the CPUs.

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
