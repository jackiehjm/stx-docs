
.. rpw1591793808686
.. _specifying-kata-container-runtime-in-pod-spec:

==========================================
Specify Kata Container Runtime in Pod Spec
==========================================

You can specify the use of Kata Container runtime in your pod specification by
runtime class or by annotation.

.. rubric:: |proc|

*   Do one of the following:

    .. table::
        :widths: auto

        +--------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------+
        | **To use the runtime class method:**                                                       | #.  Create a RuntimeClass with handler set to kata.                                        |
        |                                                                                            |                                                                                            |
        |                                                                                            | #.  Reference this class in the pod spec, as shown in the following example:               |
        |                                                                                            |                                                                                            |
        |                                                                                            |     .. code-block:: none                                                                   |
        |                                                                                            |                                                                                            |
        |                                                                                            |         kind: RuntimeClass                                                                 |
        |                                                                                            |         apiVersion: node.k8s.io/v1beta1                                                    |
        |                                                                                            |         metadata:                                                                          |
        |                                                                                            |           name: kata-containers                                                            |
        |                                                                                            |         handler: kata                                                                      |
        |                                                                                            |         ---                                                                                |
        |                                                                                            |         apiVersion: v1                                                                     |
        |                                                                                            |         kind: Pod                                                                          |
        |                                                                                            |         metadata:                                                                          |
        |                                                                                            |           name: busybox-runtime                                                            |
        |                                                                                            |         spec:                                                                              |
        |                                                                                            |           runtimeClassName: kata-containers                                                |
        |                                                                                            |           containers:                                                                      |
        |                                                                                            |           - name: busybox                                                                  |
        |                                                                                            |             command:                                                                       |
        |                                                                                            |               - sleep                                                                      |
        |                                                                                            |               - "3600"                                                                     |
        |                                                                                            |             image: busybox                                                                 |
        +--------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------+
        | **To use the annotation method:**                                                          | Set io.kubernetes.cri.untrusted-workload to true in the annotations section of a pod spec. |
        |                                                                                            |                                                                                            |
        |                                                                                            | For example:                                                                               |
        |                                                                                            |                                                                                            |
        |                                                                                            | .. code-block:: none                                                                       |
        |                                                                                            |                                                                                            |
        |                                                                                            |    apiVersion: v1                                                                          |
        |                                                                                            |    kind: Pod                                                                               |
        |                                                                                            |    metadata:                                                                               |
        |                                                                                            |      name: busybox-untrusted                                                               |
        |                                                                                            |      annotations:                                                                          |
        |                                                                                            |        io.kubernetes.cri.untrusted-workload: "true"                                        |
        |                                                                                            |    spec:                                                                                   |
        |                                                                                            |      containers:                                                                           |
        |                                                                                            |      - name: busybox                                                                       |
        |                                                                                            |        command:                                                                            |
        |                                                                                            |          - sleep                                                                           |
        |                                                                                            |          - "3600"                                                                          |
        |                                                                                            |        image: busybox                                                                      |
        |                                                                                            |                                                                                            |
        |                                                                                            | .. note::                                                                                  |
        |                                                                                            |         This method is deprecated and may not be supported in future releases.             |
        +--------------------------------------------------------------------------------------------+--------------------------------------------------------------------------------------------+
